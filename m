From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v3 RFC PATCH 2/2] crypto: ecc: use caller's GFP flags
Date: Tue, 18 Jul 2017 13:52:09 +0800
Message-ID: <20170718055209.GC4764@gondor.apana.org.au>
References: <1498658916-11044-1-git-send-email-tudor.ambarus@microchip.com>
 <1498658916-11044-3-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        nicolas.ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50036 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdGRFwf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 01:52:35 -0400
Content-Disposition: inline
In-Reply-To: <1498658916-11044-3-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 28, 2017 at 05:08:36PM +0300, Tudor Ambarus wrote:
> Using GFP_KERNEL when allocating data and implicitly
> assuming that we can sleep was wrong because the caller
> could be in atomic context. Let the caller decide whether
> sleeping is possible or not.
> 
> The caller (ecdh) was updated in the same patch in order
> to not affect bissectability.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Hmm, who wants to do asymmetric key crypto in interrupt context?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
