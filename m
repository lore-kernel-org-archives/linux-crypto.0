From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccm - move cbcmac input off the stack
Date: Tue, 28 Feb 2017 17:33:03 +0800
Message-ID: <20170228093303.GA3476@gondor.apana.org.au>
References: <1488209456-7653-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, johannes@sipsolutions.net
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33827 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751332AbdB1JdN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2017 04:33:13 -0500
Content-Disposition: inline
In-Reply-To: <1488209456-7653-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:30:56PM +0000, Ard Biesheuvel wrote:
> Commit f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
> refactored the CCM driver to allow separate implementations of the
> underlying MAC to be provided by a platform. However, in doing so, it
> moved some data from the linear region to the stack, which violates the
> SG constraints when the stack is virtually mapped.
> 
> So move idata/odata back to the request ctx struct, of which we can
> reasonably expect that it has been allocated using kmalloc() et al.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
