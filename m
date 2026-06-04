Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280EF436358
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 12:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780577084; cv=none; b=BUctFU/dWTEF1kxEC7/iC1vKituM9K2pjMAKyaOZQjP13sHtOa5dxrMS3GuI05QHlOOeasv/iVBQwVsN+Xp270ji7E0ZRaUmaLg4A08/lBZHFimKcPt59Hqf0O3Ahxmx2Axws3wkyusmTqnpj7OjJxTRgicMX+GcN8QfacMXHXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780577084; c=relaxed/simple;
	bh=YvPcqAsvrPsYklS2EfWUjYqEcZ4GAgQ6WR5VQVo4sAg=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=cLcSt9ZJT0oouw5/YcxzKSotC4P4Mw7P6YAQ2Vx97nEUbyA45bjoGGN8JqTyefKkJJIvfhUZmaM7VV/AUzzuOlpabmoCQgdl5RiThYoAVf6LkloRWIeHeJJtPYtzqUC+VvgLzXm0N0vG1YQxGdgwQWkM6ToikpbkUbRLp2YLHzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=JQ6zz/4w; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="JQ6zz/4w"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id DBCCBC63454;
	Thu,  4 Jun 2026 12:44:39 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A34915FEF7;
	Thu,  4 Jun 2026 12:44:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 19274106A1AA4;
	Thu,  4 Jun 2026 14:44:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780577079; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=gONFn4DqUOGzqbMYsfvr+tjtfjyT9w5l4C0ZwSHhYQ8=;
	b=JQ6zz/4wQHYC/p/ivqGT24bOeux7qRegZ+6GjsUDAowmR0P6XQo2qVbypQ44aTjzra+5Op
	CElMvzBEloeC/838ywmX6dkIuq3MNpyQomS0QMQ+p9auAPjerV4JpI4sfZOFXkCoIkBoJW
	LsGJU7/JLyxw+nKKVrgx0e8AHI2kNypT6Ph0LKgyzMsfDoczGHIavAuHg14ngtX6PhADqi
	KXkElBFHCY46MwB0DxbypaM7mSt77NW1pUI+9jYnCkjgiP6pdxzwSMlqiQxS4qPdggkuRT
	b+38GDlaJ970nQs30jcjNW7r7uhkgORVmPGotuHWeLtGLutXfndovTderROpvw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jun 2026 14:44:38 +0200
Message-Id: <DJ09W9GOH1UG.24IMEWGQ179KE@bootlin.com>
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/29] crypto: talitos/aead - Convert to init/exit
 type-specific API
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-14-cb1ad6cdea49@bootlin.com>
 <5c25a511-39c7-43aa-a2e2-7690ca4d074a@kernel.org>
In-Reply-To: <5c25a511-39c7-43aa-a2e2-7690ca4d074a@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

On Mon Jun 1, 2026 at 1:59 PM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Since commit 6eed1e3552fc0 ("crypto: api - Mark cra_init/cra_exit as
>> deprecated"), both cra_{init,exit} are deprecated.
>>=20
>> Restore the type-specific talitos_cra_exit_aead() wrapper and use
>> aead_alg->exit instead of the generic cra_exit field, matching the
>> pattern used by init.
>
> When you say "restore", do you mean it was removed at some point in the=
=20
> past ?

No. It was probably true at some point of my the series locally (I did a lo=
t of
rebase), I forgot to update the commit message of this patch.

Thanks for pointing this out.

>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
>
>> ---
>>   drivers/crypto/talitos/talitos-aead.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/tali=
tos/talitos-aead.c
>> index c09ed08be2ef..38df616c9b22 100644
>> --- a/drivers/crypto/talitos/talitos-aead.c
>> +++ b/drivers/crypto/talitos/talitos-aead.c
>> @@ -400,6 +400,11 @@ static int talitos_cra_init_aead(struct crypto_aead=
 *tfm)
>>   	return talitos_init_common(ctx, talitos_alg);
>>   }
>>  =20
>> +static void talitos_cra_exit_aead(struct crypto_aead *tfm)
>> +{
>> +	talitos_cra_exit(crypto_aead_tfm(tfm));
>> +}
>> +
>>   static struct talitos_alg_template aead_driver_algs[] =3D {
>>   	{	.type =3D CRYPTO_ALG_TYPE_AEAD,
>>   		.alg.aead =3D {
>> @@ -950,8 +955,8 @@ int talitos_register_aead(struct device *dev)
>>   		if (has_ftr_sec1(priv))
>>   			alg->cra_alignmask =3D 3;
>>  =20
>> -		alg->cra_exit =3D talitos_cra_exit;
>>   		aead_alg->init =3D talitos_cra_init_aead;
>> +		aead_alg->exit =3D talitos_cra_exit_aead;
>>   		aead_alg->setkey =3D aead_alg->setkey ?: aead_setkey;
>>   		aead_alg->encrypt =3D aead_encrypt;
>>   		aead_alg->decrypt =3D aead_decrypt;
>>=20




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

