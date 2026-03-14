Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3901A9FAB;
	Sat, 14 Mar 2026 05:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465586; cv=none; b=AJ6Q3QdRV0+g1ypT/h0K0mD+SrGJxoEvNG9lijA/JbDopUWS0EGtZNA5TKNEq5TljZgoiH3lgC5N0mSE32YA4UYkmzXErVuDsO2314EtTAZz1QcvGxQCGSy83Dql/2p5IIqyUzaSBWfwGXb+Xf89zU+S+LVRng5Bmj+3iGwx31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465586; c=relaxed/simple;
	bh=qLSF+1D9x5Ndc70rJ2WV/M2Lizbuq0kgFRwUurKss3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZ2+upaVf/+fP/c3LNJNMWIJwfaf2mMfUVlJzvi2raWDb67f+HyOhCj8ygfeO/FkAiOUJRWIAwqLdh4fu/K4+eHMGfGjhES03HvO2rcTlccbVS7yJ9MXHF5Mb8mpL3I+x2wEAsefMEEQPfTt2N7JF/SmaOEoUAjC8VqZ8dAU/PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=o9QWdN3m; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="o9QWdN3m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4ganEGWFGHuFd3UguXLU26jhB+9iQmRxlL9M83co1XE=; 
	b=o9QWdN3mDxEP6vmfSPppBLnc71FViTcgayB9VNbNW21GOOwiKInNh5JQIZ0+SfDsBPTjBeJEVVh
	mEpC454OeP6SUowjbNPFGvOsTRNnhryCCSrjVqC6eqRLkVe5pKDqkMfR+1/FODlKjE/5f0AoJswnr
	I6lqwBc8sMdliNJsPlblq7a3gtC6r+Zm+pPt0qevdqe2xScXF0DhVP2iiZFeYG/4Ti0vwxqmFh+Bs
	Z9Sz2mWiBzz/U8duSA/M5ybXjZhtQgdeEAR6B8eXAelzFsejL3iSCVnipYJdR40fKY9wtphXK0jnY
	b02sS9J5nfaljgUDPO6Oi7odWnh7Ef7s8rSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HPH-00ELGD-0j;
	Sat, 14 Mar 2026 13:19:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:19:23 +0900
Date: Sat, 14 Mar 2026 14:19:23 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - use list_first_entry_or_null to simplify
 find_dev
Message-ID: <abTv22TkMal7_8CW@gondor.apana.org.au>
References: <20260308232230.544209-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308232230.544209-3-thorsten.blum@linux.dev>

On Mon, Mar 09, 2026 at 12:22:32AM +0100, Thorsten Blum wrote:
> Use list_first_entry_or_null() to simplify atmel_sha_find_dev() and
> remove the now-unused local variable 'struct atmel_sha_dev *tmp'.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
