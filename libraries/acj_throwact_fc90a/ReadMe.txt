$$$$$$$$\ $$\                                                $$$$$$\              $$\               
\__$$  __|$$ |                                              $$  __$$\             $$ |              
   $$ |   $$$$$$$\   $$$$$$\   $$$$$$\  $$\  $$\  $$\       $$ /  $$ | $$$$$$$\ $$$$$$\    $$$$$$$\ 
   $$ |   $$  __$$\ $$  __$$\ $$  __$$\ $$ | $$ | $$ |      $$$$$$$$ |$$  _____|\_$$  _|  $$  _____|
   $$ |   $$ |  $$ |$$ |  \__|$$ /  $$ |$$ | $$ | $$ |      $$  __$$ |$$ /        $$ |    \$$$$$$\  
   $$ |   $$ |  $$ |$$ |      $$ |  $$ |$$ | $$ | $$ |      $$ |  $$ |$$ |        $$ |$$\  \____$$\ 
   $$ |   $$ |  $$ |$$ |      \$$$$$$  |\$$$$$\$$$$  |      $$ |  $$ |\$$$$$$$\   \$$$$  |$$$$$$$  |
   \__|   \__|  \__|\__|       \______/  \_____\____/       \__|  \__| \_______|   \____/ \_______/ 
                                                                                                    
------------------------------------------------------------------------------------------------------
Lead Programmer: AcousticJamm#9372 (go to me if you have any issues with this library)
Curve sprite: Sam Deluxe#0057
Help & Support: Kristal community (do not go to them for help with this library)
------------------------------------------------------------------------------------------------------
How to use the Throw Act:
The Throw Act is 90% cutscene based. An example cutscene and enemy are included in this library.
Encounter not included. The Target class (included) is required to use this act, as well as
additional sprites for the party members (included) being prepare_throw and throw (for the person
throwing) and prepare_thrown and thrown (for the person being thrown).

At the top of the example cutscene, you will see some variables for you to change.

battler_a: The id of the battler throwing.
battler_b: The id of the battler being thrown.
ammo_offset_x and ammo_offset_y: The offset of battler_b when being held by battler_a.
angle_speed: The rate that the angle changes when aiming.
angle: The starting angle for the throw act.
max_angle: The lowest the angle can go (the highest value).
min_angle: The highest the angle can go (the lowest value).
throw_speed: The speed at which battler_b will fly after being thrown.
gravity: The rate that battler_b will fall after being thrown.
aim_string: The text shown when the player is aiming.
hit_string: The text shown if the Target is hit.

Here is a list of functions you can use for the Target object and how to use them.

Target:hit(): When the target is hit. (Do not call this unless you have a way to check if it was hit.)
Target:detectHit(ally_y): Detect if ally_y is between the Target's y1 and y2.
Target:yShift(offset): An easy way to change the Target's y values by offset.