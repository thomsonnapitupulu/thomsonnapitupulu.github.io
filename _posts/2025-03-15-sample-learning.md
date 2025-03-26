---
layout: post
title: Advanced TypeScript - Understanding Conditional Types and Mapped Types
date: 2025-03-15 09:00:00 -0500
category: learning
course_provider: Frontend Masters
tags: [typescript, javascript, web development]
---

# Advanced TypeScript: Understanding Conditional Types and Mapped Types

Recently, I completed the "Advanced TypeScript" course on Frontend Masters, taught by Mike North. The course covered several advanced TypeScript features, but I found the sections on conditional types and mapped types particularly enlightening.

## Course Overview

- **Instructor**: Mike North
- **Platform**: Frontend Masters
- **Duration**: 6 hours
- **Difficulty**: Advanced

## Key Concepts Learned

### Conditional Types

Conditional types allow us to create type transformations that depend on conditions. They follow a syntax similar to JavaScript's ternary operator:

```typescript
type CheckNumber<T> = T extends number ? 'Yes, it is a number' : 'No, it is not a number';

// Examples
type IsItANumber = CheckNumber<42>; // 'Yes, it is a number'
type IsItANumber2 = CheckNumber<'hello'>; // 'No, it is not a number'
```

#### The `infer` Keyword

One of the most powerful features of conditional types is the `infer` keyword, which enables extraction of types from other types:

```typescript
type GetReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

// Example
function fetchData(): Promise<User[]> {
  // implementation
}

type FetchReturn = GetReturnType<typeof fetchData>; // Promise<User[]>
```

### Mapped Types

Mapped types allow us to transform properties of an existing type to create a new type:

```typescript
type Optional<T> = {
  [K in keyof T]?: T[K];
};

// Example
interface User {
  id: number;
  name: string;
  email: string;
}

type OptionalUser = Optional<User>;
// Equivalent to:
// {
//   id?: number;
//   name?: string;
//   email?: string;
// }
```

#### Modifiers in Mapped Types

We can also add or remove modifiers like `readonly` and `?`:

```typescript
type Concrete<T> = {
  [K in keyof T]-?: T[K]; // Remove optional modifier
};

type ReadOnly<T> = {
  readonly [K in keyof T]: T[K];
};

type Mutable<T> = {
  -readonly [K in keyof T]: T[K]; // Remove readonly modifier
};
```

### Combining Conditional and Mapped Types

The real power comes when combining these concepts:

```typescript
type FilterPropsOfType<T, U> = {
  [K in keyof T as T[K] extends U ? K : never]: T[K]
};

// Example
interface Product {
  id: number;
  name: string;
  price: number;
  description: string;
  inStock: boolean;
}

type NumericProps = FilterPropsOfType<Product, number>; 
// { id: number; price: number; }
```

## Practical Applications

During the course, we built several utility types that I've already started using in my projects:

1. **DeepPartial**: Makes all properties optional recursively (useful for update operations)
2. **DeepReadonly**: Makes all properties readonly recursively (for immutable data)
3. **Pick/Omit with path notation**: For selecting nested properties

## Key Takeaways

1. TypeScript's type system is Turing complete, meaning you can create complex type transformations
2. Conditional types enable powerful type inference and transformation
3. Mapped types provide a concise way to transform object types
4. Combining these features allows for creation of highly reusable type utilities

## Code Examples from Practice Exercises

One of the exercises involved building a type-safe event emitter:

```typescript
type EventMap = {
  'user:login': { userId: string; timestamp: number };
  'user:logout': { userId: string; timestamp: number };
  'item:added': { itemId: string; quantity: number };
};

class TypedEventEmitter<TEventMap extends Record<string, any>> {
  private listeners: {
    [K in keyof TEventMap]?: ((data: TEventMap[K]) => void)[];
  } = {};

  on<K extends keyof TEventMap>(event: K, listener: (data: TEventMap[K]) => void): void {
    if (!this.listeners[event]) {
      this.listeners[event] = [];
    }
    this.listeners[event]!.push(listener);
  }

  emit<K extends keyof TEventMap>(event: K, data: TEventMap[K]): void {
    const eventListeners = this.listeners[event];
    if (eventListeners) {
      eventListeners.forEach(listener => listener(data));
    }
  }
}

// Usage
const emitter = new TypedEventEmitter<EventMap>();
emitter.on('user:login', ({ userId, timestamp }) => {
  console.log(`User ${userId} logged in at ${new Date(timestamp)}`);
});
```

## Next Steps

Building on what I learned in this course, I'm planning to:

1. Refactor our project's type definitions to use these advanced patterns
2. Create a library of reusable utility types for our team
3. Dive deeper into TypeScript compiler internals

If you're interested in advancing your TypeScript skills, I highly recommend this course. The concepts may seem abstract at first, but they can significantly improve the type safety and developer experience in your projects.

Have you used advanced TypeScript features in your projects? I'd love to hear about your experiences in the comments!