From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] crypto: omap-des - fix error return code in
 omap_des_probe()
Date: Thu, 22 Sep 2016 18:43:11 +0800
Message-ID: <20160922104311.GB5884@gondor.apana.org.au>
References: <1473910035-31283-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Baolin <baolin.wang@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43739 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753108AbcIVKnd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:43:33 -0400
Content-Disposition: inline
In-Reply-To: <1473910035-31283-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 15, 2016 at 03:27:15AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return error code -ENOMEM from the crypto_engine_alloc_init()
> error handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: f1b77aaca85a ("crypto: omap-des - Integrate with the crypto
> engine framework")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
