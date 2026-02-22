Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5773352C29
	for <linux-crypto@vger.kernel.org>; Sun, 22 Feb 2026 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771791022; cv=none; b=bdScT9U7XbssxyC5ZU8qZAZaiLG8xEJNr0+2cZIg3/yK4dPKpo3TLMmH+XKTXC5K0PjbzxlLJ7Osx9zEfGr1GOFVoyYnrtH3Q2NMswp9ainxEr4zkxt2o+S0DcH6HC8IsyMR4pB7J216PFt8Z1GywI1Vl+pqrUbXVNxLWLatsns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771791022; c=relaxed/simple;
	bh=iqifWwyjTFXTIyqM0oQ0Up5yDaCs0JAGxow5W/xD4fk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=C0FPyq5Zs1Q4BCD75+IAfDD30I+jiley6mPHdUQpkCfl3K7YJYDWOQxBsohh3rQa2KBFr9K9z+TJO0+Pf1eJnsv3+agyqruUpEbCTt43B+Z48cwQRA0ei2ABWcLOXeUwpw9raktkr1gbVr9nfHJDX5L+XnDOruMUCQUI6OE4/nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HtyXJS95; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HtyXJS95"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771791008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5/Rd3t51ulL2jFj2PIuw2mldaS4mUMnXa7fZq+qDTU=;
	b=HtyXJS95iLIvZpEwYhy/cJ1s9QItwZQidbLXFje43L+iVIb4y2QpgRgk2PYH2FfHgcJssh
	gFGIrdelKpdbIGrFTeLDI69DiQDB9SB06p82SI16SpsbMVbl+sGPFcJTHY/FeCbbSsQF+j
	zopLHP9sOV+4xYL4aWXQDIYKdxXHiRc=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <CAFXKEHZ9TTZMdzKr8_5UesUdajGoQNm_u_paakggtGONbzjPcQ@mail.gmail.com>
Date: Sun, 22 Feb 2026 21:10:02 +0100
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 stable@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B6971FE-BE8B-47F7-9FB3-E32D554FC19A@linux.dev>
References: <20260215205152.518472-3-thorsten.blum@linux.dev>
 <CAFXKEHZ9TTZMdzKr8_5UesUdajGoQNm_u_paakggtGONbzjPcQ@mail.gmail.com>
To: Lothar Rubusch <l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 22. Feb 2026, at 18:03, Lothar Rubusch wrote:
> On Sun, Feb 15, 2026 at 9:52=E2=80=AFPM Thorsten Blum wrote:
>> Return -EINVAL from atmel_i2c_init_read_otp_cmd() on invalid =
addresses
>> instead of -1. Since the OTP zone is accessed in 4-byte blocks, valid
>> addresses range from 0 to OTP_ZONE_SIZE / 4 - 1. Fix the bounds check
>> accordingly.
>>=20
>> In atmel_sha204a_otp_read(), propagate the actual error code from
>> atmel_i2c_init_read_otp_cmd() instead of -1. Also, return -EIO =
instead
>> of -EINVAL when the device is not ready.
>>=20
>> Cc: stable@vger.kernel.org
>> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp =
zone")
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
>>=20
>> @@ -106,7 +107,7 @@ static int atmel_sha204a_otp_read(struct =
i2c_client *client, u16 addr, u8 *otp)
>>=20
>>    if (cmd.data[0] =3D=3D 0xff) {
>>            dev_err(&client->dev, "failed, device not ready\n");
>> -               return -EINVAL;
>> +               return -EIO;
> The cmd.data holding 0xff here is not a bus error. AFAIR it can have
> to do with the locking state, pre-initialization,
> typically the atmel watchdog kicked in / timeout, etc - so the
> response is invalid, although hardware connection (I2C) is
> supposed to work. Currently the caller of this function does not
> distinguish anyway.
>=20
> But why is EIO preferable here, over EINVAL?

AFAIK, -EINVAL is used for invalid arguments or bad input passed by the
caller, which is why the address range check returns -EINVAL.

-EIO signals an I/O error or communication failure, e.g., the caller
passed a valid address, but the device isn't ready yet, for whatever
reason. Maybe -EAGAIN or -EBUSY instead? -EIO seemed like the most
reasonable choice to me.

Since the error code will be propagated by my other patch [1], now would
probably be a good time to adjust it.

Thanks,
Thorsten

[1] =
https://lore.kernel.org/lkml/20260216074552.656814-1-thorsten.blum@linux.d=
ev/

