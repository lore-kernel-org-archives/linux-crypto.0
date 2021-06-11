Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EE9C48BE5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E644613C6
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhFKHZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:25:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50552 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhFKHZG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 03:25:06 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lrbVR-0005KB-SK; Fri, 11 Jun 2021 15:23:05 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lrbVP-0002Lu-GF; Fri, 11 Jun 2021 15:23:03 +0800
Date:   Fri, 11 Jun 2021 15:23:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH -next] crypto: qce: skcipher: fix error return code in
 qce_skcipher_async_req_handle()
Message-ID: <20210611072303.GD23016@gondor.apana.org.au>
References: <20210602113645.3038800-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602113645.3038800-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 02, 2021 at 11:36:45AM +0000, Wei Yongjun wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 1339a7c3ba05 ("crypto: qce: skcipher: Fix incorrect sg count for dma transfers")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/crypto/qce/skcipher.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
