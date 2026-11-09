Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794234847;
	b=DQifbqGSh/9e4zHgZN7WdRdveZpxqaYR+cNA6TORYyQegSDgct4c/9RuId/fX7nfJEwW
	 aXbhQnwDLNZ4GEFk/Ug9rYVZ6/jda/2IJLu+/cJehyoMtXwOOJPKqWifFayUuSQ8Vlppt
	 YDLEON2HW6eix1MUptMD6du19z8PWEDSyf9apKQeKAzEQNbbMsjfhSf++wILQwrJpfxDl
	 7KCOVYRtwl/V1AHoZb15Z14gQhvz7sSXPI7W01jTiKYhQbIXDeuAPBeN4da3jU7hqAFQK
	 azJKJgrvzz54hmCzkyI0jW/62stkCN76x3Jriq8wvlEoGb6f5rlRQKViZ2HHvesQRrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794234847;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XolQkoDA6yXInZVwiaghR0QDYNmwzSNFDd/PUyz8UMA=;
	b=kdztkm+yAtWwiZyfqF/jld3Er8E/UzHkPAYt8slHzOByRCm0/l2SRmJpMlNGsu+fuVI2
	 Me+w5psEqzq7caAKZ1W4799FvBjzZZFY13AmsYyiJkwCEkHsR+hXkPAjyomgUMc96XKim
	 MuZuBch5F4DTzaKknqSzI9X5ZlVw3lI6lqCZE8LuKjAeYIgYsRwPPKNa6nnmjXEM0QUm0
	 vBbrqkusLJ3OouiOwaWcN2FurQYD4jhWWTwl16GOYktQRcR/san6uBREZGF2N33jWHX9I
	 0u+fciHy9FVem9WX1uDtPvQCDQIW4C8rn1CMfJp5aCKGwpLicp86rUyUW6BtRm8Xacw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HoB+n7DQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD7A606A321;
	Mon,  9 Nov 2026 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HoB+n7DQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1641F0089F;
	Mon,  9 Nov 2026 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794234846;
	bh=XolQkoDA6yXInZVwiaghR0QDYNmwzSNFDd/PUyz8UMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HoB+n7DQK5VEmMOH4JfaVBFhjvGgFV9ldQt8mxy0yHmuyFftTLyGNmfmTMhzjiQEh
	 cdX/wEBNgkXGmGB6F/bCqemj02IGjqqcKSgSYvj8CAuU6Z5kKMSY6pUWZ/RKwnl8kM
	 MlinF9cGGfLJhdfl0+yg94i0PRRTe1BeAKYIpZWPj3yNRikwajUM8HBCnGXSOsEeOZ
	 YuAJgTsupr3+RTemxk3sKg5Q1MH+3jpqH83Dea0PRDT5GA8FlSw5STJKLveho0BLuT
	 z47vluVJqGpoif93LB7ftC1ESe66b22mn/c69EPMG7VJBmkZJKMheiJXLRWkv/JCLk
	 joO2+VjDtyEIA==
Date: Mon, 9 Nov 2026 15:34:01 +0100
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thorsten Blum <blum@kernel.org>, linux-crypto@vger.kernel.org, linux-i2c@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Marius Dinu <m95d@psihoexpert.ro>
Subject: Re: [PATCH] crypto: atmel-i2c - find the bus speed behind an I2C mux
Message-ID: <avHVv4LscKrE4b7K@solitude>
References: <auieEHLkx76881ZL@solitude>
 <20261102170141.54660-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102170141.54660-1-pepe.schlehofer@gmail.com>

On Mon, Nov 02, 2026 at 06:01:41PM +0100, Josef Schlehofer wrote:
> Hi Marek,
> 
> thanks for the ack and the warning.
> 
> The hwrng core starts a fill thread for the current RNG, whatever its
> quality. It reads 32 bytes every 60 seconds, even when idle.
> atmel_i2c_send_receive() puts the ATSHA204A to sleep after each
> command. That means about 1440 seed updates per day, and 100k cycles
> in about 70 days.
> 
> The ATSHA204A becomes the current RNG when the MCU firmware has no
> TRNG. It also stays current when it registers first, because both RNGs
> have quality 1024. Today the probe fails on the Omnia, so it is safe.
> This patch could wear out its EEPROM within months. It is also marked
> for stable.
> 
> The patch also lets the ATSHA204 on the Turris 1.x probe, as its I2C
> controller has no clock-frequency either. There the talitos hwrng wins,
> because the ATSHA204 has quality 1. Without talitos, the ATSHA204 would
> wear out the same way.
> 
> Should we fix the wear before this patch goes in? Does "proper power
> management" mean the idle command instead of sleep? I can look into
> it.

Yes, basically.

Note that there are two time constants after which the device goes to
sleep mode:
  t_TIMEOUT  (45 to 85 ms) - if I2C bus is inactive the device goes to sleep
  t_WATCHDOG (0.7 to 1.7s) - the device goes to sleep automatically at most
                             t_WATCHDOG time after wakeup, unless put into
			     IDLE mode

If the RANDOM command was the only command the driver is issuing, I would
simply make it so that the device is put to IDLE mode after each command.

But if there are other commands executed, maybe the implementation needs
to be smarter. Depends on the commands.

