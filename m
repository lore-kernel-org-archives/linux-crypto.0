From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH 14/14] x86/crypto: aesni: Update aesni-intel_glue to use
 scatter/gather
Date: Mon, 12 Feb 2018 15:12:16 -0800
Message-ID: <dc69bdfa-6dc2-da54-9d9a-b171aeb3212b@google.com>
References: <cover.1518211765.git.davejwatson@fb.com>
 <20180212195128.GA61087@davejwatson-mba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Ilya Lesokhin <ilyal@mellanox.com>
To: Dave Watson <davejwatson@fb.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:47069 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932368AbeBLXMU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 18:12:20 -0500
Received: by mail-pg0-f49.google.com with SMTP id a11so8525499pgu.13
        for <linux-crypto@vger.kernel.org>; Mon, 12 Feb 2018 15:12:20 -0800 (PST)
In-Reply-To: <20180212195128.GA61087@davejwatson-mba.local>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dave,


On 02/12/2018 11:51 AM, Dave Watson wrote:

> +static int gcmaes_encrypt_sg(struct aead_request *req, unsigned int assoclen,
> +			u8 *hash_subkey, u8 *iv, void *aes_ctx)
>  
> +static int gcmaes_decrypt_sg(struct aead_request *req, unsigned int assoclen,
> +			u8 *hash_subkey, u8 *iv, void *aes_ctx)

These two functions are almost identical. Wouldn't it be better to combine them into a single encrypt/decrypt function, similar to what you have done for the assembly macros?

> +	if (((struct crypto_aes_ctx *)aes_ctx)->key_length != AES_KEYSIZE_128 ||
> +		aesni_gcm_enc_tfm == aesni_gcm_enc) {

Shouldn't we also include a check for the buffer length being less than AVX_GEN2_OPTSIZE? AVX will not be used in that case either.


Thanks,
Junaid
