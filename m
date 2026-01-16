Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7E134B43D;
	Fri, 16 Jan 2026 06:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768543506; cv=none; b=AgHP22Io8wMeGkxS7SOm+/VuCpk1xQ/UzTgtqree+bycKSro+vDxLE+xzS7firIOx4XHnIh922/zbHhFbAuD/Aznyx33MJDxYAxl42hnX5qHqCnFAJCVsNTrAeGGmji9/43QF2Hgn0sBnBnz1/sYUZImtQ/gZ2bbFOovEbzGZBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768543506; c=relaxed/simple;
	bh=IqQle2c3cLnajUOmPP3yALG8YwDQmxF7C6hk7yOpfoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSEShI3+gIO1rl6AP89S5s61bApFOb6Z9jruljgIwMvgQPNa0zP8az1fZhV+EiSYy/NbMGmAoy8ctIkFMmNE0hFJZi0UE2/2+/toM7IKQNfXgg+8y3sX0xekEtqrnEkEvVMGR0PICP1yxEzz7Bn0dtgV/IO9/SHIvPQC8q7gUnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UdvLe9Iq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UdvLe9Iq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0ZyB5zAD9FMNH022ny69PadGUOzgneEmsRQhRBlpFjU=; 
	b=UdvLe9IqAdgcZqWxQEPDvxjApYxVgKox6gukwm7TYfI2CTTOSfQDksYn3NxxF7PA369TX7XPLpM
	bqCS1/2c4cUyvz/QzbDUOC7j9lk/gEGZv7LdBjGJNXDiUfxuzyREwAWodTDt3fOWtm914ZD8ppWrs
	Vpvrh9UdaUjTObr/mz6o+TG/YvJOIF9W4F4MOBygiO+8uC/RihIPuzx3oUfmofAvIg5f2vRZh/Kv9
	Sr6qE0rbowsG2vBEst/I29aVhHoqxTe+757ta6RzepkoP8sCHItJKtmpYBtz0jqUmEnygh9QEwDuA
	0XBwcV0lyiveeFXJfHl6/gLnRrAnP8gWgBHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vgcwz-00HDMs-0F;
	Fri, 16 Jan 2026 14:04:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jan 2026 14:04:49 +0800
Date: Fri, 16 Jan 2026 14:04:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: George Cherian <gcherian@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Daney <david.daney@cavium.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cavium: fix dma_free_coherent() size
Message-ID: <aWnVAavYGnsLHUCD@gondor.apana.org.au>
References: <20251218095647.45214-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218095647.45214-2-fourier.thomas@gmail.com>

On Thu, Dec 18, 2025 at 10:56:45AM +0100, Thomas Fourier wrote:
> The size of the buffer in alloc_command_queues() is
> curr->size + CPT_NEXT_CHUNK_PTR_SIZE, so used that length for
> dma_free_coherent().
> 
> Fixes: c694b233295b ("crypto: cavium - Add the Virtual Function driver for CPT")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/cavium/cpt/cptvf_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
