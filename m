Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1C2C2D0C8
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACE7206DA
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 04:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577767346;
	bh=0kFssM/ZfIwZnzvsrOJWtD8N0HL2pG7E3Kf42gGFM3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UoKtZfNLlpQ9E9r9sT/7tKPLb2zL3dCpuGqy7YSqkf0Nq9GRy4c0aYnimmeVXpD4p
	 SUYcIp+9ORcJuE2CzwZobUuBm7xLDz4GOoCgjQwrfGmk3cYDV9MRd9IkQsnoFx96Rq
	 MXPodPwnO3CKpD+VWZWvW1IshakmedblUafdzx6Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLaEm0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 23:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfLaEmZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 23:42:25 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9391206D9;
        Tue, 31 Dec 2019 04:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577767345;
        bh=0kFssM/ZfIwZnzvsrOJWtD8N0HL2pG7E3Kf42gGFM3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LkLU7XbPafGh34Hn03cgF17MxFGZQu4di1QxI35xWqMU0cNnqif9pbc3DQGWtDBqj
         q0uVOWEIRDRrnOQjDJEL4Md4so2+woYendPOU/5GRT4d6EQqfwnnpxE7zuyzIFJCot
         KN75KfrSlD/wJQf/uNcv1gMAmReHlWUUx1EnEAyY=
Date:   Mon, 30 Dec 2019 22:42:22 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Atul Gupta <atul.gupta@chelsio.com>
Subject: Re: [PATCH 1/8] crypto: chelsio - fix writing tfm flags to wrong
 place
Message-ID: <20191231044222.GA180988@zzz.localdomain>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231031938.241705-2-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[+Cc the person with a Cc tag in the patch, who I accidentally didn't Cc...
 Original message was
 https://lkml.kernel.org/linux-crypto/20191231031938.241705-2-ebiggers@kernel.org/]

On Mon, Dec 30, 2019 at 09:19:31PM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The chelsio crypto driver is casting 'struct crypto_aead' directly to
> 'struct crypto_tfm', which is incorrect because the crypto_tfm isn't the
> first field of 'struct crypto_aead'.  Consequently, the calls to
> crypto_tfm_set_flags() are modifying some other field in the struct.
> 
> Also, the driver is setting CRYPTO_TFM_RES_BAD_KEY_LEN in
> ->setauthsize(), not just in ->setkey().  This is incorrect since this
> flag is for bad key lengths, not for bad authentication tag lengths.
> 
> Fix these bugs by removing the broken crypto_tfm_set_flags() calls from
> ->setauthsize() and by fixing them in ->setkey().
> 
> Fixes: 324429d74127 ("chcr: Support for Chelsio's Crypto Hardware")
> Cc: <stable@vger.kernel.org> # v4.9+
> Cc: Atul Gupta <atul.gupta@chelsio.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index 586dbc69d0cd..5b7dbe7cdb17 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -3196,9 +3196,6 @@ static int chcr_gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
>  		aeadctx->mayverify = VERIFY_SW;
>  		break;
>  	default:
> -
> -		  crypto_tfm_set_flags((struct crypto_tfm *) tfm,
> -			CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		return -EINVAL;
>  	}
>  	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
> @@ -3223,8 +3220,6 @@ static int chcr_4106_4309_setauthsize(struct crypto_aead *tfm,
>  		aeadctx->mayverify = VERIFY_HW;
>  		break;
>  	default:
> -		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
> -				     CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		return -EINVAL;
>  	}
>  	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
> @@ -3265,8 +3260,6 @@ static int chcr_ccm_setauthsize(struct crypto_aead *tfm,
>  		aeadctx->mayverify = VERIFY_HW;
>  		break;
>  	default:
> -		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
> -				     CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		return -EINVAL;
>  	}
>  	return crypto_aead_setauthsize(aeadctx->sw_cipher, authsize);
> @@ -3291,8 +3284,7 @@ static int chcr_ccm_common_setkey(struct crypto_aead *aead,
>  		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
>  		mk_size = CHCR_KEYCTX_MAC_KEY_SIZE_256;
>  	} else {
> -		crypto_tfm_set_flags((struct crypto_tfm *)aead,
> -				     CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		aeadctx->enckey_len = 0;
>  		return	-EINVAL;
>  	}
> @@ -3330,8 +3322,7 @@ static int chcr_aead_rfc4309_setkey(struct crypto_aead *aead, const u8 *key,
>  	int error;
>  
>  	if (keylen < 3) {
> -		crypto_tfm_set_flags((struct crypto_tfm *)aead,
> -				     CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		aeadctx->enckey_len = 0;
>  		return	-EINVAL;
>  	}
> @@ -3381,8 +3372,7 @@ static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
>  	} else if (keylen == AES_KEYSIZE_256) {
>  		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
>  	} else {
> -		crypto_tfm_set_flags((struct crypto_tfm *)aead,
> -				     CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		pr_err("GCM: Invalid key length %d\n", keylen);
>  		ret = -EINVAL;
>  		goto out;
> -- 
> 2.24.1
> 
