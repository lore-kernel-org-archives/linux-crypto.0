From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: FIPS - allow RSA keys >= 2048 bits
Date: Wed, 24 Aug 2016 21:18:26 +0800
Message-ID: <20160824131826.GC4039@gondor.apana.org.au>
References: <3300015.Y5nlQbUkhj@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59985 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbcHXOd6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 10:33:58 -0400
Content-Disposition: inline
In-Reply-To: <3300015.Y5nlQbUkhj@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 23, 2016 at 10:09:32AM +0200, Stephan Mueller wrote:
> With a public notification, NIST now allows the use of RSA keys with a
> modulus >= 2048 bits. The new rule allows any modulus size >= 2048 bits
> provided that either 2048 or 3072 bits are supported at least so that
> the entire RSA implementation can be CAVS tested.
> 
> This patch fixes the inability to boot the kernel in FIPS mode, because
> certs/x509.genkey defines a 4096 bit RSA key per default. This key causes
> the RSA signature verification to fail in FIPS mode without the patch
> below.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
