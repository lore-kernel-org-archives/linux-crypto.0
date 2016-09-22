From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Fix return value check in
 ccp_dmaengine_register()
Date: Thu, 22 Sep 2016 18:45:26 +0800
Message-ID: <20160922104526.GH5884@gondor.apana.org.au>
References: <1474128082-14996-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34466 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933354AbcIVKpi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:45:38 -0400
Content-Disposition: inline
In-Reply-To: <1474128082-14996-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Sep 17, 2016 at 04:01:22PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix the retrn value check which testing the wrong variable
> in ccp_dmaengine_register().
> 
> Fixes: 58ea8abf4904 ("crypto: ccp - Register the CCP as a DMA resource")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
