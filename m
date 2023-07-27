Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D35CCC001DC
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jul 2023 05:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjG0FrQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jul 2023 01:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjG0Fq6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2023 01:46:58 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145ED3C00
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 22:46:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1bbc7b2133fso3515565ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jul 2023 22:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1690436775; x=1691041575;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EUn9yYpipOsPEKP8WCT3aJstBvAywf03drnVcolpjFQ=;
        b=T0m50/Ab2Zy9M/PiC+pYMHYO68NQ8ZURcm02JQndKWBBa5y5sZNk5CBcNEshS5mD1n
         3kp82ZVL3VL2TaBNU7kE6X1JB8CXnCzmpOhquDiQw/4sAqwh1S84fXd0Il9ihjO6A7T9
         CH1SxbDnOjBqMFaKEzYT9PY/VxS1fIv1FkSXcN+eC200RaqVn2cJ/l1SAZj/iP+EPguh
         76ZeAF3KtsB0HIXSCHaSxdL6dn68SZ/N7K4bnD/eCg4izDDP3BR+Ry4EveGb1V6ALBS+
         sliowhwvrgWtsoTYdGFcpGUBBVeS1pkkw+moKE+WK5jaefGvvkogR+VuPdlcsyEGEf4R
         8mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690436775; x=1691041575;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EUn9yYpipOsPEKP8WCT3aJstBvAywf03drnVcolpjFQ=;
        b=aSIiWT6rGi+erDVE+/mRATtA9JzOdO5T7ThwVG10Sy8b0ZEy3TZHKzByRtmlnXNnl4
         aOGXdWD//7slvZgNkqAq7xLCO/9wePRJSQrK6TbDCuC6HHlP+SPdGlBQ/erU/EgCyy7P
         enploWiRpzA6yqd0kIe1n5wz7YCG7+iY/HvhXli0QEz5OUH/+VrSFWAR7YgOgKn/JBlY
         gN8NvUx33A8Jcnd0d0C1c1uGbcbv17BbQhoih0+LYt93TnMl6SqDiAGOOqDfhipTzdkW
         z1u441a6iTsKdRc84yLn2CN2vQrlWD2K899gzVBXwuUUU1YZAsMxKp+kFe+WiSPUXBfv
         NtjQ==
X-Gm-Message-State: ABy/qLYvRxN2dSFp1/DZnTO3wYzDHssFqzqySQ1bly5F7lSMpR5sEZ6N
        IrMJSn9UVOJB3wSRrajvwm9soA==
X-Google-Smtp-Source: APBJJlE3Ta64vctib96xNN471wnaq/5n6QG87YGVu++oTzT/S44ftJCxLMUGZn/ELwioFYqemFntnQ==
X-Received: by 2002:a17:902:7882:b0:1b8:59f0:c748 with SMTP id q2-20020a170902788200b001b859f0c748mr3620942pll.2.1690436774805;
        Wed, 26 Jul 2023 22:46:14 -0700 (PDT)
Received: from [10.0.2.15] ([82.78.167.79])
        by smtp.gmail.com with ESMTPSA id jn13-20020a170903050d00b001b895a17429sm560862plb.280.2023.07.26.22.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 22:46:14 -0700 (PDT)
Message-ID: <3202ac5b-a697-64b0-375c-d2ae2aa9ffdd@tuxon.dev>
Date:   Thu, 27 Jul 2023 08:46:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] crypto: drivers - avoid memcpy size warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yangtao Li <frank.li@vivo.com>,
        Sergiu Moga <sergiu.moga@microchip.com>,
        Ryan Wanner <Ryan.Wanner@microchip.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230724135327.1173309-1-arnd@kernel.org>
From:   claudiu beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <20230724135327.1173309-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 24.07.2023 16:53, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Some configurations with gcc-12 or gcc-13 produce a warning for the source
> and destination of a memcpy() in atmel_sha_hmac_compute_ipad_hash() potentially
> overlapping:
> 
> In file included from include/linux/string.h:254,
>                   from drivers/crypto/atmel-sha.c:15:
> drivers/crypto/atmel-sha.c: In function 'atmel_sha_hmac_compute_ipad_hash':
> include/linux/fortify-string.h:57:33: error: '__builtin_memcpy' accessing 129 or more bytes at offsets 408 and 280 overlaps 1 or more bytes at offset 408 [-Werror=restrict]
>     57 | #define __underlying_memcpy     __builtin_memcpy
>        |                                 ^
> include/linux/fortify-string.h:648:9: note: in expansion of macro '__underlying_memcpy'
>    648 |         __underlying_##op(p, q, __fortify_size);                        \
>        |         ^~~~~~~~~~~~~
> include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
>    693 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>        |                          ^~~~~~~~~~~~~~~~~~~~
> drivers/crypto/atmel-sha.c:1773:9: note: in expansion of macro 'memcpy'
>   1773 |         memcpy(hmac->opad, hmac->ipad, bs);
>        |         ^~~~~~
> 
> The same thing happens in two more drivers that have the same logic:
> 
> drivers/crypto/chelsio/chcr_algo.c: In function 'chcr_ahash_setkey':
> include/linux/fortify-string.h:57:33: error: '__builtin_memcpy' accessing 129 or more bytes at offsets 260 and 132 overlaps 1 or more bytes at offset 260 [-Werror=restrict]
> drivers/crypto/bcm/cipher.c: In function 'ahash_hmac_setkey':
> include/linux/fortify-string.h:57:33: error: '__builtin_memcpy' accessing between 129 and 4294967295 bytes at offsets 840 and 712 overlaps between 1 and 4294967167 bytes at offset 840 [-Werror=restrict]
> 
> I don't think it can actually happen because the size is strictly bounded
> to the available block sizes, at most 128 bytes, though inlining decisions
> could lead gcc to not see that.
> 
> Add an explicit size check to make sure gcc also sees this function is safe
> regardless of inlining.
> 
> Note that the -Wrestrict warning is currently disabled by default, but it
> would be nice to finally enable it, and these are the only false
> postives that I see at the moment. There are 9 other crypto drivers that
> also use an identical memcpy() but don't show up in randconfig build
> warnings for me, presumably because of different inlining decisions.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev> # atmel-sha

> ---
>   drivers/crypto/atmel-sha.c         | 3 +++
>   drivers/crypto/bcm/cipher.c        | 3 +++
>   drivers/crypto/chelsio/chcr_algo.c | 3 +++
>   3 files changed, 9 insertions(+)
> 
> diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
> index f2031f934be95..52a3c81b3a05a 100644
> --- a/drivers/crypto/atmel-sha.c
> +++ b/drivers/crypto/atmel-sha.c
> @@ -1770,6 +1770,9 @@ static int atmel_sha_hmac_compute_ipad_hash(struct atmel_sha_dev *dd)
>   	size_t bs = ctx->block_size;
>   	size_t i, num_words = bs / sizeof(u32);
>   
> +	if (bs > sizeof(hmac->opad))
> +		return -EINVAL;
> +
>   	memcpy(hmac->opad, hmac->ipad, bs);
>   	for (i = 0; i < num_words; ++i) {
>   		hmac->ipad[i] ^= 0x36363636;
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index 70b911baab26d..8633ca0286a10 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -2327,6 +2327,9 @@ static int ahash_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
>   		 __func__, ahash, key, keylen, blocksize, digestsize);
>   	flow_dump("  key: ", key, keylen);
>   
> +	if (blocksize > sizeof(ctx->opad))
> +		return -EINVAL;
> +
>   	if (keylen > blocksize) {
>   		switch (ctx->auth.alg) {
>   		case HASH_ALG_MD5:
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 0eade4fa6695b..5c8e10ee010ff 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -2201,6 +2201,9 @@ static int chcr_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
>   
>   	SHASH_DESC_ON_STACK(shash, hmacctx->base_hash);
>   
> +	if (bs > sizeof(hmacctx->opad))
> +		return -EINVAL;
> +
>   	/* use the key to calculate the ipad and opad. ipad will sent with the
>   	 * first request's data. opad will be sent with the final hash result
>   	 * ipad in hmacctx->ipad and opad in hmacctx->opad location
