From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/9 v2] crypto: ux500/hash - Prepare clock before enabling it
Date: Thu, 25 Apr 2013 13:49:06 +0200
Message-ID: <CACRpkdYrCA6SduwMJF=7C9hyjP2Or7gxhjVFtLshdzkbYnxX1w@mail.gmail.com>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org>
	<1366280825-31136-2-git-send-email-lee.jones@linaro.org>
	<20130419122428.GC3432@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:35281 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3DYLtI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Apr 2013 07:49:08 -0400
Received: by mail-ia0-f182.google.com with SMTP id w33so276870iag.13
        for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2013 04:49:06 -0700 (PDT)
In-Reply-To: <20130419122428.GC3432@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 19, 2013 at 2:24 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Slight change of plan for v2.
>
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
>
> Arnd, can you confirm your Ack please?

Do you really want letters to Arnd to be part of the commit log?

>
> ---

Note: stuff following the three dashes (---) will be *omitted*
from the change log. This seems to be turned upside-down.

>
> crypto: ux500/hash - Prepare clock before enabling it
>
> If we fail to prepare the ux500-hash clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Pls include Ulf Hansson <ulf.hansson@linaro.org> on this patch.

Yours,
Linus Walleij
