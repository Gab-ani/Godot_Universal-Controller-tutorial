It came to me, spamming repos for every episode is stupid, so I will organise them as branches instead.
In this episode, our nice architecture is starting to bear fruits. In about 20 minutes of video (and about 14 hours of real work including design and assets which is absolutely stellar result) we will leap from basic character demo to a third person character that has three jump behaviours and three melee hits that can be queued into comboing series.
The scalability of this system is crazy, we are starting to getting cramped in the borders of the character controller. All that is  separates us from the full game development is creation of characters resources and interfaces for interaction with other entities, for example, damaging them or getting hit and react.

[Transitions table](https://docs.google.com/spreadsheets/d/1g3Epn-2Rf-fAI8XPp9UfOkeH6QwFUIz8fWFDrPdhe40/edit?usp=sharing)

Code explanation and architecture choices: (work in progress, estimated due 26.04)

Input package traveling scheme:
![Player](https://github.com/Gab-ani/Godot_Universal-Controller-tutorial/assets/25298003/9eb88ff2-1a54-4a83-a320-3cc920ccb0e8)
