Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1F61C5496;
	Mon,  7 Jul 2025 03:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859029; cv=none; b=VU7ptOtd5zbtyxqa+b2MDleTHBZQ8DtYo/97sXhYvgHDqoGkeIPLGsVxeRQmMJeBRll6VUi5JguB3CxUT4rYkQVkZfiMnallojQTIIQ/yZzaI+ffhvGufQKGRSf/7SUC8CXMikMTuRmGkCXNPEXXuyZfiL4frl7GmcY7MT6sYfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859029; c=relaxed/simple;
	bh=zgWUWXnoOgs4WQuXqxUYSa99tUfMSnh9VTi0Y3wUe+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSNOAq9Dv7kGfqfvsac9hlhRT86Gx3RiU/+K41vrlvnDzYkhqZX1QSZw5xaX/EvRESKZaymX8IE0ntthbUcXcwAGLq/DkjdjNzBhuOfp8k7xsXo9pa43QrKCCQBTP2D9wY/WXJk9vl6qhgROi8BjX31xJAxA1GEcPJh07eqO+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kP8AdzW6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kP8AdzW6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P42oqXCvwCJVBODBakO9+1nFTMsi65NMFfVdfyqI3BI=; b=kP8AdzW6dCKfboNvFPIeFURHjh
	5PjGFmVcbTJrGZH/VeEuJ5//mjuSgBSUsmGaQQZhDi9NASRXdbQMo3+bDkuWP2v+MwefmdcWc0m8H
	DOinMvWTgsB/4UBZPpA5rAVqnUXOyUtpieGvryvaX2KFAtdDsdTq+5P2Tonqb6y/fvncvOgW8WOUk
	U5GjK3FTRVkCzMorpq3pjB3Pq+CHYRdGuI9oajnradFupMmuehdcglFoKP/z/IJA4P8BglqKJpuQG
	DGoixtx5Pi8yyMmExjq6iY8Ni6GAYuoAci5ywmkq/RJGc55UVQzSNRaK0dsIk2qnmquWt/B8VupSk
	IaAVHPvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uYcJC-004Vag-2H;
	Mon, 07 Jul 2025 11:30:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Jul 2025 15:30:19 +1200
Date: Mon, 7 Jul 2025 15:30:19 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: inside-secure: Fix `dma_unmap_sg()` nents
 value
Message-ID: <aGs_S7tDvsxXtJO9@gondor.apana.org.au>
References: <20250620072930.8223-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620072930.8223-2-fourier.thomas@gmail.com>

On Fri, Jun 20, 2025 at 09:29:26AM +0200, Thomas Fourier wrote:
> The `dma_unmap_sg()` functions should be called with the same nents as the
> `dma_map_sg()`, not the value the map function returned.
> 
> Fixes: c957f8b3e2e5 ("crypto: inside-secure - avoid unmapping DMA memory that was not mapped")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> Reviewed-by: Antoine Tenart <atenart@kernel.org>
> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
