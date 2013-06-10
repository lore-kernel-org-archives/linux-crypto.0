From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 06/39] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
Date: Mon, 10 Jun 2013 10:17:24 +0100
Message-ID: <20130610091724.GG20297@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-7-git-send-email-lee.jones@linaro.org>
 <CACRpkdZ=NJR3VRNJE2pSTJ8t1VCMq+wjH_s0NOi4AHko3no_KA@mail.gmail.com>
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
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47867 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3FJJRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Jun 2013 05:17:30 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so3846356eaj.31
        for <linux-crypto@vger.kernel.org>; Mon, 10 Jun 2013 02:17:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACRpkdZ=NJR3VRNJE2pSTJ8t1VCMq+wjH_s0NOi4AHko3no_KA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 15 May 2013, Linus Walleij wrote:

> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wr=
ote:
>=20
> > Now DMA DT bindings exist and are in use by he MMC and UART drivers=
, it
> > should be possible to remove them from the auxdata structure. Howev=
er,
> > after doing so the drivers fail. Common clk is still reliant on the
> > dev_name() call to do device name matching, which will fail due to =
the
> > fact that Device Tree naming differs somewhat do the more tradition=
al
> > conventions.
> >
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>=20
> Cannot be applied due to dependency on 5/39.

I think this can be applied now (if it hasn't already).

--=20
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
