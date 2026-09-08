Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB881F4631;
	Tue,  8 Sep 2026 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859373; cv=none; b=nv9AqsoiQ+DXMPIMV1/fzulaMtCr0If2DsRTifkLNm+V8pDi1BlFcvVwetoy1KoHwjlfTbDJ+mQ/YHHxGJLpH0uDVuCCrk44cJqDGdpfOUYKqbD+TsJjdBE1NB/GSMJK4iRyBak/cBo6yd/Wcnj8cP6Anm3JFEWoEtd2GIutGjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859373; c=relaxed/simple;
	bh=2tOnUhKZ6vqIkcQZ6zmT+pGMYjF5d/4/OuOQm5oDEFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmwYNSECYpd+SVv8FR0EAk5Lv0tKqbZXOmbN5JWLUSLAmEHg2OM2QkOr4A4NtyTntllS0/MCw+KZpVCq/mSOhghk9l/gsTSROJePu33AWwH7uHuEih78Y8SapX6azM3QfSUebfCy1jsZXckyOYzU0u1AIyRH3WySSIOriQaLDEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=XTYF6To+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="XTYF6To+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RLcfcZ2I8QX4qdQQiyxU4fXIYW6vLUxmkCmhpjwWLWc=; 
	b=XTYF6To+fBCNT9nEVHvbO2KOod7eQqQFQyR3HmEQK6+ZLZNg5K6lrHazd1j6SFdkqGWHDReM8Tu
	fEZr42bZywOJfscdb7vdH7/wUdPlxkmjsyykgj4lR9vrVdikJV6ww1SqJbUIfHZ72mzWE1q2+Lc4M
	ixykFENbNNnEo4c1rynuXWxSQet70mWDTGeEGbMq5jyNZmQ/U1soHfCr/4TeovOAXUQJYiFs4ow+s
	LN43lAXbG4qiMKgNbjnRIx26AsdP8ioQg1wxoa4YmVfHNjRlO+kvYxl6+oGm/h3qFZ7FNJ0KbXn1R
	VqUgagtHJ603w6JIOzNPUd+6FlGGs240Eh7g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x3s2F-0000000BnfR-2zax;
	Tue, 08 Sep 2026 17:22:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 08 Sep 2026 19:22:35 +1000
Date: Tue, 8 Sep 2026 19:22:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: amlogic: Fix IRQ handler return value and
 fallthrough logic
Message-ID: <ap_T2wCesl3whdJV@gondor.apana.org.au>
References: <20260821151243.8125-1-raizudeen.kerneldev@gmail.com>
 <apox0f2D6bYOYOnj@kernel>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apox0f2D6bYOYOnj@kernel>

On Fri, Sep 04, 2026 at 08:19:53AM +0530, Mohamad Raizudeen wrote:
>
> Just following up on this patch. Please let me know if you have any
> feedback or if further changes are needed.

Please repost this patch by itself since it's not really part of a
series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
