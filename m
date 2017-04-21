From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: caam - fix error return code in
 caam_qi_init()
Date: Fri, 21 Apr 2017 21:14:47 +0800
Message-ID: <20170421131447.GB14803@gondor.apana.org.au>
References: <20170411160409.18430-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: horia.geanta@nxp.com, dan.douglass@nxp.com, davem@davemloft.net,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:42872 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1039679AbdDUNP2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 09:15:28 -0400
Content-Disposition: inline
In-Reply-To: <20170411160409.18430-1-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 11, 2017 at 04:04:09PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -ENOMEM from the kmem_cache_create() error
> handling case instead of 0(err is 0 here), as done elsewhere in this
> function.
> 
> Fixes: 67c2315def06 ("crypto: caam - add Queue Interface (QI) backend support")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
