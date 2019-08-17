Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8CBC3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 12:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE29F2075E
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 12:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfHQMSY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 08:18:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41827 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfHQMSY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 08:18:24 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so7319595edl.8
        for <linux-crypto@vger.kernel.org>; Sat, 17 Aug 2019 05:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNOn18v8Rp5GbzUQE3NK96z4rSw+eVd6G/JY1Otz7tk=;
        b=qtoSZ6qSeZGgKpJy7cEhdvGwWaAO1uhM92JE+aqo4dU28rHAjLTjCILkQ2tYen3BLZ
         UyJITclY3oIIPHI/4lKwh8rwNIE3EIhgWWb2qHbBR9DomR03bFGC8V2HpTlCO7uxEY91
         JeZ69cIEreQFu5F1f7l5MJdN8qbf1Qy6s01/0pPMAvl84HNfWBlOxHun2atmw76UMDmS
         nYYZnRxmP46XsVVA1i4ZBHxjRNPEAvNtxinvgO/kai/hQnfUXyLzx3BLGM3JLKKRSODE
         tAfAuRAnYwYjwqh/i4WA7DwbBdSqtfe3UVbBNddgsOnM6wMmHrVzFiyW0ZT5lhDfD6Cs
         +Slg==
X-Gm-Message-State: APjAAAXvVKQTnIRkU5D3hZgKxLPopYoBJs0ZBC7o+dgbj46UlDwI0Vwv
        gRco59vxV7WPHS2+HAQR8+Jf8Q==
X-Google-Smtp-Source: APXvYqxBQbhyYhI1Vveh6TS0bYWp3aZ0XKaANav6LHXYmaHiP2YolHrGWMwYK/yevgow6XEmm/JCqA==
X-Received: by 2002:a50:cf81:: with SMTP id h1mr15374391edk.141.1566044301869;
        Sat, 17 Aug 2019 05:18:21 -0700 (PDT)
Received: from shalem.localdomain (84-106-84-65.cable.dynamic.v4.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id e24sm1199680ejb.53.2019.08.17.05.18.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Aug 2019 05:18:20 -0700 (PDT)
Subject: Re: [PATCH 6/6] crypto: sha256_generic - Use sha256_transform from
 generic sha256 lib
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190816211611.2568-1-hdegoede@redhat.com>
 <20190816211611.2568-7-hdegoede@redhat.com>
 <20190817051318.GA8209@sol.localdomain>
 <20190817053555.GC8209@sol.localdomain>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <b6ce1a0c-63dd-7b0c-b050-1c56c0daeb84@redhat.com>
Date:   Sat, 17 Aug 2019 14:18:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190817053555.GC8209@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

Thank you for the review and for the quick turn around time
on the review.

On 17-08-19 07:35, Eric Biggers wrote:
> On Fri, Aug 16, 2019 at 10:13:18PM -0700, Eric Biggers wrote:
>> On Fri, Aug 16, 2019 at 11:16:11PM +0200, Hans de Goede wrote:
>>> Drop the duplicate sha256_transform function from crypto/sha256_generic.c
>>> and use the implementation from lib/crypto/sha256.c instead.
>>> "diff -u lib/crypto/sha256.c sha256_generic.c"
>>> shows that both implementations are identical.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Hi Hans, thanks for doing this!
>>
>> I'm a little concerned that the only sha256 lib function which sha256_generic.c
>> calls is sha256_transform().  This means that sha256_init(), sha256_update(),
>> and sha256_final() are not tested by the crypto self-tests.  They could be
>> broken and we wouldn't know.
>>
>> IMO, it would be better to make sha256_generic.c use sha256_init(),
>> sha256_update(), and sha256_final() rather than using sha256_base.h.
>> Then we'd get test coverage of both the sha256 lib, and of sha256_base.h
>> via the architecture-specific implementations.
>>
>> To do this you'll also need to add sha224_init(), sha224_update(), and
>> sha224_final().  But that's straightforward.
>>
> 
> This is basically what I'm suggesting:
> 
> diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
> index 51b3afcb5407..94bb23e33804 100644
> --- a/crypto/sha256_generic.c
> +++ b/crypto/sha256_generic.c
> @@ -39,39 +39,42 @@ const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
>   };
>   EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
>   
> -static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
> -				    int blocks)
> +static int crypto_sha256_init(struct shash_desc *desc)
>   {
> -	while (blocks--) {
> -		sha256_transform(sst->state, src);
> -		src += SHA256_BLOCK_SIZE;
> -	}
> +	return sha256_init(shash_desc_ctx(desc));
> +}
> +
> +static int crypto_sha224_init(struct shash_desc *desc)
> +{
> +	return sha224_init(shash_desc_ctx(desc));
>   }
>   
>   int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
>   			  unsigned int len)
>   {
> -	return sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
> +	return sha256_update(shash_desc_ctx(desc), data, len);
>   }
>   EXPORT_SYMBOL(crypto_sha256_update);
>   
>   static int crypto_sha256_final(struct shash_desc *desc, u8 *out)
>   {
> -	sha256_base_do_finalize(desc, sha256_generic_block_fn);
> -	return sha256_base_finish(desc, out);
> +	if (crypto_shash_digestsize(desc->tfm) == SHA224_DIGEST_SIZE)
> +		return sha224_final(shash_desc_ctx(desc), out);
> +	else
> +		return sha256_final(shash_desc_ctx(desc), out);
>   }
>   
>   int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
>   			unsigned int len, u8 *hash)
>   {
> -	sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
> +	sha256_update(shash_desc_ctx(desc), data, len);
>   	return crypto_sha256_final(desc, hash);
>   }
>   EXPORT_SYMBOL(crypto_sha256_finup);
>   
>   static struct shash_alg sha256_algs[2] = { {
>   	.digestsize	=	SHA256_DIGEST_SIZE,
> -	.init		=	sha256_base_init,
> +	.init		=	crypto_sha256_init,
>   	.update		=	crypto_sha256_update,
>   	.final		=	crypto_sha256_final,
>   	.finup		=	crypto_sha256_finup,
> @@ -85,7 +88,7 @@ static struct shash_alg sha256_algs[2] = { {
>   	}
>   }, {
>   	.digestsize	=	SHA224_DIGEST_SIZE,
> -	.init		=	sha224_base_init,
> +	.init		=	crypto_sha224_init,
>   	.update		=	crypto_sha256_update,
>   	.final		=	crypto_sha256_final,
>   	.finup		=	crypto_sha256_finup,
> diff --git a/include/crypto/sha256.h b/include/crypto/sha256.h
> index f596202ad85f..44e207fb13ad 100644
> --- a/include/crypto/sha256.h
> +++ b/include/crypto/sha256.h
> @@ -21,9 +21,13 @@
>    */
>   
>   extern int sha256_init(struct sha256_state *sctx);
> -extern void sha256_transform(u32 *state, const u8 *input);
>   extern int sha256_update(struct sha256_state *sctx, const u8 *input,
>   			 unsigned int length);
>   extern int sha256_final(struct sha256_state *sctx, u8 *hash);
>   
> +extern int sha224_init(struct sha256_state *sctx);
> +extern int sha224_update(struct sha256_state *sctx, const u8 *input,
> +			 unsigned int length);
> +extern int sha224_final(struct sha256_state *sctx, u8 *hash);
> +
>   #endif /* SHA256_H */
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 3e9cc54f7e1c..d808543b3784 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -42,7 +42,7 @@ static inline void BLEND_OP(int I, u32 *W)
>   	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
>   }
>   
> -void sha256_transform(u32 *state, const u8 *input)
> +static void sha256_transform(u32 *state, const u8 *input)
>   {
>   	u32 a, b, c, d, e, f, g, h, t1, t2;
>   	u32 W[64];
> @@ -204,7 +204,6 @@ void sha256_transform(u32 *state, const u8 *input)
>   	a = b = c = d = e = f = g = h = t1 = t2 = 0;
>   	memzero_explicit(W, 64 * sizeof(u32));
>   }
> -EXPORT_SYMBOL(sha256_transform);
>   
>   int sha256_init(struct sha256_state *sctx)
>   {
> @@ -222,6 +221,22 @@ int sha256_init(struct sha256_state *sctx)
>   }
>   EXPORT_SYMBOL(sha256_init);
>   
> +int sha224_init(struct sha256_state *sctx)
> +{
> +	sctx->state[0] = SHA224_H0;
> +	sctx->state[1] = SHA224_H1;
> +	sctx->state[2] = SHA224_H2;
> +	sctx->state[3] = SHA224_H3;
> +	sctx->state[4] = SHA224_H4;
> +	sctx->state[5] = SHA224_H5;
> +	sctx->state[6] = SHA224_H6;
> +	sctx->state[7] = SHA224_H7;
> +	sctx->count = 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(sha224_init);
> +
>   int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>   {
>   	unsigned int partial, done;
> @@ -253,7 +268,13 @@ int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
>   }
>   EXPORT_SYMBOL(sha256_update);
>   
> -int sha256_final(struct sha256_state *sctx, u8 *out)
> +int sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
> +{
> +	return sha256_update(sctx, data, len);
> +}
> +EXPORT_SYMBOL(sha224_update);
> +
> +static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
>   {
>   	__be32 *dst = (__be32 *)out;
>   	__be64 bits;
> @@ -273,7 +294,7 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
>   	sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
>   
>   	/* Store state in digest */
> -	for (i = 0; i < 8; i++)
> +	for (i = 0; i < digest_words; i++)
>   		dst[i] = cpu_to_be32(sctx->state[i]);
>   
>   	/* Zeroize sensitive information. */
> @@ -281,4 +302,15 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
>   
>   	return 0;
>   }
> +
> +int sha256_final(struct sha256_state *sctx, u8 *out)
> +{
> +	return __sha256_final(sctx, out, 8);
> +}
>   EXPORT_SYMBOL(sha256_final);
> +
> +int sha224_final(struct sha256_state *sctx, u8 *out)
> +{
> +	return __sha256_final(sctx, out, 7);
> +}
> +EXPORT_SYMBOL(sha224_final);

Thank you for the patch, I agree with what you are suggesting, I'm
preparing a new version of the patch series with this added.

I'm adding a:

Suggested-by: Eric Biggers <ebiggers@kernel.org>

To credit you for your input on this.

Regards,

Hans

