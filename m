From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/6] crypto: ux500/cryp - Enable DT probing of the driver
Date: Fri, 24 May 2013 08:26:04 +0200
Message-ID: <CACRpkdbfCyUNevTWzW5JzPoOY83j2vPgcPNg_hU=SDMp1GX-0g@mail.gmail.com>
References: <1368703646-26418-1-git-send-email-lee.jones@linaro.org>
	<1368703646-26418-6-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57056 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3EXG0E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 May 2013 02:26:04 -0400
Received: by mail-ie0-f176.google.com with SMTP id at1so11088467iec.21
        for <linux-crypto@vger.kernel.org>; Thu, 23 May 2013 23:26:04 -0700 (PDT)
In-Reply-To: <1368703646-26418-6-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 16, 2013 at 1:27 PM, Lee Jones <lee.jones@linaro.org> wrote:

> By providing an OF match table with a suitable compatible string, we
> can ensure the ux500-crypt driver is probed by supplying an associated
> DT node in a given platform's Device Tree.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c |    6 ++++++

W00t! No binding document?

OK I guess it's just reg, irq ... but still it's compulsory,
right?

Yours,
Linus Walleij
