From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Wed, 3 Oct 2018 13:15:38 +0200
Message-ID: <CAKv+Gu-oCH4D_otvMk+R_6z_p73Le90PkdQUUPnT6q0kWVL4Jw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180925145622.29959-24-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25 September 2018 at 16:56, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> WireGuard is a layer 3 secure networking tunnel made specifically for
> the kernel, that aims to be much simpler and easier to audit than IPsec.
...
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> ---
>  MAINTAINERS                                  |   8 +
>  drivers/net/Kconfig                          |  30 +
>  drivers/net/Makefile                         |   1 +
>  drivers/net/wireguard/Makefile               |  18 +
>  drivers/net/wireguard/allowedips.c           | 404 ++++++++++
>  drivers/net/wireguard/allowedips.h           |  55 ++
>  drivers/net/wireguard/cookie.c               | 234 ++++++
>  drivers/net/wireguard/cookie.h               |  59 ++
>  drivers/net/wireguard/device.c               | 438 +++++++++++
>  drivers/net/wireguard/device.h               |  65 ++
>  drivers/net/wireguard/hashtables.c           | 209 +++++
>  drivers/net/wireguard/hashtables.h           |  63 ++
>  drivers/net/wireguard/main.c                 |  65 ++
>  drivers/net/wireguard/messages.h             | 128 +++
>  drivers/net/wireguard/netlink.c              | 606 ++++++++++++++
>  drivers/net/wireguard/netlink.h              |  12 +
>  drivers/net/wireguard/noise.c                | 784 +++++++++++++++++++
>  drivers/net/wireguard/noise.h                | 129 +++
>  drivers/net/wireguard/peer.c                 | 191 +++++
>  drivers/net/wireguard/peer.h                 |  87 ++
>  drivers/net/wireguard/queueing.c             |  52 ++
>  drivers/net/wireguard/queueing.h             | 193 +++++
>  drivers/net/wireguard/ratelimiter.c          | 220 ++++++
>  drivers/net/wireguard/ratelimiter.h          |  19 +
>  drivers/net/wireguard/receive.c              | 595 ++++++++++++++
>  drivers/net/wireguard/selftest/allowedips.h  | 663 ++++++++++++++++
>  drivers/net/wireguard/selftest/counter.h     | 103 +++
>  drivers/net/wireguard/selftest/ratelimiter.h | 178 +++++
>  drivers/net/wireguard/send.c                 | 420 ++++++++++
>  drivers/net/wireguard/socket.c               | 432 ++++++++++
>  drivers/net/wireguard/socket.h               |  44 ++
>  drivers/net/wireguard/timers.c               | 256 ++++++
>  drivers/net/wireguard/timers.h               |  30 +
>  drivers/net/wireguard/version.h              |   1 +
>  include/uapi/linux/wireguard.h               | 190 +++++
>  tools/testing/selftests/wireguard/netns.sh   | 499 ++++++++++++
>  36 files changed, 7481 insertions(+)
>  create mode 100644 drivers/net/wireguard/Makefile
>  create mode 100644 drivers/net/wireguard/allowedips.c
>  create mode 100644 drivers/net/wireguard/allowedips.h
>  create mode 100644 drivers/net/wireguard/cookie.c
>  create mode 100644 drivers/net/wireguard/cookie.h
>  create mode 100644 drivers/net/wireguard/device.c
>  create mode 100644 drivers/net/wireguard/device.h
>  create mode 100644 drivers/net/wireguard/hashtables.c
>  create mode 100644 drivers/net/wireguard/hashtables.h
>  create mode 100644 drivers/net/wireguard/main.c
>  create mode 100644 drivers/net/wireguard/messages.h
>  create mode 100644 drivers/net/wireguard/netlink.c
>  create mode 100644 drivers/net/wireguard/netlink.h
>  create mode 100644 drivers/net/wireguard/noise.c
>  create mode 100644 drivers/net/wireguard/noise.h
>  create mode 100644 drivers/net/wireguard/peer.c
>  create mode 100644 drivers/net/wireguard/peer.h
>  create mode 100644 drivers/net/wireguard/queueing.c
>  create mode 100644 drivers/net/wireguard/queueing.h
>  create mode 100644 drivers/net/wireguard/ratelimiter.c
>  create mode 100644 drivers/net/wireguard/ratelimiter.h
>  create mode 100644 drivers/net/wireguard/receive.c
>  create mode 100644 drivers/net/wireguard/selftest/allowedips.h
>  create mode 100644 drivers/net/wireguard/selftest/counter.h
>  create mode 100644 drivers/net/wireguard/selftest/ratelimiter.h
>  create mode 100644 drivers/net/wireguard/send.c
>  create mode 100644 drivers/net/wireguard/socket.c
>  create mode 100644 drivers/net/wireguard/socket.h
>  create mode 100644 drivers/net/wireguard/timers.c
>  create mode 100644 drivers/net/wireguard/timers.h
>  create mode 100644 drivers/net/wireguard/version.h
>  create mode 100644 include/uapi/linux/wireguard.h
>  create mode 100755 tools/testing/selftests/wireguard/netns.sh
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5967c737f3ce..32db7ebad86e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15823,6 +15823,14 @@ L:     linux-gpio@vger.kernel.org
>  S:     Maintained
>  F:     drivers/gpio/gpio-ws16c48.c
>
> +WIREGUARD SECURE NETWORK TUNNEL
> +M:     Jason A. Donenfeld <Jason@zx2c4.com>
> +S:     Maintained
> +F:     drivers/net/wireguard/
> +F:     tools/testing/selftests/wireguard/
> +L:     wireguard@lists.zx2c4.com
> +L:     netdev@vger.kernel.org
> +
>  WISTRON LAPTOP BUTTON DRIVER
>  M:     Miloslav Trmac <mitr@volny.cz>
>  S:     Maintained
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index d03775100f7d..aa631fe3b395 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -70,6 +70,36 @@ config DUMMY
>           To compile this driver as a module, choose M here: the module
>           will be called dummy.
>
> +config WIREGUARD
> +       tristate "WireGuard secure network tunnel"
> +       depends on NET && INET

I think you need to add IPV6 here

> +       select NET_UDP_TUNNEL
> +       select DST_CACHE
> +       select ZINC_CHACHA20POLY1305
> +       select ZINC_BLAKE2S
> +       select ZINC_CURVE25519
> +       default m

Please drop this - we usually leave it up to the defconfigs or distro
configs to enable stuff like this.

> +       help
> +         WireGuard is a secure, fast, and easy to use replacement for IPSec
> +         that uses modern cryptography and clever networking tricks. It's
> +         designed to be fairly general purpose and abstract enough to fit most
> +         use cases, while at the same time remaining extremely simple to
> +         configure. See www.wireguard.com for more info.
> +
> +         It's safe to say Y or M here, as the driver is very lightweight and
> +         is only in use when an administrator chooses to add an interface.
> +
> +config WIREGUARD_DEBUG
> +       bool "Debugging checks and verbose messages"
> +       depends on WIREGUARD
> +       help
> +         This will write log messages for handshake and other events
> +         that occur for a WireGuard interface. It will also perform some
> +         extra validation checks and unit tests at various points. This is
> +         only useful for debugging.
> +
> +         Say N here unless you know what you're doing.
> +
>  config EQUALIZER
>         tristate "EQL (serial line load balancing) support"
>         ---help---
...
