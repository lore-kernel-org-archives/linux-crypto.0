From: Scott Wood <scottwood@freescale.com>
Subject: Re: [RFC][PATCH 2/2] crypto: caam - handle core endianness != caam
 endianness
Date: Mon, 31 Aug 2015 19:49:51 -0500
Message-ID: <1441068591.4966.47.camel@freescale.com>
References: <1440762306-7764-1-git-send-email-horia.geanta@freescale.com>
	 <1440762608-7866-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	<linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	Victoria Milhoan <vicki.milhoan@freescale.com>,
	Steve Cornelius <steve.cornelius@freescale.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>
To: Horia =?UTF-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440762608-7866-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2015-08-28 at 14:50 +0300, Horia Geant=C4=83 wrote:
> =20
> -#ifdef __BIG_ENDIAN
> -#define wr_reg32(reg, data) out_be32(reg, data)
> -#define rd_reg32(reg) in_be32(reg)
> +#ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_LE
> +#define caam16_to_cpu(value) le16_to_cpu(value)
> +#define cpu_to_caam16(value) cpu_to_le16(value)
> +#define caam32_to_cpu(value) le32_to_cpu(value)
> +#define cpu_to_caam32(value) cpu_to_le32(value)
> +#define caam64_to_cpu(value) le64_to_cpu(value)
> +#define cpu_to_caam64(value) cpu_to_le64(value)

What if we want to build a kernel that supports a chip with an LE CAAM =
and=20
another chip with a BE CAAM (e.g. ls1043a plus ls2080a)?  This informat=
ion=20
needs to come at runtime.

> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +#ifdef CONFIG_SOC_IMX7D

Likewise, why is there an ifdef for a particular SoC type?

-Scott
