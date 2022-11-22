Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC1CC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 12:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKVMmN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 07:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiKVMmM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 07:42:12 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1CF60365
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 04:42:09 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NGkMc2cN1zJnQc
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 20:38:52 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 20:42:07 +0800
Received: from [10.67.103.158] (10.67.103.158) by
 kwepemm600005.china.huawei.com (7.193.23.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 20:42:06 +0800
Subject: Re: [PATCH] crypto: hisilicon/hpre - Use helper to set reqsize
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <Y3yWRkisp1VmuBLZ@gondor.apana.org.au>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <7b002294-07a3-7697-0839-3092b4a41ab4@huawei.com>
Date:   Tue, 22 Nov 2022 20:42:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <Y3yWRkisp1VmuBLZ@gondor.apana.org.au>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.158]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2022/11/22 17:28, Herbert Xu wrote:
> The value of reqsize must only be changed through the helper.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> index ef02dadd6217..5f6d363c9435 100644
> --- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> +++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
> @@ -740,6 +740,8 @@ static int hpre_dh_init_tfm(struct crypto_kpp *tfm)
>  {
>  	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
>  
> +	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
> +
>  	return hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
>  }
>  
> @@ -1165,6 +1167,9 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
>  		return PTR_ERR(ctx->rsa.soft_tfm);
>  	}
>  
> +	akcipher_set_reqsize(tfm, sizeof(struct hpre_asym_request) +
> +				  HPRE_ALIGN_SZ);
> +
>  	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
>  	if (ret)
>  		crypto_free_akcipher(ctx->rsa.soft_tfm);
> @@ -1617,6 +1622,8 @@ static int hpre_ecdh_nist_p192_init_tfm(struct crypto_kpp *tfm)
>  
>  	ctx->curve_id = ECC_CURVE_NIST_P192;
>  
> +	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
> +
>  	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
>  }
>  
> @@ -1626,6 +1633,8 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
>  
>  	ctx->curve_id = ECC_CURVE_NIST_P256;
>  
> +	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
> +
>  	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
>  }
>  
> @@ -1635,6 +1644,8 @@ static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
>  
>  	ctx->curve_id = ECC_CURVE_NIST_P384;
>  
> +	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
> +
>  	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
>  }
>  
> @@ -1961,6 +1972,8 @@ static int hpre_curve25519_init_tfm(struct crypto_kpp *tfm)
>  {
>  	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
>  
> +	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ);
> +
>  	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
>  }
>  
> @@ -1981,7 +1994,6 @@ static struct akcipher_alg rsa = {
>  	.max_size = hpre_rsa_max_size,
>  	.init = hpre_rsa_init_tfm,
>  	.exit = hpre_rsa_exit_tfm,
> -	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  	.base = {
>  		.cra_ctxsize = sizeof(struct hpre_ctx),
>  		.cra_priority = HPRE_CRYPTO_ALG_PRI,
> @@ -1998,7 +2010,6 @@ static struct kpp_alg dh = {
>  	.max_size = hpre_dh_max_size,
>  	.init = hpre_dh_init_tfm,
>  	.exit = hpre_dh_exit_tfm,
> -	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  	.base = {
>  		.cra_ctxsize = sizeof(struct hpre_ctx),
>  		.cra_priority = HPRE_CRYPTO_ALG_PRI,
> @@ -2016,7 +2027,6 @@ static struct kpp_alg ecdh_curves[] = {
>  		.max_size = hpre_ecdh_max_size,
>  		.init = hpre_ecdh_nist_p192_init_tfm,
>  		.exit = hpre_ecdh_exit_tfm,
> -		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  		.base = {
>  			.cra_ctxsize = sizeof(struct hpre_ctx),
>  			.cra_priority = HPRE_CRYPTO_ALG_PRI,
> @@ -2031,7 +2041,6 @@ static struct kpp_alg ecdh_curves[] = {
>  		.max_size = hpre_ecdh_max_size,
>  		.init = hpre_ecdh_nist_p256_init_tfm,
>  		.exit = hpre_ecdh_exit_tfm,
> -		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  		.base = {
>  			.cra_ctxsize = sizeof(struct hpre_ctx),
>  			.cra_priority = HPRE_CRYPTO_ALG_PRI,
> @@ -2046,7 +2055,6 @@ static struct kpp_alg ecdh_curves[] = {
>  		.max_size = hpre_ecdh_max_size,
>  		.init = hpre_ecdh_nist_p384_init_tfm,
>  		.exit = hpre_ecdh_exit_tfm,
> -		.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  		.base = {
>  			.cra_ctxsize = sizeof(struct hpre_ctx),
>  			.cra_priority = HPRE_CRYPTO_ALG_PRI,
> @@ -2064,7 +2072,6 @@ static struct kpp_alg curve25519_alg = {
>  	.max_size = hpre_curve25519_max_size,
>  	.init = hpre_curve25519_init_tfm,
>  	.exit = hpre_curve25519_exit_tfm,
> -	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
>  	.base = {
>  		.cra_ctxsize = sizeof(struct hpre_ctx),
>  		.cra_priority = HPRE_CRYPTO_ALG_PRI,
> 

Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Thanks,
Longfang.
