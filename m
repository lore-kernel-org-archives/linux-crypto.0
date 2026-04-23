Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A0320B810;
	Thu, 23 Apr 2026 11:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776942570; cv=none; b=BFD9G4Y7/+lpQFHciHSiFRBouWoqL/nbDM+P5lv1bUewxQbWj9y5uUXaU0KYDjMOCdSuhczXNcNOgvaC4qN3xO/smZLP5KgqynW2BE3XXz9BxNetbKqONidDEZI895jXlVqPTd7tQir7ZonrJqkGwbpGwt56813a4PU5T6l8DT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776942570; c=relaxed/simple;
	bh=ccu6EmSmTWTy090+Ka/iFmSk702D+KDJFdMw9SSG35M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fil4Vxuu4Wib+KXtEJDQlVRNVQrixvhAj/gqV3w5Wx2B6QxYkvpdDzOhqVwGGAOmPM24BloggMt+Vbbdr/7M5kca6bYnETgvRwGEEE2TXVIPiTNyAyG6+0togF5jSMmot3l9rCsn2ZlTZ7iY0c5dgSfhkxKLTpJ225/JiHzcOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YQXiwRPA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YQXiwRPA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xXwNgY+WRRCQRx1M0mqaUAIHObx/PwdHncNqoa+Z/Qo=; 
	b=YQXiwRPAdBDMK97uQ4DtCe8+qwsZ4W7mhOMNOYWqVs6kTyacEmaGoiWPhDiy2tB7Ho1RwIVPKIE
	w5m3txl34RAHy43RGnHnGNAq8fxAGTfJXT3QR5HAsgHI7y3LMlVN9XoCDn/YhjtjqMtDXOgLhNVZU
	Aws2E5Xa4Un0IyZHYurKG2PgHfnEZYjrJNFyDGFmRDLfaH+ogbwmV1KuzULz+jhfVjMvmbomEqLye
	Icxim6TGB0UXEeu0cg/Ag6snsSAXHKkbhuqdkKBfugz35MVHqBIa6yo1xhiW+10tLxD/VHdMA8iXj
	s6r6jJnB1dp70WOtt1TzsHMp1Alm7JtLstgQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFrve-008DiK-2T;
	Thu, 23 Apr 2026 19:09:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 19:09:06 +0800
Date: Thu, 23 Apr 2026 19:09:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - avoid hash and rng references
Message-ID: <aen90oUsJwvamhzL@gondor.apana.org.au>
References: <20260423065600.2081989-1-arnd@kernel.org>
 <aenfmxOvtHaAODqH@gondor.apana.org.au>
 <1cd6ddc3-479c-4cbf-8315-78bc53ac3a54@app.fastmail.com>
 <aenmEQNhhw9bnxEa@gondor.apana.org.au>
 <3948e39f-dd20-44e2-b264-dc2a0a88f5b5@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3948e39f-dd20-44e2-b264-dc2a0a88f5b5@app.fastmail.com>

On Thu, Apr 23, 2026 at 12:26:23PM +0200, Arnd Bergmann wrote:
>
> Sure, but I'm not adding new code here, I only reported a regression
> from Eric's (otherwise very nice) cleanup and tried to come up
> with a better workaround than adding another 'select'.
> 
> I've tried to rework one driver to use IS_ENABLED() checks now
> instead of the #ifdef, and also replace the for()/switch()
> loop with three separate loops for simplicity. See below for
> what I ended up with compared with my first patch.
> 
> I'm still not entirely happy with that version either, especially
> since this is getting beyond a purely mechanical cleanup.
> If you think this is better, I can do it for all three drivers,
> otherwise I'd just send the oneline change to work around the
> third driver link failure the same way that Eric did for the
> other two, and let the sunxi maintainters worry about cleaning
> it up.

Sorry, I made my comment based on your original patch only which
simply added ifdefs.

Now that I see the wider context in the driver, I'm happy to take
your original patch as is.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
