From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 12/39] crypto: ux500/hash - Prepare clock before enabling it
Date: Mon, 20 May 2013 14:05:11 +0200
Message-ID: <CACRpkdbER9p+RkNauKtpby5Mr=Tu20F-Hd_0jMfpGJYPTEOwvg@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-13-git-send-email-lee.jones@linaro.org>
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
	Andreas Westin <andreas.westin@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58050 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3ETMFM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 May 2013 08:05:12 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so13775247iec.1
        for <linux-crypto@vger.kernel.org>; Mon, 20 May 2013 05:05:12 -0700 (PDT)
In-Reply-To: <1368611522-9984-13-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> If we fail to prepare the ux500-hash clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my dma40 branch with Herbert's ACK.

Yours,
Linus Walleij
