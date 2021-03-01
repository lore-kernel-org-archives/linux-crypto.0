Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64BCC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 10:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1A8B64E37
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 10:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhCAKhL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 05:37:11 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:48273 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhCAKgj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 05:36:39 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4DpxVj596vz9tx3x;
        Mon,  1 Mar 2021 11:35:41 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 3uLz0sfECZb6; Mon,  1 Mar 2021 11:35:41 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4DpxVj4CNbz9tx3v;
        Mon,  1 Mar 2021 11:35:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B6EA78B795;
        Mon,  1 Mar 2021 11:35:46 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id EfdrfbCBUR78; Mon,  1 Mar 2021 11:35:46 +0100 (CET)
Received: from [172.25.230.103] (po15451.idsi0.si.c-s.fr [172.25.230.103])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5FB748B75B;
        Mon,  1 Mar 2021 11:35:46 +0100 (CET)
Subject: Re: [PATCH] crypto: sun8i-ce: rename kfree() to kfree_sensitive()
To:     Yang Li <yang.lee@linux.alibaba.com>, clabbe.montjoie@gmail.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1614594641-35606-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <4f448ec8-3694-b918-30eb-641d473c85ff@csgroup.eu>
Date:   Mon, 1 Mar 2021 11:35:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1614594641-35606-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 01/03/2021 à 11:30, Yang Li a écrit :
> Rename kfree() to kfree_sensitive() to  make the intention of the API
> more explicit.

As far as I understand, you are not renaming kfree() to kfree_sensitive().

You are making a change to use kfree_sensitive() instead of using kfree().

Christophe

> 
> fixed the following coccicheck:
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:30:16-17: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 29)
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:42:16-17: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 41)
> ./drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c:161:8-9: WARNING
> opportunity for kfree_sensitive/kvfree_sensitive (memset at line 109)
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> index cfde9ee..8259d52 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> @@ -27,7 +27,7 @@ void sun8i_ce_prng_exit(struct crypto_tfm *tfm)
>   	struct sun8i_ce_rng_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
>   
>   	memzero_explicit(ctx->seed, ctx->slen);
> -	kfree(ctx->seed);
> +	kfree_sensitive(ctx->seed);
>   	ctx->seed = NULL;
>   	ctx->slen = 0;
>   }
> @@ -39,7 +39,7 @@ int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed,
>   
>   	if (ctx->seed && ctx->slen != slen) {
>   		memzero_explicit(ctx->seed, ctx->slen);
> -		kfree(ctx->seed);
> +		kfree_sensitive(ctx->seed);
>   		ctx->slen = 0;
>   		ctx->seed = NULL;
>   	}
> @@ -158,7 +158,7 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
>   	}
>   	memzero_explicit(d, todo);
>   err_iv:
> -	kfree(d);
> +	kfree_sensitive(d);
>   err_mem:
>   	return err;
>   }
> 
