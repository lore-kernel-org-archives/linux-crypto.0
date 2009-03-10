From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: Tree for March 10 (crypto & NLATTR)
Date: Tue, 10 Mar 2009 20:56:59 +0100
Message-ID: <10f740e80903101256v2cfe08a8g410c297e019d8693@mail.gmail.com>
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
	 <49B6B821.5050302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <49B6B821.5050302@oracle.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 10, 2009 at 19:57, Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
> Stephen Rothwell wrote:
>> Changes since 20090306:
>>
>>
>> The driver-core tree gained a build failure due to a conflict with t=
he
>> crypto tree. =C2=A0I have applied a patch to the crypto tree for tod=
ay.
>
> I had several (4 of 50) randconfig builds fail with:
>
> lib/built-in.o: In function `__nla_reserve_nohdr':
> (.text+0xd08d): undefined reference to `skb_put'
> lib/built-in.o: In function `__nla_reserve':
> (.text+0xd121): undefined reference to `skb_put'
> lib/built-in.o: In function `nla_append':
> (.text+0xd493): undefined reference to `skb_put'
>
> which happens with CONFIG_NET=3Dn, CONFIG_CRYPTO=3Dy, CONFIG_CRYPTO_Z=
LIB=3D[my].
>
> CRYPTO_ZLIB selects NLATTR, but obviously the build of nlattr.c fails
> when CONFIG_NET=3Dn. =C2=A0Should CRYPTO_ZLIB depend on NET?
> Please don't say that CRYPTO_ZLIB should select NET.

Bummer, my fault (commit e9cc8bddaea3944fabfebb968bc88d603239beed,
netlink: Move netlink attribute parsing support to lib).

Obviously I was only worried about crypto/zlib.c needing nlattr.c
without pulling in the whole networking code, not about nlattr.c
itself needing networking functionality. But still, how could I have
missed this compile failure?

Does it sound sane to protect the routines that do call skb_put() by
#ifdef CONFIG_NET?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
							    -- Linus Torvalds
