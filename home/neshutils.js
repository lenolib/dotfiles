sleep = s => {require('child_process').execSync(`sleep ${s}`)};

//await = promise => {
//  ret = undefined;
//  promise.then(response=>ret=response);
//  return ret;
//}
//await = promise => promise.then(x=>r=x);
await = promise => promise.then(x=>{r=x; console.log('\n[Out:]\n', r)})
const print = (prefix, obj) => {
    if (obj) {
        console.log(
            util.inspect(prefix, {depth: null, colors: true}),
            util.inspect(obj, {depth: null, colors: true}),
        );
    } else {
        console.log(util.inspect(prefix, {depth: null, colors: true}));
    }
};