Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059C1D5CC9
	for <linux-crypto@vger.kernel.org>; Sat, 28 Feb 2026 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772272710; cv=none; b=i9pyABeX4AK2SzdKWwceiclZ2coPfV4fEeHoK3e0cS+swJo1vcxOgXLDrjIAerBW63QBTUOJDjSLoHeG6S+8WkYR17oFZO/8OgqLP7NP702BKBf55Tf4IdzQSvHrbePGHIwalZOhlSsSSK/jOUftZRlwYL7FsU4OSJTo0vsumA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772272710; c=relaxed/simple;
	bh=A2jVfZe3xMr7+UYdFllfKxH9v1wa03LIgfyKGzTURUA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=KmWeNNSzfOIOdj+pSRkoFXnNKzPgSIe8ShcDK5iJqCnKlVWIt2ldT6/pjlwVyqNkGaxSIIrSfqdu+j1itGEFa8dLeY65MqYAJa2Db2TIp++vCuBxuwn6PgWZz9xtZPtMoROCHa6b9KLEhgWAD127e9MPVhnS1t7TIyMqWA8HrZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mvZ04meN; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mvZ04meN"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772272705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t+ZD0E/Be2DkeoGJSTMXxYgl8VB2e+o0QP4h5bIji8A=;
	b=mvZ04meN/UBkJwE1Q9w6856JK0QYUvTooBgrFSSmSVjY0Rab63Nj0smQneIHTi/m+ZsX/G
	tLoFBvisCyMxVuHOwRMM2VgdYXnaaNsmyo6/25xo2T/0KQrhC6peeRGa1NUKKdIXYv4ahC
	L9Jbs8p78GYmX43/p6kMxoqBMC2JKfs=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix error codes in OTP reads
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aaKr1E1mPOgxo0JL@gondor.apana.org.au>
Date: Sat, 28 Feb 2026 10:57:51 +0100
Cc: "David S. Miller" <davem@davemloft.net>,
 Nicolas Ferre <nicolas.ferre@microchip.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Claudiu Beznea <claudiu.beznea@tuxon.dev>,
 Lothar Rubusch <l.rubusch@gmail.com>,
 stable@vger.kernel.org,
 linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <21D21541-8B24-47CA-9BFE-CC3B287CCB3A@linux.dev>
References: <20260215205152.518472-3-thorsten.blum@linux.dev>
 <aaKr1E1mPOgxo0JL@gondor.apana.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On 28. Feb 2026, at 09:48, Herbert Xu wrote:
> On Sun, Feb 15, 2026 at 09:51:53PM +0100, Thorsten Blum wrote:
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
>> Compile-tested only.
>> ---
>> drivers/crypto/atmel-i2c.c     | 4 ++--
>> drivers/crypto/atmel-sha204a.c | 7 ++++---
>> 2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> Patch applied.  Thanks.

Hi Herbert,

I also submitted [1], which combines this patch here and patch [2] after
Lothar suggested to squash them. Feel free to apply them separately or
together. Just FYI.

Thanks,
Thorsten

[1] =
https://lore.kernel.org/lkml/20260224225547.683713-2-thorsten.blum@linux.d=
ev/
[2] =
https://lore.kernel.org/lkml/20260220133135.1122081-2-thorsten.blum@linux.=
dev/

