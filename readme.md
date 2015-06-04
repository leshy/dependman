dependman

takes dictionary of format
    {
      name:       String
      requires:   Array || String
      before:     Array || String
      after:      Array || String
      init:       Function // async or sync, can return a promise or accept a callback
    }

and makes sure to run init functions in order, using bluebird promises