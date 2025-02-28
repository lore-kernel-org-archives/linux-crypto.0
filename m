Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7581ADC75
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 04:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740716096; cv=none; b=djKbucZDtW6Pip2nAMGaizsd8QCZHXx9p1TUMjNujy5wfItt3KHF19qcB2LaoVjPaPXxQOcTAmJiKb8TTWgmUg2IrQSZC92QlP0fK3ob3v4UOUa5uLLhZEzx30dhsmmmpINu46YYCESuKWirc4Q6JYPfgi7/ianRH9UMvvBs3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740716096; c=relaxed/simple;
	bh=V0VDUJUjjahFu0PEnYR62aihHFZ+o798bTSnnlH3gLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Afc1hByvsc8Irl5M1ve55szqxAd5f2BvxuUKNf2jP6VnRIuo0c19rKvbitAJj3v8zmxFSZjyURGPoCFMspdJCtd8Vn1hDRZKQgaN+S5bNTNN62wO/Am+AyUNzuQ3TjsLl1MqD2UCIX1SV6kghWCsCG+CuYd9HtTPmyGn21sM8e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=nNrRKExz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="nNrRKExz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sfZMNl6/k9bmI5hBUjPMUDf77lJBEpd82TXltnS/CnE=; b=nNrRKExzx4qBk5UsObMJTM5pmn
	PINuI5kKmpMI2iqPMS1m644hfjahmelXgYtowq8VW6RGbWo4MsRnUWAjsor/55M1yhqNORx4FFTlA
	Bqc41I3vavxkBOragO0pYPKas0ZV3DO3WgbLyoS14rs4mzEutsA8FrGNXzhOFHlL07sihP1r3bvwp
	n4kEtfVzFJZQD9Mdw4DJ0Avsx1TpUEfR7UFCWtUrZk+emPjBomdvjdoARIX92uQJ+UJd57J8DoBNT
	FY56rDf+J7KGq8VOR2ZLdVISiJYR3TmVIIdw70HXoZShsLwMeHzeY/vx2yzPxag+Kus5A0aQQbRlm
	1EA+kYaw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnrlt-002TFq-1r;
	Fri, 28 Feb 2025 12:14:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Feb 2025 12:14:45 +0800
Date: Fri, 28 Feb 2025 12:14:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: lib/chachapoly - Drop dependency on CRYPTO_ALGAPI
Message-ID: <Z8E4Ncxo5VkqXFh8@gondor.apana.org.au>
References: <20250227123338.3033402-1-ardb+git@google.com>
 <89944059-872e-4013-a025-f01d6d2f51cd@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89944059-872e-4013-a025-f01d6d2f51cd@app.fastmail.com>

On Thu, Feb 27, 2025 at 01:59:42PM +0100, Arnd Bergmann wrote:
>
> I think importantly, dropping the 'select CRYPTO_ALGAPI'
> means that the 'depends on CRYPTO' here can also be dropped:
> CRYPTO_LIB_CHACHA20POLY1305 needs nothing else from the
> crypto subsystem. Moreover, CONFIG_WIREGUARD can now drop the
> 'select CRYPTO' because it seems to only need this in
> order to 'select CRYPTO_LIB_CHACHA20POLY1305'.

Yes you can drop it from CHACHA20POLY1305, but you must keep
the 'select CRYPTO' on the individual CHACHA and POLY1305 LIB
options as otherwise the arch options cannot be selected at
all since they're all under CRYPTO.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
