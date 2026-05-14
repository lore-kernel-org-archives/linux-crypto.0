Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE833A1684
	for <linux-crypto@vger.kernel.org>; Thu, 14 May 2026 19:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778788280; cv=none; b=fdVHIBPs54GkUF5H53pSJeIxeCaFvLd1nQ60TVSw1bM4fHSpszS8ZCAUceaVm3joQbtrmP1Gj88aPnjYsYS8zaAUr6ewCofxHIQnppvjnUrlWEplqOmN6ldN+lyAxadxzr5reLtS0jyZ0GdIOflZ7tX0v4hMEfhNeB528rupk4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778788280; c=relaxed/simple;
	bh=Xy2rXfjB5pYkx7hjJZMil8LRrN+bBpqRn6I/nrAfvtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5/fKl2p3x7IzQlTkRmnuBNsV2lI9afARAKrj8KJJPhRZa6fJKvAQ80nMOI0mQLb7qO/f1AZ0MVf4B4uWTmIDDq3qMqHsGdhrn/ODLusbPAAOz0D4Lz21FOLDbICLaswR3T62fAXbhFawsIFZgdMNS8tKSodNisFOBKzAactZKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ENAOdSG/; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ENAOdSG/"
Date: Thu, 14 May 2026 21:51:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778788266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t3vKFZ+ZAc477pdDejo5QZaOuOl53nFCfCWOpFZE7UY=;
	b=ENAOdSG/5e9S3guHxvN8N/NjNqnMIrV5wOAseLL5bQJfUQnMon3sPSd7L3rbYrMl7ZzvEy
	zb2FGLB1nANQ4vFaVl6zbwo1QdAIXq3buYALLUwnRvYxo7nUfvn17hX9PIZZPPZyO13ODp
	WoI/fng0zsEFc57DptemWhtHAheqfTk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] crypto: atmel - refactor common i2c support and
 add SHA256 ahash support
Message-ID: <agYnpsiG8bNeVw57@linux.dev>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

Hi Lothar,

On Tue, May 12, 2026 at 10:43:37PM +0000, Lothar Rubusch wrote:
> This series restructures the Atmel secure element drivers around a
> shared atmel-i2c core and adds SHA256 ahash support for ATSHA204A and
> ECC based devices.
> 
> The existing drivers duplicated substantial parts of the transport,
> RNG, EEPROM and device management logic. This series consolidates the
> common functionality into the shared i2c core and converts the client
> drivers to capability based allocation.
> 
> The series also introduces per-device timing configuration through
> match data, moves sanity checks and RNG handling into the core driver,
> updates workqueue handling and cleans up internal constants and helper
> definitions.
> 
> The final patch adds SHA256 ahash support using the hardware SHA engine
> provided by the devices.
> 
> ATSHA204A devices require software-side SHA256 padding according to
> FIPS 180-4, while newer ECC devices provide a dedicated SHA final
> command and perform padding internally in hardware.
> 
> Supporting the SHA engine also requires changes to the command
> transport path. SHA operations must execute as a strict uninterrupted
> sequence consisting of SHA INIT, one or more SHA COMPUTE commands and,
> for ECC devices, a terminating SHA FINAL command. The device loses its
> internal SHA state if it enters sleep mode or if unrelated commands
> are interleaved during the transaction.
> 
> To satisfy these hardware requirements, the send/receive path is split
> into a low-level transfer helper and a higher-level wrapper managing
> wakeup, sleep and locking. SHA operations keep the device awake and
> hold the i2c lock for the full duration of the hashing transaction.
> 
> The series has been tested on ATSHA204A and ATECC508A devices.
> Tests are ongoing/pending on ATECC608A and ATECC608B.
> ---
> Lothar Rubusch (12):
>   crypto: atmel - introduce shared I2C client management
>   crypto: atmel - move capability-based client allocation into i2c core
>   crypto: atmel - remove obsolete CONFIG_OF guard
>   crypto: atmel - add per-device timing and match-data driven
>     configuration
>   crypto: atmel - move RNG support into common i2c core
>   crypto: atmel - move EEPROM access support into common i2c core
>   crypto: atmel - expose CONFIG zone through sysfs
>   crypto: atmel - move device sanity check to core driver
>   crypto: atmel - check client data in remove callbacks
>   crypto: atmel - update workqueue flags and add flush on exit
>   crypto: atmel - refactor and localize driver constants
>   crypto: atmel - add SHA256 ahash support
> 
>  drivers/crypto/atmel-ecc.c     | 252 +++++++-----
>  drivers/crypto/atmel-i2c.c     | 679 +++++++++++++++++++++++++++++----
>  drivers/crypto/atmel-i2c.h     | 180 +++++----
>  drivers/crypto/atmel-sha204a.c | 284 +++++++-------
>  4 files changed, 1010 insertions(+), 385 deletions(-)
> 
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Thanks, but I'm not sure reviewing such a large series is sustainable.
I've only skimmed it, but it also mixes several different things that
should probably be submitted separately (e.g., refactorings and new
features).

Sashiko [1] also reviewed the series and found potential regressions
that might be helpful to consider.

Thanks,
Thorsten

[1] https://sashiko.dev/#/patchset/20260512224349.64621-1-l.rubusch%40gmail.com
