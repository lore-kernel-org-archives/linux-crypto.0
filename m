From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 01/16] crypto: prevent helper ciphers from being used
Date: Thu, 19 Mar 2015 08:23:58 +0100
Message-ID: <29741349.4tmP3Ys1qT@tauon>
References: <21952258.n2qYaab1Is@tachyon.chronox.de> <109752153.14abfcUJ8X@tachyon.chronox.de> <20150319071630.GA2902@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150319071630.GA2902@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 19. M=E4rz 2015, 18:16:30 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Mar 19, 2015 at 07:57:36AM +0100, Stephan Mueller wrote:
>> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
>> index db201bca..2cd83ad 100644
>> --- a/crypto/ablkcipher.c
>> +++ b/crypto/ablkcipher.c
>> @@ -688,7 +688,7 @@ struct crypto_ablkcipher
>> *crypto_alloc_ablkcipher(const char *alg_name,>=20
>>  			goto err;
>>  	=09
>>  		}
>>=20
>> -		tfm =3D __crypto_alloc_tfm(alg, type, mask);
>> +		tfm =3D __crypto_alloc_tfm_safe(alg, type, mask);
>
>Rather than changing every algorithm type, I'd rather suggest
>that you modify crypto_alg_mod_lookup so that it's kept in one
>spot.  Just copy what we currently do for CRYPTO_ALG_TESTED.

How can you distinguish between calls coming from crypto_*_spawn (which=
=20
we need to allow) and calls that come from the normal API calls (which=20
we should block?

>
>Thanks,


Ciao
Stephan
