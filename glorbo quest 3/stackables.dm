obj/gettable/stackable/var/amount

obj/gettable/stackable/proc/StackZeroCheck(obj/gettable/stackable/stack)
	if(stack.amount <= 0)
		del src

obj/gettable/stackable/verb/split_stack(splitamount as num)
	if(!splitamount)
		return
	if(amount < splitamount)
		usr << "There isn't enough to split!"
	if(amount >= splitamount)
		usr << "[usr] splits [splitamount] from the stack of [src]."
		amount -= splitamount
		src.name = initial(src.name)
		src.name = "[name] x[src.amount]"
		CreateNewStack(src,splitamount)
		StackZeroCheck(src)

obj/gettable/stackable/proc/CreateNewStack(obj/gettable/stackable/stack,stacksize)
	stack = stack.type
	new stack(usr,stacksize)

obj/gettable/stackable/New(loc,stacksize=amount)
	amount = stacksize
	name = initial(name)
	name = "[name] x[src.amount]"
	..()

obj/gettable/stackable/verb/combine_stacks()
	var/list/combinable_stacks = list()
	var/obj/gettable/stackable/stacks
	for(stacks in view(1))
		if(stacks != src)
			combinable_stacks += stacks
	var/chosen_stack = input("Choose a stack to combine", "combine stacks") as null|obj in combinable_stacks
	if(!chosen_stack)
		return
	CombineStacks(src,chosen_stack)

obj/gettable/stackable/proc/CombineStacks(obj/gettable/stackable/original_stack,obj/gettable/stackable/second_stack)
	view() << "[usr] combines [original_stack] into [second_stack]."
	original_stack.amount += second_stack.amount
	original_stack.name = initial(original_stack.name)
	original_stack.name = "[original_stack.name] x[original_stack.amount]"
	del second_stack

obj/gettable/stackable/MouseDrop(destination)
	if(destination in view(1))
		if(istype(destination,src))
			CombineStacks(src,destination)
		else
			..()
	else
		..()

obj/gettable/stackable/ammunition/MouseDrop(obj/gettable/guns/destination)
	if(destination in view(1))
		if(istype(destination,/obj/gettable/guns))
			destination.Reload(src)
		else
			..()
	else
		..()