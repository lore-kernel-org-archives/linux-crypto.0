Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9C2DF42;
	Tue,  4 Jun 2024 09:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493999; cv=none; b=Sn2UvHbZdMbByo9heH7/fCXzqJZwdqE5EEuogsCGlmbMvwQNdZbvheE8HvKeNCEGOtK2FEmoOQyLAxdnkXa1yGj0Yj9NdWUL4i8eeX+2tr6ad2WCpJMbuoCCwma/7hCtEzFJrt/OWy287VEGFZOSTKFEcsxSDwdl4fw5cAph4kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493999; c=relaxed/simple;
	bh=M2aneL/MWWgSjrHHcp91Qlu71EuWtggB8FK6h4m+DFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwsrfwIG34upPR+YhEzKWbhLVjX3TjiEiVOtSU9YNW2SMDkNdHhShHD7V8lsKdSSntcp3p6wN5VxdTix1LPJTYa/zWmFhSAPgA7s81J9uyd7bLuTUKxDuabH3UqTc7zBp35iCNqYZrYiUXkVjbh6fEAaTsFcmfhhCJUIMMjfvPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sEQe0-005SnC-0J;
	Tue, 04 Jun 2024 17:39:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Jun 2024 17:39:54 +0800
Date: Tue, 4 Jun 2024 17:39:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <Zl7g6mJd6mJrLmwT@gondor.apana.org.au>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
 <20240531061348.GG6505@sol.localdomain>
 <20240531065258.GH6505@sol.localdomain>
 <ZlmPGEt68OyAfuWo@gondor.apana.org.au>
 <20240531185126.GA1153@sol.localdomain>
 <20240603185002.GA35358@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603185002.GA35358@sol.localdomain>

On Mon, Jun 03, 2024 at 11:50:02AM -0700, Eric Biggers wrote:
>
> I've now unified the code paths for single-block and multi-block processing in
> fsverity and dm-verity, which I think addresses your remaining concern that's
> feasible to address.  Your feedback has been conflating different issues, and it
> only comes in once every few weeks, so it's a bit hard to follow.  But I think
> the remaining thing that you're asking for is to make the API to be part of
> "ahash" and use the existing async completion callback.  That's not actually
> feasible, for the reasons that I've explained in detail.  See in particular
> https://lore.kernel.org/linux-crypto/20240503152810.GA1132@sol.localdomain/.

I've tried to dedicate more time to your patches, but sending
them in just before a merge window is a sure way to add extra
delay before I get a chance to review them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
