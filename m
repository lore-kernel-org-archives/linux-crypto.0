From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: mark authenticated ctr(aes) also as FIPS able
Date: Thu, 04 Feb 2016 15:36:48 +0100
Message-ID: <3713148.5C80UWCsQh@positron.chronox.de>
References: <1454596226-27843-1-git-send-email-meissner@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60750 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbcBDOgv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Feb 2016 09:36:51 -0500
In-Reply-To: <1454596226-27843-1-git-send-email-meissner@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 4. Februar 2016, 15:30:26 schrieb Marcus Meissner:

Hi Marcus,

> Signed-off-by: Marcus Meissner <meissner@suse.de>

Acked-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/testmgr.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index ae8c57fd..ff6a799 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2143,6 +2143,10 @@ static const struct alg_test_desc alg_test_descs[] =
> { }
>  		}
>  	}, {
> +		.alg = "authenc(hmac(sha1),ctr(aes))"
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
>  		.test = alg_test_aead,
>  		.suite = {
> @@ -2227,6 +2231,10 @@ static const struct alg_test_desc alg_test_descs[] =
> { }
>  		}
>  	}, {
> +		.alg = "authenc(hmac(sha256),ctr(aes))"
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "authenc(hmac(sha384),cbc(des))",
>  		.test = alg_test_aead,
>  		.suite = {
> @@ -2253,6 +2261,10 @@ static const struct alg_test_desc alg_test_descs[] =
> { }
>  		}
>  	}, {
> +		.alg = "authenc(hmac(sha384),ctr(aes))"
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "authenc(hmac(sha512),cbc(aes))",
>  		.test = alg_test_aead,
>  		.suite = {
> @@ -2292,6 +2304,10 @@ static const struct alg_test_desc alg_test_descs[] =
> { }
>  		}
>  	}, {
> +		.alg = "authenc(hmac(sha512),ctr(aes))"
> +		.test = alg_test_null,
> +		.fips_allowed = 1,
> +	}, {
>  		.alg = "cbc(aes)",
>  		.test = alg_test_skcipher,
>  		.fips_allowed = 1,


Ciao
Stephan
