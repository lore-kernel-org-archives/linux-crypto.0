Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD43DC43334
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 08:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiGOIdg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 04:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGOIdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 04:33:35 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CCD1E8;
        Fri, 15 Jul 2022 01:33:33 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCGl9-000ndq-8p; Fri, 15 Jul 2022 18:33:16 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:33:15 +0800
Date:   Fri, 15 Jul 2022 16:33:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Yang Shen <shenyang39@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/zip: Use the bitmap API to allocate
 bitmaps
Message-ID: <YtEmS//eV3Ok08BD@gondor.apana.org.au>
References: <49a1b5bf6e8f7c2ad06a0e2dbc35e00169d4ebe2.1657383385.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a1b5bf6e8f7c2ad06a0e2dbc35e00169d4ebe2.1657383385.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 09, 2022 at 06:16:46PM +0200, Christophe JAILLET wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
> index 67869513e48c..7bf53877e508 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
> @@ -606,8 +606,7 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
>  		req_q = &ctx->qp_ctx[i].req_q;
>  		req_q->size = QM_Q_DEPTH;
>  
> -		req_q->req_bitmap = kcalloc(BITS_TO_LONGS(req_q->size),
> -					    sizeof(long), GFP_KERNEL);
> +		req_q->req_bitmap = bitmap_zalloc(req_q->size, GFP_KERNEL);
>  		if (!req_q->req_bitmap) {
>  			ret = -ENOMEM;
>  			if (i == 0)

You should add an include for linux/bitmap.h instead of relying
on implicit inclusion through some random header file.

The same goes for all your other patches too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
