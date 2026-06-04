Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E353D6CB5
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780576735; cv=none; b=eFsuN8Uj2xbKtWl+2fDUIVhmTKxjQcaBUD0eES5AD9mQUA50linWiWTLjBZzYXbQ5O83OWNCxNEOjz/+uNP5LEyKVkmml/7t0LRRUmu8jdrVoK/UsRsRN89hHr2WH6TBG3mooBVYI3fHqxEjI87Bue7IamYqfibRdyrcEeKJ3FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780576735; c=relaxed/simple;
	bh=UN1vmou7bmZqrI1bstUgAi497tFRgU8A+axe/6EYL2k=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Wm6SpsYBHxXzZXtCvkiwJ6fCIaMlU4VIqKIrd/LbPzyd5wmJ1UYh4ghrIBZaVn12cgh8OZ/5Y0D458+/8yMthJIcF2cH/ukPTzvAJ1FbFJqo4QiDdzamGzn2PgNc76jAY6QSXjGrer6b3zRfrU2/6QIo2WUj9KRDq8yyAmuzchM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=lBDZmsFT; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="lBDZmsFT"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id D00E9C63453
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 12:38:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8B64A5FEF7;
	Thu,  4 Jun 2026 12:38:49 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id A1165106A1A27;
	Thu,  4 Jun 2026 14:38:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780576729; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=n/u1YCJ3AnScp6Vzj5zv++EvIzFAzsmTtVmck3i0Q8g=;
	b=lBDZmsFT7WkKqbex1iOTn6xviqOtDTSna5Iew7p8damEcL3OB5tgdQNW0e9yg79bBSbj+d
	O3uJnAMq1zvAikV0VhyLa0+dt7a4taGcNwHnwClHob96HQeiim/RlIMw6xuI9T7RukiKU2
	Okj+CO0eR4v4NPD02JiHCI4R3B5B4fiGLXdX6fJhhOg89Nu42uNxofE3JLWt7JLsqsVM1N
	ljTJlK5BmToPB+2N3UOcIRkLvzIxU/LBtsLxTp2Avvq2F+VhOuB5fXIwilbr5Y1Udz6k2c
	zBb+mQcYwbNYwHY8Aujb7D+rJlHHa3GBcSk6+yEWOuoKrzk9zKqcl+ePKbD3tA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jun 2026 14:38:46 +0200
Message-Id: <DJ09RRXV4QB4.HJW3BD4EPKJ4@bootlin.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/29] crypto: talitos - Remove alg settings in
 talitos_register_common()
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-10-cb1ad6cdea49@bootlin.com>
 <d98bd2ad-fba2-49f4-97e0-1dfb559ea419@kernel.org>
In-Reply-To: <d98bd2ad-fba2-49f4-97e0-1dfb559ea419@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3


On Mon Jun 1, 2026 at 1:53 PM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Algorithm properties should be set at definition time.
>
> Can you provide more details on why it _should_ be set at definition time=
 ?

"Should" is definetly not the right wording here. In my opinion, it would b=
e
better if they were set a definition time.
The properties set in talitos_alg_set_common() have no reason to be set at
runtime, unlike the properties set in the algorithm registration functions =
that
depends on runtime checks (if the hardware supports a feature or not).

>
> Also, couldn't this change be done after the "Use macro for algorithm=20
> definitions" patches in order to minimise churn ?
>

Yes.

>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>> ---
>>   drivers/crypto/talitos/talitos-aead.c     | 131 ++++++++++++++++++++++=
+-------
>>   drivers/crypto/talitos/talitos-hash.c     |  72 +++++++++++++---
>>   drivers/crypto/talitos/talitos-skcipher.c |  51 ++++++++++--
>>   drivers/crypto/talitos/talitos.c          |  23 ------
>>   4 files changed, 206 insertions(+), 71 deletions(-)
>>=20
>> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/tali=
tos/talitos-aead.c
>> index ce6bd6133fd0..c09ed08be2ef 100644
>> --- a/drivers/crypto/talitos/talitos-aead.c
>> +++ b/drivers/crypto/talitos/talitos-aead.c
>> @@ -409,7 +409,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> @@ -423,7 +427,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha1),cbc(aes))",
>> @@ -431,7 +434,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos-hsna",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> @@ -453,7 +460,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> @@ -469,7 +480,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha1),"
>> @@ -478,7 +488,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos-hsna",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> @@ -501,7 +515,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> @@ -515,7 +533,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>>   	},
>>   	{       .type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha224),cbc(aes))",
>> @@ -523,7 +540,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos-hsna",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> @@ -545,7 +566,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> @@ -561,7 +586,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha224),"
>> @@ -570,7 +594,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos-hsna",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> @@ -593,7 +621,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> @@ -607,7 +639,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha256),cbc(aes))",
>> @@ -615,7 +646,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos-hsna",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> @@ -637,7 +672,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> @@ -653,7 +692,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(sha256),"
>> @@ -662,7 +700,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos-hsna",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> @@ -685,7 +727,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA384_DIGEST_SIZE,
>> @@ -707,7 +753,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA384_DIGEST_SIZE,
>> @@ -730,7 +780,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA512_DIGEST_SIZE,
>> @@ -752,7 +806,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D SHA512_DIGEST_SIZE,
>> @@ -775,7 +833,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D MD5_DIGEST_SIZE,
>> @@ -789,7 +851,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(md5),cbc(aes))",
>> @@ -797,7 +858,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-aes-talitos-hsna",
>>   				.cra_blocksize =3D AES_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D AES_BLOCK_SIZE,
>>   			.maxauthsize =3D MD5_DIGEST_SIZE,
>> @@ -818,7 +883,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D MD5_DIGEST_SIZE,
>> @@ -834,7 +903,6 @@ static struct talitos_alg_template aead_driver_algs[=
] =3D {
>>   				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>>   	},
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>>   		.alg.aead =3D {
>>   			.base =3D {
>>   				.cra_name =3D "authenc(hmac(md5),cbc(des3_ede))",
>> @@ -842,7 +910,11 @@ static struct talitos_alg_template aead_driver_algs=
[] =3D {
>>   						   "cbc-3des-talitos-hsna",
>>   				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			},
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>>   			.maxauthsize =3D MD5_DIGEST_SIZE,
>> @@ -875,6 +947,9 @@ int talitos_register_aead(struct device *dev)
>>   		aead_alg =3D &aead_driver_algs[i].alg.aead;
>>   		alg =3D &aead_alg->base;
>>  =20
>> +		if (has_ftr_sec1(priv))
>> +			alg->cra_alignmask =3D 3;
>> +
>>   		alg->cra_exit =3D talitos_cra_exit;
>>   		aead_alg->init =3D talitos_cra_init_aead;
>>   		aead_alg->setkey =3D aead_alg->setkey ?: aead_setkey;
>> diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/tali=
tos/talitos-hash.c
>> index 5792e7093392..3793b6fd5b75 100644
>> --- a/drivers/crypto/talitos/talitos-hash.c
>> +++ b/drivers/crypto/talitos/talitos-hash.c
>> @@ -559,8 +559,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -578,8 +582,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -597,8 +605,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -616,8 +628,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -635,8 +651,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -654,8 +674,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -673,8 +697,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -692,8 +720,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -711,8 +743,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -730,8 +766,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -749,8 +789,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> @@ -768,8 +812,12 @@ static struct talitos_alg_template hash_driver_algs=
[] =3D {
>>   				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>   				.cra_flags =3D CRYPTO_ALG_ASYNC |
>>   					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +			     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>>   					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>> +				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +				.cra_module =3D THIS_MODULE,
>>   			}
>>   		},
>>   		.desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
>> diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/=
talitos/talitos-skcipher.c
>> index 4f742930ec47..ff7b8f9344c4 100644
>> --- a/drivers/crypto/talitos/talitos-skcipher.c
>> +++ b/drivers/crypto/talitos/talitos-skcipher.c
>> @@ -239,7 +239,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "ecb-aes-talitos",
>>   			.base.cra_blocksize =3D AES_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D AES_MIN_KEY_SIZE,
>>   			.max_keysize =3D AES_MAX_KEY_SIZE,
>>   			.setkey =3D skcipher_aes_setkey,
>> @@ -253,7 +257,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "cbc-aes-talitos",
>>   			.base.cra_blocksize =3D AES_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D AES_MIN_KEY_SIZE,
>>   			.max_keysize =3D AES_MAX_KEY_SIZE,
>>   			.ivsize =3D AES_BLOCK_SIZE,
>> @@ -269,7 +277,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "ctr-aes-talitos",
>>   			.base.cra_blocksize =3D 1,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D AES_MIN_KEY_SIZE,
>>   			.max_keysize =3D AES_MAX_KEY_SIZE,
>>   			.ivsize =3D AES_BLOCK_SIZE,
>> @@ -285,7 +297,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "ctr-aes-talitos",
>>   			.base.cra_blocksize =3D 1,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D AES_MIN_KEY_SIZE,
>>   			.max_keysize =3D AES_MAX_KEY_SIZE,
>>   			.ivsize =3D AES_BLOCK_SIZE,
>> @@ -301,7 +317,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "ecb-des-talitos",
>>   			.base.cra_blocksize =3D DES_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D DES_KEY_SIZE,
>>   			.max_keysize =3D DES_KEY_SIZE,
>>   			.setkey =3D skcipher_des_setkey,
>> @@ -315,7 +335,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "cbc-des-talitos",
>>   			.base.cra_blocksize =3D DES_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D DES_KEY_SIZE,
>>   			.max_keysize =3D DES_KEY_SIZE,
>>   			.ivsize =3D DES_BLOCK_SIZE,
>> @@ -331,7 +355,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "ecb-3des-talitos",
>>   			.base.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D DES3_EDE_KEY_SIZE,
>>   			.max_keysize =3D DES3_EDE_KEY_SIZE,
>>   			.setkey =3D skcipher_des3_setkey,
>> @@ -346,7 +374,11 @@ static struct talitos_alg_template skcipher_driver_=
algs[] =3D {
>>   			.base.cra_driver_name =3D "cbc-3des-talitos",
>>   			.base.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>>   			.base.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					  CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					  CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY,
>> +			.base.cra_priority =3D TALITOS_CRA_PRIORITY,
>> +			.base.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> +			.base.cra_module =3D THIS_MODULE,
>>   			.min_keysize =3D DES3_EDE_KEY_SIZE,
>>   			.max_keysize =3D DES3_EDE_KEY_SIZE,
>>   			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> @@ -375,6 +407,9 @@ int talitos_register_skcipher(struct device *dev)
>>   		skcipher_alg =3D &skcipher_driver_algs[i].alg.skcipher;
>>   		alg =3D &skcipher_alg->base;
>>  =20
>> +		if (has_ftr_sec1(priv))
>> +			alg->cra_alignmask =3D 3;
>> +
>>   		alg->cra_exit =3D talitos_cra_exit;
>>   		skcipher_alg->init =3D talitos_cra_init_skcipher;
>>   		skcipher_alg->setkey =3D skcipher_alg->setkey ?: skcipher_setkey;
>> diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/t=
alitos.c
>> index 41d7d0e570e3..f38a156a0459 100644
>> --- a/drivers/crypto/talitos/talitos.c
>> +++ b/drivers/crypto/talitos/talitos.c
>> @@ -1133,23 +1133,6 @@ static void talitos_remove(struct platform_device=
 *ofdev)
>>   		tasklet_kill(&priv->done_task[1]);
>>   }
>>  =20
>> -static void talitos_alg_set_common(struct talitos_private *priv,
>> -				   struct crypto_alg *alg, u32 custom_priority,
>> -				   u32 type)
>> -{
>> -	alg->cra_module =3D THIS_MODULE;
>> -	if (custom_priority)
>> -		alg->cra_priority =3D custom_priority;
>> -	else
>> -		alg->cra_priority =3D TALITOS_CRA_PRIORITY;
>> -	if (has_ftr_sec1(priv) && type !=3D CRYPTO_ALG_TYPE_AHASH)
>> -		alg->cra_alignmask =3D 3;
>> -	else
>> -		alg->cra_alignmask =3D 0;
>> -	alg->cra_ctxsize =3D sizeof(struct talitos_ctx);
>> -	alg->cra_flags |=3D CRYPTO_ALG_KERN_DRIVER_ONLY;
>> -}
>> -
>>   int talitos_register_common(struct device *dev,
>>   			    struct talitos_alg_template *template)
>>   {
>> @@ -1168,20 +1151,14 @@ int talitos_register_common(struct device *dev,
>>   	switch (t_alg->algt.type) {
>>   	case CRYPTO_ALG_TYPE_AHASH:
>>   		alg =3D &t_alg->algt.alg.hash.halg.base;
>> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
>> -				       t_alg->algt.type);
>>   		ret =3D crypto_register_ahash(&t_alg->algt.alg.hash);
>>   		break;
>>   	case CRYPTO_ALG_TYPE_SKCIPHER:
>>   		alg =3D &t_alg->algt.alg.skcipher.base;
>> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
>> -				       t_alg->algt.type);
>>   		ret =3D crypto_register_skcipher(&t_alg->algt.alg.skcipher);
>>   		break;
>>   	case CRYPTO_ALG_TYPE_AEAD:
>>   		alg =3D &t_alg->algt.alg.aead.base;
>> -		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
>> -				       t_alg->algt.type);
>>   		ret =3D crypto_register_aead(&t_alg->algt.alg.aead);
>>   		break;
>>   	default:
>>=20

Thanks,

Paul.




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

