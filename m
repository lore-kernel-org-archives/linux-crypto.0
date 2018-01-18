From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] hwrng: exynos - remove redundant dev_err call in
 exynos_trng_probe()
Date: Thu, 18 Jan 2018 23:03:05 +1100
Message-ID: <20180118120305.GF20717@gondor.apana.org.au>
References: <1515591059-73230-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: l.stelmach@samsung.com, mpm@selenic.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, kgene@kernel.org, krzk@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55404 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752184AbeARMEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:04:24 -0500
Content-Disposition: inline
In-Reply-To: <1515591059-73230-1-git-send-email-weiyongjun1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:30:59PM +0000, Wei Yongjun wrote:
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
