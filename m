From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3][CRYPTO] RIPEMD: add support for RIPEMD hash algorithms.
Date: Wed, 7 May 2008 22:20:32 +0800
Message-ID: <20080507142032.GA27932@gondor.apana.org.au>
References: <1209913413-8229-1-git-send-email-rueegsegger@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54493 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755251AbYEGOUg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 10:20:36 -0400
Content-Disposition: inline
In-Reply-To: <1209913413-8229-1-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 04, 2008 at 05:03:30PM +0200, Adrian-Ken Rueegsegger wrote:
> These patches add RIPEMD-128/160 support to the cryptoapi.
> 
> The first patch contains the actual implementation of the hash
> algorithms. It is based on the sample implementation by Antoon
> Bosselaers (ESAT-COSIC) found at:
>          <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>
> 
> The second patch adds test vectors for both hash functions and their
> respective digests (HMAC) to tcrypt. The test vectors for the hash
> functions are taken from ISO/IEC 10118-3:2004 and the ones for HMAC
> from RFC2286.
> 
> The third patch contains the Kconfig entries for both algorithms.

All applied.  Thanks a lot Adrian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
