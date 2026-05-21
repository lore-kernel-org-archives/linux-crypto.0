Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC93806A3
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 10:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358825; cv=none; b=OfGvlROhJGVeQzuCATsAF/mL+QJc5lHfd+sF60AvCjT+tCMBEdMOEwepxwlKcdXiTv814I4HSA0ZJYQMEiHEESCre3RViy9LAy2tm3f7lvQ8MxqFftokQjxYSZ/w8mJEXtpkWWbXVNW/WMbrlWlkHH5r1JKzY4m/vgGscuv1eRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358825; c=relaxed/simple;
	bh=RsFsKMxlnM+epZ0LmkhDQ62s1eZGdm98OBx+teTEx84=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=oKYXya6ylxOVPaMihtiBBKPwpqT1zOR5ruzbpv4GlWZd8VdSgrJVSRW6guUXGDkLR/l17JSGLi8Wox8si7xi7meMV8nqnJPVOZOLE0TfWfFJEzUSfJ9kQ1+hYnsFlreA82T0SLneO0YayLqrDSmqvS2ZWGzNP+OuJ9BPvW5WEb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=XelEORNV; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="XelEORNV"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id CF5EE4E42D02;
	Thu, 21 May 2026 10:20:21 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id A3BEE60495;
	Thu, 21 May 2026 10:20:21 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 612EE107E9CE4;
	Thu, 21 May 2026 12:20:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779358821; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=gjx/FpZorTQ8sC52xT/+ZbpzyTFqM8yxsw1eW1fSB1A=;
	b=XelEORNVxZnjWKnqE2ArOZdi7Jvzsv6eA7Y16GL5HUqD0UIq+K2/BZAz1u91XADTkV+yFy
	kW9tmPeZeMZ5CMSkjw77Wi/Yk5ObSJvwMTo6YmRjbX6eq90Z7mx46Rzweh/kmDSkBz9Kh3
	mFMBNucesGEgin0Vig8j6VfpsDbK5XxDxsUtxj60wtvRUlAL5shBR2fu1ZbHBE5LQV++o3
	CP7GU4tlSoebz8GIuCZBvoRKFEGoAh6yDNCfm8ZYIxy7j0xBUR9cGzlR5tyX3RTcw1TlL0
	m7XpdTY435kydzUFMGNRzm/uXi4g26KHOVc+8bZZfCA4PfyT7WokfntKtskxGg==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 12:20:18 +0200
Message-Id: <DIOA24QU02W5.2RSVK05RE7BJK@bootlin.com>
Cc: <herve.codina@bootlin.com>, <miquel.raynal@bootlin.com>,
 <stable@vger.kernel.org>, <thomas.petazzoni@bootlin.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Sasha Levin"
 <sashal@kernel.org>
Subject: Re: [PATCH] crypto: talitos - fix rename first/last to
 first_desc/last_desc
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Paul Louvel" <paul.louvel@bootlin.com>, "Goetz Goerisch"
 <ggoerisch@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <142603430.61540.1779296295550@app.mailbox.org>
 <DIO9YUHO5VGT.3BLGH04NVJNHP@bootlin.com>
In-Reply-To: <DIO9YUHO5VGT.3BLGH04NVJNHP@bootlin.com>
X-Last-TLS-Session-Version: TLSv1.3

On Thu May 21, 2026 at 12:16 PM CEST, Paul Louvel wrote:
> On Wed May 20, 2026 at 6:58 PM CEST, Goetz Goerisch wrote:
>> Hi,
>>
>> Commit a1b80018b8cec27fc06a8b04a7f8b5f6cfe86eae
>> was backported to 6.6.y with a866e2b1c65edaee2e1bb1024ee2c761ced335f8
>> It renames last to last_desc but misses one occurrence which leads to co=
mpile errors on mpc85xx
>
> Hi Goetz,
>
> Thank you for the patch. I did not catch that since I worked on a mainlin=
e tree,
> and that specific line was removed in 9826d1d6ed5f ("crypto: talitos - st=
op
> using crypto_ahash::init"), which was not backported into the stable tree=
.
>
>> drivers/crypto/talitos.c: In function 'ahash_digest':
>> drivers/crypto/talitos.c:2204:16: error: 'struct talitos_ahash_req_ctx' =
has no member named 'last'
>>  2204 | req_ctx->last =3D 1;
>>       |        ^~4
>>
>> Fixes: a866e2b1c65e ("crypto: talitos - rename first/last to first_desc/=
last_desc")
>> Signed-off-by: Goetz Goerisch <ggoerisch@gmail.com>
>> ---
>>  drivers/crypto/talitos.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
>> index 347483f6fc5d..ed160c591346 100644
>> --- a/drivers/crypto/talitos.c
>> +++ b/drivers/crypto/talitos.c
>> @@ -2201,7 +2201,7 @@ static int ahash_digest(struct ahash_request *areq=
)
>>  	struct crypto_ahash *ahash =3D crypto_ahash_reqtfm(areq);
>> =20
>>  	ahash->init(areq);
>> -	req_ctx->last =3D 1;
>> +	req_ctx->last_desc =3D 1;
>
> Instead of renaming req_ctx->last, commit 9826d1d6ed5f8 ("crypto: talitos=
 - stop
> using crypto_ahash::init") should be applied. Ideally before commit
> 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request limitation") =
to
> avoid any compilation breakage and ensure correctness of the code.

Small correction:

Ideally before commit 00463d5f864a ("crypto: talitos - fix SEC1 32k ahash
request limitation") to avoid any compilation breakage and ensure correctne=
ss of
the code.

>
>> =20
>>  	return ahash_process_req(areq, areq->nbytes);
>>  }
>
> Paul.




--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

