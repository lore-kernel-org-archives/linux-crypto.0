Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC85C0651F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 13:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DFE321850
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 13:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gN6z8PaW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfGDN34 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 09:29:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56281 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfGDN3z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 09:29:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so5757785wmj.5
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jul 2019 06:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ayCRIhqWSMy1q+h3XFfGHK2FQt5FIGxphjkjd92VHhk=;
        b=gN6z8PaWvpr8YE/cko1K6YBvILZ7rGhriXRhyHHRuXAzd883jK/ww80apHEFrz4KIg
         P49jRyZPl6Xzc8PES+o4sjO0QVJVPKJaMD4Bcxj1MTIqQDH33XuMc2oPEJ5LeKakNEVg
         JYVZ1zw3Yudpjc3PqJg/XwmmlESvgf6GSm+a7GHMEWSYcjcL1qA++o/7thutebYIrhhc
         vBla3RyCP0OvRSO/tSQqs1pHfpdGLuCEW6YpDSvESdx0iGDVvj6zxwn6nltulp1QbZ+7
         LqMd5lVz33UpXeBQcj5GZR2KtSh89lAv8CU/7A2Oxx78JcKc0H1UhTcDkPbLlAMI6SLx
         qoLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayCRIhqWSMy1q+h3XFfGHK2FQt5FIGxphjkjd92VHhk=;
        b=KH71w2qPSePz/G2O6fgr4xe4predNFj+/nc07bxtBQ6+tZsTV98sW/VJhIcfvcaSxQ
         OPp3DS6ufSek7qQPN6KKglaGJaXTDnOCc41dMdDQlI2NYS1IfATjbmYSTgHCMYk0Iqfi
         C8xcKPpsTv2VkEtBWKiqWK2XTO2o/GrpCzGYHswV2L8E6uEtML/4xI4xb9GxL8ZGyqyx
         28t+fpfnR5xwWEpcStdtVQ8Np1bf1dv6C42DI8BXbfFnm2h6XJrebMGdC1IJ1SYHUyWO
         qGAyM5LN9Pjy9F//nPSxnuXREuuGnItAHBUNif+WeiruaMdI62AlKEPAamQCqLFxaBpe
         kwvA==
X-Gm-Message-State: APjAAAUyhzBLHifxrtvSLbVTX4rjMhp7y4oMjXiEkK0VJ3QkjNDoEH1/
        SMmlC64+rm/GXqNafEIZX7FRVXBrWr0=
X-Google-Smtp-Source: APXvYqwW1jYLR8Ba8FxJ5l+p5J+yFVs7stOGcg8QskjeuX19yVbT5frTpAbrw5wnE0HNNleeKaGkFA==
X-Received: by 2002:a1c:5f87:: with SMTP id t129mr13528498wmb.150.1562246992850;
        Thu, 04 Jul 2019 06:29:52 -0700 (PDT)
Received: from [10.43.17.24] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o1sm4738327wrw.54.2019.07.04.06.29.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 06:29:51 -0700 (PDT)
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <20190704131033.9919-1-gmazyland@gmail.com>
 <20190704131033.9919-3-gmazyland@gmail.com>
Cc:     dm-devel@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
Date:   Thu, 4 Jul 2019 15:29:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704131033.9919-3-gmazyland@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,

I have a question about the crypto_cipher API in dm-crypt:

We are apparently trying to deprecate cryto_cipher API (see the ESSIV patchset),
but I am not sure what API now should be used instead.

See the patch below - all we need is to one block encryption for IV.

This algorithm makes sense only for FDE (old compatible Bitlocker devices),
I really do not want this to be shared in some crypto module...

What API should I use here? Sync skcipher? Is the crypto_cipher API
really a problem in this case?

Thanks,
Milan


On 04/07/2019 15:10, Milan Broz wrote:
> This IV is used in some BitLocker devices with CBC encryption mode.
> 
> NOTE: maybe we need to use another crypto API if the bare cipher
>       API is going to be deprecated.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  drivers/md/dm-crypt.c | 82 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 81 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 96ead4492787..a5ffa1ac6a28 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -120,6 +120,10 @@ struct iv_tcw_private {
>  	u8 *whitening;
>  };
>  
> +struct iv_eboiv_private {
> +	struct crypto_cipher *tfm;
> +};
> +
>  /*
>   * Crypt: maps a linear range of a block device
>   * and encrypts / decrypts at the same time.
> @@ -159,6 +163,7 @@ struct crypt_config {
>  		struct iv_benbi_private benbi;
>  		struct iv_lmk_private lmk;
>  		struct iv_tcw_private tcw;
> +		struct iv_eboiv_private eboiv;
>  	} iv_gen_private;
>  	u64 iv_offset;
>  	unsigned int iv_size;
> @@ -290,6 +295,10 @@ static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
>   *       is calculated from initial key, sector number and mixed using CRC32.
>   *       Note that this encryption scheme is vulnerable to watermarking attacks
>   *       and should be used for old compatible containers access only.
> + *
> + * eboiv: Encrypted byte-offset IV (used in Bitlocker in CBC mode)
> + *        The IV is encrypted little-endian byte-offset (with the same key
> + *        and cipher as the volume).
>   */
>  
>  static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
> @@ -838,6 +847,67 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
>  	return 0;
>  }
>  
> +static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> +{
> +	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +
> +	crypto_free_cipher(eboiv->tfm);
> +	eboiv->tfm = NULL;
> +}
> +
> +static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
> +			    const char *opts)
> +{
> +	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +	struct crypto_cipher *tfm;
> +
> +	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		ti->error = "Error allocating crypto tfm for EBOIV";
> +		return PTR_ERR(tfm);
> +	}
> +
> +	if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> +		ti->error = "Block size of EBOIV cipher does "
> +			    "not match IV size of block cipher";
> +		crypto_free_cipher(tfm);
> +		return -EINVAL;
> +	}
> +
> +	eboiv->tfm = tfm;
> +	return 0;
> +}
> +
> +static int crypt_iv_eboiv_init(struct crypt_config *cc)
> +{
> +	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +	int err;
> +
> +	err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> +{
> +	/* Called after cc->key is set to random key in crypt_wipe() */
> +	return crypt_iv_eboiv_init(cc);
> +}
> +
> +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> +			    struct dm_crypt_request *dmreq)
> +{
> +	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> +
> +	memset(iv, 0, cc->iv_size);
> +	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> +	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> +
> +	return 0;
> +}
> +
>  static const struct crypt_iv_operations crypt_iv_plain_ops = {
>  	.generator = crypt_iv_plain_gen
>  };
> @@ -890,6 +960,14 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
>  	.generator = crypt_iv_random_gen
>  };
>  
> +static struct crypt_iv_operations crypt_iv_eboiv_ops = {
> +	.ctr	   = crypt_iv_eboiv_ctr,
> +	.dtr	   = crypt_iv_eboiv_dtr,
> +	.init	   = crypt_iv_eboiv_init,
> +	.wipe	   = crypt_iv_eboiv_wipe,
> +	.generator = crypt_iv_eboiv_gen
> +};
> +
>  /*
>   * Integrity extensions
>   */
> @@ -2293,6 +2371,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>  		cc->iv_gen_ops = &crypt_iv_benbi_ops;
>  	else if (strcmp(ivmode, "null") == 0)
>  		cc->iv_gen_ops = &crypt_iv_null_ops;
> +	else if (strcmp(ivmode, "eboiv") == 0)
> +		cc->iv_gen_ops = &crypt_iv_eboiv_ops;
>  	else if (strcmp(ivmode, "lmk") == 0) {
>  		cc->iv_gen_ops = &crypt_iv_lmk_ops;
>  		/*
> @@ -3093,7 +3173,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  
>  static struct target_type crypt_target = {
>  	.name   = "crypt",
> -	.version = {1, 18, 1},
> +	.version = {1, 19, 0},
>  	.module = THIS_MODULE,
>  	.ctr    = crypt_ctr,
>  	.dtr    = crypt_dtr,
> 
