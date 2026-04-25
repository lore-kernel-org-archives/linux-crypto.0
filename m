Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F63315ECCC
	for <linux-crypto@vger.kernel.org>; Sat, 25 Apr 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777126099; cv=none; b=ifFHryz04VQDSzKB8XHY6vaZnrkAobNZk1jSLOyQXekBmlETjYJW+vLzwRAulRs9awy8dyl3XpjAPx4MptuQ1itD9/w1jItepqJcCLoiBB/hriGmqoTkjyoZGbRxriDrVLRlQUhui24gx4AlzFc8FmSyR++MnWV00Tf3xMNR3Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777126099; c=relaxed/simple;
	bh=YsSWshUJFm3k1dbiXRCPEvOX1qUKcEvHV3UP3OasymA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqT5wsVt3ki5pQXoCi0ThbeNarEwn/PSWzz1rEiNLYKPc/vPX5kqMtoLjF6ZWUZiMeSk5iRy5QE4y8SiE312FRwSLICoXiCHwGAOMWGWJ/izICIuM8e/DuCMFQamE3tWfhtLwsQ1gUn4JQEvClsihBsUH97tbCWBJObU+78lqC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/2OsEMH; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/2OsEMH"
Date: Sat, 25 Apr 2026 16:08:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777126085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qzUAxgA9tGRq/PHsmc2325DJDEXjY0bT1l/jFUonhLs=;
	b=C/2OsEMHuzXqmSkoPcUBUmVTlRKrBMNxqwH7xmAmnLw9m1322fDC+yHHJfGL8UBzVSxZXi
	3Zw3Tl+qCMgp3blYNVP4puZ/2ooyBy5mkuZCkQDtUeEZFu3mj+L/neL1Ube6gAXkNje71b
	/vQ47IrYj7awq+6hZw/phyYsADmMXy0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte
 blocking read
Message-ID: <aezKwAqWPo0kXHDu@linux.dev>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
 <20260422210936.20095-3-l.rubusch@gmail.com>
 <aezFsF8gLkABZZ1O@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aezFsF8gLkABZZ1O@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 25, 2026 at 03:46:30PM +0200, Thorsten Blum wrote:
> Hi Lothar,
> 
> On Wed, Apr 22, 2026 at 09:09:35PM +0000, Lothar Rubusch wrote:
> > The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
> > 32 bytes of entropy, and a 2-byte CRC. The current blocking read
> > implementation was incorrectly copying data starting from the
> > count byte, leading to offset data and truncated entropy.
> > 
> > Additionally, the chip requires significant execution time to
> > generate random numbers, going by the datasheet. Reading the I2C bus
> > too early results in the chip NACK-ing or returning a partial buffer
> > followed by zeros.
> > 
> > Verification:
> > Tests before showed repeadetly reading only 8 bytes of entropy:
> > $ head -c 32 /dev/hwrng | hexdump -C
> > 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> > 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > 00000020
> > 
> > After this patch applied, the result will be as follows:
> > $ head -c 32 /dev/hwrng | hexdump -C
> > 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> > 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> > 00000020
> > 
> > Fix these issues by:
> > Increase cmd.msecs to 30ms to provide sufficient execution time. Then
> > set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
> > hardware response. Eventually, correct the memcpy() offset to index 1 of
> > the data buffer to skip the count byte and retrieve exactly 32 bytes of
> > entropy.
> > 
> > Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> > Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

[...]

> > -	max = min(sizeof(cmd.data), max);
> > -	memcpy(data, cmd.data, max);
> > +	max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
> > +	memcpy(data, &cmd.data[1], max);

I just noticed that index 1 is already defined as RSP_DATA_IDX in
drivers/crypto/atmel-i2c.h.

> This works and fixes rngtest for me on real hardware.
> 
> min_t() is not strictly necessary here, since the types are compatible
> and min() is sufficient.
> 
> I agree with Ard that patch 2/3 should be a separate patch for easier
> stable backporting.

Thanks,
Thorsten
