From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: skcipher - introduce walksize attribute for
 SIMD algos
Date: Fri, 30 Dec 2016 20:21:00 +0800
Message-ID: <20161230122100.GI15832@gondor.apana.org.au>
References: <1483020548-19233-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35035 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753795AbcL3MVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:21:06 -0500
Content-Disposition: inline
In-Reply-To: <1483020548-19233-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 29, 2016 at 02:09:08PM +0000, Ard Biesheuvel wrote:
> In some cases, SIMD algorithms can only perform optimally when
> allowed to operate on multiple input blocks in parallel. This is
> especially true for bit slicing algorithms, which typically take
> the same amount of time processing a single block or 8 blocks in
> parallel. However, other SIMD algorithms may benefit as well from
> bigger strides.
> 
> So add a walksize attribute to the skcipher algorithm definition, and
> wire it up to the skcipher walk API. To avoid confusion between the
> skcipher and AEAD attributes, rename the skcipher_walk chunksize
> attribute to 'stride', and set it from the walksize (in the skcipher
> case) or from the chunksize (in the AEAD case).
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
