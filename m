Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59250C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 11:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 212D721874
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 11:53:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjSJoJ6O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfHHLxQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 07:53:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46672 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfHHLxQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 07:53:16 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so94631378wru.13
        for <linux-crypto@vger.kernel.org>; Thu, 08 Aug 2019 04:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vILGCjKtV3eGAFYGxVaZEjKfTjQI0RrbwrN7GVSVEp4=;
        b=NjSJoJ6OshZWe6QGnwvrZhuR9NFMXymXAvOePeDJ7RBvXNgPuPHQ3mdEpkMW0Ks4LJ
         FR72b0/q4C7nZNL5/Lpebz1xDzAVOIpyDl5kThlgJECt4h4ZjT8tzjeg1XyPOFuIG4k8
         vYylheCi4ZquCIPZT4Gu9CUzAb5OLmz8Xvat5q5oh/3UbsGsr5/lNUCVbeaMVnI4dTLU
         oxF0TBDGblXa1+3SFW2n/hSjB0ulDOv32fNG//kZTZkGGZkuJ6az2hP7BemIDngzdoFW
         Zpossbf0oE7cFPX/2g2eBsdOr8hGU7FrtyXTLdwjY5a/RL3HtroI1mJyGw9yE+SvvfUP
         olNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vILGCjKtV3eGAFYGxVaZEjKfTjQI0RrbwrN7GVSVEp4=;
        b=YngjqaR8mhovTdSas7fbz76yEsA20MY57H5ldpS6XTHyxVAQrA7BPf+wmTRffOhn4B
         tPbEMr+2bvhkHM1x4Pa+w91EE7gglysYSw92OzoWvT2y+lZhVROrsWL849XGyRsaJmFB
         IsMtF8nYRGT6g51eFuCTVgPBcQ+jM+dSNB2W5FBrFZzdBHvVf+N00hb4bdAd+DkLXuVt
         bzzq7jHikGS0nh0TyNN5//hHz2Qt2bMtYZ5/DHNlxmDzg+dGZnLMHEdFr6QxGHJkKEqo
         wxitmAl+rtSxVZbkDzIxQjqh6W2mk5yLUPkujKJ6OB9sgicSM1MexF5l488S43Z6xA77
         AhJA==
X-Gm-Message-State: APjAAAUaI0dEBB8LZybsXosibT3aoZuj1ppX5iVEHhBSy/rTm4AO2+YO
        aUdqgMmAP5CckwGawnh26GE=
X-Google-Smtp-Source: APXvYqxm780O8ckDgYoEDh8DvDZ5LgviPaPxu/Ldk3Lgsd9780EhXxKJqwqCrOND8kBKjKxQ26FpoA==
X-Received: by 2002:a5d:4950:: with SMTP id r16mr695153wrs.347.1565265193339;
        Thu, 08 Aug 2019 04:53:13 -0700 (PDT)
Received: from [10.43.17.10] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u130sm3196942wmg.28.2019.08.08.04.53.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 04:53:12 -0700 (PDT)
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e13525a4-4885-e0f3-6711-efd83dd4a9fb@gmail.com>
Date:   Thu, 8 Aug 2019 13:53:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07/08/2019 07:50, Ard Biesheuvel wrote:
> Instead of instantiating a separate cipher to perform the encryption
> needed to produce the IV, reuse the skcipher used for the block data
> and invoke it one additional time for each block to encrypt a zero
> vector and use the output as the IV.
> 
> For CBC mode, this is equivalent to using the bare block cipher, but
> without the risk of ending up with a non-time invariant implementation
> of AES when the skcipher itself is time variant (e.g., arm64 without
> Crypto Extensions has a NEON based time invariant implementation of
> cbc(aes) but no time invariant implementation of the core cipher other
> than aes-ti, which is not enabled by default)
> 
> This approach is a compromise between dm-crypt API flexibility and
> reducing dependence on parts of the crypto API that should not usually
> be exposed to other subsystems, such as the bare cipher API.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

For now I have just pair of images here to test, but seems checksums are ok.

Tested-by: Milan Broz <gmazyland@gmail.com>

I talked with Mike already, so it should go through DM tree now.

Thanks!
Milan


> ---
>  drivers/md/dm-crypt.c | 70 ++++++++++++++-----------------------------
>  1 file changed, 22 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index d5216bcc4649..48cd76c88d77 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -120,10 +120,6 @@ struct iv_tcw_private {
>  	u8 *whitening;
>  };
>  
> -struct iv_eboiv_private {
> -	struct crypto_cipher *tfm;
> -};
> -
>  /*
>   * Crypt: maps a linear range of a block device
>   * and encrypts / decrypts at the same time.
> @@ -163,7 +159,6 @@ struct crypt_config {
>  		struct iv_benbi_private benbi;
>  		struct iv_lmk_private lmk;
>  		struct iv_tcw_private tcw;
> -		struct iv_eboiv_private eboiv;
>  	} iv_gen_private;
>  	u64 iv_offset;
>  	unsigned int iv_size;
> @@ -847,65 +842,47 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
>  	return 0;
>  }
>  
> -static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> -{
> -	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> -
> -	crypto_free_cipher(eboiv->tfm);
> -	eboiv->tfm = NULL;
> -}
> -
>  static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
>  			    const char *opts)
>  {
> -	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> -	struct crypto_cipher *tfm;
> -
> -	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> -	if (IS_ERR(tfm)) {
> -		ti->error = "Error allocating crypto tfm for EBOIV";
> -		return PTR_ERR(tfm);
> +	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
> +		ti->error = "AEAD transforms not supported for EBOIV";
> +		return -EINVAL;
>  	}
>  
> -	if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> +	if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
>  		ti->error = "Block size of EBOIV cipher does "
>  			    "not match IV size of block cipher";
> -		crypto_free_cipher(tfm);
>  		return -EINVAL;
>  	}
>  
> -	eboiv->tfm = tfm;
>  	return 0;
>  }
>  
> -static int crypt_iv_eboiv_init(struct crypt_config *cc)
> +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> +			    struct dm_crypt_request *dmreq)
>  {
> -	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> +	struct skcipher_request *req;
> +	struct scatterlist src, dst;
> +	struct crypto_wait wait;
>  	int err;
>  
> -	err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> -	if (err)
> -		return err;
> -
> -	return 0;
> -}
> -
> -static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> -{
> -	/* Called after cc->key is set to random key in crypt_wipe() */
> -	return crypt_iv_eboiv_init(cc);
> -}
> +	req = skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
> +	if (!req)
> +		return -ENOMEM;
>  
> -static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> -			    struct dm_crypt_request *dmreq)
> -{
> -	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +	memset(buf, 0, cc->iv_size);
> +	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
>  
> -	memset(iv, 0, cc->iv_size);
> -	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> -	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> +	sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
> +	sg_init_one(&dst, iv, cc->iv_size);
> +	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
> +	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
> +	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> +	skcipher_request_free(req);
>  
> -	return 0;
> +	return err;
>  }
>  
>  static const struct crypt_iv_operations crypt_iv_plain_ops = {
> @@ -962,9 +939,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
>  
>  static struct crypt_iv_operations crypt_iv_eboiv_ops = {
>  	.ctr	   = crypt_iv_eboiv_ctr,
> -	.dtr	   = crypt_iv_eboiv_dtr,
> -	.init	   = crypt_iv_eboiv_init,
> -	.wipe	   = crypt_iv_eboiv_wipe,
>  	.generator = crypt_iv_eboiv_gen
>  };
>  
> 
