From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -next] hwrng: amd - Fix return value check in mod_init()
Date: Thu, 22 Sep 2016 18:44:46 +0800
Message-ID: <20160922104446.GF5884@gondor.apana.org.au>
References: <1473990581-18602-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54037 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933243AbcIVKpI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:45:08 -0400
Content-Disposition: inline
In-Reply-To: <1473990581-18602-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 16, 2016 at 01:49:41AM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> In case of error, the function devm_kzalloc() or devm_ioport_map()
> return NULL pointer not ERR_PTR(). The IS_ERR() test in the return
> value check should be replaced with NULL test.
> 
> Fixes: 31b2a73c9c5f ("hwrng: amd - Migrate to managed API")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
