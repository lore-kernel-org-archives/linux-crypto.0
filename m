From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: fips - Move fips_enabled sysctl into fips.c
Date: Thu, 23 Apr 2015 09:02:39 +0800
Message-ID: <20150423010239.GA16834@gondor.apana.org.au>
References: <20150422050222.GA7414@gondor.apana.org.au>
 <4705621.sm6yBUSkxg@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39305 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbDWBCn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 21:02:43 -0400
Content-Disposition: inline
In-Reply-To: <4705621.sm6yBUSkxg@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 22, 2015 at 02:33:03PM +0200, Stephan Mueller wrote:
>
> With this removal of crypto_proc_fips_* from crypto_*_proc, wouldn't you have 
> broken the link from algapi.c? There, crypto_*_proc is called where now the 
> FIPS logic may not be initialized any more.

This code does not provide the fips_enabled variable.  All it does
is export it as a sysctl.  So it has nothing to do with the crypto
API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
