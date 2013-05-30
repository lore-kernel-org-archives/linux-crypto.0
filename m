From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 38/39] dmaengine: ste_dma40: Fetch the number of physical
 channels from DT
Date: Thu, 30 May 2013 11:15:20 +0200
Message-ID: <CACRpkdbKwU=gwPYPYgMoj1mRVgnw9zA9RpzmZStFAXVHrkFNRQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-39-git-send-email-lee.jones@linaro.org>
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
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Dan Williams <djbw@fb.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Rabin Vincent <rabin@rab.in>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41604 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967979Ab3E3JPU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 05:15:20 -0400
Received: by mail-ie0-f172.google.com with SMTP id 17so9999iea.17
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 02:15:20 -0700 (PDT)
In-Reply-To: <1368611522-9984-39-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:52 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Some platforms insist on obscure physical channel availability. This
> information is currently passed though platform data in internal BSP
> kernels. Once those platforms land, they'll need to configure them
> appropriately, so we may as well add the infrastructure.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied with Vinod's ACK.

Yours,
Linus Walleij
