Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B0419CC14;
	Sun, 12 Apr 2026 05:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775973107; cv=none; b=F0pacJmsJkhDTQqNBfOc2v8eWwd3m35ZzI26LYTPJnX2FBdL7PSBPVS90dDxLxNldhnoDbNHMF8n98zrcGvpx1M6AVpk7BDgo+SbipFtvMSuy/fJ+vj+4YwGvQG2QH0p49eOdOJ7JiwNG94PSsf7OTlzEoNvmd/rBvtQtipEpls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775973107; c=relaxed/simple;
	bh=zKz+SIDEj40kXFeony/KwLAX+50CDjSUzIFveQMRFco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWbKKi25wiCc/Pg52mjawBWgdWwdev7aeIsZh+m6pQf49iMnlTa1+shwpPqAEaMKA+yMiB1Iahq/8DpHFa98rdONsEJeKmtg48EVrd43F3mvzzkyPSWiHTjXTbmTnePsulnLOBXXCpUToFMYS2FQqtE/n8d59p3fzwuucTtWJco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mymNJDa3; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mymNJDa3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IUn/0oYiuWFPh0x53XCMORztV8/rGkx/S77yMEPOoss=; 
	b=mymNJDa3GY+BtcS1hLT2Sa5wR5mtaCZyHN99BNfLDnGHY4m8a85CB4DwK2VSA1HGe5n+3Nuv5GY
	/J/2RLzn1mfJ9m+0jPN86Ulw93dSsI59QvV9aQOSfFsX6fOZ9isZTTgDQgRnwpMjhujOkIzp5/mED
	JDVt0AZ3GkI1k+GLxj0y/HDtqgUjevitqGey4QDCK5IvI5OAAzyZRSsVkMaFDaKlwrcPCVH0695of
	ByaW8XJUqPJB5u/NDvhj/nqoHUU9W1/Ttjf1oT9Z6jTgm9ENUmPUqY6mGg1cz/bVSKL5GknVF9gtD
	B8fgh2rcyuR3WfKrgby3x3OeLZjHsnwZc8Ig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBnJT-005T6v-17;
	Sun, 12 Apr 2026 13:51:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 13:51:10 +0800
Date: Sun, 12 Apr 2026 13:51:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: atmel-ecc - add support for atecc608b
Message-ID: <adsyzmm3WSZ1ao4a@gondor.apana.org.au>
References: <20260330100800.389042-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330100800.389042-3-thorsten.blum@linux.dev>

On Mon, Mar 30, 2026 at 12:08:00PM +0200, Thorsten Blum wrote:
> Tested on hardware with an ATECC608B at 0x60. The device binds
> successfully, passes the driver's sanity check, and registers the
> ecdh-nist-p256 KPP algorithm.
> 
> The hardware ECDH path was also exercised using a minimal KPP test
> module, covering private key generation, public key derivation, and
> shared secret computation.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 3 +++
>  1 file changed, 3 insertions(+)

Is there supposed to be a 2/2 or should I apply this patch on its
own?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
