args = process.argv
args.shift()
args.shift()
args = args.join(" ").split("{{");
args.shift()
args = args.join("{{").split("}}")
args.pop()
args = args.join("}}")
data = JSON.stringify(JSON.parse(args), null, 4)
console.log(data)
