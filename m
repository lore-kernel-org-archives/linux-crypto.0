Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41555158553;
	Wed, 26 Mar 2025 03:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742959854; cv=none; b=hBTU3Z7k/Qafkh3SSFsd5PHKnvSuzmDManeIrVivYsKbnBgD7lNE44LTPdf0AwyIKtVQ6mnQrvgR1SOeyN5aEWr2xKPqFg2/XK4V4qhXNuFPWnRcBMG6cBxUkdq60llOUrQz2UkIfEZDfxDNpxgyJ3f/xdxfWa+D6k5ik2na9Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742959854; c=relaxed/simple;
	bh=CmFZuTZqpUHcAPdxjucE/ujNFKYz4hO6s1uDMwERr/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckkdGQpdQ+wJy5wrRSuIKPslSYgvjjPgbGSJNf5x0n1mnf+oTA9B/2jR8embGOJwAWUkJiBr6etbjmpko06FippP1RGys5CWVcBVa8K1OCvYaP4Ipl/dOi1FeUmukwuzXixBfn4wuKnUTlpeYLj9ij32o3DtVbBCakBYlBK5aKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Y84xubhg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Y84xubhg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BL463vqceJgY0uFH+z227Doj3LriW5S/gxV8lhy+OdE=; b=Y84xubhgNm2M2v4Zo6KT5ziZ2f
	4/BjbvRTjuMXP9HmxkaU9Ewg5gdGWmhFKXuSNylNAzWn1BTeQHMYMgtgNHbEuEzGDzpP4VEDZ5tRb
	Q4fMoh6WgHMkW/bag9Dijb5PCuAeRjJwEz0u9BTlM/xeoe0JEkjCjWLSdUYMgKJGlqRJ/qfIqGuSg
	P7AeS/uulKush2kEbgIQRBOR/tlpWFnKM4+h7Bnc8pCNSPpduzWPb7PM8XgqDmTKbs0LlYBsSWqh1
	LCsiSTJSvhaCFgPhbxUDtT1fauF7tJ4UO9d1QKbG+wV9lQsIy9sqU94QTw/E25eQc98TodFVFipzE
	g2l1UkBQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txHTT-00ABDQ-0G;
	Wed, 26 Mar 2025 11:30:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 11:30:39 +0800
Date: Wed, 26 Mar 2025 11:30:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <Z-N033YKCBNchfzA@gondor.apana.org.au>
References: <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <20250326032038.GC1661@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326032038.GC1661@sol.localdomain>

On Tue, Mar 25, 2025 at 08:20:38PM -0700, Eric Biggers wrote:
>
> I'd love for your work to make my patches obsolete, but unfortunately your
> version is just worse.  And besides it being very incomplete, the main issue is
> fundamental with the design.  So it doesn't really make sense to use it,
> especially when I'm going to get stuck cleaning up your mess again.

I haven't even pushed the bulk of my hash work and yet you're trying
stop my pull request, so it's your way or the high way.

I don't see how that is constructive feedback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
