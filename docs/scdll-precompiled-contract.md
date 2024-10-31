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
```

| slot | offset | variable | composite key                                  |
| ---- | ------ | -------- | ---------------------------------------------- |
| 0    | 0      | max_size | hash(msgSender, 0)                             |
| 1    | 0      | size     | hash(msgSender, listId, 1)                     |
| 1    | 1      | middle   | hash(msgSender, listId, 2)                     |
| 1    | 2      | elements | hash(msgSender, listId, 3, element, direction) |

direction with boolean type `true` which is `1` for `next` element `next` and `false` which is `0` for `previous` element  
element `0` reserved for sentinel node which is use for fast retrieve first and last element of list
all state store at msgSender address not the precompile state storage

#### Interfaces

`size(uint256 listId)` for first element `hash(msgSender, listId, 0)`  
`front(uint256 listId)` for first element `hash(msgSender, listId, 3, sentinel, true)`  
`back(uint256 listId)` for last element `hash(msgSender, listId, 3, sentinel, false)`  
`middle(uint256 listId)` for middle element `hash(msgSender, listId, 2)`  
`next(uint256 listId, uint256 element)` for get next element `hash(msgSender, listId, 3, element, true)`  
`previous(uint256 listId, uint256 element)` for get previous element `hash(msgSender, listId, 3, element, false)`  
`list(uint256 listId)` for get all element in list by loop from `front(uint256 listId)` to  `back(uint256 listId)`  
`rlist(uint256 listId)` for get all element in list by loop from `back(uint256 listId)` to  `front(uint256 listId)`  
`find(uint256 listId, uint256 element)` for check is element exist in list

```python
value1 = getStorageAt(hash(msgSender, listId, 3, element, false)) > 0 # before given element are not zero
value2 = getStorageAt(hash(msgSender, listId, 3, sentinel, true)) == element # next to sentinel node equal to element
result = value1 || value2 # if true mean exists
```

`insert(uint256 listId, uint256 element)` try `find(uint256 listId, uint256 element)` before insert, if not exist then insert to list  
`remove(uint256 listId, uint256 element)` try `find(uint256 listId, uint256 element)` before insert, if exist then remove from list  

#### Gas Used Logic

for applied in public network or network that have native token for incentivize miner node or validator node
calculate from

for private network should considering ddos attack if too low

## Security Considerations

- Restrict direct call from External Owned Account (EOA)
- MAX_SIZE too large when call list and rlist

## Mitigating Security Concern

adding pagination style for get list in smaller chunk
- `list(uint256 listId, uint256 start, uint256 size)`
- `rlist(uint256 listId, uint256 start, uint256 size)`

if passing start 0 is start from sentinel node size should be start from 1 to MAX_SIZE

#### Historical links related to this standard

> TODO

#### Appendix

**rlist** definition reverse list (descending)

## License

Release under the [MIT](LINCENSE-MIT) license.  
Copyright (C) to author. All rights reserved.
