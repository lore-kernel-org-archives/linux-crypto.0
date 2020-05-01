Return-Path: <SRS0=G1bP=6P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A1BC47253
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 12:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38402206F0
	for <linux-crypto@archiver.kernel.org>; Fri,  1 May 2020 12:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Tp8xseUQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgEAM20 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 May 2020 08:28:26 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:26943 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgEAM2Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 May 2020 08:28:25 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49DBP20c2xz9txNG;
        Fri,  1 May 2020 14:28:22 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Tp8xseUQ; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 84j98byPuBUK; Fri,  1 May 2020 14:28:22 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49DBP15CN1z9txNF;
        Fri,  1 May 2020 14:28:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1588336101; bh=XlApbvGOz8/OYrkITFPCwcdCBwZhKBqS6j6tWRgOa6Y=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Tp8xseUQlEH9kn2Gozne2FNci2pLwkLx9v9Eu6eOJx5uxBfqmtNn7wQ8QCIXYq+Dg
         TaHeu05jGUNXa66utNH814kp2egcDIHlv3khCY+Bn9VSuobx9X31N5NLW3YklXTM1N
         Mn6G4RBaLBkF0OzcP2ndAEqvf8V/tagDyL9+TNUE=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 39EAC8B923;
        Fri,  1 May 2020 14:28:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id OYHinAPzGiTU; Fri,  1 May 2020 14:28:23 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 419268B774;
        Fri,  1 May 2020 14:28:22 +0200 (CEST)
Subject: Re: [PATCH] crypto: lib/sha256 - return void
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
References: <20200501071338.777352-1-ebiggers@kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <3ba66f39-e84f-43c6-a36b-17cd231f55db@c-s.fr>
Date:   Fri, 1 May 2020 14:28:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501071338.777352-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 01/05/2020 à 09:13, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> The SHA-256 / SHA-224 library functions can't fail, so remove the
> useless return value.
> 
> Also long as the declarations are being changed anyway, also fix some
> parameter names in the declarations to match the definitions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   crypto/sha256_generic.c      | 14 +++++++++-----
>   include/crypto/sha.h         | 20 ++++++++------------
>   include/crypto/sha256_base.h |  6 ++++--
>   lib/crypto/sha256.c          | 20 ++++++++------------
>   4 files changed, 29 insertions(+), 31 deletions(-)
> 
> diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
> index f2d7095d4f2d64..88156e3e2a33e0 100644
> --- a/crypto/sha256_generic.c
> +++ b/crypto/sha256_generic.c
> @@ -35,27 +35,31 @@ EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
>   
>   static int crypto_sha256_init(struct shash_desc *desc)
>   {
> -	return sha256_init(shash_desc_ctx(desc));
> +	sha256_init(shash_desc_ctx(desc));
> +	return 0;
>   }
>   
>   static int crypto_sha224_init(struct shash_desc *desc)
>   {
> -	return sha224_init(shash_desc_ctx(desc));
> +	sha224_init(shash_desc_ctx(desc));
> +	return 0;
>   }
>   
>   int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
>   			  unsigned int len)
>   {
> -	return sha256_update(shash_desc_ctx(desc), data, len);
> +	sha256_update(shash_desc_ctx(desc), data, len);
> +	return 0;
>   }
>   EXPORT_SYMBOL(crypto_sha256_update);
>   
>   static int crypto_sha256_final(struct shash_desc *desc, u8 *out)
>   {
>   	if (crypto_shash_digestsize(desc->tfm) == SHA224_DIGEST_SIZE)
> -		return sha224_final(shash_desc_ctx(desc), out);
> +		sha224_final(shash_desc_ctx(desc), out);
>   	else
> -		return sha256_final(shash_desc_ctx(desc), out);
> +		sha256_final(shash_desc_ctx(desc), out);
> +	return 0;
>   }
>   
>   int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
> diff --git a/include/crypto/sha.h b/include/crypto/sha.h
> index 5c2132c7190095..8db9e1a3eb0cf6 100644
> --- a/include/crypto/sha.h
> +++ b/include/crypto/sha.h
> @@ -123,7 +123,7 @@ extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
>    * For details see lib/crypto/sha256.c
>    */
>   
> -static inline int sha256_init(struct sha256_state *sctx)
> +static inline void sha256_init(struct sha256_state *sctx)
>   {
>   	sctx->state[0] = SHA256_H0;
>   	sctx->state[1] = SHA256_H1;
> @@ -134,14 +134,12 @@ static inline int sha256_init(struct sha256_state *sctx)
>   	sctx->state[6] = SHA256_H6;
>   	sctx->state[7] = SHA256_H7;
>   	sctx->count = 0;
> -
> -	return 0;
>   }
> -extern int sha256_update(struct sha256_state *sctx, const u8 *input,
> -			 unsigned int length);
> -extern int sha256_final(struct sha256_state *sctx, u8 *hash);
> +extern void sha256_update(struct sha256_state *sctx, const u8 *data,
> +			  unsigned int len);
> +extern void sha256_final(struct sha256_state *sctx, u8 *out);

The 'extern' keywork is useless in a function declaration. It should be 
removed, as recommended by 'checkpatch --strict'.

>   
> -static inline int sha224_init(struct sha256_state *sctx)
> +static inline void sha224_init(struct sha256_state *sctx)
>   {
>   	sctx->state[0] = SHA224_H0;
>   	sctx->state[1] = SHA224_H1;
> @@ -152,11 +150,9 @@ static inline int sha224_init(struct sha256_state *sctx)
>   	sctx->state[6] = SHA224_H6;
>   	sctx->state[7] = SHA224_H7;
>   	sctx->count = 0;
> -
> -	return 0;
>   }
> -extern int sha224_update(struct sha256_state *sctx, const u8 *input,
> -			 unsigned int length);
> -extern int sha224_final(struct sha256_state *sctx, u8 *hash);
> +extern void sha224_update(struct sha256_state *sctx, const u8 *data,
> +			  unsigned int len);
> +extern void sha224_final(struct sha256_state *sctx, u8 *out);

The 'extern' keywork is useless in a function declaration. It should be 
removed, as recommended by 'checkpatch --strict'.

>   
>   #endif
> diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
> index cea60cff80bd87..6ded110783ae87 100644
> --- a/include/crypto/sha256_base.h
> +++ b/include/crypto/sha256_base.h
> @@ -22,14 +22,16 @@ static inline int sha224_base_init(struct shash_desc *desc)
>   {
>   	struct sha256_state *sctx = shash_desc_ctx(desc);
>   
> -	return sha224_init(sctx);
> +	sha224_init(sctx);
> +	return 0;
>   }
>   
>   static inline int sha256_base_init(struct shash_desc *desc)
>   {
>   	struct sha256_state *sctx = shash_desc_ctx(desc);
>   
> -	return sha256_init(sctx);
> +	sha256_init(sctx);
> +	return 0;
>   }
>   
>   static inline int sha256_base_do_update(struct shash_desc *desc,
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 66cb04b0cf4e7e..2e621697c5c35c 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -206,7 +206,7 @@ static void sha256_transform(u32 *state, const u8 *input)
>   	memzero_explicit(W, 64 * sizeof(u32));
>   }
>   
> -int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
> +void sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>   {
>   	unsigned int partial, done;
>   	const u8 *src;
> @@ -232,18 +232,16 @@ int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>   		partial = 0;
>   	}
>   	memcpy(sctx->buf + partial, src, len - done);
> -
> -	return 0;
>   }
>   EXPORT_SYMBOL(sha256_update);
>   
> -int sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
> +void sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>   {
> -	return sha256_update(sctx, data, len);
> +	sha256_update(sctx, data, len);
>   }
>   EXPORT_SYMBOL(sha224_update);
>   
> -static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
> +static void __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
>   {
>   	__be32 *dst = (__be32 *)out;
>   	__be64 bits;
> @@ -268,19 +266,17 @@ static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
>   
>   	/* Zeroize sensitive information. */
>   	memset(sctx, 0, sizeof(*sctx));
> -
> -	return 0;
>   }
>   
> -int sha256_final(struct sha256_state *sctx, u8 *out)
> +void sha256_final(struct sha256_state *sctx, u8 *out)
>   {
> -	return __sha256_final(sctx, out, 8);
> +	__sha256_final(sctx, out, 8);
>   }
>   EXPORT_SYMBOL(sha256_final);
>   
> -int sha224_final(struct sha256_state *sctx, u8 *out)
> +void sha224_final(struct sha256_state *sctx, u8 *out)
>   {
> -	return __sha256_final(sctx, out, 7);
> +	__sha256_final(sctx, out, 7);
>   }
>   EXPORT_SYMBOL(sha224_final);
>   
> 

Christophe
