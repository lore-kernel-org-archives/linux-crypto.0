From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v2 PATCH 0/11] rng: New style interface
Date: Tue, 21 Apr 2015 14:23:04 +0200
Message-ID: <26477171.VNyzQyxJ7m@myon.chronox.de>
References: <20150421024436.GA28057@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34226 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894AbbDUMXK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 08:23:10 -0400
In-Reply-To: <20150421024436.GA28057@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. April 2015, 10:44:36 schrieb Herbert Xu:

Hi Herbert,

> This series converts the crypto_rng interface over to the "new"
> style.  I'm putting it in quotes because this style has been
> around since 2008.  In fact, RNG was the very last interface
> type added before the introduction of the new style.
> 
> Eventually all existing interfaces should be converted over but
> obviously it's taking some time to get there :)
> 
> v2 uses kzfree instead of free for the temporary seed.
> 
> Cheers,

For the DRBG changes:

Acked-by: Stephan Mueller <smueller@chronox.de>

-- 
Ciao
Stephan
