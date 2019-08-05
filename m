Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC05C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CEA218B6
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 07:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfHEHvI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 03:51:08 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:47411 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfHEHvI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 03:51:08 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 91AAB1BF208;
        Mon,  5 Aug 2019 07:51:04 +0000 (UTC)
Date:   Mon, 5 Aug 2019 09:51:03 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv3 2/4] crypto: inside-secure - Remove redundant algo to
 engine mapping code
Message-ID: <20190805075103.GE14470@kwain>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-3-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564586959-9963-3-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Jul 31, 2019 at 05:29:17PM +0200, Pascal van Leeuwen wrote:
> This removes some code determine which engine has which algorithms which
> was effectively redundant (may have been forward-looking?) due to always
> enabling all algorithms for all currently supported engines.
> A future patch will use a different, more scalable approach to achieve
> this. This is removed now because otherwise the next patch will add new
> hardware which would otherwise have to be added to all algorithms, so
> now is a convenient time to just get rid of this.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c        |  9 ---------
>  drivers/crypto/inside-secure/safexcel.h        |  1 -
>  drivers/crypto/inside-secure/safexcel_cipher.c | 11 -----------
>  drivers/crypto/inside-secure/safexcel_hash.c   | 12 ------------
>  4 files changed, 33 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index df43a2c..a066152 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -869,9 +869,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
>  	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
>  		safexcel_algs[i]->priv = priv;
> 
> -		if (!(safexcel_algs[i]->engines & priv->version))
> -			continue;
> -
>  		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
>  			ret = crypto_register_skcipher(&safexcel_algs[i]->alg.skcipher);
>  		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
> @@ -887,9 +884,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
> 
>  fail:
>  	for (j = 0; j < i; j++) {
> -		if (!(safexcel_algs[j]->engines & priv->version))
> -			continue;
> -
>  		if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
>  			crypto_unregister_skcipher(&safexcel_algs[j]->alg.skcipher);
>  		else if (safexcel_algs[j]->type == SAFEXCEL_ALG_TYPE_AEAD)
> @@ -906,9 +900,6 @@ static void safexcel_unregister_algorithms(struct safexcel_crypto_priv *priv)
>  	int i;
> 
>  	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
> -		if (!(safexcel_algs[i]->engines & priv->version))
> -			continue;
> -
>  		if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_SKCIPHER)
>  			crypto_unregister_skcipher(&safexcel_algs[i]->alg.skcipher);
>  		else if (safexcel_algs[i]->type == SAFEXCEL_ALG_TYPE_AEAD)
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index e0c202f..e53c232 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -655,7 +655,6 @@ struct safexcel_ahash_export_state {
>  struct safexcel_alg_template {
>  	struct safexcel_crypto_priv *priv;
>  	enum safexcel_alg_type type;
> -	u32 engines;
>  	union {
>  		struct skcipher_alg skcipher;
>  		struct aead_alg aead;
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 8cdbdbe..ee8a0c3 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -881,7 +881,6 @@ static void safexcel_aead_cra_exit(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_ecb_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_skcipher_aes_setkey,
>  		.encrypt = safexcel_ecb_aes_encrypt,
> @@ -920,7 +919,6 @@ static int safexcel_cbc_aes_decrypt(struct skcipher_request *req)
> 
>  struct safexcel_alg_template safexcel_alg_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_skcipher_aes_setkey,
>  		.encrypt = safexcel_cbc_aes_encrypt,
> @@ -990,7 +988,6 @@ static int safexcel_des_setkey(struct crypto_skcipher *ctfm, const u8 *key,
> 
>  struct safexcel_alg_template safexcel_alg_cbc_des = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_des_setkey,
>  		.encrypt = safexcel_cbc_des_encrypt,
> @@ -1030,7 +1027,6 @@ static int safexcel_ecb_des_decrypt(struct skcipher_request *req)
> 
>  struct safexcel_alg_template safexcel_alg_ecb_des = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_des_setkey,
>  		.encrypt = safexcel_ecb_des_encrypt,
> @@ -1093,7 +1089,6 @@ static int safexcel_des3_ede_setkey(struct crypto_skcipher *ctfm,
> 
>  struct safexcel_alg_template safexcel_alg_cbc_des3_ede = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_des3_ede_setkey,
>  		.encrypt = safexcel_cbc_des3_ede_encrypt,
> @@ -1133,7 +1128,6 @@ static int safexcel_ecb_des3_ede_decrypt(struct skcipher_request *req)
> 
>  struct safexcel_alg_template safexcel_alg_ecb_des3_ede = {
>  	.type = SAFEXCEL_ALG_TYPE_SKCIPHER,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.skcipher = {
>  		.setkey = safexcel_des3_ede_setkey,
>  		.encrypt = safexcel_ecb_des3_ede_encrypt,
> @@ -1203,7 +1197,6 @@ static int safexcel_aead_sha1_cra_init(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_AEAD,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.aead = {
>  		.setkey = safexcel_aead_aes_setkey,
>  		.encrypt = safexcel_aead_encrypt,
> @@ -1238,7 +1231,6 @@ static int safexcel_aead_sha256_cra_init(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_AEAD,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.aead = {
>  		.setkey = safexcel_aead_aes_setkey,
>  		.encrypt = safexcel_aead_encrypt,
> @@ -1273,7 +1265,6 @@ static int safexcel_aead_sha224_cra_init(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_AEAD,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.aead = {
>  		.setkey = safexcel_aead_aes_setkey,
>  		.encrypt = safexcel_aead_encrypt,
> @@ -1308,7 +1299,6 @@ static int safexcel_aead_sha512_cra_init(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_AEAD,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.aead = {
>  		.setkey = safexcel_aead_aes_setkey,
>  		.encrypt = safexcel_aead_encrypt,
> @@ -1343,7 +1333,6 @@ static int safexcel_aead_sha384_cra_init(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_cbc_aes = {
>  	.type = SAFEXCEL_ALG_TYPE_AEAD,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.aead = {
>  		.setkey = safexcel_aead_aes_setkey,
>  		.encrypt = safexcel_aead_encrypt,
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index a80a5e7..2c31536 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -802,7 +802,6 @@ static void safexcel_ahash_cra_exit(struct crypto_tfm *tfm)
> 
>  struct safexcel_alg_template safexcel_alg_sha1 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_sha1_init,
>  		.update = safexcel_ahash_update,
> @@ -1035,7 +1034,6 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
> 
>  struct safexcel_alg_template safexcel_alg_hmac_sha1 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_sha1_init,
>  		.update = safexcel_ahash_update,
> @@ -1099,7 +1097,6 @@ static int safexcel_sha256_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_sha256 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_sha256_init,
>  		.update = safexcel_ahash_update,
> @@ -1162,7 +1159,6 @@ static int safexcel_sha224_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_sha224 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_sha224_init,
>  		.update = safexcel_ahash_update,
> @@ -1218,7 +1214,6 @@ static int safexcel_hmac_sha224_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_hmac_sha224 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_sha224_init,
>  		.update = safexcel_ahash_update,
> @@ -1275,7 +1270,6 @@ static int safexcel_hmac_sha256_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_hmac_sha256 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_sha256_init,
>  		.update = safexcel_ahash_update,
> @@ -1347,7 +1341,6 @@ static int safexcel_sha512_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_sha512 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_sha512_init,
>  		.update = safexcel_ahash_update,
> @@ -1418,7 +1411,6 @@ static int safexcel_sha384_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_sha384 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_sha384_init,
>  		.update = safexcel_ahash_update,
> @@ -1474,7 +1466,6 @@ static int safexcel_hmac_sha512_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_hmac_sha512 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_sha512_init,
>  		.update = safexcel_ahash_update,
> @@ -1531,7 +1522,6 @@ static int safexcel_hmac_sha384_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_hmac_sha384 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_sha384_init,
>  		.update = safexcel_ahash_update,
> @@ -1591,7 +1581,6 @@ static int safexcel_md5_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_md5 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_md5_init,
>  		.update = safexcel_ahash_update,
> @@ -1647,7 +1636,6 @@ static int safexcel_hmac_md5_digest(struct ahash_request *areq)
> 
>  struct safexcel_alg_template safexcel_alg_hmac_md5 = {
>  	.type = SAFEXCEL_ALG_TYPE_AHASH,
> -	.engines = EIP97IES | EIP197B | EIP197D,
>  	.alg.ahash = {
>  		.init = safexcel_hmac_md5_init,
>  		.update = safexcel_ahash_update,
> --
> 1.8.3.1

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
