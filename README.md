# FinExpert_System_Lisp
Chartist Expert System written in Lisp (LeLisp 1987)
Presentation : 
📄 **Read the paper**: [Chartix_PRES.pdf (francais)](./Chartix_PRES.pdf)

Papier : 
📄 **Read the paper**: [Chartix_papier.pdf (francais)](./Chartix_papier.pdf)

AI chez MR : 
📄 **Read the paper**: [IA_chez_MR.pdf (francais)](./IA_chez_MR.pdf)

# GRAPHICUS Expert System Manual

## Introduction

**GRAPHICUS** is a modular, Lisp-based expert system environment rooted in AI paradigms such as object-oriented programming, rule chaining, and hypothetical worlds. This document outlines its structure, usage, and key components.

---

## General Philosophy

GRAPHICUS is built from a base object-oriented Lisp module, with optional modules adding features like chart pattern analysis. Users are encouraged to load only necessary modules for memory efficiency and to develop their own modules within this philosophy.

---

## Core Concepts

### Objects

- Created using:
  ```lisp
  (USER-INSTANCIATE metaclass name superclasses)
  ```
- Objects contain **slots**, which contain **facets**, which in turn contain **aspects**.
- Types:
  - Slots: `system` or `user`
  - Facets: `system` or `user`
  - Aspects: `fundamental` or `hypothetical`

### Example

```lisp
(USER-INSTANCIATE 'metaclass 'extremum nil)
(USER-INSTANCIATE 'metaclass 'maximum '(extremum))
(GET-ALL-INSTANCES 'maximum)
```

---

## Slots & Facets Management

- Add slots:
  ```lisp
  (ADD-SLOT-USER object slot-name role)
  ```
- Add facets:
  ```lisp
  (ADD-SLOT-FACET-USER object slot facet initial-value)
  ```

---

## Messaging and Methods

- Send message:
  ```lisp
  ($ object message-name args...)
  ```
- Add method:
  ```lisp
  (ADD-METHOD object function message role)
  ```

---

## Demons and Situations

### Demons

Attached to slots or instantiations:
```lisp
(ADD-READ-DEMON ...)
(ADD-WRITE-BEFORE-DEMON ...)
(ADD-POST-INSTANCIATION-DEMON ...)
```

### Situation Block

Trigger Lisp code when predicates match:
```lisp
(ADD-SITUATION-BLOC invocation-form predicate action name)
```

---

## Advanced Features

### Transparent Objects

Pass messages to objects in slots:
```lisp
(SET-TRANSPARENT-OBJECT object (slot1 slot2 ...))
```

### Dynamic Links

Propagate value changes:
```lisp
(ADD-DYNAMIC-LINK obj1 slot1 role1 obj2 slot2 role2)
```

---

## Slot Access

- General:
  ```lisp
  (USER-GET-VALUE object slot)
  (SETF (USER-GET-VALUE ...) ...)
  ```
- Fast:
  ```lisp
  (GET-SLOT-VALUE ...)
  (GET-SLOT-FACET-VALUE ...)
  ```

---

## Determination and Rule Chaining

### Slot Determination

- Prepare slot:
  ```lisp
  (SET-DETERMINATION-SLOT object (slots...))
  ```

- Trigger determination:
  ```lisp
  ($ object 'DETERMINE slot)
  ```

### Rule Types

- **Backward rule**:
  ```lisp
  (ADD-BACKWARD-RULE chainer premise conclusion slot-spec comment)
  ```
- **Forward rule**:
  ```lisp
  (ADD-FORWARD-RULE chainer premise conclusion comment)
  ```

- Launch chaining:
  ```lisp
  ($ chainer 'GO)
  ($ chainer 'SATURE)
  ```

---

## Determination Blocks & Attributes

### Determination Block

```lisp
(ADD-DETERMINATION-BLOC body name)
```

### Attribute

```lisp
(ADD-ATTRIBUTE-USER object slot function role)
```

---

## Hypothetical Worlds

- Root: `FONDAMENTAL`
- Access world slot:
  ```lisp
  (GET-SLOT-WORLD obj slot world)
  ```

- Create world:
  ```lisp
  (CREATE-HYPOTHETICAL-WOLRD sequence)
  ```

- Predicate:
  ```lisp
  (IN-A-WORLD-WHERE world description predicate)
  ```

---

## Backtracking

```lisp
(CREATE-POSSIBILITIES sequence function pointname subhypothesis)
(BACKTRACK)
(BACKTRACK-TO pointname)
```

---

## Tracing

Enable tracing:
```lisp
(SETQ *TRACE-LEVEL* '(5 6))
```

Trace levels range from `1` to `12` and cover all execution steps.

---

**End of GRAPHICUS Manual Overview**
