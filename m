Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376BCC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 02:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiGSCQf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jul 2022 22:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbiGSCQa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jul 2022 22:16:30 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2CF2528F;
        Mon, 18 Jul 2022 19:16:28 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oDcme-001wgN-8q; Tue, 19 Jul 2022 12:16:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 19 Jul 2022 10:16:24 +0800
Date:   Tue, 19 Jul 2022 10:16:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        liulongfang@huawei.com, davem@davemloft.net, xuzaibo@huawei.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/hpre - don't use GFP_KERNEL to alloc
 mem during softirq
Message-ID: <YtYT+JeYj7vlz9Xp@gondor.apana.org.au>
References: <20220719021042.250882-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719021042.250882-1-shaozhengchao@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 19, 2022 at 10:10:42AM +0800, Zhengchao Shao wrote:
>
> @@ -252,7 +252,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
>  	if (unlikely(shift < 0))
>  		return -EINVAL;
>  
> -	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, GFP_KERNEL);
> +	ptr = dma_alloc_coherent(dev, ctx->key_sz, tmp, flags);

How about just using GFP_ATOMIC unconditinoally?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
