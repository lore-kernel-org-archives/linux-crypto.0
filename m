Received: from abb.hmeau.com (unknown [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8A529D05;
	Fri, 25 Apr 2025 02:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745549425; cv=none; b=rLie+E/ak5wdlsyK6N4VTUxWcQcU5tBY5K/ZP1Z2hNPpRZovafMXAgy6swON61WogYyXxgfyhPTabOFKgf/FMbauAmBpBh9WEjWXRRO069Ea3f5iJ61nQ4s73EXC6NQ5dF+uJaRavOGCmT+4rBc5YlUcJHv3pbH4/eil5AJHW9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745549425; c=relaxed/simple;
	bh=r8mHunVlq49P5IxUdHY3/lnK36Co8V7pk9knPjWzEtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHzALkHSq5XktWM91NyXqSY4WQR+Ur6GXBdubkeYGAMKR3qlPejQjxQ0utmXHlxs7TC/ZmrFm2D/0jo8ivHJkCY2E8+SmNPsLWQ48bGjdJVecAttuvROf3kOO9C4C3hfoc2guddr1a1yaHBLqNEu7z2f1ZX0HjRJIYTxpyxkLiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FqqAK3Yl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FqqAK3Yl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ifAmGRLxgSXeOVYd6H/dg41LDvyQgzkUQ0ByWFHsOwU=; b=FqqAK3YlMEpfYMIAXk7Og2rmTZ
	DlohGcEPPMRWFdG75VsIvLuw1fQCh3XJ6XOKs+WgZ9QdOQyS2ih6zJqyvNQpEMcYWRRhmXdGk8KT0
	LH+5EOCQx98bC6fhka5e1R7f7+nGAlnYD0FKjfKDfsbkbCSs/WwLsmD8i6B/caGbNu+Gi3wHwltH7
	zIR4EeNe/VdtnH10z+zPB7oQkx3QjdIAp2w8A39syucERlsOao5dTRUmB4XOUlw+gT8bNd4Hj1D6r
	dWRNNy7IzCaPJ2vK89iViWvjNNmJsb8xgKu0Z0MeJKXrrcFn9Mn5qyamEuL0k3hSISvn2Mj1tR7G9
	9COrEfww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u898p-000reU-1c;
	Fri, 25 Apr 2025 10:50:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 10:50:15 +0800
Date: Fri, 25 Apr 2025 10:50:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/9] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
Message-ID: <aAr4Z1iLDgKfyLyf@gondor.apana.org.au>
References: <20250422152151.3691-6-ebiggers@kernel.org>
 <aAoKDnfJLyI7n58S@gondor.apana.org.au>
 <20250424155617.GD2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424155617.GD2427@sol.localdomain>

On Thu, Apr 24, 2025 at 08:56:17AM -0700, Eric Biggers wrote:
>
> If there's going to be a dependency to keep most users from seeing this,
> wouldn't DEBUG_KERNEL be more appropriate?

Sure, I just don't want Linus to start bitching about yet another
new symbol.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
