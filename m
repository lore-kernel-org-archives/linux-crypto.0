Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07BA2D94AB;
	Sun, 12 Apr 2026 09:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775985452; cv=none; b=IH3Qq34GuuL350IylIOB009HU0F3AB3YBo/wdM7tgzDXO/mXYgfUzn0E0olNs5+PswTI3T9bbWO/PQn4Qt15fl57GeBIAVAUdsY6tzDbXq7NXVVs1Q7XqaaQe/8guSNYFgfmqh8jyKnCJxXUbxrtKvRWVbQKxukZnPcAeTNc/4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775985452; c=relaxed/simple;
	bh=5lBlA3aOffLmWcszKTk2oUqx8otvxa1d/L/Vvr3aNMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=un/tUtbLBp+hQCgDvi5IldPcUkD683l2gpymHjEnWSqER12NnoqOF2h45LDywr1IklxawL3ihj7zg/kaIke+GwfkVPzU1rmUs6HtnMfsFq6L/Rx1o8v0Q8qmDAdXTxAioGajDrN+rcqYDfwrlY8ytO1YHrigcw6afBKfd66cVhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=tEGr0KiU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="tEGr0KiU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RmznhBhjXGDYV0incK6I0ZWQrf1f9ZaINeozsHiYOJQ=; 
	b=tEGr0KiU9lu9XtjOLj2gObVKsRIDEDVhqOM/QJxiEPvNTefAyyMe3/dHbf2Q/QY4937w5hkHsUk
	ztXJAvWGI7jspIuKY3ef/l4xgACKwAe9KH4mb1sTMO/C2/p2E0cUlEymQcZV1o3xXwveW/7gVr0U7
	NhH6LfDQPWgK/MG9tXjRBSgx1lf1l+0mENFSc6ieENnpJbE6VkcFVKfaoT/iZT8/1l06lIm9T1IO/
	pdOecmtBmNdsbZBi2Qs+Ti9rPmcFMVMz0AweJKgE/U56B9WUb8u88OEhPKZSFutCvN+Kfrj4NdWZ3
	mmiOyLaQZwYpINqA7MJ5GMV11OGIvbMQxiDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBqX4-005UVx-0L;
	Sun, 12 Apr 2026 17:17:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 17:17:24 +0800
Date: Sun, 12 Apr 2026 17:17:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: vmx - remove CRYPTO_DEV_VMX from Kconfig
Message-ID: <adtjJMlY1LoHDkkb@gondor.apana.org.au>
References: <20260404135203.943986-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404135203.943986-2-thorsten.blum@linux.dev>

On Sat, Apr 04, 2026 at 03:52:03PM +0200, Thorsten Blum wrote:
> CRYPTO_DEV_VMX has been moved to arch/powerpc/crypto/Kconfig, remove it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/Kconfig | 8 --------
>  1 file changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
