Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49490C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 09:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2149A20737
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 09:57:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="H9sfqFZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgGWJ5g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 05:57:36 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34028 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgGWJ5g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 05:57:36 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06N9vSQw125040;
        Thu, 23 Jul 2020 04:57:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1595498248;
        bh=fn2qvmj3CvfIk9kEzUTSBLpw6ahgDPBbLHrhRzlWNY8=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=H9sfqFZMjJZYVdFXFMO4lRdl7I69TcZrz15MoEggN5A+hZzCy4yO2QE1v0cmC7uAv
         SxhfUlW+YU+pyHC4lKgJ7+7HLEkRHlgAza+Fv3zRA8J0BEegM1ByyqnWvhxvywPJOj
         kxNbIiiFcxnLFg6we26M2oHlMPqDJpnkCDuX97Po=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06N9vSqk093293
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jul 2020 04:57:28 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Jul 2020 04:57:28 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Jul 2020 04:57:28 -0500
Received: from [127.0.0.1] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06N9vOnY120905;
        Thu, 23 Jul 2020 04:57:25 -0500
Subject: Re: [PATCH] crypto: sa2ul - Fix build warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <j-keerthy@ti.com>
References: <20200723074350.GA3233@gondor.apana.org.au>
From:   Tero Kristo <t-kristo@ti.com>
Message-ID: <4e5eee05-c956-448f-10ea-06102852e979@ti.com>
Date:   Thu, 23 Jul 2020 12:57:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200723074350.GA3233@gondor.apana.org.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 23/07/2020 10:43, Herbert Xu wrote:
> This patch fixes a bunch of initialiser warnings.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks ok to me, however I never saw any build warnings with the code 
myself. Which compiler/version produces them?

-Tero

> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index ebcdffcdb686..fc3a8268e2c8 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -916,7 +916,7 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   static int sa_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   			     unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
>   	int key_idx = (keylen >> 3) - 2;
>   
> @@ -936,7 +936,7 @@ static int sa_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   static int sa_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   			     unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
>   	int key_idx = (keylen >> 3) - 2;
>   
> @@ -954,7 +954,7 @@ static int sa_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   			      unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   
>   	ad.mci_enc = mci_cbc_3des_enc_array;
>   	ad.mci_dec = mci_cbc_3des_dec_array;
> @@ -968,7 +968,7 @@ static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   static int sa_3des_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
>   			      unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   
>   	ad.mci_enc = mci_ecb_3des_enc_array;
>   	ad.mci_dec = mci_ecb_3des_dec_array;
> @@ -1233,7 +1233,7 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
>   	struct sa_tfm_ctx *ctx =
>   	    crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
>   	struct crypto_alg *alg = req->base.tfm->__crt_alg;
> -	struct sa_req sa_req = { 0 };
> +	struct sa_req sa_req = {};
>   	int ret;
>   
>   	if (!req->cryptlen)
> @@ -1344,7 +1344,7 @@ static int sa_sha_run(struct ahash_request *req)
>   {
>   	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
>   	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
> -	struct sa_req sa_req = { 0 };
> +	struct sa_req sa_req = {};
>   	size_t auth_len;
>   
>   	auth_len = req->nbytes;
> @@ -1566,7 +1566,7 @@ static int sa_sha_export(struct ahash_request *req, void *out)
>   
>   static int sa_sha1_cra_init(struct crypto_tfm *tfm)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
>   
>   	sa_sha_cra_init_alg(tfm, "sha1");
> @@ -1582,7 +1582,7 @@ static int sa_sha1_cra_init(struct crypto_tfm *tfm)
>   
>   static int sa_sha256_cra_init(struct crypto_tfm *tfm)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
>   
>   	sa_sha_cra_init_alg(tfm, "sha256");
> @@ -1598,7 +1598,7 @@ static int sa_sha256_cra_init(struct crypto_tfm *tfm)
>   
>   static int sa_sha512_cra_init(struct crypto_tfm *tfm)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
>   
>   	sa_sha_cra_init_alg(tfm, "sha512");
> @@ -1842,7 +1842,7 @@ static int sa_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
>   static int sa_aead_cbc_sha1_setkey(struct crypto_aead *authenc,
>   				   const u8 *key, unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   
>   	ad.ealg_id = SA_EALG_ID_AES_CBC;
>   	ad.aalg_id = SA_AALG_ID_HMAC_SHA1;
> @@ -1855,7 +1855,7 @@ static int sa_aead_cbc_sha1_setkey(struct crypto_aead *authenc,
>   static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
>   				     const u8 *key, unsigned int keylen)
>   {
> -	struct algo_data ad = { 0 };
> +	struct algo_data ad = {};
>   
>   	ad.ealg_id = SA_EALG_ID_AES_CBC;
>   	ad.aalg_id = SA_AALG_ID_HMAC_SHA2_256;
> @@ -1869,7 +1869,7 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
>   {
>   	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>   	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
> -	struct sa_req sa_req = { 0 };
> +	struct sa_req sa_req = {};
>   	size_t auth_size, enc_size;
>   
>   	enc_size = req->cryptlen;
> 

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
