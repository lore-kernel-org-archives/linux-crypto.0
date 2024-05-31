Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C6514532A
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 08:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717144165; cv=none; b=CUn8fZNbonDwDG3O1o4xSoYIisF5qDbywqN5OLTI8FXUqM2xvYvfyOWiyWaCl8N/MAYN3OZxtE6v3wr5rxsIVeC+57s9sDw6SEnjgg0B85Tkp4ZPoAAjdUVWamwwEbO04ct9MW0e3yLn1KHxd2K3KayE07sR8Lpcrwa/8bIcsGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717144165; c=relaxed/simple;
	bh=WIZcZkIvC5nHKyifUKYq8m7uR0BlGdBdhehXVrvdXk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPinJkQS0uSWNpirXvcfwJXi7QatGKB3acLri5PnYG3VmdxBR+8pW9POliPkLl4azLZkPlcxAkVwTemQ9EZnQJH9mib2D4CQKTpKjhlEnn5GPtTgZ/UnBs3bSdsCqJhhlIuTefx1tAq4Vcltc8yI1Lw3YDL/4D0g4aIvNVUJUco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCxdV-00489F-1D;
	Fri, 31 May 2024 16:29:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 16:29:19 +0800
Date: Fri, 31 May 2024 16:29:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531063444.GG8400@google.com>

On Fri, May 31, 2024 at 03:34:44PM +0900, Sergey Senozhatsky wrote:
>
> So passing "raw" algorithm parameters to crypto_scomp_setparam(tfm) can be
> suboptimal, depending on the compression driver. For instance, for zstd
> (what is currently done in zram [1]) we pre-process "raw" parameters:
> parse dictionary in order to get zstd_cdict and zstd_ddict which are then
> shared by all tfm-s (as they access C/D dictionaries in read-only mode).
> For zram/zswap doing this per-tfm would result in extra per-CPU
> zstd_cdict/zstd_ddict allocations, which is a significant overhead.

If they share the dictionary, why can't they just share the
tfm directly? Or do you actually need to vary the other parameters
while keeping the dictionary the same?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
