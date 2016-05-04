From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/7] asm-generic/io.h: add io{read,write}64 accessors
Date: Thu, 05 May 2016 00:35:50 +0200
Message-ID: <16429831.u9JK7qO1GE@wuerfel>
References: <1462382179-11889-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:52381 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbcEDWgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 18:36:13 -0400
In-Reply-To: <1462382179-11889-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 04 May 2016 20:16:19 Horia Geant=C4=83 wrote:
> @@ -625,6 +645,16 @@ static inline u32 ioread32be(const volatile void=
 __iomem *addr)
>  }
>  #endif
> =20
> +#ifdef CONFIG_64BIT
> +#ifndef ioread64be
> +#define ioread64be ioread64be
> +static inline u64 ioread64be(const volatile void __iomem *addr)
> +{
> +       return __be64_to_cpu(__raw_readq(addr));
> +}
> +#endif
> +#endif /* CONFIG_64BIT */
> +
>  #ifndef iowrite16be
>  #define iowrite16be iowrite16be
>  static inline void iowrite16be(u16 value, void volatile __iomem *add=
r)
> @@ -641,6 +671,16 @@ static inline void iowrite32be(u32 value, volati=
le void __iomem *addr)
>  }
>  #endif
> =20
> +#ifdef CONFIG_64BIT
> +#ifndef iowrite64be
> +#define iowrite64be iowrite64be
> +static inline void iowrite64be(u64 value, volatile void __iomem *add=
r)
> +{
> +       __raw_writeq(__cpu_to_be64(value), addr);
> +}
> +#endif
> +#endif /* CONFIG_64BIT */
> +
>=20

I just noticed that these two are both a bit wrong, but they copy the
mistake that already exists in the 16 and 32 bit versions: If an
architecture overrides readq/writeq to have barriers but does not overr=
ide
ioread64be/iowrite64be, this will lack the barriers and behave differen=
tly
from the little-endian version. I think the only affected architecture
is ARC, since ARM and ARM64 both override the big-endian accessors to
have the correct barriers, and all others don't use barriers at all.

Maybe you can add a patch before this one to replace the 16/32-bit acce=
ssors
with ones that do a

static inline void iowrite32be(u32 value, volatile void __iomem *addr)
{
	writel(swab32(value), addr);
}

This will lead to a double-swap on architectures that don't override it=
,
but it will work correctly on all architectures without them having
to override the big-endian accessors.

Aside from that, the patch looks fine.

	Arnd
