From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: drbg - Remove FIPS ifdef from drbg_healthcheck_sanity
Date: Wed, 22 Apr 2015 06:30:14 +0200
Message-ID: <2254100.YVDNQBfXBj@myon.chronox.de>
References: <20150422034235.GA6907@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34234 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbbDVEcI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 00:32:08 -0400
In-Reply-To: <20150422034235.GA6907@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. April 2015, 11:42:35 schrieb Herbert Xu:

Hi Herbert,

> This patch removes the unnecessary CRYPTO_FIPS ifdef from
> drbg_healthcheck_sanity so that the code always gets checked
> by the compiler.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Stephan Mueller <smueller@chronox.de>

-- 
Ciao
Stephan
