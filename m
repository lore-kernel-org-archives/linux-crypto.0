From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/nx842: Mask XERS0 bit in return value
Date: Thu, 17 Dec 2015 16:45:55 +0800
Message-ID: <20151217084555.GA9239@gondor.apana.org.au>
References: <1450006242.19568.11.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: segher@kernel.crashing.org, ddstreet@ieee.org, davem@davemloft.net,
	pair@us.ibm.com, mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42016 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbbLQIqV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Dec 2015 03:46:21 -0500
Content-Disposition: inline
In-Reply-To: <1450006242.19568.11.camel@hbabu-laptop>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 13, 2015 at 03:30:41AM -0800, Haren Myneni wrote:
> 
> NX842 coprocessor sets 3rd bit in CR register with XER[S0] which is
> nothing to do with NX request. Since this bit can be set with other
> valuable return status, mast this bit.
> 
> One of other bits (INITIATED, BUSY or REJECTED) will be returned for
> any given NX request.
> 
> Signed-off-by: Haren Myneni <haren@us.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
