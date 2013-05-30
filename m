From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 35/39] dmaengine: ste_dma40_ll: Replace meaningless
 register set with comment
Date: Thu, 30 May 2013 11:04:23 +0200
Message-ID: <CACRpkdbXVd7k9rzb-OKUmnW_9J+jWYhz=AjO09_Ymvd2_DOVcQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-36-git-send-email-lee.jones@linaro.org>
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
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Dan Williams <djbw@fb.com>,
	Per Forlin <per.forlin@stericsson.com>,
	Rabin Vincent <rabin@rab.in>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:61839 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967933Ab3E3JEX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 May 2013 05:04:23 -0400
Received: by mail-ie0-f169.google.com with SMTP id u16so28299350iet.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2013 02:04:23 -0700 (PDT)
In-Reply-To: <1368611522-9984-36-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Unsure of the author's intentions, rather than just removing the nop,
> we're replacing it with a comment containing the possible intention
> of the statement OR:ing with 0.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied. Missing Vinod's ACK.

Yours,
Linus Walleij
