def process_list(mylist):
    return [[[[x,-1][x%3 == 0],-2][x%5 == 0],-3][x%15 == 0] for x in mylist if isinstance(x, int)]

mylist = [1,3,5,15,22,'b']
print process_list(mylist)
