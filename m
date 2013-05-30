From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Date: Thu, 30 May 2013 09:44:49 +0200
Message-ID: <CACRpkda+C7qzKSssXStkcM4eOQaHUcWEUd6txfV-pAWdTT=YEw@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-21-git-send-email-lee.jones@linaro.org>
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
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59436 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967558Ab3E3Hou (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 03:44:50 -0400
Received: by mail-ie0-f180.google.com with SMTP id b11so13165291iee.39
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 00:44:49 -0700 (PDT)
In-Reply-To: <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> For all ux500 based platforms the maximum number of end-points are used.
> Move this knowledge into the driver so we can relinquish the burden from
> platform data. This also removes quite a bit of complexity from the driver
> and will aid us when we come to enable the driver for Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my dma40 branch with Felipe's ACK.

Thanks!
Linus Walleij
