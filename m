From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AF_ALG - update correct dst SGL entry
Date: Thu, 21 Sep 2017 16:07:36 +0800
Message-ID: <20170921080736.GH7718@gondor.apana.org.au>
References: <2484753.VGNM65Hb0R@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44936 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdIUIHy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:07:54 -0400
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
