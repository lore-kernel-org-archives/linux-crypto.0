Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F733F1662
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 10:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372912; cv=none; b=Urj7l8ZYOy5eOed65Tq95GjcwbZU+hIwEvizKjXVe2qunk+ebYKx/RhG0Wwsm2EMrZ6BB0WEJadvAnWfyb/QbcZ1KuiOvooiVBz43nOvPO6eZ+nL+JYYZIc+NsNj2cAVB/AcFaumgT3LdhNY/mzcad+YFOWHpYMQHsKOQfrR/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372912; c=relaxed/simple;
	bh=+zskbUZygGIRyLEojlorFo5hj9kenW9SgW0vsB80GDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJD1dOFiWpCuldUxZ8n2aaj3p24x9wGDaRqyng4nDb6T+bL5wfA40/Ak0u0RVLNDV9lMl+QcR7NqALMNR02W+we4z4L+0fMxrlAM/kFrirEnMIzPAUVZF0VvfWEXiDHlVqUO581p/tN0Fl6j+llEFvuT791jhPwmpv5/zrCIK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IoniuwUV; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IoniuwUV"
Date: Tue, 28 Apr 2026 12:41:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777372907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/FFJUWuJo8UWH0tVMp4fDMIt9eUlpWyEGXsfdajhYrQ=;
	b=IoniuwUV6zCfw9A0IcTRrRx/lRLMMjurS88bvpyaT9bKeAtqAKMBfJuC32JLHB1lFlWzhp
	hgFCUDnxm7t0NwLDlL1XU3mpA8P1F3yZ8HCzH7I9QIQ8Q8fXSLG44fnwogcGW4dHnKmdJU
	5gC7oomeg/bBQky+gupqHydEb9imIG0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] crypto: atmel-sha204a - fix blocking and
 non-blocking rng logic
Message-ID: <afCO4ncvuormBV2x@linux.dev>
References: <20260426212947.24757-1-l.rubusch@gmail.com>
 <20260426212947.24757-2-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426212947.24757-2-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 26, 2026 at 09:29:47PM +0000, Lothar Rubusch wrote:
> The blocking and non-blocking paths were failing to provide valid entropy
> due to improper buffer management. Reading the buffer starting from byte 1,
> only fetch the 32 bytes of random data from the return message.
> 
> Tested on an Atmel SHA204A device.
> 
> Before (here for blocking), tests showed repeatedly reading reduced bytes.
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
> 
> After, the result will be similar to the following:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Tested on SHA204A hardware using rngtest:

  $ sudo head -c 300000 /dev/hwrng | rngtest -c 100
  rngtest: FIPS 140-2 successes: 100
  rngtest: FIPS 140-2 failures: 0

and verified via hexdump that the byte stream is no longer zero-padded.

Tested-by: Thorsten Blum <thorsten.blum@linux.dev>

Thanks,
Thorsten
