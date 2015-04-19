From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/3] crypto: drbg - revamp locking
Date: Sun, 19 Apr 2015 13:49:31 +0800
Message-ID: <20150419054931.GC11255@gondor.apana.org.au>
References: <1702481.h2hMdNkdaF@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57419 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbDSFte (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 01:49:34 -0400
Content-Disposition: inline
In-Reply-To: <1702481.h2hMdNkdaF@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 18, 2015 at 07:35:11PM +0200, Stephan Mueller wrote:
> Hi,
> 
> the current implementation of the DRBG generates a shadow copy of its
> DRBG state for each incoming request. The idea is that only a short
> term lock is needed to spawn the shadow copy. The drawback is that
> if multiple parallel requests come in, the generated DRBG shadow
> states only differ by a high-resolution timer that was mixed in during
> the shadow state generation.
> 
> This patch now removes this shadow state and introduces a mutex
> to serialize all requests to one DRBG instance.
> 
> The patch was fully CAVS tested and demonstrates that the DRBG still
> complies with the standard.

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
