Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24CFC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707B320B7C
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 08:12:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IXoOwl6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405765AbfHIIMU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:12:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46569 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405612AbfHIIMU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 04:12:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so97389088wru.13
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 01:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vxGcmXr8SlfnQiIywxU/vIruwseIJl18vHG+iJ4jgdQ=;
        b=IXoOwl6QVXkBGGnr0ODSwH+/7WBYluxFwGjUKfTrmiNQuZakC63OjtWhtQx/npufLg
         m3bfAHfe1EyPESC9UzMKvEcO7mm4biJohWXKl7l2U/32LAIRGH6aukL60XA9pD5UW+M3
         yWvgXzKTnpcJyrmA7mCkb/Qyyq3xmZG/6XCE0oBh2Yh0XYWNLNBdeSiDyZknNJFSrwb+
         SHb/gqNdZO1u4OINk7dG56tgE9VumtcLy+Fi4c8PYWpcFkyW8idm99izSiYe9SPGSSK2
         4l+Kojb2ROabUGaYPJrffdhtw/P+b55qjgIwtcTYxW8BPmghiIB61bdKlBx9MEmfaaZI
         cC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vxGcmXr8SlfnQiIywxU/vIruwseIJl18vHG+iJ4jgdQ=;
        b=nhcOEsQUaa56TX+Mteuu/z4smHmqu5YbtToDWPN/MiW5CPTjY+NsfGdHdH9lx4MGuo
         4GXIDDbaymFfTd3miUrmwY/GTsrQYBx4y6Pu3dLpGo1ikwdlSRCK+wHzm6ZQqKilQh5L
         QxFRsGxDJsS7c2AeLbsHRiGItdKZJFXl5605JOIuwV7H0Bk0WRNh953v0vX15KKSLgAh
         /NoQXhgcQRbwb7NZMRsB46r98jJQ1es4k7C8bmXr8cH3DF3PROoqVONuheSUM/fkH1UJ
         5+K02lgN60NKiqC+vf+MZcCGcSzlk2LN4s26w+aoEjRud6xQn9/9o6q+0FjdmHGT6miJ
         1l2A==
X-Gm-Message-State: APjAAAXAX9l9lurfXovklYTezYh2VKBLvyh+AHD0YJGpYBsIZbUpAz9K
        0s4wK6hqm8Hqbk0Ep5R7Sf4=
X-Google-Smtp-Source: APXvYqzOuAoqolTZ6vI6O+hu1M2jcmAQ4fnm0gQzippC5i1WC3vRwdTAdQO2aY+JJzGHNQgc7rAtzQ==
X-Received: by 2002:a5d:6409:: with SMTP id z9mr9546702wru.308.1565338336864;
        Fri, 09 Aug 2019 01:12:16 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 24sm1014464wmf.10.2019.08.09.01.12.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 01:12:16 -0700 (PDT)
Subject: Re: [PATCH] crypto: xts - add support for ciphertext stealing
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
References: <20190809063106.316-1-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <11d5a697-aefb-e73a-746b-baae71b0e0f0@gmail.com>
Date:   Fri, 9 Aug 2019 10:12:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809063106.316-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 09/08/2019 08:31, Ard Biesheuvel wrote:
> Add support for the missing ciphertext stealing part of the XTS-AES
> specification, which permits inputs of any size >= the block size.
> 
> Cc: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> Cc: Ondrej Mosnacek <omosnace@redhat.com>
> Cc: Milan Broz <gmazyland@gmail.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> This is an alternative approach to Pascal's [0]: instead of instantiating
> a separate cipher to deal with the tail, invoke the same ECB skcipher used
> for the bulk of the data.
> 
> [0] https://lore.kernel.org/linux-crypto/1565245094-8584-1-git-send-email-pvanleeuwen@verimatrix.com/

I added the 8byte IVs test vectors, and run vectors test with AF_ALG.
Seems it works (the same in comparison with OpenSSL and gcrypt XTS implementations).

So whatever patch version is applied, I am happy with it :-)

If it helps anything, you can add

Tested-by: Milan Broz <gmazyland@gmail.com>

m.

> 
>  crypto/xts.c | 148 +++++++++++++++++---
>  1 file changed, 130 insertions(+), 18 deletions(-)
> 
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 11211003db7e..fc9edc6eb11e 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -34,6 +34,7 @@ struct xts_instance_ctx {
>  
>  struct rctx {
>  	le128 t;
> +	struct scatterlist sg[2];
>  	struct skcipher_request subreq;
>  };
>  
> @@ -84,10 +85,11 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
>   * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
>   * just doing the gf128mul_x_ble() calls again.
>   */
> -static int xor_tweak(struct skcipher_request *req, bool second_pass)
> +static int xor_tweak(struct skcipher_request *req, bool second_pass, bool enc)
>  {
>  	struct rctx *rctx = skcipher_request_ctx(req);
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	const bool cts = (req->cryptlen % XTS_BLOCK_SIZE);
>  	const int bs = XTS_BLOCK_SIZE;
>  	struct skcipher_walk w;
>  	le128 t = rctx->t;
> @@ -109,6 +111,20 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
>  		wdst = w.dst.virt.addr;
>  
>  		do {
> +			if (unlikely(cts) &&
> +			    w.total - w.nbytes + avail < 2 * XTS_BLOCK_SIZE) {
> +				if (!enc) {
> +					if (second_pass)
> +						rctx->t = t;
> +					gf128mul_x_ble(&t, &t);
> +				}
> +				le128_xor(wdst, &t, wsrc);
> +				if (enc && second_pass)
> +					gf128mul_x_ble(&rctx->t, &t);
> +				skcipher_walk_done(&w, avail - bs);
> +				return 0;
> +			}
> +
>  			le128_xor(wdst++, &t, wsrc++);
>  			gf128mul_x_ble(&t, &t);
>  		} while ((avail -= bs) >= bs);
> @@ -119,17 +135,70 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
>  	return err;
>  }
>  
> -static int xor_tweak_pre(struct skcipher_request *req)
> +static int xor_tweak_pre(struct skcipher_request *req, bool enc)
>  {
> -	return xor_tweak(req, false);
> +	return xor_tweak(req, false, enc);
>  }
>  
> -static int xor_tweak_post(struct skcipher_request *req)
> +static int xor_tweak_post(struct skcipher_request *req, bool enc)
>  {
> -	return xor_tweak(req, true);
> +	return xor_tweak(req, true, enc);
>  }
>  
> -static void crypt_done(struct crypto_async_request *areq, int err)
> +static void cts_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req = areq->data;
> +	le128 b;
> +
> +	if (!err) {
> +		struct rctx *rctx = skcipher_request_ctx(req);
> +
> +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 0);
> +		le128_xor(&b, &rctx->t, &b);
> +		scatterwalk_map_and_copy(&b, rctx->sg, 0, XTS_BLOCK_SIZE, 1);
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int cts_final(struct skcipher_request *req,
> +		     int (*crypt)(struct skcipher_request *req))
> +{
> +	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> +	int offset = req->cryptlen & ~(XTS_BLOCK_SIZE - 1);
> +	struct rctx *rctx = skcipher_request_ctx(req);
> +	struct skcipher_request *subreq = &rctx->subreq;
> +	int tail = req->cryptlen % XTS_BLOCK_SIZE;
> +	struct scatterlist *sg;
> +	le128 b[2];
> +	int err;
> +
> +	sg = scatterwalk_ffwd(rctx->sg, req->dst, offset - XTS_BLOCK_SIZE);
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> +	memcpy(b + 1, b, tail);
> +	scatterwalk_map_and_copy(b, req->src, offset, tail, 0);
> +
> +	le128_xor(b, &rctx->t, b);
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE + tail, 1);
> +
> +	skcipher_request_set_tfm(subreq, ctx->child);
> +	skcipher_request_set_callback(subreq, req->base.flags, cts_done, req);
> +	skcipher_request_set_crypt(subreq, sg, sg, XTS_BLOCK_SIZE, NULL);
> +
> +	err = crypt(subreq);
> +	if (err)
> +		return err;
> +
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 0);
> +	le128_xor(b, &rctx->t, b);
> +	scatterwalk_map_and_copy(b, sg, 0, XTS_BLOCK_SIZE, 1);
> +
> +	return 0;
> +}
> +
> +static void encrypt_done(struct crypto_async_request *areq, int err)
>  {
>  	struct skcipher_request *req = areq->data;
>  
> @@ -137,47 +206,90 @@ static void crypt_done(struct crypto_async_request *areq, int err)
>  		struct rctx *rctx = skcipher_request_ctx(req);
>  
>  		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> -		err = xor_tweak_post(req);
> +		err = xor_tweak_post(req, true);
> +
> +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> +			err = cts_final(req, crypto_skcipher_encrypt);
> +			if (err == -EINPROGRESS)
> +				return;
> +		}
>  	}
>  
>  	skcipher_request_complete(req, err);
>  }
>  
> -static void init_crypt(struct skcipher_request *req)
> +static void decrypt_done(struct crypto_async_request *areq, int err)
> +{
> +	struct skcipher_request *req = areq->data;
> +
> +	if (!err) {
> +		struct rctx *rctx = skcipher_request_ctx(req);
> +
> +		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
> +		err = xor_tweak_post(req, false);
> +
> +		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
> +			err = cts_final(req, crypto_skcipher_decrypt);
> +			if (err == -EINPROGRESS)
> +				return;
> +		}
> +	}
> +
> +	skcipher_request_complete(req, err);
> +}
> +
> +static int init_crypt(struct skcipher_request *req, crypto_completion_t compl)
>  {
>  	struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
>  	struct rctx *rctx = skcipher_request_ctx(req);
>  	struct skcipher_request *subreq = &rctx->subreq;
>  
> +	if (req->cryptlen < XTS_BLOCK_SIZE)
> +		return -EINVAL;
> +
>  	skcipher_request_set_tfm(subreq, ctx->child);
> -	skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
> +	skcipher_request_set_callback(subreq, req->base.flags, compl, req);
>  	skcipher_request_set_crypt(subreq, req->dst, req->dst,
> -				   req->cryptlen, NULL);
> +				   req->cryptlen & ~(XTS_BLOCK_SIZE - 1), NULL);
>  
>  	/* calculate first value of T */
>  	crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> +
> +	return 0;
>  }
>  
>  static int encrypt(struct skcipher_request *req)
>  {
>  	struct rctx *rctx = skcipher_request_ctx(req);
>  	struct skcipher_request *subreq = &rctx->subreq;
> +	int err;
>  
> -	init_crypt(req);
> -	return xor_tweak_pre(req) ?:
> -		crypto_skcipher_encrypt(subreq) ?:
> -		xor_tweak_post(req);
> +	err = init_crypt(req, encrypt_done) ?:
> +	      xor_tweak_pre(req, true) ?:
> +	      crypto_skcipher_encrypt(subreq) ?:
> +	      xor_tweak_post(req, true);
> +
> +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
> +		return err;
> +
> +	return cts_final(req, crypto_skcipher_encrypt);
>  }
>  
>  static int decrypt(struct skcipher_request *req)
>  {
>  	struct rctx *rctx = skcipher_request_ctx(req);
>  	struct skcipher_request *subreq = &rctx->subreq;
> +	int err;
> +
> +	err = init_crypt(req, decrypt_done) ?:
> +	      xor_tweak_pre(req, false) ?:
> +	      crypto_skcipher_decrypt(subreq) ?:
> +	      xor_tweak_post(req, false);
> +
> +	if (err || likely((req->cryptlen % XTS_BLOCK_SIZE) == 0))
> +		return err;
>  
> -	init_crypt(req);
> -	return xor_tweak_pre(req) ?:
> -		crypto_skcipher_decrypt(subreq) ?:
> -		xor_tweak_post(req);
> +	return cts_final(req, crypto_skcipher_decrypt);
>  }
>  
>  static int init_tfm(struct crypto_skcipher *tfm)
> 
