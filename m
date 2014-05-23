From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Fri, 23 May 2014 12:46:10 +0200
Message-ID: <201405231246.10365.arnd@arndb.de>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <7774492.yVryDeoI4M@wuerfel> <537E3E2F.7000407@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	rdunlap@infradead.org, maxime.ripard@free-electrons.com,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	davem@davemloft.net, grant.likely@linaro.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <537E3E2F.7000407@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 22 May 2014, Corentin LABBE wrote:
> Le 22/05/2014 17:28, Arnd Bergmann a =E9crit :
> > On Thursday 22 May 2014 17:09:56 LABBE Corentin wrote:
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> >=20
> > My feeling is that this should either be one driver that provides
> > all five algorithms unconditionally, or five drivers that are each
> > separate loadable modules and based on top of a common module
> > that only exports functions but has no active logic itself
>=20
> I agree for the split.
> It was my first intention but I feared to add too many files.
> So I propose to split in 6, sunxi-ss-hash.c, sunxi-ss-des.c, sunxi-ss=
-aes.c, sunxi-ss-rng.c, sunxi-ss-common.c and sunxi-ss.h
> Does can I add a sunxi-ss directory in drivers/crypto ?

Yes, I think a subdirectory would be best.


> >> +	/* If we have more than one SG, we cannot use kmap_atomic since
> >> +	 * we hold the mapping too long*/
> >> +	src_addr =3D kmap(sg_page(in_sg)) + in_sg->offset;
> >> +	if (src_addr =3D=3D NULL) {
> >> +		dev_err(ss_ctx->dev, "KMAP error for src SG\n");
> >> +		return -1;
> >> +	}
> >> +	dst_addr =3D kmap(sg_page(out_sg)) + out_sg->offset;
> >> +	if (dst_addr =3D=3D NULL) {
> >> +		kunmap(src_addr);
> >> +		dev_err(ss_ctx->dev, "KMAP error for dst SG\n");
> >> +		return -1;
> >> +	}
> >> +	src32 =3D (u32 *)src_addr;
> >> +	dst32 =3D (u32 *)dst_addr;
> >> +	ileft =3D nbytes / 4;
> >> +	oleft =3D nbytes / 4;
> >> +	sgileft =3D in_sg->length / 4;
> >> +	sgoleft =3D out_sg->length / 4;
> >> +	do {
> >> +		tmp =3D readl_relaxed(ss_ctx->base + SUNXI_SS_FCSR);
> >> +		rx_cnt =3D SS_RXFIFO_SPACES(tmp);
> >> +		tx_cnt =3D SS_TXFIFO_SPACES(tmp);
> >> +		todo =3D min3(rx_cnt, ileft, sgileft);
> >> +		if (todo > 0) {
> >> +			ileft -=3D todo;
> >> +			sgileft -=3D todo;
> >> +		}
> >> +		while (todo > 0) {
> >> +			writel_relaxed(*src32++, ss_ctx->base + SS_RXFIFO);
> >> +			todo--;
> >> +		}
> >=20
> > I wonder if this is meant to be used in combination with a dma engi=
ne
> > rather than accessed with writel/readl.
>=20
> You could do both, but the dmaengine driver is under development.
> When it will be ready, I will add DMA support.
> But my intention is to keep both mode, since poll mode is better than=
 DMA for small request.

Ok, I see.

> > How does the original driver do it?
>=20
> There are no original driver, this driver is the first for the Securi=
ty System.

Ah, I thought there was one in the allwinner BSP kernel.

	Arnd
