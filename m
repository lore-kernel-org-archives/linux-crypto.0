Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1582B2AE90;
	Wed,  7 May 2025 00:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746579244; cv=none; b=SC98fbwWxVib+JyYy5G9MwTDWGjGWhIuQ+0BvBHKXCI+1Cxha3shgMlPSqO6Y6HdoLEprWazCWJTzYL2OPzF85GMgJ/7OIuy2HclXDwaF4wN5a2Y/XfkQk6kiJ4I2zWvdc39KNSbZruaXS+zQ6dOa2SDvz7Vtjn3bPIeLdhr+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746579244; c=relaxed/simple;
	bh=yzfCPq/Ea+XrfZ+ASW4eXQTefCsJ1DxMN8WM7TXS6Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeBsjLSCwAN94BA40cxxoVtnmU7pYCAYauER7HjJbOmejIgcmqrvDqqBKcBdJwpocJaAzHx+mAJfAEaCcfVJxKqNgMWjFSwftLcb5/R64K81GXnSJ+PA+2zhyye81DvKdj1Roxxh7O1PBfiqMOq73MGAIxLuZKXcOqDOE4hImws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HdqA9uuT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HdqA9uuT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0+Av79XTudTREbKPCka69/drhNtVkapL3EfXHKAHlkA=; b=HdqA9uuTb96fPwW/8K/1cdOG6R
	b08wjkMpC3/PIWcPuSaOBgyFZQIePirN8qB2BoQ11YAXDIwqTe/VSMJbCVI/PtWPQHrshFvpsMp09
	AcwqjRhrk80rB01caZz8yOYt2UwHnrYkgg73HfH7/4Ap4/TOG9S6vFESOx/EIg9+Mmsx4+csh+lkm
	6TMEzGhZKKVH2DA68LE3+WYHG+9qua5ILOK5wKtSczY1TwJXlO9BX3mVh7J3MFld23kx8cK2sQUqU
	D7KHBg05+jM5qDpnSefQOmrf46wp/NGsq0KqpAjLe/0GlchMspGoD5aqmD4FCZwpaNcRU65bZbGJ6
	3K4/QB0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCT2q-0046KK-1q;
	Wed, 07 May 2025 08:53:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 May 2025 08:53:56 +0800
Date: Wed, 7 May 2025 08:53:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Wanner <ryan.wanner@microchip.com>
Cc: linux-crypto@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: crypto self-test errors kernel 6.12.4
Message-ID: <aBqvJJdXMcBpp9mC@gondor.apana.org.au>
References: <468a8e17-d564-441d-9893-72b0ed48d8bb@microchip.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468a8e17-d564-441d-9893-72b0ed48d8bb@microchip.com>

On Tue, May 06, 2025 at 01:12:31PM -0700, Ryan Wanner wrote:
> Hello,
> 
> I upgraded my ARM kernel from v6.6.9 to v6.12.4 and I am seeing some
> crypto self test errors that I did not see before. Shown below. These
> errors are different every boot and I did not see them on 6.6.9 kernel.
> I did notice that when I compile the crypto HW acceleration drivers as
> modules like this:
> CONFIG_CRYPTO_DEV_ATMEL_AES [=m]
> CONFIG_CRYPTO_DEV_ATMEL_TDES [=m]
> CONFIG_CRYPTO_DEV_ATMEL_SHA [=m]
> 
> and have them loaded by systemd at boot I do not get errors and all the
> self tests pass.
> 
> Is there a race condition I am not aware of? Or is the new asynchronous
> crypto tests creating bugs in the HW acceleration drivers.

Yes that's entirely possible as I think it was around that time
when the self-tests became concurrent.

> DRBG: could not allocate digest TFM handle: hmac(sha512)
> alg: drbg: Failed to reset rng
> alg: drbg: Test 0 failed for drbg_nopr_hmac_sha512
> alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 90 at crypto/testmgr.c:5928 0xc0397fd0
> alg: self-tests for stdrng using drbg_nopr_hmac_sha512 failed (rc=-22)
> 
> alg: hash: error allocating hmac(sha512-generic) (generic impl of
> hmac(sha512)): -17
> alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 53 at crypto/testmgr.c:5928 0xc0397fd0
> alg: self-tests for hmac(sha512) using atmel-hmac-sha512 failed (rc=-17)

17 is EEXIST, that may actually point to a bug in the Crypto API
itself.

Could you please test the current mainline kernel and send me the
complete bootup messages and kconfig file?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
