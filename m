Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0453CC314;
	Fri, 26 Jun 2026 05:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782452856; cv=none; b=kHH8ZxwHSRpnufuUVrn06slkIY5mUb1KuwruKOolDw2LkNs5DH0DEG3vdkcBZprb9wvU4uctomFmQVcRNKmns4ouNk6HInfCgkLbwSY3bx+HRgkCWI8MB61K+0xcARWpd4jDWaJxcgwHB4vSC7n5uw9Mh6bCf7sAvRcB/XOAmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782452856; c=relaxed/simple;
	bh=lLPLKdlLEPPhxaA7zMCz8O1gDrQEutc8hG2DNwpe+bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lN1E+2zgMhlfkunjnpAw5y/xNjNFKSPFkFwlHXsUoiP2iFTqeXn9HThxkZJaznBF0/6QFkXmosF6HecdSQDTjxuEY9w3muoe04hSOpfoekTJlHTs4I9kgMzCiA/CfApj4kb/mY0ojm1BhO/BEjtpWpJCFsGP6iXkUnGhxXbXJrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD31968B05; Fri, 26 Jun 2026 07:47:31 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:47:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH 8/8] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260626054731.GC9629@lst.de>
References: <20260626043731.319287-1-ebiggers@kernel.org> <20260626043731.319287-9-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626043731.319287-9-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 09:37:31PM -0700, Eric Biggers wrote:
> +	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_AVX512F) &&
> +	    !boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
> +		/* AVX-512 will be the best; no need to try others. */
> +		/* !PREFER_YMM excludes CPUs with overly-eager downclocking. */

Can you turn this into a single block comment using full sentences?
Right now the two separate comments almost feel contradictory even
if I get what you mean.  While you're at it also through in a blurb
why we dont bother with AVX-512 (number of register, no one in the right
mind would bother running high performance code on modern cpus in 32-bit
mode).

