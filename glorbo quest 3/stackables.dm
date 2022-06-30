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