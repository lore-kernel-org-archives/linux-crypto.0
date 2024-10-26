Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0251529CE5
	for <linux-crypto@vger.kernel.org>; Sat, 26 Oct 2024 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925633; cv=none; b=kNLUsSFmGQh4Byx52xzY/mBfYzT25MR78bFtkrugvKlZHsXGsWSJDcBxOtlJU3ErymUXlnGa2tmli2HH38zYL0yn7szvfubxd7lupH8eEdN+Usgs1yn5aUZAISIUderfJzabbXw3Yf2ooeRLwoh9UY25kBBb+bPVB+SqLX8JGXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925633; c=relaxed/simple;
	bh=fLM0CE/I6wlQ9c3xBdYql1PCYyKpFlHxCHAQKpmAGME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d5WlL6ZPxQtZo19U8327SyT8GjugSV1YjBBH1+cuMuQsKNjbtmjF5fanASe37r8afJntfAMDJ7Lpqn6QUHpyoQtiGBLbFACJN6FocQOPxZcKKYdTs0GxAiAs/jC9bdfOjKQfNP1rwsPlavtbNZjDdrAR1cJggyLDE7CAfqrW7LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qqR9HuB6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qqR9HuB6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=heJGTeuJHY2QjZr2LCFkOEsLDrkfpXMbbCDZCZ+kkUM=; b=qqR9HuB6eKmxWOk6t8ms0lWOwr
	bU/2pb66G2c5TZgTko2l9k7LUcUTrX8Q18eWvqlNzWHp4tuNU0PPnWBBIhLjYNTCVi07t0MnHpwml
	+MqNB25Ic8AqI9j9roDtH2zR/ahZnJ8Xp6K/LJm6z9bvqjrHokMIR1o878n7Fj+F2M3nMpdah5G2o
	tIK6jZ02dcslMKbd0esI+HOsXjyzsW2FTHWKEvCFyY2BFlUu9EDGPzOP4gNdjArRLdK9VRmNy/oEI
	xlyBnbhQc7wOlbbjHZvfJzEjyeXzoK3RzSEu6aX1uEvim0VvG7QygqcqiL+mrwdafE+CTaaHSCZJ1
	Ieb5wPWw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ag6-00CFsG-2z;
	Sat, 26 Oct 2024 14:53:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:53:38 +0800
Date: Sat, 26 Oct 2024 14:53:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ecdsa - Update Kconfig help text for NIST P521
Message-ID: <ZxyR8l6odWaDIBOO@gondor.apana.org.au>
References: <e843333c7b9522f7cd3b609e4eae7da3ddb8405c.1728900075.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e843333c7b9522f7cd3b609e4eae7da3ddb8405c.1728900075.git.lukas@wunner.de>

On Mon, Oct 14, 2024 at 12:04:41PM +0200, Lukas Wunner wrote:
> Commit a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
> suite") added support for ECDSA signature verification using NIST P521,
> but forgot to amend the Kconfig help text.  Fix it.
> 
> Fixes: a7d45ba77d3d ("crypto: ecdsa - Register NIST P521 and extend test
> suite")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
