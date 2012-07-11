From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: allow aesni-intel and ghash_clmulni-intel in
 fips mode
Date: Wed, 11 Jul 2012 11:25:22 +0800
Message-ID: <20120711032522.GE5263@gondor.apana.org.au>
References: <1341000489-12691-1-git-send-email-mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Paul Wouters <pwouters@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:47360 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755773Ab2GKDZY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 23:25:24 -0400
Content-Disposition: inline
In-Reply-To: <1341000489-12691-1-git-send-email-mbroz@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 29, 2012 at 10:08:09PM +0200, Milan Broz wrote:
> Patch 863b557a88f8c033f7419fabafef4712a5055f85 added NULL entries
> for intel accelerated drivers but did not marked these fips allowed.
> This cause panic if running tests with fips=1.
> 
> For ghash, fips_allowed flag was added in patch
> 18c0ebd2d8194cce4b3f67e2903fa01bea892cbc.
> 
> Without patch, "modprobe tcrypt" fails with
>   alg: skcipher: Failed to load transform for cbc-aes-aesni: -2
>   cbc-aes-aesni: cbc(aes) alg self test failed in fips mode!
>   (panic)
> 
> Also add missing cryptd(__driver-cbc-aes-aesni) and
> cryptd(__driver-gcm-aes-aesni) test to complement
> null tests above, otherwise system complains with
>   alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-aesni))
>   alg: No test for __gcm-aes-aesni (cryptd(__driver-gcm-aes-aesni))
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> Signed-off-by: Paul Wouters <pwouters@redhat.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
