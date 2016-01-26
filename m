From: Stephan Mueller <smueller@chronox.de>
Subject: Re: AF_ALG: hash returns -ENOKEY
Date: Tue, 26 Jan 2016 17:46:08 +0100
Message-ID: <25518493.8Y4zKbioBK@positron.chronox.de>
References: <6333443.68gdEOIkbe@positron.chronox.de> <20160126161637.GA24423@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42556 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966657AbcAZQqT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 11:46:19 -0500
In-Reply-To: <20160126161637.GA24423@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Januar 2016, 00:16:37 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jan 25, 2016 at 10:22:36PM +0100, Stephan Mueller wrote:
> > Hi Herbert,
> > 
> > during testing of the current cryptodev-2.6 key, the AF_ALG hash does not
> > seem to work as it used to.
> 
> Oops, looks like I screwed up shash.
> 
> ---8<---
> Subject: crypto: shash - Fix has_key setting
> 
> The has_key logic is wrong for shash algorithms as they always
> have a setkey function.  So we should instead be testing against
> shash_no_setkey.
> 
> Fixes: a5596d633278 ("crypto: hash - Add crypto_ahash_has_setkey")
> Cc: stable@vger.kernel.org
> Reported-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
