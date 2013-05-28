From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Date: Tue, 28 May 2013 17:48:03 +0100
Message-ID: <20130528164803.GA3012@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
 <20130528162715.GB28253@arwen.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Walleij <linus.walleij@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Vinod Koul <vinod.koul@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Felipe Balbi <balbi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44211 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934805Ab3E1QsJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 12:48:09 -0400
Received: by mail-ee0-f42.google.com with SMTP id c50so4722569eek.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2013 09:48:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130528162715.GB28253@arwen.pp.htv.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Felipe

> > > For all ux500 based platforms the maximum number of end-points ar=
e used.
> > > Move this knowledge into the driver so we can relinquish the burd=
en from
> > > platform data. This also removes quite a bit of complexity from t=
he driver
> > > and will aid us when we come to enable the driver for Device Tree=
=2E
> > >
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: linux-usb@vger.kernel.org
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >=20
> > I guess this stuff is dependent on the stuff Fabio has recently sen=
t to
> > Felipe for the ux500 musb DMA so these musb patches should
> > primarily go through his tree.
> >=20
> > It seems like the later changes to the platform code
> > (arch/arm/mach-ux500) may be sufficiently orthogonal
> > so it can be done out-of-order?
> >=20
> > I can't merge any of this without Felipes ACKs in any
> > case.
>=20
> Do you want to take this yourself ? I haven't fully read the series y=
et,
> but seems like this depends on the rest of the series. If you want to
> take it, let me know I can ack the patches as soon as I'm done
> reviewing.

Yes that would be ideal, if you wouldn't mind.

Kind regards,
Lee

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
