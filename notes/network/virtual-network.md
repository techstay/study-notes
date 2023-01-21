# 虚拟组网及内网穿透方案

这里记录一些常用的虚拟组网手段。

## tailscale && headscale

[tailescale](https://tailscale.com)是目前评价很不错的一个 VPN，基于 wireguard 技术，支持 P2P，在可能的情况下可以打穿隧道，让几台设备直连，延迟更低也更加安全。

tailscale 免费账号支持单个用户和 20 台设备，1 个子网路由但无法自定义 IP 段，一般情况下是够用了。不过因为是基于 UDP 的协议，所以在没有打通隧道的情况下，需要通过 tailscale 的网络进行连接，速度和延迟会受到影响。

tailscale 是一个私有的服务，通过官方服务器承载。而[headscale](https://github.com/juanfont/headscale)是一个开源的替代产品，实现了 tailscale 的多数功能，可以部署在自己的服务器上。

如果为很多台设备组网，又不方便为每台设备单独安装 tailscale，可以使用子网路由功能。在路由器上安装 tailscale，然后通告子网网段，然后在 tailscale 管理控制台上启用，就能实现访问一个网络下的多台设备了。

```sh
opkg install tailscale

tailscale up --advertise-routes=192.168.31.0/24
```

调试

```sh
tailscale ping <host>
tailscale netcheck
tailscale status
```

## xedge.cc

[xEdge](https://xedge.cc)是一个基于 tailscale 和 headscale 等开源代码开发的国内版 tailescale，配置起来同样简单，实测可能因为国内节点的关系，打洞成功率高很多，和朋友开黑玩游戏毫无压力。

## zerotier

[zerotier](https://www.zerotier.com) 是另一个不错的 VPN，功能和 tailscale 类似。

zerotier 免费版账户支持单个用户和 25 台设备。tailscale 和 zerotier 在不同网络环境下的表现不同，如果其中一个用着不行的话，可以尝试一下另外一个，或许表现会好很多。

zerotier 要开启子网路由很简单，一般的 openwrt 固件已经包含了 zerotier 插件，只需要在插件设置中添加网络 ID，然后在 zerotier 管理控制台中设置子网和路由 IP 即可。

调试

```sh
zerotier-cli info
zerotier-cli peers
zerotier-cli listnetworks
```

## happyn

[happyn](https://www.happyn.cn)是一个类似 tailescale 的虚拟组网方案，因为节点在国内，所以即使穿透失败，通过国内节点中转，速度也不会太慢。目前该服务在内测阶段，只有免费版账户，所有设备共享 10Mb 带宽，每月 10GB 流量限制，单个网络和最多 10 台设备的支持。

使用之前需要先注册一个账号，然后将信息填写到客户端中。如果已安装了 tailscale 等服务，可能出现冲突，可到[官方文档](https://happyncn.feishu.cn/wiki/wikcnxLh9x8jmgtRfTZYguwvfIf)寻找解决方案。

## frp && sakura frp

[frp](https://github.com/fatedier/frp)是一个开源的内网穿透软件，可以将本地服务暴露到公网中。frp 需要使用一台拥有公网 IP 地址的设备作为服务端，本地设备作为客户端来进行连接。这个要求对于一般人来说有点高，但是拥有一台自己的服务器可以进行完全的自定义配置，如设置端口号等等。这是一般的内网穿透服务所不具备的功能，它们为了节约资源，通常只会提供随机域名和端口号来进行访问。

[sakura frp](https://www.natfrp.com)是一个免费的内网穿透服务，提供了最高 10Mbps 以及每月 5GB 流量的 frp 内网穿透服务，还可以通过网页签到的方式获取更多流量。sakura frp 有自己的图形界面启动器，相比于纯手工配置的 frp，更适合一般用户使用。如果要使用 sakura frp 的国内节点，需要先购买 1 元的实名认证服务，否则只能使用一个延迟较高的国外节点。

## ngrok

[ngrok](https://ngrok.com)和 frp 类似，也是一个内网穿透软件，同时提供了在线服务可以直接使用。免费版账户只能使用给定的域名和随机分配的公网端口号访问。

ngrok 可通过 scoop 安装。

```sh
scoop install ngrok
```

登录网页端获取 TOKEN，然后通过命令行登录。

```sh
ngrok config add-authtoken TOKEN
```

最后通过命令行暴露内网服务。

```sh
ngrok http 8000
ngrok tcp 22
```

更多配置参考[官方文档](https://ngrok.com/docs/)。