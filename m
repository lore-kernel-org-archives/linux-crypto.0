Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D727F74A
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745511461; cv=none; b=BlnjYjEqBh+g6GH6cfj+miYo21KwFN2U7/tOFeVmR0UTQ2p9JcXb7S7QvWqub9cuia1Lz7QZ2kVdgJq536pyNaY/UwjEa1kRpB4bwFSvWyCXs8fk7UJc+p8VT/bRVMZ2/Geezx0vSzNLjONVUceQuJFvISZFYGkiY7urzlkZDrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745511461; c=relaxed/simple;
	bh=jB8JPU4OmOcyrZXpXeKhpwjBPvnEU5YZJrTTvpLMoto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eV5RwqS05KPUALoy6pvabqZNUU+Dkk6M6tmZSBiVJjrOWnXmushvreEc0hWbK2B3jwO0OUEw803Jb+V3Kz3KChKaL6raAWqP2e7N/Z9mASuublSneQuQ/o/1tTgq31ASridajJB271xAVM15rT9G7WFqgoKxRSUn9SxOPg2vXxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7NdmeHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7NdmeHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27495C4CEE3;
	Thu, 24 Apr 2025 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745511461;
	bh=jB8JPU4OmOcyrZXpXeKhpwjBPvnEU5YZJrTTvpLMoto=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N7NdmeHG3CtL6JKCppHnYyNKMNOslFR6W84Du0JvqOchhpBhDPZ0E8LyOhCEcugnO
	 Lbg7VdsALSQaVa0eUfq5NwCZTT0wo8vxJuoraSkbdDXliOqUblXx8NW3P+HZtapxiZ
	 9kAiPG5sEHFq7GMcpM34sscEi37C/rrg2Vlo+rEMXwQzXlZ231IhBDF22Rz1ZndKGM
	 OgNUihHgd8yU9O92u6W1Ijpz+rqry29JVVWv3SYlhyT4kS/2gIcsL0TegKSUDFBOWg
	 zbn+T5E4OWYRUJsvtkmsIOeXRJixs8v5cRyO5aeANTe+AqAFKckb1ZIzvGOMy7JpJi
	 5IRTL6/cZqh8A==
Date: Thu, 24 Apr 2025 09:17:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/15] crypto: lib - Add partial block helper
Message-ID: <20250424161739.GF2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1745490652.git.herbert@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 06:46:56PM +0800, Herbert Xu wrote:
> This is based on
> 
> 	https://patchwork.kernel.org/project/linux-crypto/patch/20250422152151.3691-2-ebiggers@kernel.org/
> 	https://patchwork.kernel.org/project/linux-crypto/patch/20250422152716.5923-2-ebiggers@kernel.org/
> 	https://patchwork.kernel.org/project/linux-crypto/patch/2ea17454f213a54134340b25f70a33cd3f26be37.1745399917.git.herbert@gondor.apana.org.au/
> 
> This series introduces a partial block helper for lib/crypto hash
> algorithms based on the one from sha256_base.
> 
> It then uses it on poly1305 to eliminate duplication between
> architectures.  In particular, instead of having complete update
> functions for each architecture, reduce it to a block function
> per architecture instead.  The partial block handling is handled
> by the generic library layer.
> 
> The poly1305 implementation was anomalous due to the inability
> to call setkey in softirq.  This has since been resolved with
> the addition of cloning.  Add setkey to poly1305 and switch the
> IPsec code (rfc7539) to use that.
> 
> Finally add a partial blocks conversion for polyval.

Why aren't the POLYVAL changes in their own patch series?

Touching SHA-256 (which again, I'm currently working on fixing properly, so I
keep having to rebase on top of your random changes which will be superseded
anyway) also seems to be unnecessary.

- Eric
