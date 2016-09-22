From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] hwrng: geode - fix return value check in mod_init()
Date: Thu, 22 Sep 2016 18:45:02 +0800
Message-ID: <20160922104502.GG5884@gondor.apana.org.au>
References: <1473990601-18721-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47195 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932551AbcIVKpV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:45:21 -0400
Content-Disposition: inline
In-Reply-To: <1473990601-18721-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 16, 2016 at 01:50:01AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> In case of error, the function devm_ioremap() returns NULL pointer
> not ERR_PTR(). The IS_ERR() test in the return value check should
> be replaced with NULL test.
> 
> Fixes: 6e9b5e76882c ("hwrng: geode - Migrate to managed API")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
