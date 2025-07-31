import type { IntersectionType } from '../core'
import { MyIntersectingValue } from '../core'

// Example object of IntersectionType
const myObject: IntersectionType = {
    a: 42,
    b: 'frontend',
    c: true,
}

const otherObject = MyIntersectingValue

setInterval(() => {
    console.log(myObject, otherObject, myObject === otherObject)
}, 10000)
