From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] crypto: arm and cryptd fixes
Date: Wed, 7 Sep 2016 21:21:13 +0800
Message-ID: <20160907132113.GI17176@gondor.apana.org.au>
References: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54762 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756625AbcIGNVQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:21:16 -0400
Content-Disposition: inline
In-Reply-To: <1472736343-15305-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 01, 2016 at 02:25:40PM +0100, Ard Biesheuvel wrote:
> Patch #1 fixes a trivial code generation issue on ARM.
> 
> Patch #2 and #3 fix the broken GHASH on ARM using the v8 Crypto Extensions
> pmull.64 instructions. The problem seems to be that it is allowed to call
> .import() without .init() (at least, that is what the test cases do), but
> this means that the initialization to tie the shash_desc's to their child
> transforms needs to execute in the .import() context as well.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
