From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Fix race around ctx->rcvused by making it
 atomic_t
Date: Fri, 22 Dec 2017 19:34:49 +1100
Message-ID: <20171222083449.GE29663@gondor.apana.org.au>
References: <20171218161045.0000161c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        Stephan Mueller <smueller@chronox.de>, davem@davemloft.net
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46184 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdLVIey (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:34:54 -0500
Content-Disposition: inline
In-Reply-To: <20171218161045.0000161c@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 19, 2017 at 10:31:22AM +0000, Jonathan Cameron wrote:
> This variable was increased and decreased without any protection.
> Result was an occasional misscount and negative wrap around resulting
> in false resource allocation failures.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Fixes: 2d97591ef43d ("crypto: af_alg - consolidation of duplicate code")

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
