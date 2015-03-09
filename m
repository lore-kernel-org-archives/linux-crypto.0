From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: RNGs must return 0 in success case
Date: Mon, 9 Mar 2015 21:07:51 +1100
Message-ID: <20150309100751.GB4452@gondor.apana.org.au>
References: <1936568.p0IkOmavk3@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37995 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbbCIKIA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 06:08:00 -0400
Content-Disposition: inline
In-Reply-To: <1936568.p0IkOmavk3@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 06, 2015 at 08:26:31AM +0100, Stephan Mueller wrote:
> Change the RNGs to always return 0 in success case.
> 
> This patch ensures that seqiv.c works with RNGs other than krng. seqiv
> expects that any return code other than 0 is an error. Without the
> patch, rfc4106(gcm(aes)) will not work when using a DRBG or an ANSI
> X9.31 RNG.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
