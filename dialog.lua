if CURR_ROMHACK == "sm64" then
smlua_text_utils_dialog_replace(DIALOG_078, 1, 5, 30, 200, "A Blue Coin Switch?\
A Boo Coin Switch!\
These Boos love playing\
games, so they've hidden\
themselves as coins!\
If you're able to collect\
all of them, they'll vanish\
and give you a Blue Coin\
each for your trouble!")
end

lifeInsurancePremium = tostring(100 * gLevelValues.numCoinsToLife)
DIALOG_YOSHI_INSURANCE = ("Mario!!!\
It that really you???\
It has been so long since\
our last adventure!\
Check it out. While you\
were gone, I purchased\
a new life insurance\
policy!\
For just lifeInsurancePremium coins,\
I got access to the\
coverage of a hundred\
lifetimes!\
They said it was just\
in case, but surely\
nothing bad would happen\
to me, right?\
...Mario?"):gsub("lifeInsurancePremium", lifeInsurancePremium)

DIALOG_YOSHI_REPETITION = ("Phew!\
That was a close call.\
Huh? You thought I died?\
Yeah, but I'm okay now.\
I guess this is why\
it's good to always\
be prepared, ey\
Mario?")