From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 34/39] dmaengine: ste_dma40: Convert data_width from
 register bit format to value
Date: Thu, 30 May 2013 11:01:27 +0200
Message-ID: <CACRpkdZ6bijvD1S+YL2W+8R_DVGrmPshiMVigg7iK4zen8r57g@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-35-git-send-email-lee.jones@linaro.org>
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
Received: from mail-ie0-f173.google.com ([209.85.223.173]:44575 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967932Ab3E3JB2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 05:01:28 -0400
Received: by mail-ie0-f173.google.com with SMTP id k13so8066014iea.32
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 02:01:28 -0700 (PDT)
In-Reply-To: <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> When a DMA client requests and configures a DMA channel, it requests
> data_width in Bytes. The DMA40 driver then swiftly converts it over to
> the necessary register bit value. Unfortunately, for any subsequent
> calculations we have to shift '1' by the bit pattern (1 << data_width)
> times to make any sense of it.
>
> This patch flips the semantics on its head and only converts the value
> to its respective register bit pattern when writing to registers. This
> way we can use the true data_width (in Bytes) value.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied with what I interpret as Vinod's ACK
("okay..." statement on last reply.)

Yours,
Linus Walleij
