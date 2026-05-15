Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC73CF024;
	Fri, 15 May 2026 10:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840618; cv=none; b=X61dXQWPzD1h/4kLIx07xE/fw0RHFm7DEy963JUtQjGdjIrmVPsiJPHNxckRKFAXDrZrp8pnAgVU8p/psTvJwAAyh8U/oMW03ksR0p12exYvxq7K6Bv2CAVwQaJbGkgk//YDfbDkQDnGYH9ZUir1MzHTXRUKq02q7z2kRvP155U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840618; c=relaxed/simple;
	bh=cdCP6FfFRs0zfarEOk2jjROBqWQ4s+QYI7x5tW3MIus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOeWPNZ4N5WOq0L3yI69sGF3ekMa1xMVWdkwBektjovG11rRod9A5lx4KUhWv9UCkvmpH5Wg6OU8ARtZsDJi1K4z9YOtgOpC0Pa3MC3Xgsk0EI+12kFSg7LS5nsXdUhFbFNg7q+eUE53zfgHxLulpLFnycubE9MCCmte5vfXRTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mV3Wzn2l; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mV3Wzn2l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8NnQR+jyfhEOUkjyMF+jpjt0gX3QhcoeRSCdVZk1re4=; 
	b=mV3Wzn2lV+cbkyuRsOmnSA3nyP+MBQ6knKm9KkLAi9UUPjiQViaL5XP+t3ZPbMnYBzHbSMx+2LH
	UJcq8kPJTFwRXCxT3G7FsZQfWeQ4JFkPF2rVi5X1LxMcVsxlSVcjC/aJZXwMDoWUhc8FVwp8SYjzv
	5ERkfSdYC4jtJwPoB8Hvb7RzmRHK2h0vlJKXjWhXUVQiD2itdCYYl5qSnX12p2p37UPhhCshlJAYU
	nUtPQFY6WkrbcumiiVn4b9QkVpz0PVYaL18iPun3QdQ84Aqjo7ZXfSJxxLOcP2kFWtGLIqhxjfR81
	k1OxzW3R0qWYjpHti/NFC18vT7BHWojgzuWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNphI-00EOXt-2Q;
	Fri, 15 May 2026 18:23:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:23:12 +0800
Date: Fri, 15 May 2026 18:23:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - replace min_t with min
Message-ID: <agb0EIfOeRSRb3f0@gondor.apana.org.au>
References: <20260507135525.331107-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507135525.331107-3-thorsten.blum@linux.dev>

On Thu, May 07, 2026 at 03:55:27PM +0200, Thorsten Blum wrote:
> Use the simpler min() macro since the values are all unsigned and
> compatible.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
