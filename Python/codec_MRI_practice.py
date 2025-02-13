import os
import glob
import expyriment 


## codec practice task MRI

######################################################## DEVELOPING MODE ###################################################

expyriment.control.set_develop_mode(True) # True
LAPTOP = True # False if on lab pc (this changes the STIMULUS_PATH

######################################################### SETTINGS ######################################################### 

DEBUGGING = True  # False will activate the ports and deactivate the keyboard /// True will activate the keyboard and deactivate the ports
BB_MARKER_PORT = "COM2" #sending markers and receiving button presses.
TRIGGER_PORT = "COM3"
TRIAL_DURATION = [30000,10000] # Time duration that trial is being presented on the screen (10000 for high-time pressure, 30000 for low-time pressure)
REFRESH_RATE = 60 # Refresh rate of the stimulus screen
REST = 10000 # Initial rest period -> before the start of the experiment?
BG_COLOUR = (255,255,255)
TEXT_COLOUR = (0,0,0)
TEXT_SIZE = 25

PROTOCOL_PATH = os.path.abspath('./design') # C:\Users\jorvlan\Desktop\expyriment_task\design

if LAPTOP:
    STIMULUS_PATH = "C:/Users/jorvlan/Desktop/expyriment_task/"
else:
    STIMULUS_PATH = "D:/Users/jorvlan/expyriment_task" 
    
#STIMULUS_PATH = "D:/Users/jorvlan/expyriment_task" # when lab PC #"C:/Users/jorvlan/Desktop/expyriment_task/" when not on lab pc, but on laptop

#in develop mode taak gaat niet verder na instructies?
######################################################### DEFINITIONS ###################################################### 

def send_marker(code, debugging=DEBUGGING):
    if not debugging:
        marker.send(code)

# when debugging doesn't send a marker to the scanner when in debugging mode

######################################################## INITIALISATION ####################################################

exp = expyriment.design.Experiment(name="codec MRI practice task", background_colour=BG_COLOUR)
exp.add_data_variable_names(["TrialID, thisGrid, thisAns1, thisAns2, thisAns3, thisAns4, ISI, trialdur, response_list, rt_list"]) #add stimulus name to each row of dataframe && exp.data.add([trial.id, key, rt, response]) stimulus name

expyriment.control.defaults.display_resolution = (1920,1080)
expyriment.control.initialize(exp) #From here on exp.clock, exp.screen, exp.events are available
expyriment.control.start(skip_ready_screen=False) # Present a screen to ask for the subject number. exp.subject and exp.data will be available from now on

# Markers
markers = { "start": 10,
            "stimulus": 11,
            "response_thisAns1": 12,
            "response_thisAns2": 13,
            "response_thisAns3": 14,
            "response_thisAns4": 15,
            "response_error": 16,
            "end": 17}



#Define subject and session
subject = int(exp.subject)
session = int(expyriment.io.TextInput("Session:").get()) ## 1 vs. 2
handedness = str(expyriment.io.TextInput("Handedness:").get()) ## R vs. L

if session not in [1, 2]:
    print("Not a valid option was provided for session")
    print("session only accepts: '1' '2' ")
    exit(1)
 
if handedness not in ['R', 'L']:
    print("Not a valid option was provided for handedness")
    print("handedness only accepts: 'R' 'L'")
    exit(1)
    

#Preload general stimuli
fixcross = expyriment.stimuli.FixCross()
fixcross.preload()
fixcross.present()


instruction_screen = expyriment.stimuli.TextScreen("Het Puzzelbos", """
    Dit is de oefen versie van de taak.
    Je ziet zometeen 10 voorbeeld opdrachten.
    Voor de eerste 5 heb je iedere keer 30 seconden om ze op te lossen.
    Voor de laatste 5 heb je iedere keer 10 seconden om ze op te lossen.
    Kies welke vorm er in het lege vakje hoort. 
    Los zoveel mogelijk puzzels op om schatten te vinden en door het puzzelbos heen te komen!
    Probeer het goede antwoord te vinden maar ook zo snel mogelijk te zijn.
    Ben je er klaar voor? 
    Succes!""",
    text_size=25, heading_size=35, text_bold=False, position=(0,-150), text_justification=1,
    text_colour=TEXT_COLOUR, background_colour=BG_COLOUR)
    
instruction_screen_between = expyriment.stimuli.TextScreen("""Dat waren de eerste 5 langzame puzzels (30 seconden),
    de volgende 5 puzzels zullen sneller gaan (10 seconden), succes!
    """,
    text_size=25, heading_size=35, text_bold=False, position=(0,-150), text_justification=1,
    text_colour=TEXT_COLOUR, background_colour=BG_COLOUR)
    
instruction_screen_2 = expyriment.stimuli.TextScreen("Goed gedaan!", """
    De taak is afgelopen. 
    Wacht rustig op verdere instructies van de onderzoekers.
    """,
    text_size=25, heading_size=35, text_bold=False, position=(0,-150), text_justification=1,
    text_colour=TEXT_COLOUR, background_colour=BG_COLOUR)
    
################################################# IO #################################################

if not DEBUGGING:
    # Ports
    com2 = expyriment.io.SerialPort(BB_MARKER_PORT, baudrate=115200)
    com3 = expyriment.io.SerialPort(TRIGGER_PORT, baudrate=115200)
    
    # Inputs/Outputs
    bb = expyriment.io.EventButtonBox(com2)
    marker = expyriment.io.MarkerOutput(com2)
    trigger = expyriment.io.TriggerInput(com3, expyriment.misc.constants.K_a) 

    if handedness == str("R"):
    # Responses right hand
        response_thisAns1 = 97 # most left button (right index finger)
        response_thisAns2 = 98 # second most left button (right middle finger)
        response_thisAns3 = 99 # second most right button (right ring finger)
        response_thisAns4 = 100 # most right button (right pinky finger)
    elif handedness == str("L"):
    # Responses left hand
        response_thisAns1 = 101 # most right button (left index finger)
        response_thisAns2 = 102 # second most right button (left middle finger)
        response_thisAns3 = 103 # second most left button (left ring finger)
        response_thisAns4 = 104 # most left button (left pink finger)
    else: 
        exit()
        

# For debugging switch to keyboard
else:
    # Inputs/Outputs
    bb = exp.keyboard
    trigger = exp.keyboard


    if handedness == str("L"):
    # Responses left hand
        response_thisAns1 = expyriment.misc.constants.K_1
        response_thisAns2 = expyriment.misc.constants.K_2
        response_thisAns3 = expyriment.misc.constants.K_3
        response_thisAns4 = expyriment.misc.constants.K_4
    elif handedness == str("R"):
    # Responses right hand
        response_thisAns1 = expyriment.misc.constants.K_5
        response_thisAns2 = expyriment.misc.constants.K_6
        response_thisAns3 = expyriment.misc.constants.K_7
        response_thisAns4 = expyriment.misc.constants.K_8
    else: 
        exit()

############################################ LOAD PROTOCOL ############################################

exp.load_design(os.path.join(PROTOCOL_PATH,'practice_ses{:01d}.csv'.format(session)))

for trial in exp.blocks[0].trials:
    
    
    canvas = expyriment.stimuli.Canvas(size=(1000,1000), colour=BG_COLOUR)
    stim1 = expyriment.stimuli.Picture(os.path.join(STIMULUS_PATH, trial.get_factor("thisGrid")), position=(0,150)) #add stimulus name to each row of dataframe #creates a picture stimulus in the right position
    #stim1.preload()
    stim1.plot(canvas)
    stim2 = expyriment.stimuli.Picture(os.path.join(STIMULUS_PATH, trial.get_factor("thisAns1")), position=(-150,-75))
    #stim2.preload()                                                              
    stim2.plot(canvas)                                                           
    stim3 = expyriment.stimuli.Picture(os.path.join(STIMULUS_PATH, trial.get_factor("thisAns2")), position=(-50,-75))
    #stim3.preload()                                                              
    stim3.plot(canvas)                                                           
    stim4 = expyriment.stimuli.Picture(os.path.join(STIMULUS_PATH, trial.get_factor("thisAns3")), position=(50,-75))
    #stim4.preload()
    stim4.plot(canvas)
    stim5 = expyriment.stimuli.Picture(os.path.join(STIMULUS_PATH, trial.get_factor("thisAns4")), position=(150,-75))
    #stim5.preload()
    stim5.plot(canvas)

    
    #image_stim = stimuli.Picture(image) #how to define / loop through positions on screen) position = (0,150))
    
    #background = stimuli.Canvas(size= (1000,1000), colour=BG_COLOUR)
    #image_stim.plot(background)
    
    # Add stimuli for each trial 
    trial.add_stimulus(canvas) #adding now the composite stimulus in the trial

# Update screen
#image_instruction = stimuli.Picture('C:/Users/jorvlan/Desktop/expyriment_task/stimuli/instruction_image.png', position=(0,-150)) #change directory later
#image.plot(instruction_screen)
instruction_screen.present() # "Het Puzzelbos:"
bb.wait()

# Update screen
#waiting_screen.present() #"wachten op scanner..."
#trigger.wait()

# Frame correction for wait functions:
halfframe = 1000 / REFRESH_RATE / 2 # duration of half a frame in milliseconds #could also be in settings

# Initial rest:
fixcross.present()

exp.blocks[0].trials[0].preload_stimuli() #pre loading for the first trial [0]
exp.clock.wait(REST- halfframe)

###################################### RUN ##################################

# Run the experiment now that we have defined everything above

# Trials
for counter, trial in enumerate(exp.blocks[0].trials[0:5]):


    
    #for counter, trial in enumerate(blocks[0].trials):
    
    # Present stimuli
    trial.stimuli[0].present()
    
    # Send stimulus marker
    send_marker(markers['stimulus']) # add marker values
    
    # Wait for response  #as soon as answer during trial dur it move sto lines 189, but doesn't 
    #key, rt = bb.wait([response_thisAns1, response_thisAns2, response_thisAns3, response_thisAns4],
    #                    duration=TRIAL_DURATION-halfframe)
    
    response_list = []  #list
    rt_list = []        #list
    key = None          #to make sure in 203 it would look for is the key equal to response, thisAns1, if not definied it will crash.
    
    exp.clock.reset_stopwatch() #this takes the internal self that is already running when initializing the task. #method to reset
    #expyriment.misc.Clock.reset_stopwatch()
    
    # waiting for whole trial duration, just a halfframe less #exp.clock.stopwatch_time -> property
    while exp.clock.stopwatch_time < float(TRIAL_DURATION[0])-halfframe:
        key = bb.check([response_thisAns1, response_thisAns2, response_thisAns3, response_thisAns4])
        rt = exp.clock.stopwatch_time
        
    
    # Send response marker and set response
        if key == response_thisAns1:
            send_marker(markers['response_thisAns1'])
            response_list.append('thisAns1') 
            rt_list.append(rt)
        elif key == response_thisAns2:
            send_marker(markers['response_thisAns2'])
            response_list.append('thisAns2')
            rt_list.append(rt)
        elif key == response_thisAns3:
            send_marker(markers['response_thisAns3'])
            response_list.append('thisAns3')
            rt_list.append(rt)
        elif key == response_thisAns4:
            send_marker(markers['response_thisAns4'])
            response_list.append('thisAns4')
            rt_list.append(rt)
        key = None
    
    
    # Wait until the end of the trial:
    #if rt != None:
    #   exp.clock.wait(TRIAL_DURATION-rt-halfframe)
        
    # Log trial data
    exp.data.add([trial.id, trial.get_factor("thisGrid"), trial.get_factor("thisAns1"), 
                trial.get_factor("thisAns2"), trial.get_factor("thisAns3"), 
                trial.get_factor("thisAns4"), trial.get_factor("ISI"), trial.get_factor("trialdur"), response_list, rt_list])
       
    # Present cross
    fixcross.present()
    
    # Wait for ISI minus the time it takes to load/unload the stimuli
    if counter < exp.blocks[0].n_trials - 1: # Excludes last trial
        exp.clock.wait(float(trial.get_factor("ISI")) -
                        trial.unload_stimuli() - 
                        exp.blocks[0].trials[counter+1].preload_stimuli() -
                        halfframe)
   
instruction_screen_between.present() # "Dat waren de eerste 5..."
bb.wait()


# Trials
for counter, trial in enumerate(exp.blocks[0].trials[5:10]):


    
    #for counter, trial in enumerate(blocks[0].trials):
    
    # Present stimuli
    trial.stimuli[0].present()
    
    # Send stimulus marker
    send_marker(markers['stimulus']) # add marker values
    
    # Wait for response  #as soon as answer during trial dur it move sto lines 189, but doesn't 
    #key, rt = bb.wait([response_thisAns1, response_thisAns2, response_thisAns3, response_thisAns4],
    #                    duration=TRIAL_DURATION-halfframe)
    
    response_list = []  #list
    rt_list = []        #list
    key = None          #to make sure in 203 it would look for is the key equal to response, thisAns1, if not definied it will crash.
    
    exp.clock.reset_stopwatch() #this takes the internal self that is already running when initializing the task. #method to reset
    #expyriment.misc.Clock.reset_stopwatch()
    
    # waiting for whole trial duration, just a halfframe less #exp.clock.stopwatch_time -> property
    while exp.clock.stopwatch_time < float(TRIAL_DURATION[1])-halfframe:
        key = bb.check([response_thisAns1, response_thisAns2, response_thisAns3, response_thisAns4])
        rt = exp.clock.stopwatch_time
        
    
    # Send response marker and set response
        if key == response_thisAns1:
            send_marker(markers['response_thisAns1'])
            response_list.append('thisAns1') 
            rt_list.append(rt)
        elif key == response_thisAns2:
            send_marker(markers['response_thisAns2'])
            response_list.append('thisAns2')
            rt_list.append(rt)
        elif key == response_thisAns3:
            send_marker(markers['response_thisAns3'])
            response_list.append('thisAns3')
            rt_list.append(rt)
        elif key == response_thisAns4:
            send_marker(markers['response_thisAns4'])
            response_list.append('thisAns4')
            rt_list.append(rt)
        key = None
    
    
    # Wait until the end of the trial:
    #if rt != None:
    #   exp.clock.wait(TRIAL_DURATION-rt-halfframe)
        
    # Log trial data
    exp.data.add([trial.id, trial.get_factor("thisGrid"), trial.get_factor("thisAns1"), 
                trial.get_factor("thisAns2"), trial.get_factor("thisAns3"), 
                trial.get_factor("thisAns4"), trial.get_factor("ISI"), trial.get_factor("trialdur"), response_list, rt_list])
       
    # Present cross
    fixcross.present()
    
    # Wait for ISI minus the time it takes to load/unload the stimuli
    if counter < exp.blocks[0].n_trials - 1: # Excludes last trial
        exp.clock.wait(float(trial.get_factor("ISI")) -
                        trial.unload_stimuli() - 
                        exp.blocks[0].trials[counter+1].preload_stimuli() -
                        halfframe)


# Update screen
fixcross.present()
exp.clock.wait(REST) 

# Update to final screen
instruction_screen_2.present()  # "De taak is afgelopen, wacht alsjeblieft op verdere instructies..."
exp.clock.wait(REST) 

# End the experiment
expyriment.control.end()   



#print(expyriment.misc.get_monitor_resolution())
#expyriment.io.Screen.monitor_resolution(window_size=(1920,1080))