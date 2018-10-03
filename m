From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Wed, 3 Oct 2018 16:28:56 +0200
Message-ID: <CAHmME9pQn3TJtwKuna=qrgm5Sc4sXN2VYEYXkGyKePezkQGu+Q@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <CAKv+Gu-oCH4D_otvMk+R_6z_p73Le90PkdQUUPnT6q0kWVL4Jw@mail.gmail.com>
 <CAHmME9rWkLT=92QVhbYZd1oee5wYtVRnYu0BGHkGn3bXjN-OxQ@mail.gmail.com>
 <CAKv+Gu9dOLbiBYKp9HG+GSPML0OJ-UuXnGsJO_re2S75ZF_qNA@mail.gmail.com> <CAKv+Gu-d07eqZTzh04dTtCjpnG-0fKsh7=k9BQYW_bx0Ju6gDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-d07eqZTzh04dTtCjpnG-0fKsh7=k9BQYW_bx0Ju6gDw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 3, 2018 at 4:25 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> On Wed, Oct 3, 2018 at 1:15 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >>> > +config WIREGUARD
> >>> > +       tristate "WireGuard secure network tunnel"
> >>> > +       depends on NET && INET
> >>>
> >>> I think you need to add IPV6 here
> >>
> >> Nope. Like much of the net tree, WireGuard can function on ipv6-less
> >> kernels. If you do find something in WireGuard isn't working in a
> >> v6-less configuration, I consider that to be a bug that needs fixing.
> >>
> >
> > OK. I hit a build error yesterday, and setting CONFIG_IPV6 fixed it.
> > Let me see if I can reproduce.
>
> I get
>
> drivers/net/wireguard/socket.o: In function `send6':
> socket.c:(.text+0x56c): undefined reference to `ipv6_chk_addr'
> drivers/net/wireguard/socket.o: In function `wg_socket_send_skb_to_peer':
> socket.c:(.text+0x904): undefined reference to `ipv6_chk_addr'
> drivers/net/wireguard/socket.o: In function `wg_socket_init':
> socket.c:(.text+0x161c): undefined reference to `ipv6_mod_enabled'
>
> if I build my kernel with WireGuard built in but IPv6 support enabled
> as a module.

Nice catch. Looks like the norm is adding "depends on IPV6 || !IPV6"
or the like. I'll play and make sure this works for v7. Thanks for
pointing it out.

Jason
