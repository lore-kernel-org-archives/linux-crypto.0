Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD633B6BF7
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781102515; cv=none; b=iEl2knaFpbpZwwoycDqUTGsSYZ71CcUECmiEWcJ903PPCNU1McEaTTNfSbBx+efW+COxEhcMsdpc5mD1FGA13EZ8UEaVazqcLgpIL/en7X2jrZ9ICsx6PuWacIJ5cap2oR59emkKcXFbtc1qvTn3yc0QuNaM2IBnpKA5cwAGwMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781102515; c=relaxed/simple;
	bh=91L90gIIBwKdZLRSZ7x+GxoAhQjnD0R9Dts9ZGspdHI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=JSlYQ7pDCfty6LtGVcYIyAUaM51/AlEW9LTlu8Q0iU12Dif/51qFg8clIT6+Oe7PwKGCYurK5rlI4YGzH4BN8tHdqAZGhQ5W5nGd4lhESZzporEbJ2teSbR4bt18GfJBRphBuAtJJk49ZlfZ1dFcw4NOqp8n3Fc2bFvjlunXY7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=FO7Ftye0; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="FO7Ftye0"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 523D4C4FEDD
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 14:41:52 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 250735FFC9;
	Wed, 10 Jun 2026 14:41:50 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id EABEA106B9A08;
	Wed, 10 Jun 2026 16:41:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1781102509; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=t84bip9l2GsdKepa+luKQci4jsxMjYTwKim81DVy/pw=;
	b=FO7Ftye0b8J1HhvUsi6tCCzUSRJDQtkug8MXsmGIsMICX6hT6GXZ0pT4o+Wht0tJoaw4Mh
	Ko0//+s/WGOhHkH7Oy3MDgeNqP22uWpMxyZL07mvOSLIB2Uv8UOBtVvfkWQXD8N8u89hak
	ks4kK3ZUNEWkWQNWkrKSic2OeWxPD9iMSWWDSjZKCDN413MMkyS5UOxw8rawwOJE7wVkyA
	ge92yb8jryTRGQZW/piKX8cqXkIbW2C/JIbsm6B6f1BYVTm2v8cr6VoYmUIiXlwoUx3hvr
	/eC4k8zb9VPoxAC9sFPmcz32NBEdr+0czunAdgwJLfH542gJOkuyfty36cNiXw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Jun 2026 16:41:44 +0200
Message-Id: <DJ5G56ORGABQ.1GWJJ7M7UR0V@bootlin.com>
Subject: Re: [PATCH 17/29] crypto: talitos/aead - Use macro for algorithm
 definitions
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-17-cb1ad6cdea49@bootlin.com>
 <30919934-0baf-47c3-a601-3ff0c8cc7f43@kernel.org>
In-Reply-To: <30919934-0baf-47c3-a601-3ff0c8cc7f43@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

Hi Christophe,

On Mon Jun 1, 2026 at 2:12 PM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Replace the repetitive struct initializer entries in aead_driver_algs[]
>> with preprocessor macros (TALITOS_AEAD_ALG, TALITOS_AEAD_ALG_HSNA).
>>=20
>> Move the function pointer assignments (init, exit, encrypt, decrypt)
>> from the registration loop into the static initializer, since they are
>> identical for all algorithms.
>>=20
>> The fallback setkey assignment (aead_alg->setkey ?: aead_setkey) is
>> replaced by specifying the correct setkey handler directly in each macro
>> invocation.
>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>
> Wondering if we could go even more far with the COMMON flags, as for=20
> instance all TALITOS_AEAD_ALG_HSNA have DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU=
=20
> while TALITOS_AEAD_ALG have DESC_HDR_TYPE_IPSEC_ESP
>

I tried going as far as possible, but it make a mess of macros. Even if the=
re is
repetition here (there is outside your example) for the template, I think t=
his
is better if this is kept as is.

>> ---
>>   drivers/crypto/talitos/talitos-aead.c | 751 ++++++++++----------------=
--------
>>   1 file changed, 218 insertions(+), 533 deletions(-)
>>=20
>> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/tali=
tos/talitos-aead.c
>> index 38df616c9b22..cd1b8e6d371b 100644
>> --- a/drivers/crypto/talitos/talitos-aead.c
>> +++ b/drivers/crypto/talitos/talitos-aead.c
>> @@ -405,535 +405,225 @@ static void talitos_cra_exit_aead(struct crypto_=
aead *tfm)
>>   	talitos_cra_exit(crypto_aead_tfm(tfm));
>>   }
>>  =20
>> +#define TALITOS_AEAD_ALG_COMMON(name, name_prefix, set_key, block_size,=
 \
>> +				max_auth_size, template, priority)      \
>> +	{ \
>> +		.type =3D CRYPTO_ALG_TYPE_AEAD, \
>> +		.alg.aead =3D { \
>> +			.base =3D { \
>> +				.cra_name =3D name, \
>> +				.cra_driver_name =3D name"-talitos"name_prefix, \
>> +				.cra_blocksize =3D block_size, \
>> +				.cra_flags =3D CRYPTO_ALG_ASYNC | \
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY | \
>> +					     CRYPTO_ALG_KERN_DRIVER_ONLY, \
>> +				.cra_priority =3D (priority), \
>> +				.cra_ctxsize =3D sizeof(struct talitos_ctx), \
>> +				.cra_module =3D THIS_MODULE, \
>> +			}, \
>> +			.ivsize =3D block_size, \
>> +			.maxauthsize =3D max_auth_size, \
>> +			.setkey =3D set_key, \
>> +			.init =3D talitos_cra_init_aead, \
>> +			.exit =3D talitos_cra_exit_aead, \
>> +			.encrypt =3D aead_encrypt, \
>> +			.decrypt =3D aead_decrypt, \
>> +		}, \
>> +		.desc_hdr_template =3D template, \
>> +	}
>> +
>> +#define TALITOS_AEAD_ALG(name, set_key, block_size, max_auth_size, temp=
late)  \
>> +	TALITOS_AEAD_ALG_COMMON(name, "", set_key, block_size, max_auth_size, =
\
>> +				template, TALITOS_CRA_PRIORITY)
>> +
>> +#define TALITOS_AEAD_ALG_HSNA(name, set_key, block_size, max_auth_size,=
 \
>> +			      template)                                 \
>> +	TALITOS_AEAD_ALG_COMMON(name, "-hsna", set_key, block_size,     \
>> +				max_auth_size, template,                \
>> +				TALITOS_CRA_PRIORITY_AEAD_HSNA)
>> +
>>   static struct talitos_alg_template aead_driver_algs[] =3D {
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha1),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha1-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha1),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha1-"
>> -						   "cbc-aes-talitos-hsna",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha1),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha1-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha1),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha1-"
>> -						   "cbc-3des-talitos-hsna",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA1_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>> -	},
>> -	{       .type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha224),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha224-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>> -	},
>> -	{       .type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha224),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha224-"
>> -						   "cbc-aes-talitos-hsna",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha224),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha224-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha224),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha224-"
>> -						   "cbc-3des-talitos-hsna",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA224_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha256),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha256-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha256),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha256-"
>> -						   "cbc-aes-talitos-hsna",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha256),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha256-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha256),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha256-"
>> -						   "cbc-3des-talitos-hsna",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA256_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha384),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha384-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA384_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUB |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha384),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha384-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA384_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUB |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha512),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-sha512-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA512_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUB |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(sha512),"
>> -					    "cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-sha512-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D SHA512_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUB |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(md5),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-md5-"
>> -						   "cbc-aes-talitos",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D MD5_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(md5),cbc(aes))",
>> -				.cra_driver_name =3D "authenc-hmac-md5-"
>> -						   "cbc-aes-talitos-hsna",
>> -				.cra_blocksize =3D AES_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D AES_BLOCK_SIZE,
>> -			.maxauthsize =3D MD5_DIGEST_SIZE,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_AESU |
>> -				     DESC_HDR_MODE0_AESU_CBC |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(md5),cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-md5-"
>> -						   "cbc-3des-talitos",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D MD5_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_IPSEC_ESP |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>> -	},
>> -	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>> -		.alg.aead =3D {
>> -			.base =3D {
>> -				.cra_name =3D "authenc(hmac(md5),cbc(des3_ede))",
>> -				.cra_driver_name =3D "authenc-hmac-md5-"
>> -						   "cbc-3des-talitos-hsna",
>> -				.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
>> -				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> -					     CRYPTO_ALG_KERN_DRIVER_ONLY,
>> -				.cra_priority =3D TALITOS_CRA_PRIORITY_AEAD_HSNA,
>> -				.cra_ctxsize =3D sizeof(struct talitos_ctx),
>> -				.cra_module =3D THIS_MODULE,
>> -			},
>> -			.ivsize =3D DES3_EDE_BLOCK_SIZE,
>> -			.maxauthsize =3D MD5_DIGEST_SIZE,
>> -			.setkey =3D aead_des3_setkey,
>> -		},
>> -		.desc_hdr_template =3D DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
>> -				     DESC_HDR_SEL0_DEU |
>> -				     DESC_HDR_MODE0_DEU_CBC |
>> -				     DESC_HDR_MODE0_DEU_3DES |
>> -				     DESC_HDR_SEL1_MDEUA |
>> -				     DESC_HDR_MODE1_MDEU_INIT |
>> -				     DESC_HDR_MODE1_MDEU_PAD |
>> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
>> -	},
>> +	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
>> +
>> +	/* sha1 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, SHA1_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha1),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
>> +		SHA1_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
>> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey=
,
>> +			 DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +				 DESC_HDR_MODE0_DEU_CBC |
>> +				 DESC_HDR_MODE0_DEU_3DES | DESC_HDR_SEL1_MDEUA |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEU_SHA1_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha1),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA1_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA1_HMAC),
>> +
>> +	/* sha224 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha224),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, SHA224_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEU_SHA224_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha224),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
>> +		SHA224_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
>> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
>> +
>> +	TALITOS_AEAD_ALG(
>> +		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha224),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA224_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA224_HMAC),
>> +
>> +	/* sha256 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha256),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, SHA256_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEU_SHA256_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha256),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
>> +		SHA256_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
>> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
>> +
>> +	TALITOS_AEAD_ALG(
>> +		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(sha256),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA256_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_SHA256_HMAC),
>> +
>> +	/* sha384 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha384),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, SHA384_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
>> +
>> +	TALITOS_AEAD_ALG(
>> +		"authenc(hmac(sha384),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA384_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEUB_SHA384_HMAC),
>> +
>> +	/* sha512 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(sha512),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, SHA512_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUB |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
>> +
>> +	TALITOS_AEAD_ALG(
>> +		"authenc(hmac(sha512),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, SHA512_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUB | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEUB_SHA512_HMAC),
>> +
>> +	/* md5 auth */
>> +
>> +	TALITOS_AEAD_ALG("authenc(hmac(md5),cbc(aes))", aead_setkey,
>> +			 AES_BLOCK_SIZE, MD5_DIGEST_SIZE,
>> +			 DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_AESU |
>> +				 DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +				 DESC_HDR_MODE1_MDEU_INIT |
>> +				 DESC_HDR_MODE1_MDEU_PAD |
>> +				 DESC_HDR_MODE1_MDEU_MD5_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(md5),cbc(aes))", aead_setkey, AES_BLOCK_SIZE,
>> +		MD5_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_AESU |
>> +			DESC_HDR_MODE0_AESU_CBC | DESC_HDR_SEL1_MDEUA |
>> +			DESC_HDR_MODE1_MDEU_INIT | DESC_HDR_MODE1_MDEU_PAD |
>> +			DESC_HDR_MODE1_MDEU_MD5_HMAC),
>> +
>> +	TALITOS_AEAD_ALG(
>> +		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_IPSEC_ESP | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
>> +
>> +	TALITOS_AEAD_ALG_HSNA(
>> +		"authenc(hmac(md5),cbc(des3_ede))", aead_des3_setkey,
>> +		DES3_EDE_BLOCK_SIZE, MD5_DIGEST_SIZE,
>> +		DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU | DESC_HDR_SEL0_DEU |
>> +			DESC_HDR_MODE0_DEU_CBC | DESC_HDR_MODE0_DEU_3DES |
>> +			DESC_HDR_SEL1_MDEUA | DESC_HDR_MODE1_MDEU_INIT |
>> +			DESC_HDR_MODE1_MDEU_PAD | DESC_HDR_MODE1_MDEU_MD5_HMAC),
>>   };
>>  =20
>>   int talitos_register_aead(struct device *dev)
>> @@ -955,11 +645,6 @@ int talitos_register_aead(struct device *dev)
>>   		if (has_ftr_sec1(priv))
>>   			alg->cra_alignmask =3D 3;
>>  =20
>> -		aead_alg->init =3D talitos_cra_init_aead;
>> -		aead_alg->exit =3D talitos_cra_exit_aead;
>> -		aead_alg->setkey =3D aead_alg->setkey ?: aead_setkey;
>> -		aead_alg->encrypt =3D aead_encrypt;
>> -		aead_alg->decrypt =3D aead_decrypt;
>>   		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
>>   		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
>>   			continue;
>>=20

Thanks,



--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

