Supplies can be created both in Eden editor and during ongoin operations. In Editor in order to create a supply you have to paste this line in objects init field (in object attributes, remember to replace "_type", "_mod" and "_size" with proper parameters explained below):

[this, _type, _mod, _size] execVM "DNT_supplies\DNT_createSupplies.sqf";

while in zeus mode you have to double click on object you want mark as supply, paste this line in "Execute" field, and make sure the icon in top right of "Execute" field is set to G - if not set it to G by clicking on it. Also remember to replace "_type", "_mod" and "_size" with proper parameters explained below)

[_this, _type, _mod, _size] execVM "DNT_supplies\DNT_createSupplies.sqf";

Parameters:

1) this for editor or _this in zeus context. Refers to the object you want to be an supply and shouldn't be changed unless you know what you're doing

2) _type - possible values are 
"ammunition" - create ammo crate. An action appears on an object which allows players to search the container for ammunition. If supplies are found a task is crated to bring crate with ammunition back to supply drop at the base
"medicaments" - create crate with medicaments. Works the same way as "ammunition" but players can find and deliver medical supplies instead
"vehicle" - claim a vehicle. Players can claim unoccupied vehicles which creates a task with name and location of the vehicle which can help quarter master with keeping up with claimed vehicles. Only alive (not destroyed) vehicles can be claimed
"scrap" - salvage scrap. When placed on an object action to salvage it will become available but only engineers can perform this action. Object after being salvaged will be changed into box of scrap that can be taken bakc to supplty drop.

3) _mod - default 0: for ammunition and medicaments scripts randomly picks a number from 0-20. If value is >= 10 supplies are found. By increasing value of _mod you increase a chance of finding supplies. You can also use negative number to decrease that chance. For example if you put 20 it will be guaranted success and similarly -20 will be guaranteed failure. Important note: keep in mind that the higher the roll the more supplies can be found and so by increasing this parameter you also increase the amount of found supplies.  

4) _size - size of the supply. On default is 1 but if you want for a big box to take more space you can increase that number. For example if you increase this number to 5 you want be able to load this crate to vehicle with cargo space size of 4 and so on. 


