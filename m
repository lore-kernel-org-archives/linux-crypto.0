Return-Path: <SRS0=KXmQ=WY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26EA7C3A5A1
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 07:04:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0289A2173E
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Aug 2019 07:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfH1HEM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Aug 2019 03:04:12 -0400
Received: from nbd.name ([46.4.11.11]:42278 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbfH1HEL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Aug 2019 03:04:11 -0400
Received: from p5dcfb7c9.dip0.t-ipconnect.de ([93.207.183.201] helo=[192.168.45.104])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1i2rzs-0004V3-3B; Wed, 28 Aug 2019 09:04:00 +0200
Subject: Re: [PATCH 5/5] crypto: mediatek: fix incorrect crypto key setting
To:     Vic Wu <vic.wu@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ryder Lee <ryder.lee@mediatek.com>, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
References: <20190828063716.22689-1-vic.wu@mediatek.com>
 <20190828063716.22689-5-vic.wu@mediatek.com>
From:   John Crispin <john@phrozen.org>
Message-ID: <f91ceaa6-edb3-1e70-1fdc-d0022fafd316@phrozen.org>
Date:   Wed, 28 Aug 2019 09:03:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190828063716.22689-5-vic.wu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 28/08/2019 08:37, Vic Wu wrote:
> Record crypto key to context during setkey and set the key to
> transform state buffer in encrypt/decrypt process.
>
> Signed-off-by: Vic Wu <vic.wu@mediatek.com>

Thanks for the fix !

Tested-by: John Crispin <john@phrozen.og>

> ---
>   drivers/crypto/mediatek/mtk-aes.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/mediatek/mtk-aes.c b/drivers/crypto/mediatek/mtk-aes.c
> index 9eeb8b8d..05f21dc8 100644
> --- a/drivers/crypto/mediatek/mtk-aes.c
> +++ b/drivers/crypto/mediatek/mtk-aes.c
> @@ -107,6 +107,7 @@ struct mtk_aes_reqctx {
>   struct mtk_aes_base_ctx {
>   	struct mtk_cryp *cryp;
>   	u32 keylen;
> +	__le32 key[12];
>   	__le32 keymode;
>   
>   	mtk_aes_fn start;
> @@ -541,6 +542,8 @@ static int mtk_aes_handle_queue(struct mtk_cryp *cryp, u8 id,
>   		backlog->complete(backlog, -EINPROGRESS);
>   
>   	ctx = crypto_tfm_ctx(areq->tfm);
> +	/* Write key into state buffer */
> +	memcpy(ctx->info.state, ctx->key, sizeof(ctx->key));
>   
>   	aes->areq = areq;
>   	aes->ctx = ctx;
> @@ -660,7 +663,7 @@ static int mtk_aes_setkey(struct crypto_ablkcipher *tfm,
>   	}
>   
>   	ctx->keylen = SIZE_IN_WORDS(keylen);
> -	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
> +	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
>   
>   	return 0;
>   }
> @@ -1093,10 +1096,8 @@ static int mtk_aes_gcm_setkey(struct crypto_aead *aead, const u8 *key,
>   	if (err)
>   		goto out;
>   
> -	/* Write key into state buffer */
> -	mtk_aes_write_state_le(ctx->info.state, (const u32 *)key, keylen);
> -	/* Write key(H) into state buffer */
> -	mtk_aes_write_state_be(ctx->info.state + ctx->keylen, data->hash,
> +	mtk_aes_write_state_le(ctx->key, (const u32 *)key, keylen);
> +	mtk_aes_write_state_be(ctx->key + ctx->keylen, data->hash,
>   			       AES_BLOCK_SIZE);
>   out:
>   	kzfree(data);
