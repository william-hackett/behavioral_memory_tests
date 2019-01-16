# behavioral_memory_tests
A repository containing two MATLAB files, cognitive_behavior_tests.m and batch_processing.m. The cognitive_behavior_tests.m file runs three cognitive science experiments (the Serial Position Task, Partial Report Task, and Mental Scanning Task) consecutively, using the Psychtoolbox and producing a .csv file with the results. The batch_processing.m file contains a script for preliminary processing of the data obtained in the task - capable of evaluating multiple subjects' files at a time.

Serial Position Task: Participants are presented with a series of words, one at a time. They are to recall as many words as possible after being presented with a series of words. Due to the Primacy and Recency Effects, they tend to recall items that were presented first or last in the series the most often.

Partial Report Task: Participants are presented with 9 words in a 3x3 grid. Subsequently, they are asked to recall 1 of the 3 lines. Subjects are able to recall a line of words when asked to only perform a 'partial report', but recall significantly less when they are asked to recall the board overall. This is often used as evidence for iconic memory, a form of visual memory.

Mental Scanning Task: A random pattern of dots is flashed briefly on the screen, and after they disappear, an arrow appears. Participants are to indicate whether or not the arrow is pointing towards a place on the screen where a dot had previously been displayed. The distance between the dot and arrow varies per trial. Upon analysis, participants have a longer response time when there was a longer distance between the dot and the arrow. The correlation between response latency and distance is cited as evidence for a mental representation of the image that corresponds to the image itself.

In order to use the code in this repository, first, run cognitive_behavior_tests.m. Follow the instructions presented on the screen. Next, run batch_processing.m on the resulting .csv file.

Partner: Julia Donovan, responsible for some sections of code (credit given in code comments)
