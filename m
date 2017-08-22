From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto/chacha20: fix handling of chunked input
Date: Tue, 22 Aug 2017 15:58:29 +0800
Message-ID: <20170822075829.GG6269@gondor.apana.org.au>
References: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        tobias@strongswan.org, martin@strongswan.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:40878 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbdHVH6m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 03:58:42 -0400
Content-Disposition: inline
In-Reply-To: <20170814132815.24524-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 14, 2017 at 02:28:14PM +0100, Ard Biesheuvel wrote:
> Commit 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86 versions
> to skcipher") ported the existing chacha20 code to use the new skcipher
> API, and introduced a bug along the way. Unfortunately, the tcrypt tests
> did not catch the error, and it was only found recently by Tobias.
> 
> Stefan kindly diagnosed the error, and proposed a fix which is similar
> to the one below, with the exception that 'walk.stride' is used rather
> than the hardcoded block size. This does not actually matter in this
> case, but it's a better example of how to use the skcipher walk API.
> 
> Fixes: 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86 ...")
> Cc: <stable@vger.kernel.org> # v4.11+
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Reported-by: Tobias Brunner <tobias@strongswan.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
