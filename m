From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Sat, 15 Nov 2014 12:08:30 +0100
Message-ID: <2542656.2ocf2Vp6rc@wuerfel>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com> <1415621455-10468-2-git-send-email-james.hartley@imgtec.com> <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: James Hartley <james.hartley@imgtec.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	joe@perches.com, mchehab@osg.samsung.com,
	Antti Palosaari <crope@iki.fi>, jg1.han@samsung.com,
	linux-crypto@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52261 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaKOLJA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Nov 2014 06:09:00 -0500
In-Reply-To: <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 14 November 2014 15:59:02 Andrew Bresticker wrote:
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index 2fb0fdf..4b931eb 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -436,4 +436,17 @@ config CRYPTO_DEV_QCE
> >           hardware. To compile this driver as a module, choose M here. The
> >           module will be called qcrypto.
> >
> > +config CRYPTO_DEV_IMGTEC_HASH
> > +        tristate "Imagination Technologies hardware hash accelerator"
> 
> Is there no meaningful depends-on here?  There's no MACH_PISTACHIO
> yet, but perhaps MIPS for now?  Also, {readl,writel}_relaxed aren't
> available on all architectures.
> 

I've queued up support for {readl,writel}_relaxed on all architectures
for 3.19, based on a series from Will Deacon.

	Arnd
