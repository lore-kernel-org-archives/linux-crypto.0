Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1620AC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 15:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiKKPnz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbiKKPny (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 10:43:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312C4DE93
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 07:43:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p21so4526706plr.7
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 07:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BG6yEELrQ+5Gqlx5pgI/WTlERb6rsrrOtH7R7yNN+oM=;
        b=enfrrrCdo9uMC850+wFIYO7P+pm42FJ+U08bCwrj3XJAI+hn9P0gg690/cimgawHHb
         reamDV/ndgTLANm1lUgPfa1EQKe+8lffl6A0T1W0OeQamU6ZnV6+MiAdkmyOlgI//SxY
         iozjDMECt1uVXMn7Ia1asPqShPOMruP74fqghr+WJ6hfecyOR6meUUPpljhiHlGYl98Q
         qreNlEsGKpCSK0JvUJX3Y089c+9Q79dtCB2TWUAmlSG3/tRbDbjfGtG679wXYoH1OP2v
         hRxLcDbSYkN+EebAzi13yNpD4qGmjPZKXU1d2Q69OgJdvZTHc6F65UM+vEGHZQ581yiy
         0+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BG6yEELrQ+5Gqlx5pgI/WTlERb6rsrrOtH7R7yNN+oM=;
        b=1yLoa/cAqePDn7VveKmS6NmvELmj6IbDHfFpIJNtVcQmHHM4/LVwzSvsueuclR+jCz
         1+NdM4LL4EjC2RUZHbVDZsAnH60GyYST0JfAexFaH06iED9l9C3DVi5Qi8foaR6UPZuG
         HqpPK4sE53yE9iL04hb+6Q4x8Y4Ap3E2o1XiOUpooqA3877ud/c3YUk6EXMtj/pZFDRO
         maVVLDpGec7fD6U+yzpBpcMRI58Aanun8WI4Z89gdatHQgysWAK5naxolPcdLmRLOSgy
         akavcEMLt2yIlOBSCd2Za12nUEAwSO3dWDUZTb6tUSJPDgQpjI/ChVFaVZuBkU5Lzrec
         fq4w==
X-Gm-Message-State: ANoB5plvWxSnmJYav8MXyRiHfkgcedZDzGcGkxcOYzwP2ytuK+r7iEQw
        8gQ8ciLKRys7Ox3ytmCvpxA=
X-Google-Smtp-Source: AA0mqf5YVg2ei/cjnioU7JWk4/tITJ+r2Eu9wP4BcnRhUq5wmaewyp9YEelwVDAPTu4l32eisoAxhA==
X-Received: by 2002:a17:902:6a8c:b0:186:b46d:da59 with SMTP id n12-20020a1709026a8c00b00186b46dda59mr3063119plk.116.1668181432552;
        Fri, 11 Nov 2022 07:43:52 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f00:98::16:12e])
        by smtp.gmail.com with ESMTPSA id n5-20020aa79845000000b0056281da3bcbsm1788872pfq.149.2022.11.11.07.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 07:43:52 -0800 (PST)
Message-ID: <bdd7c674-75fa-d897-2a94-aeaabae08ef8@gmail.com>
Date:   Sat, 12 Nov 2022 00:43:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: crypto: cryptd - Use request context instead of stack for
 sub-request
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        Kees Cook <keescook@chromium.org>
References: <20221106143627.30920-1-ap420073@gmail.com>
 <20221106143627.30920-2-ap420073@gmail.com>
 <Y2jGTvgHnu4QZV+D@gondor.apana.org.au>
 <51ed3735-24f0-eef0-0ca6-908c4581d143@gmail.com>
 <Y24c9WcEpvibbRqo@gondor.apana.org.au>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y24c9WcEpvibbRqo@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thank you so much for this work!

On 11/11/22 18:59, Herbert Xu wrote:
 > On Wed, Nov 09, 2022 at 10:16:58PM +0900, Taehee Yoo wrote:
 >>
 >> I have encountered kernel panic(stack-out-of-bounds) while using the 
reqctx
 >> instead of the tfm.
 >>
 >> cryptd is used when simd drivers are used.
 >> cryptd_skcipher_encrypt() internally doesn't allocate a request ctx of a
 >> child, instead, it uses stack memory with 
SYNC_SKCIPHER_REQUEST_ON_STACK.
 >> It retains only 384 bytes for child request ctx even if a child set 
a large
 >> reqsize value with crypto_skcipher_set_reqsize().
 >> aria-avx2 needs 512 bytes and aria-avx512 needs 1024 bytes.
 >> So, stack-out-of-bounds occurs.
 >
 > OK this is not supposed to happen.
 >
 > ---8<---
 > cryptd is buggy as it tries to use sync_skcipher without going
 > through the proper sync_skcipher interface.  In fact it doesn't
 > even need sync_skcipher since it's already a proper skcipher and
 > can easily access the request context instead of using something
 > off the stack.
 >

I have tested this patch with ctr(aria-avx), ctr(aria-avx2), and 
ctr(aria-avx512), and it works well.
stack-out-of-bounds issues have disappeared after this patch.
So, I will test more and I will send a v4 patch.

 > Fixes: 36b3875a97b8 ("crypto: cryptd - Remove VLA usage of skcipher")
 > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
 >
 > diff --git a/crypto/cryptd.c b/crypto/cryptd.c
 > index 668095eca0fa..ca3a40fc7da9 100644
 > --- a/crypto/cryptd.c
 > +++ b/crypto/cryptd.c
 > @@ -68,11 +68,12 @@ struct aead_instance_ctx {
 >
 >   struct cryptd_skcipher_ctx {
 >   	refcount_t refcnt;
 > -	struct crypto_sync_skcipher *child;
 > +	struct crypto_skcipher *child;
 >   };
 >
 >   struct cryptd_skcipher_request_ctx {
 >   	crypto_completion_t complete;
 > +	struct skcipher_request req;
 >   };
 >
 >   struct cryptd_hash_ctx {
 > @@ -227,13 +228,13 @@ static int cryptd_skcipher_setkey(struct 
crypto_skcipher *parent,
 >   				  const u8 *key, unsigned int keylen)
 >   {
 >   	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(parent);
 > -	struct crypto_sync_skcipher *child = ctx->child;
 > +	struct crypto_skcipher *child = ctx->child;
 >
 > -	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 > -	crypto_sync_skcipher_set_flags(child,
 > -				       crypto_skcipher_get_flags(parent) &
 > -					 CRYPTO_TFM_REQ_MASK);
 > -	return crypto_sync_skcipher_setkey(child, key, keylen);
 > +	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
 > +	crypto_skcipher_set_flags(child,
 > +				  crypto_skcipher_get_flags(parent) &
 > +				  CRYPTO_TFM_REQ_MASK);
 > +	return crypto_skcipher_setkey(child, key, keylen);
 >   }
 >
 >   static void cryptd_skcipher_complete(struct skcipher_request *req, 
int err)
 > @@ -258,13 +259,13 @@ static void cryptd_skcipher_encrypt(struct 
crypto_async_request *base,
 >   	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 >   	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 >   	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 > -	struct crypto_sync_skcipher *child = ctx->child;
 > -	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 > +	struct skcipher_request *subreq = &rctx->req;
 > +	struct crypto_skcipher *child = ctx->child;
 >
 >   	if (unlikely(err == -EINPROGRESS))
 >   		goto out;
 >
 > -	skcipher_request_set_sync_tfm(subreq, child);
 > +	skcipher_request_set_tfm(subreq, child);
 >   	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 >   				      NULL, NULL);
 >   	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 > @@ -286,13 +287,13 @@ static void cryptd_skcipher_decrypt(struct 
crypto_async_request *base,
 >   	struct cryptd_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
 >   	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 >   	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 > -	struct crypto_sync_skcipher *child = ctx->child;
 > -	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, child);
 > +	struct skcipher_request *subreq = &rctx->req;
 > +	struct crypto_skcipher *child = ctx->child;
 >
 >   	if (unlikely(err == -EINPROGRESS))
 >   		goto out;
 >
 > -	skcipher_request_set_sync_tfm(subreq, child);
 > +	skcipher_request_set_tfm(subreq, child);
 >   	skcipher_request_set_callback(subreq, CRYPTO_TFM_REQ_MAY_SLEEP,
 >   				      NULL, NULL);
 >   	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
 > @@ -343,9 +344,10 @@ static int cryptd_skcipher_init_tfm(struct 
crypto_skcipher *tfm)
 >   	if (IS_ERR(cipher))
 >   		return PTR_ERR(cipher);
 >
 > -	ctx->child = (struct crypto_sync_skcipher *)cipher;
 > +	ctx->child = cipher;
 >   	crypto_skcipher_set_reqsize(
 > -		tfm, sizeof(struct cryptd_skcipher_request_ctx));
 > +		tfm, sizeof(struct cryptd_skcipher_request_ctx) +
 > +		     crypto_skcipher_reqsize(cipher));
 >   	return 0;
 >   }
 >
 > @@ -353,7 +355,7 @@ static void cryptd_skcipher_exit_tfm(struct 
crypto_skcipher *tfm)
 >   {
 >   	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 >
 > -	crypto_free_sync_skcipher(ctx->child);
 > +	crypto_free_skcipher(ctx->child);
 >   }
 >
 >   static void cryptd_skcipher_free(struct skcipher_instance *inst)
 > @@ -931,7 +933,7 @@ struct crypto_skcipher 
*cryptd_skcipher_child(struct cryptd_skcipher *tfm)
 >   {
 >   	struct cryptd_skcipher_ctx *ctx = crypto_skcipher_ctx(&tfm->base);
 >
 > -	return &ctx->child->base;
 > +	return ctx->child;
 >   }
 >   EXPORT_SYMBOL_GPL(cryptd_skcipher_child);
 >

Thanks a lot,
Taehee Yoo
