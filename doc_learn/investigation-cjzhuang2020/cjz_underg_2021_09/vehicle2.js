//vehicle id
let vehicleId = "0xd8717f56d3e794d4d1e7ecbb0cc76d0f153292ea";
let vehecleStatus = 0;

let vehiclePosition = "wx4epnz0q70"
let vehicleRoute= ["wx4epnz0q70","wx4epjr1wrb","wx4ep5z5nk8","wx4ep4rhw30","wx4ep0zjymb","wx4dzprpq68"];
let vehicleIntersection = vehicleRoute[0];
let vehicleCoords = ["wx4epnz0q4z","wx4epnxpq1r","wx4epnxnnpz","wx4epnxjnnp","wx4epnxhnhx","wx4epnx5n5p","wx4epnx4n1r","wx4epnx0ypz","wx4epnrpynr","wx4epnrnyhx","wx4epnrjy5p","wx4epnrhy1x","wx4epnr5wpz","wx4epnr4wnr","wx4epnr1whz","wx4epnr0w5p","wx4epnppw1x","wx4epnpnw0p","wx4epnpjqnr","wx4epnphqhz","wx4epnp5q5p","wx4epnp4q1x","wx4epnp1q0p","wx4epnp0nnr","wx4epjzpnhz","wx4epjznn5r","wx4epjzjn1x","wx4epjzhn0p","wx4epjz4ynx","wx4epjz1yhz","wx4epjz0y5r","wx4epjxpy1z","wx4epjxny0p","wx4epjxjwnx","wx4epjxhwjp","wx4epjx5w5r","wx4epjx4w1z","wx4epjx1w0p","wx4epjx0qnx","wx4epjrpqjp","wx4epjrnq5r","wx4epjrjq1z","wx4epjrhq0r","wx4epjr5nnx","wx4epjr4njp","wx4epjr1n5x","wx4epjr0n1z","wx4epjppn0r","wx4epjpjynz","wx4epjphyjp","wx4epjp5y5x","wx4epjp4y4p","wx4epjp1y0r","wx4epjp0wnz","wx4ephzpwjr","wx4ephznw5x","wx4ephzjw4p","wx4ephzhw0r","wx4ephz5qnz","wx4ephz4qjr","wx4ephz1q5x","wx4ephz0q4p","wx4ephxpq0x","wx4ephxnnnz","wx4ephxjnjr","wx4ephxhn5z","wx4ephx5n4p","wx4ephx4n0x","wx4ephx0ypp","wx4ephrpyjr","wx4ephrny5z","wx4ephrjy4r","wx4ephrhy0x","wx4ephr5wpp","wx4ephr4wjr","wx4ephr1w5z","wx4ephr0w4r","wx4ephppw0x","wx4ephpnqpp","wx4ephpjqjx","wx4ephphq5z","wx4ephp5q4r","wx4ephp4q0z","wx4ephp1npp","wx4ephp0njx","wx4ep5zpnhp","wx4ep5znn4r","wx4ep5zjn0z","wx4ep5z5ypr","wx4ep5z4yjx","wx4ep5z1yhp","wx4ep5z0y4x","wx4ep5xpy0z","wx4ep5xnwpr","wx4ep5xjwjx","wx4ep5xhwhp","wx4ep5x5w4x","wx4ep5x4w0z","wx4ep5x1qpr","wx4ep5x0qjz","wx4ep5rpqhp","wx4ep5rnq4x","wx4ep5rjq1p","wx4ep5rhnpr","wx4ep5r5njz","wx4ep5r4nhr","wx4ep5r1n4x","wx4ep5r0n1p","wx4ep5pnypx","wx4ep5pjyjz","wx4ep5phyhr","wx4ep5p5y4x","wx4ep5p4y1p","wx4ep5p1wpx","wx4ep5p0wjz","wx4ep4zpwhr","wx4ep4znw4z","wx4ep4zjw1p","wx4ep4zhqpx","wx4ep4z5qnp","wx4ep4z4qhr","wx4ep4z1q4z","wx4ep4z0q1r","wx4ep4xpnpx","wx4ep4xnnnp","wx4ep4xjnhx","wx4ep4xhn4z","wx4ep4x5n1r","wx4ep4x1ypz","wx4ep4x0ynp","wx4ep4rpyhx","wx4ep4rny4z","wx4ep4rjy1r","wx4ep4rhwpz","wx4ep4r5wnp","wx4ep4r4whx","wx4ep4r1w5p","wx4ep4r0w1r","wx4ep4ppqpz","wx4ep4pnqnr","wx4ep4pjqhx","wx4ep4phq5p","wx4ep4p5q1x","wx4ep4p4npz","wx4ep4p1nnr","wx4ep4p0nhz","wx4ep1zpn5p","wx4ep1znn1x","wx4ep1zhypz","wx4ep1z5ynr","wx4ep1z4yhz","wx4ep1z1y5p","wx4ep1z0y1x","wx4ep1xpy0p","wx4ep1xnwnr","wx4ep1xjwhz","wx4ep1xhw5r","wx4ep1x5w1x","wx4ep1x4w0p","wx4ep1x1qnx","wx4ep1x0qhz","wx4ep1rpq5r","wx4ep1rnq1z","wx4ep1rjq0p","wx4ep1rhnnx","wx4ep1r5njp","wx4ep1r4n5r","wx4ep1r1n1z","wx4ep1r0n0p","wx4ep1pnynx","wx4ep1pjyjp","wx4ep1phy5r","wx4ep1p5y1z","wx4ep1p4y0r","wx4ep1p1wnx","wx4ep1p0wjp","wx4ep0zpw5x","wx4ep0znw1z","wx4ep0zjw0r","wx4ep0zhqnz","wx4ep0z5qjp","wx4ep0z4q5x","wx4ep0z1q4p","wx4ep0z0q0r","wx4ep0xpnnz","wx4ep0xnnjp","wx4ep0xjn5x","wx4ep0xhn4p","wx4ep0x5n0r","wx4ep0x1ynz","wx4ep0x0yjr","wx4ep0rpy5x","wx4ep0rny4p","wx4ep0rjy0x","wx4ep0rhwnz","wx4ep0r5wjr","wx4ep0r4w5z","wx4ep0r1w4p","wx4ep0r0w0x","wx4ep0ppqpp","wx4ep0pnqjr","wx4ep0pjq5z","wx4ep0phq4r","wx4ep0p5q0x","wx4ep0p4npp","wx4ep0p1njr","wx4ep0p0n5z","wx4dzpzpn4r","wx4dzpznn0x","wx4dzpzhypp","wx4dzpz5yjx","wx4dzpz4y5z","wx4dzpz1y4r","wx4dzpz0y0z","wx4dzpxpwpp","wx4dzpxnwjx","wx4dzpxjwhp","wx4dzpxhw4r","wx4dzpx5w0z","wx4dzpx4qpr","wx4dzpx1qjx","wx4dzpx0qhp"]