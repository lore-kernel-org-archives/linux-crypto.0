Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7315C2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AE220825
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 21:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9F7OyYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgKLVVi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 16:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgKLVVi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 16:21:38 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F004EC0613D1;
        Thu, 12 Nov 2020 13:21:37 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id o20so8163580eds.3;
        Thu, 12 Nov 2020 13:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F7pOkzR2g826W8yFIgMZddtTn8R1MT7RN19wNn/t72I=;
        b=a9F7OyYR+DX5DX3Xy85b/DC2bN2b2wboNZlahnaZ2V14+zHHDfLBK6sm6VBcMXg7LZ
         DgMR7JJpeLD2s4xs+a4oJIZBf7g+BktDSguINJKH6Ja6yxQJsQ2Hm+vRuWokKz7UTATL
         FJVkTYJ7cfbvdFAxdf2yQ4UJodx/jN+vUxqsF4V6UaF3TaGQy7URYfi8dHnfLzKzjr0s
         P1Z/cejkkLAKqxn8eeiuJYjWk6eTJlbC3EBTgr7LtHj5d/wy1T9ys8CkHcVmKlkj2Dne
         GLFomayB/NYpU64mqUvbxdIkU+jq8K+gNyMyrCPWsdr0mivOmEgUIOUUZTXEvEpDzWXL
         +5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F7pOkzR2g826W8yFIgMZddtTn8R1MT7RN19wNn/t72I=;
        b=NY5aI1eN5lffRNHsxFMREss0sykL+J5bh6MGokA4MqBC9xpWgBcOjsUzK2trYLTDhi
         vacfqQe0WweccILDe/dLgeLzVVpH5SIE3oA87IbiBQ2Wr9BJoRy+MoRozBwQTvqL509S
         6wxUNVhOXNHZn5Q7mFOx2VHi++8jq9h6I9mUCtbglGRYcCyt4BOzREMbaDgSn7z7qK2Z
         DnAY53B6EMYt/PSQpQJxhDOwQfG+L2wHuuztup23XnEASF6Pg9EC+h64CZdrQ21PNClH
         kSPXusRn+NhbpoLU5RG5R7c0N0Yltvz++mg7yzGNgrhP+7bo8lHTOJYCTnjWSs+nQlNy
         yttw==
X-Gm-Message-State: AOAM5320oM+2qoSY6cCZTrL5D1+a/Oz7ZcpyMwYZKSvppAVAB0/9bUVT
        tKGBxlLyIb7IRPH0TeaCGQQ=
X-Google-Smtp-Source: ABdhPJzRNHj5dkZ1bz6V9uC5W0Lmt/bSHJOdixo2u7RWB+XEX7l2/KbeQXHRIYKu9e+moKfpZ2jfeg==
X-Received: by 2002:aa7:c617:: with SMTP id h23mr1983027edq.154.1605216096661;
        Thu, 12 Nov 2020 13:21:36 -0800 (PST)
Received: from debian64.daheim (p5b0d74e1.dip0.t-ipconnect.de. [91.13.116.225])
        by smtp.gmail.com with ESMTPSA id og19sm2599561ejb.7.2020.11.12.13.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 13:21:36 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.94)
        (envelope-from <chunkeey@gmail.com>)
        id 1kdK2B-000F3t-92; Thu, 12 Nov 2020 22:21:35 +0100
Subject: Re: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR in
 crypto4xx_build_pd
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20201112200702.1664905-1-natechancellor@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
Message-ID: <1f5e8575-ab7e-59ea-6be7-0340df4d31c5@gmail.com>
Date:   Thu, 12 Nov 2020 22:21:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201112200702.1664905-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 12/11/2020 21:07, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
> lower precedence than '|'; '|' will be evaluated first
> [-Wbitwise-conditional-parentheses]
>                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
> drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> around the '|' expression to silence this warning
>                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                                                                           ^
>                                                                          )
> drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> around the '?:' expression to evaluate it first
>                   (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                                                                           ^
>                   (
> 1 warning generated.
> 
> It looks like this should have been a logical OR so that
> PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
> is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD.
Yes. This probably wasn't spotted earlier since the driver doesn't make
use of CRYPTO_ALG_TYPE_AHASH (yet). This is because the hash accelerator
setup cost was never worth it.

> Change the operator so that everything works properly.
I'm curious if this is true. Is there a way to break this somehow on purpose?

I've extracted the code from line 921 and added the defines
(the CRYPTO_ALG_... from the current 5.10-rc3 crypto.h and the PD_CTL_
from crypto4xx_reg_def.h) and replaced the u32 with uint32_t
so it runs in userspace too:

--- crypto4xx_test.c ---
/* test study - is it possible to break the | vs || in crypto4xx's code */

#include <stdio.h>
#include <stdint.h>

#define CRYPTO_ALG_TYPE_AEAD 	0x00000003
#define CRYPTO_ALG_TYPE_AHASH	0x0000000f
#define PD_CTL_HASH_FINAL	(1<<4) /* Stand-in for BIT(4) */
#define PD_CTL_HOST_READY	(1<<0) /* BIT(0) */

uint32_t func_with_bitwise_or(uint32_t alg_type)
{
	return PD_CTL_HOST_READY |
		((alg_type == CRYPTO_ALG_TYPE_AHASH) |
		 (alg_type == CRYPTO_ALG_TYPE_AEAD) ?
			PD_CTL_HASH_FINAL : 0);
}

uint32_t func_with_logical_or(uint32_t alg_type)
{
	return PD_CTL_HOST_READY |
		((alg_type == CRYPTO_ALG_TYPE_AHASH) ||
		 (alg_type == CRYPTO_ALG_TYPE_AEAD) ?
			PD_CTL_HASH_FINAL : 0);
}

int main(int arg, char **args)
{
	uint32_t alg;

	for (alg = 0; alg < 0x10; alg++) { /* this is because CRYPTO_ALG_TYPE_MASK is 0xf */
		if (func_with_bitwise_or(alg) != func_with_logical_or(alg)) {
			printf("for alg_type:%d, the bitwise result=%d doesn't match the logical result=%d\n",
				alg, func_with_bitwise_or(alg), func_with_logical_or(alg));
			return 1;
		}
	}
	printf("logical and bitwise always agreed.\n");

	return 0;
}
--- EOF ---

Both gcc (gcc version 10.2.0 (Debian 10.2.0-17)) or clang (clang version 9.0.1-15)
version always gave the "logical and bitwise always agreed.". which means there wasn't
anything wrong and this patch just makes clang happy? Or can you get it to break?

Also, can you please give this patch a try:
--- extra-bracket.patch

--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -932,8 +932,8 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
  	}

  	pd->pd_ctl.w = PD_CTL_HOST_READY |
-		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
-		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
+		(((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
+		  (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD)) ?
  			PD_CTL_HASH_FINAL : 0);
  	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
  	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);

---
I'm mostly curious if clang will warn about it too.

That said:
Reviewed-by: Christian Lamparter <chunkeey@gmail.com>

Cheers,
Christian

> Fixes: 4b5b79998af6 ("crypto: crypto4xx - fix stalls under heavy load")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1198
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/crypto/amcc/crypto4xx_core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 981de43ea5e2..2e3690f65786 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -917,7 +917,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
>   	}
>   
>   	pd->pd_ctl.w = PD_CTL_HOST_READY |
> -		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
> +		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
>   		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>   			 : 0);
>   	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
> 
> base-commit: f8394f232b1eab649ce2df5c5f15b0e528c92091
> 

