---
title: Sorted Circular Doubly Linked List Precompiled Contract
description: A Guidance to implementing a Sorted Circular Doubly Linked List (SCDLL) as a stateful precompile contract for complex data structure.
author: sirawt (@MASDXI)
status: Draft
---

## Simple Summary

> TODO

## Abstract

> TODO

## Motivation

> TODO

## Rationale

> TODO

## Guidance

#### Storage Layout

```Solidity
uint256 max_size;

struct List {
    uint256 size;
    uint256 middle;
    mapping(uint256 => mapping(bool => uint256)) elements;
}

mapping(uint256 => List) lists;
```

| slot | offset | variable | composite key                                            |
| ---- | ------ | -------- | -------------------------------------------------------- |
| 0    | 0      | max_size | $\text{hash(msg.sender, 0)}$                             |
| 1    | 0      | size     | $\text{hash(msg.sender, listId, 0)}$                     |
| 1    | 1      | middle   | $\text{hash(msg.sender, listId, 2)}$                     |
| 1    | 2      | elements | $\text{hash(msg.sender, listId, 3, element, direction)}$ |

direction with boolean type `true` which is `1` for `next` element `next` and `false` which is `0` for `previous` element  
element `0` reserved for sentinel node which is use for fast retrieve first and last element of list
all state store at msgSender address not the precompile state storage

#### Interfaces

```Solidity
function size(uint256 listId) external view returns (uint256);
```

- Purpose: For get size of the given listId `hash(msgSender, listId, 0)`
- Parameters: `listId`
- Returns:

```Solidity
function front(uint256 listId) external view returns (uint256);
```

- Purpose: For get first element of the given listId by get storage `hash(msgSender, listId, 3, sentinel, true)`
- Parameters: `listId`
- Returns:

```Solidity
function back(uint256 listId) external view returns (uint256);
```

- Purpose: For get last element of the given listId `hash(msgSender, listId, 3, sentinel, false)`
- Parameters: `listId`
- Returns:

```Solidity
function middle(uint256 listId) external view returns (uint256);
```

- Purpose: For get middle element of the given listId `hash(msgSender, listId, 2)`
- Parameters: `listId`
- Returns:

```Solidity
function next(uint256 listId, uint256 element) external view returns (uint256);
```

- Purpose: For get next element `hash(msgSender, listId, 3, element, true)`
- Parameters:
  - `listId`
  - `element`
- Returns:

```Solidity
function previous(uint256 listId, uint256 element) external view returns (uint256);
```

- Purpose: For get previous element `hash(msgSender, listId, 3, element, false)`
- Parameters:
  - `listId`
  - `element`
- Returns:

```Solidity
function list(uint256 listId) external view returns (uint256 [] memory);
```

- Purpose: For get all element in list by loop from `front(uint256 listId)` to `back(uint256 listId)`
- Parameters: `listId`
- Returns:

```Solidity
function rlist(uint256 listId) external view returns (uint256 [] memory);
```

- Purpose: For get all element in list by loop from `back(uint256 listId)` to `front(uint256 listId)`
- Parameters: `listId`
- Returns:

```Solidity
function find(uint256 listId, uint256 element) external view returns (bool);
```

```python
# pseudo code
sentinel = 0
first_condition = list.previous(listId, element) > 0
# Checks if there is a non-zero value before the given element in storage
second_condition = list.next(listId, sentinel) == element
# Checks if the element is directly after the sentinel node in storage
exist = first_condition or second_condition
# If either condition is true, then the element exists in the list
```

- Purpose: For check is element exist in list
- Parameters:
  - `listId`
  - `element`
- Returns:

```Solidity
function insert(uint256 listId, uint256 element) external view returns (bool);
```

```python
# pseudo code
front = list.front(listId)
middle = list.middle(listId)
back = list.back(listId)
exists = list.find(listId, element)

if not exists:
    if element > front and element < middle:
        # Insert between front and middle
        insert_between(front, middle, element)
    elif element > middle and element < back:
        # Insert between middle and back
        insert_between(middle, back, element)
    elif element < front:
        # Insert before front
        insert_before(front, element)
    else:
        # If element is greater than or equal to back (it can't be equal to back due to check)
        insert_after(back, element)

    # Update list metadata
    increment_list_size(listId)
    update_list_middle(listId)

```

- Purpose: For insert, try `find(uint256 listId, uint256 element)` before insert, if not exist then insert to list
- Parameters:
  - `listId`
  - `element`
- Returns:

```Solidity
function remove(uint256 listId, uint256 element) external view returns (bool);
```

```python
# pseudo code
front = list.front(listId)
middle = list.middle(listId)
back = list.back(listId)
exists = list.find(listId, element)

if exists:
    if element == front:
        # Remove the front element
        remove_front(listId)
    elif element == middle:
        # Remove the middle element
        remove_middle(listId)
    elif element == back:
        # Remove the back element
        remove_back(listId)
    elif element > front and element < middle:
        # Remove element between front and middle
        remove_between(front, middle, element)
    elif element > middle and element < back:
        # Remove element between middle and back
        remove_between(middle, back, element)

    # Update list metadata
    decrement_list_size(listId)
    update_list_middle(listId)
```

- Purpose: For remove, try `find(uint256 listId, uint256 element)` before remove, if exist then remove from list
- Parameters:
  - `listId`
  - `element`
- Returns:

#### Gas Used Logic

for applied in public network or network that have native token for incentivize miner node or validator node
calculate from

for private network should considering ddos attack if too low

## Security Considerations

- Restrict direct call from EOA
- `MAX_SIZE` too large when call `list` and `rlist`

## Mitigating Security Concern

adding pagination style for get list in smaller chunk

- `list(uint256 listId, uint256 start, uint256 size)`
- `rlist(uint256 listId, uint256 start, uint256 size)`

if passing start 0 is start from sentinel node size should be start from 1 to `MAX_SIZE`

#### Historical links related to this standard

> TODO

#### Appendix

**EOA** definition Externally Owned Account is an account controlled by a cryptographic keypair.  
**rlist** definition reverse list (descending)

## License

Release under the [MIT](LINCENSE-MIT) license.  
Copyright (C) to author. All rights reserved.
