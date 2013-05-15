From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 15/39] crypto: ux500/cryp - Prepare clock before enabling it
Date: Wed, 15 May 2013 19:11:46 +0200
Message-ID: <CACRpkdY_9=OO_E9pFLuihVmE4YvLmydk_b+jsGr_R0sELt0UvA@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-16-git-send-email-lee.jones@linaro.org>
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
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39168 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab3EORLq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 13:11:46 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so4207200iea.17
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 10:11:46 -0700 (PDT)
In-Reply-To: <1368611522-9984-16-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> If we fail to prepare the ux500-cryp clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This patch also looks like -rc series stuff for the crypto tree.

BTW: these two clk_prepare_enable() patches are
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
