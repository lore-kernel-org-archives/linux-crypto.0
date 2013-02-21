From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/3] crypto: sahara: Add support for SAHARA in i.MX27.
Date: Thu, 21 Feb 2013 14:40:59 +0000
Message-ID: <201302211440.59577.arnd@arndb.de>
References: <1361449162-27302-1-git-send-email-javier.martin@vista-silicon.com> <201302211259.26763.arnd@arndb.de> <CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: kernel@pengutronix.de, herbert@gondor.apana.org.au,
	davem@davemloft.net, tony@atomide.com, swarren@nvidia.com,
	shawn.guo@linaro.org, gcembed@gmail.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: javier Martin <javier.martin@vista-silicon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3BUOlQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2013 09:41:16 -0500
In-Reply-To: <CACKLOr1-EPK=DLz0SY+1E35qSMdtCsueuqdzV4VZdbkoM+TD6A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 21 February 2013, javier Martin wrote:
> We know about the existence of DT and the constant migration process
> that is taking place towards it.
> 
> Moreover we are strongly interested in converting the Visstrim SM10
> platform to DT. Unfortunately, there are several issues that need to
> be solved so that Visstrim M10 can be fully converted to DT:
> - full SoC camera DT support
> - DT support for ov7670
> - pinctrl support for i.MX27

Ok, I see. Full device tree support is certainly asking too much then.

> Furthermore, we have limited resources at the moment and we have to
> decide priorities. But having an hybrid platform-DT support is our
> next task for Visstrim M10.

Ok, cool.

> However, I understand your concern about new drivers having DT
> support. Maybe a good approach could be that I added compile-tested
> only DT support for this driver and remove platform support for
> mainline submission (although we maintain it internally in our
> repositories).
> 
> What do you think?

Sounds good. Since it sounds like the hardware is available in all
imx27 device, maybe someone else can test your driver on an imx27
board that already has partial DT support when you add it to
arch/arm/boot/dts/imx27.dtsi?

Is there any reason why an imx27 based board would not support this
driver? Are there any other chips that could use it, e.g. imx25 or
imx6?

	Arnd
