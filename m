From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - fix overlap in chunked tests again
Date: Thu, 8 Dec 2016 20:17:28 +0800
Message-ID: <20161208121728.GB24768@gondor.apana.org.au>
References: <1481185432-24761-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers@google.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50958 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752308AbcLHMRi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 07:17:38 -0500
Content-Disposition: inline
In-Reply-To: <1481185432-24761-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 08, 2016 at 08:23:52AM +0000, Ard Biesheuvel wrote:
> Commit 7e4c7f17cde2 ("crypto: testmgr - avoid overlap in chunked tests")
> attempted to address a problem in the crypto testmgr code where chunked
> test cases are copied to memory in a way that results in overlap.
> 
> However, the fix recreated the exact same issue for other chunked tests,
> by putting IDX3 within 492 bytes of IDX1, which causes overlap if the
> first chunk exceeds 492 bytes, which is the case for at least one of
> the xts(aes) test cases.
> 
> So increase IDX3 by another 1000 bytes.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
