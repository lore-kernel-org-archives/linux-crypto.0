Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2628FFE7;
	Sun, 15 Mar 2026 23:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773616892; cv=none; b=eG4xx0b61cThY4cs7HUGp0wmgLlMFmbVnD28hw1ovT7N7oNL4FhDmmLMME1GCUczN/D+LxPxyqb8WkmNNEE/N3lhciqybbG8TJifTV+AMNL7HpSJgor/WS8FATCE8CED9DSaG72lGxe44D7C7S8ABCQlPki62VgU1nFnuKju9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773616892; c=relaxed/simple;
	bh=dXJcoZ8t/3SxXewi/owm+Y0BKA0zA09l3J0VgHFBcVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fX2/+3HxnA+5mhtBLt11TFKE3hQDh9CNXO7l56wMnZpgiXaGqwN+4Rcm4tYD+0UN3Uc3iY9x95WcDjxCYxT7eFN8LSm9LcCIHxcFLbJ3TxoiXBufR+D3Le+SmytFAA4RLqr5/mVMxeV2AP1fk2UUN5npgWoc2JIVvaRwRXRFy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MoxBjgcG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MoxBjgcG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wIzof5uMfFAlq/YkbW90WMHyCk3LebQ4QmaEMSrM14c=; 
	b=MoxBjgcG3VNAcppuB0AbYzC7W+XR/JictKa0OyeTbPsZzWwwUdfeu3Pv5uvJrm0Tbndb4nwW5Jg
	kkDztmwQhMc3j4fZBICT/LAiVXxDnXYzSCj8p4eH/E+a7pbPyLTf7qjmisLwHGqsk67qmNaCmXZcL
	lfcyI3TSpGv3A1Vr051YUjAoGkhCspQD3dTI5Mk64VaJ+9hjhgTyEiVBTE+kGRJngdwmJvbDDnJX7
	eH/fLLDn4IiL3Kr+RV4JT/fFqRr+JRwN9zt97CPu1c0bR7S7Nnu6EVZlLKEz7lJNptNggnnzPPj80
	cCvjOAJlMrS6Zo/zu5560irX2gGn4MyZuHAA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1ulY-00EgbJ-1r;
	Mon, 16 Mar 2026 07:21:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Mar 2026 08:21:00 +0900
Date: Mon, 16 Mar 2026 08:21:00 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - Fix potential UAF and memory
 leak in remove path
Message-ID: <abc-3OGP0kJpWfo3@gondor.apana.org.au>
References: <20260314193627.728469-3-thorsten.blum@linux.dev>
 <abY2HdOs0768G8G3@gondor.apana.org.au>
 <abcMS4YYrHOF6ud1@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abcMS4YYrHOF6ud1@linux.dev>

On Sun, Mar 15, 2026 at 08:45:15PM +0100, Thorsten Blum wrote:
>
> Yes, it should be safe since explicitly unregistering the hwrng removes
> the devres entry, and the automatic devm cleanup later essentially
> becomes a no-op.

If it's safe then let's just keep it this way.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
