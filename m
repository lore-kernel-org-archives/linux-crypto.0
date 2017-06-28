From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - Reenable sha1/aes in FIPS mode
Date: Wed, 28 Jun 2017 15:05:21 +0200
Message-ID: <2993400.PYF8rrXN5v@positron.chronox.de>
References: <20170628110907.GA14186@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60426 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751511AbdF1NFe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 09:05:34 -0400
In-Reply-To: <20170628110907.GA14186@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Juni 2017, 13:09:07 CEST schrieb Herbert Xu:

Hi Herbert,

> The combination of sha1 and aes was disabled in FIPS Mode
> accidentally.  This patch reenables it.
> 
> Fixes: 284a0f6e87b0 ("crypto: testmgr - Disable fips-allowed for...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Müller <smueller@chronox.de>

Ciao
Stephan
