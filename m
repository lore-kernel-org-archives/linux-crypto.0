From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: blowfish from openSSL to kernel cryptoAPI
Date: Thu, 5 May 2011 08:45:32 +1000
Message-ID: <20110504224532.GA14974@gondor.apana.org.au>
References: <ippek3$10l$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tzvi Chumash <tzvi@research.att.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43601 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab1EDWpg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2011 18:45:36 -0400
Content-Disposition: inline
In-Reply-To: <ippek3$10l$1@dough.gmane.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tzvi Chumash <tzvi@research.att.com> wrote:
>
> I'm not using the command line openssl to produce the cipher.. the API 
> says nothing about a salt or a passphrase:
> 
>  int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
>                 ENGINE *impl, unsigned char *key, unsigned char *iv);
> 
> relevant parts of my openSSL code:
> ...
> rc = EVP_EncryptInit_ex(&ctx, EVP_bf_cbc(), NULL, env_key, env_iv);
> ...
> rc = EVP_EncryptUpdate(&ctx, out, &olen, in, ilen);
> ...
> rc = EVP_EncryptFinal_ex(&ctx, out+olen, &olen);
> 
> where
> EVP_CIPHER_CTX ctx;
> unsigned char env_key[56];
> unsigned char env_iv[8];
> unsigned char *in, *out;
> int rc, ilen, olen;

Please show us the user-space and kernel code you used for this
so we can check for ourselves.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
