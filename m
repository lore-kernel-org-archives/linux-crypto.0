From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 11/39] ARM: ux500: Remove unnecessary attributes from DMA
 channel request pdata
Date: Wed, 15 May 2013 19:05:44 +0200
Message-ID: <CACRpkdYLwywT0R7zyd2d=1bH+FajV=yopHrvTMpYRYF+4zkQDQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-12-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54778 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932942Ab3EORLe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 13:11:34 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar20so4179724iec.39
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 10:11:33 -0700 (PDT)
In-Reply-To: <1368611522-9984-12-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA data width and packet size information is only required at channel
> configuration time. Any information passed from platform data is passed
> directly to the DMA40 driver to use during channel allocation, but these
> pieces of information are subsequently ignored by the driver, so we may
> as well remove them.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij
