Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C47342E436;
	Fri, 18 Sep 2026 09:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725282; cv=none; b=U04hixs+hfMmXEJ3diSs+UxCcxHHl1UgYbaQ+OnBvSd1tm39BCXYnB3f3iC0WeYZquR2BCSqzpDObOljmUDPBF/WtoNP4T2JRF2OWCJhLY0qSORDLHpOkytNoDimxdVNIrHQn7coa6tIt+zA7R7vgBEAy1VFtdmrX8NBza3XnDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725282; c=relaxed/simple;
	bh=QfYWwLAkImiI333+tIG+q13/b6GKvBLxca7zFYXjRbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b6wtaHSweZNuAxv/8sAE/4Lmvo4ng7ix+aqQBMjenQ9m0zhgwV2PivtkwQwqSW53PZGgMbtNqUwIjAccUKDTNQXs6SGU6RZ2Wp3z0rh2+Qp1ckoCoZro74asvieI4p5RykzkhaFf9UsNRYXR6OaMqg3TAsJPNqjy2Otf4XUS/cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UYfHUl43; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UYfHUl43"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Iz2d2e8t0wkEWqjMMjv5AWLmaohR4cR1kKJ341FT4sA=; 
	b=UYfHUl43RguOC2naDWh4jO8Tc/f+RdMOGDIz0BbvKRLTaS9XfLcfyeZENnBq9zPCKBDlw+uNIGX
	wVfComfvl7y0c8uOa+2phzUBvbwJvMiupQb41ZJeheJ0rLNSE7tbH0Zuu4zzCZH949hdHZGh/vQZY
	OPY02F25RPOD5WSrdUTO3hynbBu3eYUZGkUntlbBBO8ph+No5fXliiTpHQiANdOvzp5GC1IW4rYYD
	lzzAU6ZFhosYxekk/v1lRmoRLlydFOEBgKw3SK4jrQiFS05BunVRaoiiz0pj2ebxncjzwtskwzt8/
	Y1ufqRHcbz7jH5iRvsvi40TQ0IVDzAn0mWxQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VIb-0000000FM1c-0Jx0;
	Fri, 18 Sep 2026 17:54:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:54:29 +1000
Date: Fri, 18 Sep 2026 19:54:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>, Harsh Jain <h.jain@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Danilo Krummrich <dakr@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: xilinx - clear AES key buffer before freeing it
Message-ID: <aq0KVeDLBP11Eaw_@gondor.apana.org.au>
References: <20260908191607.405177-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908191607.405177-2-blum@kernel.org>

On Tue, Sep 08, 2026 at 09:16:06PM +0200, Thorsten Blum wrote:
> In xilinx_aes_aead_exit(), the AES key buffer is freed without being
> cleared, which allows key material to remain in memory. Use
> kfree_sensitive() to clear the buffer before freeing it.
> 
> Fixes: c315cb0005be ("crypto: xilinx - Change coherent DMA to streaming DMA API")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
