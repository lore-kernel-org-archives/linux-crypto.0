From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 09/39] ARM: ux500: Remove DMA address look-up table
Date: Wed, 15 May 2013 19:03:10 +0200
Message-ID: <CACRpkdasU0a_T5rwvRah0VpddrOGardLQkNCMRngUdxOUnSH7A@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-10-git-send-email-lee.jones@linaro.org>
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
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56140 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab3EORDL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 13:03:11 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so4327031iec.29
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 10:03:11 -0700 (PDT)
In-Reply-To: <1368611522-9984-10-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> DMA addresses are now passed as part of the dmaengine API by invoking
> dmaengine_slave_config(). So there's no requirement for the DMA40
> driver to look them up in a table provided by platform data. This
> method does not fit in well using Device Tree either.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Good riddance. Patch tentatively applied.
Awaiting Vinod's ACK for include/platform_data/*.

Yours,
Linus Walleij
