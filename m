Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630927;
	b=zNiNixQbbqGFCS30U5tYW8fWmcZ5wsq5Ng0WJ/trK0V0zCa1+FGRrjvyAcfh5pd9oAwd
	 xd6R+B7QtzddtO/NKOM8Ztyy+mkTj4ZW6YP6wM4YmQO/Y7UrCVKpDJK+fo7M9kALw+9HJ
	 A9rYqoV7GQIr+Hy6ynHvv6FRcS2FpAF3DiR+l3l1MEMS3zpA9vVvY1nM7VDKWqEz6IYEA
	 aSGmImxFKnY7OfsNZimjkHuuYG2R9skA+3zzJ7a3utJvIg0EmHWkEdGHIuTgBI1SotUop
	 gwnwWAWAmSWIw40TPTdOxQfSBHQ18vy2bW6ekLVnG6QZ4xzQeKvjcGDcr7HmiJr26TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630927;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=awlPE73wPHw2AMrVqP2UuNcNJF8Oo01qcJYNc91vBmU=;
	b=XHC3OfnyfSULh4K8Q3Qm/9EkfXpnH8EeAhc0zUeEbk+KTmKythByS1CanKUaD9tH+W1p
	 PSee7VfCzercjM1p74KExKmBa47t10XIhguvGAQgN2eNz8AIbnagTf8lTfvle14PbCCMW
	 46A/jhUidbG2gcOBilXOaqNCYENUdYfx0TZyUTFe6C+E1VO7m5t/SBdzWlmGxbJOS58SB
	 ABl/Q2Zcq6vp2WXSDQE8gV9avUhAD291jitR62DZ2ArjMqeax7urUc0X00TbJnL5XmTMX
	 gp5d1TcgJOyjU1Nk4Tfw58O7lOQRwJUImIPJIfnC7ajWtKoZOVhIq0tAvKX9lUR6QRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUVw5QPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3490606A90B;
	Mon,  2 Nov 2026 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IUVw5QPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC6E1F00A16;
	Mon,  2 Nov 2026 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630926;
	bh=awlPE73wPHw2AMrVqP2UuNcNJF8Oo01qcJYNc91vBmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IUVw5QPjjGQLBd6MbIzXIConuFqDlewBfNp3KiqisO++aGoUs0yK9u0v2SHWNCnE3
	 OyToqYzxqu8DHKK0JwbqQS9dp23Gagqu1rzsOX8pvD9TvDe0frGwVr3vOLMk/7zWEG
	 FG33Oi1JFAAABDwtDtblLUH2Qb7BUEU3QOM2mA5cF/M3RDlz76alOV5h7r9cSzrbC3
	 EyOVPlbAtuvwrg+ACwUrXTUe+u3KyC5qe398bTDaWId5DsfUBa/iciUKgUU+Kso3vF
	 T625VZPV8lCSMP9HfIDT9nCKuMJVU9eGIP0+fx3osjkz91BJiiLzZzFwGCZhAimIA4
	 F0dPHxoeW4NBA==
Date: Mon, 2 Nov 2026 15:48:41 +0100
From: Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
To: Josef Schlehofer <pepe.schlehofer@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Thorsten Blum <blum@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, Marius Dinu <m95d@psihoexpert.ro>
Subject: Re: [PATCH] crypto: atmel-i2c - find the bus speed behind an I2C mux
Message-ID: <auieEHLkx76881ZL@solitude>
References: <20261029082616.53365-1-pepe.schlehofer@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261029082616.53365-1-pepe.schlehofer@gmail.com>

Acked-by: Marek Behún <kabel@kernel.org>

But I would suggest not using this driver on Omnia for TRNG.

If you need TRNG, just use the one provided by the turris-omnia-mcu driver.
Upgrade your MCU firmware with the omnia-mcutool utility.

Why?

The Atmel SHA204A TRNG needs to update a part of its random seed in EEPROM
everytime it goes to sleep. Unless proper power management is implemented in
the driver, it will go to sleep 1.3 seconds after each wakeup.

The EEPROM is rated for ~100 000 cycles before it wears out.

Since proper power management is not implemented in the driver now, if you
enable this driver and read the TRNG continuosly, you can wear the EEPROM in
several days.

Marek
