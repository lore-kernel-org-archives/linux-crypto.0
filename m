Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB59226CE0;
	Thu, 10 Jul 2025 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752134914; cv=none; b=Vb6q01ZMsLPFeXrNZg2+I+sbIF1nZ6pqvKJPifkJQku99mXStQKOQ9EDjcGJJW5jeAS21KMbryeqgyKzjQVJJNsv9lLDHJlNGFDNHeY97PCMggl5+Eow0a/SYWFau4cFzZGUDVSyTxLVi3K/f+VPerC8V5Y5inkU4MylVyyZnuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752134914; c=relaxed/simple;
	bh=6ctZAJksvs+Z8bSZM4K5HcWTAqZv1Nvb8sFGXgBLHbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=envG9ddjI3xKf5GBULq39bI90mGx4i7SnHWx32qog2bNjzSpn3x1YugQSNWwSa3RIrzjZYDaBgHp18X8p2APWBoz5F585VxA9FeRTMQnJdkprLC7IDQxiKGOrAEur6nooazbYjM2WJFTxsUxnsROSWXAsn6H0hUvQW3VAEu5dac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kFcHmoUx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kFcHmoUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h2M9UzPooAH4xms8AQ/UUyaHRr7orBGN4WSmNKt0TTs=; b=kFcHmoUxWcjbLkrbePzQ7yVZrF
	FNB7PpULB3X+20i/zjqq83O44Q+yB9JeDVOek3lqoIvg8QjYO8D6HwQ07aFKlNqp2IPFCCY5JPjoh
	Ab+lAfBWG/ImFlJT9RSwzZpyjdco/Lhnr+w7MIr3k0YTC7Ivcp7uu1Jn0irNMOTNPYbbh6fF0VV2a
	/dSZ7kTfEbxDXVj6dVz8zqF2L1SCdA7xFYCFjSQbrmmqcBhbMCpodA6eYvpPQIrnj78bcKaNkgim1
	aJX7EkhkbekSEb8CjE4XSz3RYW2ixDvg4wXTauiWcroWP5j3BUlmfQbqEl5aTGxN/ZPeFpZah8x9N
	9mI5U6kA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uZm4f-005Olj-1u;
	Thu, 10 Jul 2025 16:08:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Jul 2025 20:08:05 +1200
Date: Thu, 10 Jul 2025 20:08:05 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexey Romanov <romanov.alexey2000@gmail.com>
Cc: neil.armstrong@linaro.org, clabbe@baylibre.com, davem@davemloft.net,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	khilman@baylibre.com, jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 11/22] crypto: amlogic - Introduce hasher
Message-ID: <aG905asYccnkO3P1@gondor.apana.org.au>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
 <20250624135214.1355051-12-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624135214.1355051-12-romanov.alexey2000@gmail.com>

On Tue, Jun 24, 2025 at 04:52:03PM +0300, Alexey Romanov wrote:
>
> +static int meson_fill_partial_buffer(struct hasher_ctx *ctx, unsigned int len)
> +{

Please use the new partial block API which removes the need to
handle partial blocks.  See aspeed for an example.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
