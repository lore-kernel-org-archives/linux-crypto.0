Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4F23D76;
	Thu, 11 Jun 2026 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168053; cv=none; b=VixGFDaSukWmJxPC1VhJp+QKpPlEUMKyKWCneP5FJftq9qKMzdGtq0gk4269YJovzI1KNH9e35NkPaSv6fdXRLgZPGJ/BUuqhZB26IKQ+TQkV6uAyBQqw9ydOPGmEvAodKwU7bCBtPSBfYESB6rJT36PfzZCFV3Oopz86vyztfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168053; c=relaxed/simple;
	bh=M+cUBQ61Srmxt6XFPltv9FRXDHD7Fyobob8NNiHAcnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hS2yT1+N83ByGI3zhIGg+L1M7yKR2gXrj4Wwx4DO+fAdKyXuOVcAFfMTHL0Rn7LnVrFYLLW848WhD92eR4bW4yiaINX+KRR4AdxSzUTyXTAHfx2HYLdg22retGBZPybzx1pziX2NHTFBM3peVv5dibkmBJIHsu085GxiQ2hUYAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HIvbi4vk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HIvbi4vk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MUHMqAo3ugkJlQ7EQw5/NEt8gRDDAZp7dOjD/4On6zw=; 
	b=HIvbi4vkfxLc7vIm1tnPzdvsNs306ER5vwg2S148SID/lAeHvRIuW9EiDmgdkbbxEbFDff4hhhA
	hPEEwrpXH3qqp6hU+n6uFjpR9TKQy9CiQqe8QzqLJBSx3c2jECDKhklmURv8I+V5HmKvKzvctZbII
	5XE32vlaEQ5uaOREvIy2KBnvSsvvwBZkdUXmTOaX3cVxQAqijKsTAXShyIgYYbyJddalUyYAMxyRQ
	OR3izP/b166mcYXKOhwhLNA7WH+Gzd1gDtQ2pklC5sIFxKmOhaMsbczEY3pKMcfrjtiwZ8wy+bJgW
	SptALvrenmInFWmZ7Pd9KxI2sZ88pBY+cmkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbAv-00000004XcN-1VyX;
	Thu, 11 Jun 2026 16:54:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:54:09 +0800
Date: Thu, 11 Jun 2026 16:54:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Felix Gu <ustc.gu@gmail.com>
Cc: George Cherian <gcherian@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>,
	George Cherian <george.cherian@cavium.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium/cpt - fix DMA cleanup using wrong loop
 index
Message-ID: <aip3sczoMrtq7qOf@gondor.apana.org.au>
References: <20260602-cptvf-v1-1-d68e58e59173@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-cptvf-v1-1-d68e58e59173@gmail.com>

On Tue, Jun 02, 2026 at 10:55:35PM +0800, Felix Gu wrote:
> The sg_cleanup error path used list[i] instead of list[j] when unmapping
> DMA buffers, leaking successfully mapped entries and repeatedly unmapping
> the failed one.
> 
> Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
> Signed-off-by: Felix Gu <ustc.gu@gmail.com>
> ---
>  drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
