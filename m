Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793262178;
	b=2/XHweQq7/E49WpzxoM68htXugT++8gfcEmjbfd+kvi7m1QTYalQM5yNYxUzHcmKDZNo
	 3i1gLG8t6THO4eRVub8SvD0wV2s+fCIlO98avxqto459JP5cQEKNJBFM4nRWDN+UCLx8z
	 5yVsowwr5D0OY9WfeyqLFVS3ilMa6YZSISzeqxKvgsjhNclGW5NAkp3lCO00gIwpDKWTZ
	 pw8DOrwYBEhJ6nDtTZUtrIkkbz7jzWTybu+72Z7YhlO+gDZV8XD/l8MLRp7SC8xhfFaJA
	 0BG8etGm/QbI4eFVMjuFyOMBxLJApjeNUtzdhQLNbuxtoCi6/a4zFnpIGYnm5AQNSpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793262178;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2apa8Mr/pCcSFyuTTcmI9mAPuP1EGz22opH+X2kB18Y=;
	b=EiUc7dVk652t/kTZUfngxT1q6ueuEUZ0x+ZONB71FQeuFpxyl2aA4IhK0fjUDPCu+18h
	 JFU4SWexqq1X0P59hc2chRBxxeuCrTjO4ljp3WKpNhqeYiwYtUB9UYYqoRiWTin+6JDKY
	 THPrT69P486cFbJHeoHDTuAIvdA4Ye6QNN3T98PeiOjXWG97nrihNbItKtpPmF2c+n2KM
	 oSy5MrWrz8d3f1qP+2qwiEPTkdOgf9VGTkAMDDHbhAfby8K6NLkSigbEmdhdiPJZkmT4g
	 wAcPYSpZscHCY0f8+UlMex6zVWW2GLH2yG/HjAbOhIFn8Xkhv3ZIyJHTDQipa1yy2PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=UHmLTmmx;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5B7606A31C;
	Thu, 29 Oct 2026 08:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F5B7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=UHmLTmmx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2apa8Mr/pCcSFyuTTcmI9mAPuP1EGz22opH+X2kB18Y=; 
	b=UHmLTmmxsQXWP79uUgFoAw2NJDK2NcG91qq8NUxO8PYoCNxAbqtAn5bxrjB3K3d6fhnDZf35Nh/
	7ayNPUu4q6o/SOeRc31+HInmDlj0qLHaWuh4ikJZ2H/qa3CFz20nWDAlMc394xpqr3538+KzpiMoD
	Uh56gWhTFg12MubXPjP0caNCb+dlFP0UKOTUwwAtXOVxhyKx/WfGHReQ5Aj2FVOGjHTlbsMMylb/t
	bb4VRAaYPYGo86gFO15cfVyAbrsiz/YgUVwBCZ4caDV/SbMzozdIMaNFDh7O9ySIyQNjuG2ZLLGvG
	NV7T0J/LrWlMLnvPgl42t9aRP6wloAC00xXg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMLPL-00000008gDW-1lPL;
	Thu, 29 Oct 2026 16:22:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 16:22:47 +0800
Date: Thu, 29 Oct 2026 16:22:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 3/8] crypto: acomp - Add trivial segmentation wrapper.
Message-ID: <auMCV1AFlEFuJnk7@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-4-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188655@kernel.org>
 <CACpmpodu3C=uYH6dmFM-xkvdJxiRDjamRKs1Q4jU6_KKjFWNqA@mail.gmail.com>
 <auLbyon-KaV5Sw5_@gondor.apana.org.au>
 <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpofcd=ZPKhAoHJfvJU_JZshKs1GGJZf5JhjAW1PZzDq-Lw@mail.gmail.com>

On Wed, Oct 28, 2026 at 11:03:55PM -0700, Kanchana P. Sridhar wrote:
> 
> I was under the impression that if acomp_req_on_stack and synchronous
> tfm, it would go through acomp_do_req_chain(). Please correct me if I
> am wrong, and I can modify the conditional accordingly.

It's perfectly fine for a stack request to go to a sync tfm.  What
isn't legal is for a stack request to go through an async tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
