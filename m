From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 05/39] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
Date: Mon, 10 Jun 2013 10:15:03 +0100
Message-ID: <20130610091503.GF20297@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Felipe Balbi <balbi@ti.com>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45908 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3FJJPI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Jun 2013 05:15:08 -0400
Received: by mail-ea0-f181.google.com with SMTP id a15so2832705eae.40
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2013 02:15:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 15 May 2013, Linus Walleij wrote:

> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wr=
ote:
>=20
> > It was required to pass DMA channel configuration information to th=
e
> > MMC driver before the new DMA API was in place. Now that it is, and
> > is fully compatible with Device Tree we can stop doing that.
> >
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> So since the use of dma_request_slave_channel() is not upstream,
> I guess this will break DMA use (i.e slow down transfers!) on all
> device tree boots?
>=20
> I'd be happy to apply it once the MMCI patch is in linux-next
> indicating there may just be a window in the merge period
> where it falls back to IRQ mode, but I don't want to disable
> DMA on DT boots for an entire kernel cycle just like that.
>=20
> Not applied as of yet.

I believe it's now okay to apply this.

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
