From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: cavium: Remove the individual
 encrypt/decrypt function for each algorithm
Date: Mon, 24 Apr 2017 18:05:14 +0800
Message-ID: <20170424100514.GA20943@gondor.apana.org.au>
References: <1492773366-17899-1-git-send-email-george.cherian@cavium.com>
 <1492773366-17899-3-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:47324 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1168750AbdDXKkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 06:40:25 -0400
Content-Disposition: inline
In-Reply-To: <1492773366-17899-3-git-send-email-george.cherian@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 11:16:05AM +0000, George Cherian wrote:
>
> -int cvm_aes_encrypt_cbc(struct ablkcipher_request *req)
> +static inline u32 cvm_cipher_type(const char *name)
>  {
> -	return cvm_enc_dec(req, true, AES_CBC);
> -}
>  
> -int cvm_aes_decrypt_cbc(struct ablkcipher_request *req)
> -{
> -	return cvm_enc_dec(req, false, AES_CBC);
> +	const struct cvm_cipher *cipher = cvm_cipher_table;
> +
> +	while (cipher->name) {
> +		if (!strcmp(cipher->name, name))
> +			break;
> +		cipher++;
> +	}
> +
> +	return cipher->value;
>  }

That's rather unwieldy.  It's usually easier to embed the cipher
type into the algo structure and then get to it via the alg object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
