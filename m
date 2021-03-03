Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F6CC433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF00C64F6C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356747AbhCDAHO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:14 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37046 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239795AbhCCK1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 05:27:00 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lHNLY-0000Kk-1J; Wed, 03 Mar 2021 19:59:09 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Mar 2021 19:59:07 +1100
Date:   Wed, 3 Mar 2021 19:59:07 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     clabbe.montjoie@gmail.com, clabbe@baylibre.com,
        gcherian@marvell.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
        prime.zeng@huawei.com
Subject: Re: [PATCH 2/4] crypto: cavium - Fix the parameter of dma_unmap_sg()
Message-ID: <20210303085907.GA8134@gondor.apana.org.au>
References: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
 <1612853965-67777-3-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612853965-67777-3-git-send-email-chenxiang66@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 09, 2021 at 02:59:23PM +0800, chenxiang wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> For function dma_unmap_sg(), the <nents> parameter should be number of
> elements in the scatterlist prior to the mapping, not after the mapping.
> So fix this usage.
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
> index 53ef067..1263194 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
> @@ -170,7 +170,7 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
>  		sr->in.total_bytes += sg_dma_len(sg);
>  
>  	sr->in.sg = req->src;
> -	sr->in.sgmap_cnt = nents;
> +	sr->in.sgmap_cnt = sg_nents(req->src);
>  	ret = create_sg_component(sr, &sr->in, sr->in.sgmap_cnt);

So you're changing the count passed to create_sg_component.  Are you
sure that's correct? Even if it is correct you should change your
patch description to document this change.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
