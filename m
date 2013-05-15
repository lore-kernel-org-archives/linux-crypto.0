From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 12/39] crypto: ux500/hash - Prepare clock before enabling it
Date: Wed, 15 May 2013 19:07:58 +0200
Message-ID: <CACRpkdYdf1j+V516CigFeGKv1B+Mf4mZk8g3ZwYAwa=rDP=7vg@mail.gmail.com>
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
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44740 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550Ab3EORH7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 May 2013 13:07:59 -0400
Received: by mail-ie0-f170.google.com with SMTP id aq17so4339208iec.29
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2013 10:07:59 -0700 (PDT)
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

This patch seems to be totally independent of the other stuff
in the patch series, and it even seems like an -rc fix to me
(I don't think the crypto device works without this).

This should go into the crypto tree?

Else please convince Herbert to give his ACK on this
before I apply it.

Yours,
Linus Walleij
