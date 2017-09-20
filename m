From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - update correct dst SGL entry
Date: Wed, 20 Sep 2017 16:34:10 +0800
Message-ID: <20170920083410.GB3395@gondor.apana.org.au>
References: <2484753.VGNM65Hb0R@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43540 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbdITIe1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 04:34:27 -0400
Content-Disposition: inline
In-Reply-To: <2484753.VGNM65Hb0R@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 30, 2017 at 09:17:39AM +0200, Stephan Müller wrote:
> When two adjacent TX SGL are processed and parts of both TX SGLs
> are pulled into the per-request TX SGL, the wrong per-request
> TX SGL entries were updated.
> 
> This fixes a NULL pointer dereference when a cipher implementation walks
> the TX SGL where some of the SGL entries were NULL.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Oops, looks like you already sent me this fix.  It should have
this fixes header:

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory...")

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
