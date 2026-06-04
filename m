Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2231746AF27
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 13:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780578120; cv=none; b=AgTcnOpBoORoOzIYnESb9fWzV3ZXdyxxbOiKQ/wzlBDg+9F4WibovrDv8TiUMC+hwYGZqkGW7cq322oU3tyd2oE6UqTs7/rPUujiWZA6f04pu64QD0S++35TNr5QNjO3cpaGFVbcWYf/Xj3AiP80u7lcKZa6P9UzsguouNoPH/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780578120; c=relaxed/simple;
	bh=NlDsBXo51dPRk4SzaM16RB7RXHS4ufmveWV+ZA3F72g=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OCMl9PXQH0PIWXQJp27o2zKgrxCPT2NiZLyF+OydjnM/VQY9kIWPlEpq8fbhTFG7Am3564/LUrkMunsBaHo0yJErvQH59vWSvxcttPMJP0/Lqx01dotmmBgnmhb/WnY+Wqxg9S4PjuanTIH0a3A+RA87xOkAxBREBKtZb3Gp2h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=MEjC/tJ5; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="MEjC/tJ5"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id AB0C84E405EE;
	Thu,  4 Jun 2026 13:01:57 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 803E35FEF7;
	Thu,  4 Jun 2026 13:01:57 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id D83A3106A1ACF;
	Thu,  4 Jun 2026 15:01:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780578117; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jCGS7k9PV+NJv11anJk8baA90NQcwulyClZvpkfh5GQ=;
	b=MEjC/tJ5j1fWSx3aw1ZvwVFpcA6cMrO1lSyVwOFwmpN3sTnfGq9xRl/tkzYkudi8MG3SnL
	oMDs3pACM06HAL54iLbLnLslIqvkO1vLtiaqruyIaQSVREsEbc79Xy1vZfhaa3k53WCbSA
	8y6Nhtmok3hLbmrqvRi7AI/pelVuSG9vX8MlFWlWevtU9W05CUz9dbA2fIF8rd0/JJfja4
	tuYOGTi40pXKCPITMHjFTPiUpsTqxuvdNxnrvMxrMoJm4z18/KItetWcGIX1HlOGSnrI8L
	jDPdemGckTPdsxlmBjscvyZ5X5/mubpuKB24z4xjjICEaWhc75xVNMAy+XbWYA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 04 Jun 2026 15:01:55 +0200
Message-Id: <DJ0A9HT6DUNI.3ROQ6L8CR5ES8@bootlin.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 29/29] crypto: talitos - Remove TALITOS_DESC_SIZE macro
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-29-cb1ad6cdea49@bootlin.com>
 <4202c304-4a4e-4b1a-8d40-d96a1ef143fb@kernel.org>
In-Reply-To: <4202c304-4a4e-4b1a-8d40-d96a1ef143fb@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

On Thu Jun 4, 2026 at 11:59 AM CEST, Christophe Leroy (CS GROUP) wrote:
>
>
> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Now that struct talitos_desc no longer has the SEC1-only next_desc field
>> (it was moved into sec1_talitos_desc), TALITOS_DESC_SIZE is identical to
>> sizeof(struct talitos_desc) and no longer serves any purpose. Remove it
>> and use sizeof directly at each macro invocation.
>
> It is still there ...
>
> $ git grep TALITOS_DESC_SIZE drivers
> drivers/crypto/talitos/talitos.h:#define TALITOS_DESC_SIZE=20
> sizeof(struct talitos_desc)

My bad. At least, it is no longer _used_ in the code..

Thanks.

>
>
>>=20
>> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
>> ---
>>   drivers/crypto/talitos/talitos-sec1.c | 10 +++++-----
>>   drivers/crypto/talitos/talitos-sec2.c |  6 +++---
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>=20
>> diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/tali=
tos/talitos-sec1.c
>> index e4f482520372..504ce9e23e59 100644
>> --- a/drivers/crypto/talitos/talitos-sec1.c
>> +++ b/drivers/crypto/talitos/talitos-sec1.c
>> @@ -190,7 +190,7 @@ static void sec1_dma_map_request(struct device *dev,
>>   	while (edesc) {
>>  =20
>>   		dma_desc =3D dma_map_single(dev, &edesc->desc.sec1.hdr,
>> -					  TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>> +					  sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
>>  =20
>>   		if (!prev_edesc) {
>>   			request->dma_desc =3D dma_desc;
>> @@ -202,7 +202,7 @@ static void sec1_dma_map_request(struct device *dev,
>>   		prev_edesc->desc.sec1.next_desc =3D cpu_to_be32(dma_desc);
>>  =20
>>   		dma_sync_single_for_device(dev, prev_dma_desc,
>> -					   TALITOS_DESC_SIZE, DMA_TO_DEVICE);
>> +					   sizeof(struct talitos_desc), DMA_TO_DEVICE);
>>  =20
>>   next:
>>   		prev_edesc =3D edesc;
>> @@ -216,12 +216,12 @@ static void sec1_dma_unmap_request(struct device *=
dev,
>>   {
>>   	struct talitos_edesc *edesc;
>>  =20
>> -	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
>> +	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
>>   			 DMA_BIDIRECTIONAL);
>>   	edesc =3D container_of(request->desc, struct talitos_edesc, desc);
>>   	while (edesc->next_desc) {
>>   		dma_unmap_single(dev, be32_to_cpu(edesc->desc.sec1.next_desc),
>> -				 TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>> +				 sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
>>   		edesc =3D edesc->next_desc;
>>   	}
>>   }
>> @@ -239,7 +239,7 @@ static __be32 sec1_get_request_hdr(struct device *de=
v,
>>   		edesc =3D edesc->next_desc;
>>   	}
>>  =20
>> -	dma_sync_single_for_cpu(dev, dma_desc, TALITOS_DESC_SIZE,
>> +	dma_sync_single_for_cpu(dev, dma_desc, sizeof(struct talitos_desc),
>>   				DMA_BIDIRECTIONAL);
>>  =20
>>   	return edesc->desc.sec1.hdr;
>> diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/tali=
tos/talitos-sec2.c
>> index 52f783ddc8b6..0df3b22510c7 100644
>> --- a/drivers/crypto/talitos/talitos-sec2.c
>> +++ b/drivers/crypto/talitos/talitos-sec2.c
>> @@ -205,7 +205,7 @@ static void sec2_dma_map_request(struct device *dev,
>>   				 struct talitos_desc *desc)
>>   {
>>   	request->dma_desc =3D
>> -		dma_map_single(dev, desc, TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
>> +		dma_map_single(dev, desc, sizeof(struct talitos_desc), DMA_BIDIRECTIO=
NAL);
>>   }
>>  =20
>>   static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 =
isr_lo)
>> @@ -346,14 +346,14 @@ static void sec2_init_task(struct device *dev)
>>   static void sec2_dma_unmap_request(struct device *dev,
>>   				   struct talitos_request *request)
>>   {
>> -	dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
>> +	dma_unmap_single(dev, request->dma_desc, sizeof(struct talitos_desc),
>>   			 DMA_BIDIRECTIONAL);
>>   }
>>  =20
>>   static __be32 sec2_get_request_hdr(struct device *dev,
>>   				   struct talitos_request *request)
>>   {
>> -	dma_sync_single_for_cpu(dev, request->dma_desc, TALITOS_DESC_SIZE,
>> +	dma_sync_single_for_cpu(dev, request->dma_desc, sizeof(struct talitos_=
desc),
>>   				DMA_BIDIRECTIONAL);
>>  =20
>>   	return request->desc->sec2.hdr;
>>=20




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

