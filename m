From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC][PATCH 1/2] arm64: add ioread64be and iowrite64be macros
Date: Wed, 2 Sep 2015 11:38:17 +0100
Message-ID: <20150902103817.GI25720@arm.com>
References: <1440762306-7764-1-git-send-email-horia.geanta@freescale.com>
 <1440762587-7815-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Scott Wood <scottwood@freescale.com>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	Steve Cornelius <steve.cornelius@freescale.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:35922 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbbIBKiW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2015 06:38:22 -0400
Content-Disposition: inline
In-Reply-To: <1440762587-7815-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 28, 2015 at 12:49:47PM +0100, Horia Geant=C4=83 wrote:
> This will allow device drivers to consistently use io{read,write}XXbe
> macros also for 64-bit accesses.
>=20
> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
> ---
>  arch/arm64/include/asm/io.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.=
h
> index 44be1e03ed65..9b6e408cfa51 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -174,13 +174,15 @@ extern void __iomem *ioremap_cache(phys_addr_t =
phys_addr, size_t size);
>  #define iounmap				__iounmap
> =20
>  /*
> - * io{read,write}{16,32}be() macros
> + * io{read,write}{16,32,64}be() macros
>   */
>  #define ioread16be(p)		({ __u16 __v =3D be16_to_cpu((__force __be16)=
__raw_readw(p)); __iormb(); __v; })
>  #define ioread32be(p)		({ __u32 __v =3D be32_to_cpu((__force __be32)=
__raw_readl(p)); __iormb(); __v; })
> +#define ioread64be(p)		({ __u64 __v =3D be64_to_cpu((__force __be64)=
__raw_readq(p)); __iormb(); __v; })
> =20
>  #define iowrite16be(v,p)	({ __iowmb(); __raw_writew((__force __u16)c=
pu_to_be16(v), p); })
>  #define iowrite32be(v,p)	({ __iowmb(); __raw_writel((__force __u32)c=
pu_to_be32(v), p); })
> +#define iowrite64be(v,p)	({ __iowmb(); __raw_writeq((__force __u64)c=
pu_to_be64(v), p); })

This looks like the first instance of this in the tree, so perhaps it's
also worth adding a version to asm-generic/io.h predicated on
CONFIG_64BIT?

Will
