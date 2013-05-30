From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Date: Thu, 30 May 2013 09:12:11 +0100
Message-ID: <20130530081211.GA1915@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <20130529175741.GG21290@arwen.pp.htv.fi>
 <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe Balbi <balbi@ti.com>,
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
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:55348 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966916Ab3E3IMS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 04:12:18 -0400
Received: by mail-wi0-f179.google.com with SMTP id hq7so4240072wib.12
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 01:12:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACRpkda3d9_XvqRmy0nbWyri2xC3Qst2U2Sv=UDxV4w-UxK_JQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 30 May 2013, Linus Walleij wrote:

> On Wed, May 29, 2013 at 7:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Wed, May 15, 2013 at 10:51:43AM +0100, Lee Jones wrote:
> >> For all ux500 based platforms the maximum number of end-points are=
 used.
> >> Move this knowledge into the driver so we can relinquish the burde=
n from
> >> platform data. This also removes quite a bit of complexity from th=
e driver
> >> and will aid us when we come to enable the driver for Device Tree.
> >>
> >> Cc: Felipe Balbi <balbi@ti.com>
> >> Cc: linux-usb@vger.kernel.org
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >
> > for drivers/usb/musb
> >
> > Acked-by: Felipe Balbi <balbi@ti.com>
>=20
> Is that only for this patch 20/39 or also 21, 22 & 23?
>=20
> Poke us if we should re-send them...

I read this as all patches in the series "for drivers/usb/musb".

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
