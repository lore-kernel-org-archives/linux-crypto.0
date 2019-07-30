Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87059C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62DA520657
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 14:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbfG3OfZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:35:25 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33699 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbfG3OfZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 10:35:25 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 1CCF4240002;
        Tue, 30 Jul 2019 14:35:22 +0000 (UTC)
Date:   Tue, 30 Jul 2019 16:35:21 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 1/2] crypto: inside-secure - Use defines instead of some
 constants (cosmetic)
Message-ID: <20190730143521.GI3108@kwain>
References: <1564493232-30733-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564493232-30733-2-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564493232-30733-2-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Tue, Jul 30, 2019 at 03:27:11PM +0200, Pascal van Leeuwen wrote:
> This patch replaces some hard constants regarding key, IV and nonce sizes
> with appropriate defines from the crypto header files.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 35 ++++++++++++++------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index d65e5f7..a30fdd5 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -12,6 +12,7 @@
>  #include <crypto/aead.h>
>  #include <crypto/aes.h>
>  #include <crypto/authenc.h>
> +#include <crypto/ctr.h>
>  #include <crypto/des.h>
>  #include <crypto/sha.h>
>  #include <crypto/skcipher.h>
> @@ -237,19 +238,21 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>  		goto badkey;
>  
>  	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD) {
> -		/* 20 is minimum AES key: 16 bytes + 4 bytes nonce */
> -		if (keys.enckeylen < 20)
> +		/* Minimum keysize is minimum AES key size + nonce size */
> +		if (keys.enckeylen < (AES_MIN_KEY_SIZE +
> +				      CTR_RFC3686_NONCE_SIZE))
>  			goto badkey;
>  		/* last 4 bytes of key are the nonce! */
> -		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen - 4);
> +		ctx->nonce = *(u32 *)(keys.enckey + keys.enckeylen -
> +				      CTR_RFC3686_NONCE_SIZE);
>  		/* exclude the nonce here */
> -		keys.enckeylen -= 4;
> +		keys.enckeylen -= CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD;
>  	}
>  
>  	/* Encryption key */
>  	switch (ctx->alg) {
>  	case SAFEXCEL_3DES:
> -		if (keys.enckeylen != 24)
> +		if (keys.enckeylen != DES3_EDE_KEY_SIZE)
>  			goto badkey;
>  		flags = crypto_aead_get_flags(ctfm);
>  		err = __des3_verify_key(&flags, keys.enckey);
> @@ -1114,9 +1117,9 @@ static int safexcel_skcipher_aesctr_setkey(struct crypto_skcipher *ctfm,
>  	unsigned int keylen;
>  
>  	/* last 4 bytes of key are the nonce! */
> -	ctx->nonce = *(u32 *)(key + len - 4);
> +	ctx->nonce = *(u32 *)(key + len - CTR_RFC3686_NONCE_SIZE);
>  	/* exclude the nonce here */
> -	keylen = len - 4;
> +	keylen = len - CTR_RFC3686_NONCE_SIZE;
>  	ret = crypto_aes_expand_key(&aes, key, keylen);
>  	if (ret) {
>  		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> @@ -1157,10 +1160,10 @@ struct safexcel_alg_template safexcel_alg_ctr_aes = {
>  		.setkey = safexcel_skcipher_aesctr_setkey,
>  		.encrypt = safexcel_encrypt,
>  		.decrypt = safexcel_decrypt,
> -		/* Add 4 to include the 4 byte nonce! */
> -		.min_keysize = AES_MIN_KEY_SIZE + 4,
> -		.max_keysize = AES_MAX_KEY_SIZE + 4,
> -		.ivsize = 8,
> +		/* Add nonce size */
> +		.min_keysize = AES_MIN_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
> +		.max_keysize = AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.base = {
>  			.cra_name = "rfc3686(ctr(aes))",
>  			.cra_driver_name = "safexcel-ctr-aes",
> @@ -1620,7 +1623,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha1_ctr_aes = {
>  		.setkey = safexcel_aead_setkey,
>  		.encrypt = safexcel_aead_encrypt,
>  		.decrypt = safexcel_aead_decrypt,
> -		.ivsize = 8,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.maxauthsize = SHA1_DIGEST_SIZE,
>  		.base = {
>  			.cra_name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
> @@ -1653,7 +1656,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes = {
>  		.setkey = safexcel_aead_setkey,
>  		.encrypt = safexcel_aead_encrypt,
>  		.decrypt = safexcel_aead_decrypt,
> -		.ivsize = 8,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.maxauthsize = SHA256_DIGEST_SIZE,
>  		.base = {
>  			.cra_name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
> @@ -1686,7 +1689,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha224_ctr_aes = {
>  		.setkey = safexcel_aead_setkey,
>  		.encrypt = safexcel_aead_encrypt,
>  		.decrypt = safexcel_aead_decrypt,
> -		.ivsize = 8,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.maxauthsize = SHA224_DIGEST_SIZE,
>  		.base = {
>  			.cra_name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
> @@ -1719,7 +1722,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes = {
>  		.setkey = safexcel_aead_setkey,
>  		.encrypt = safexcel_aead_encrypt,
>  		.decrypt = safexcel_aead_decrypt,
> -		.ivsize = 8,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.maxauthsize = SHA512_DIGEST_SIZE,
>  		.base = {
>  			.cra_name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
> @@ -1752,7 +1755,7 @@ struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes = {
>  		.setkey = safexcel_aead_setkey,
>  		.encrypt = safexcel_aead_encrypt,
>  		.decrypt = safexcel_aead_decrypt,
> -		.ivsize = 8,
> +		.ivsize = CTR_RFC3686_IV_SIZE,
>  		.maxauthsize = SHA384_DIGEST_SIZE,
>  		.base = {
>  			.cra_name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
