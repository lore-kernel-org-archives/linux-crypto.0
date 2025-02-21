Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC581917E3
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 06:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740118263; cv=none; b=FXjex5Byz3i+cyrFe/Do2nribNfbqxMlOsOZinnS7QiFxDGTdlk+lWuLT018Ua4o3cga5CM3IZre1RZLi+IDFQxDhHbMdU5aF0z3whTefoJYhUgTQICv4ZOkHaxAA52eEkqfVKNVGNjOF8banV7DwZspWCzYNIy4UNr2phDbBcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740118263; c=relaxed/simple;
	bh=jUfjOGPLr1JDsbNB4KquLJ9ByERw6JYYcxgf9cUjid0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTxO+tcS4Vk3WeAiEmMPJeCbIAuMFIpOz9m88BRBfxYHXbivLarYy311A/aRXxqjW11Z0uYCLTwDkNi+oKMyLbJ7B6Ftf1gAVIxuN/7lFXxBIxrt+btZBxeBfOOtwll841d5kYyc5/cvwnkP7eCWB4I9hJxkwszzg3B4+DeqEzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c2lN7fnC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c2lN7fnC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pLPgoAVZoADa+G2SVdvjLB1fijmCEtLP4Nnh01RrWsI=; b=c2lN7fnCO6/NJt6dVuq6z70vnn
	XyERQgDx6IpEjxHo+Nw3hjDwrhaGqam3gSp/4I85cpZJWo40gB/b0dFiwCQ5V8HHFIlvh+c0OP+t0
	N6WjXkysv1H5XUCYjIbLDwbjo8wEOg5IqDRBbJUVto1J/tLtJROTyL3wmvHfF3pz6IKqhUPBDM1ah
	oz9BBW98+F2W7qXiLrRYgG1NsiAJM5q6MArNlLjYSYpN9CwlwWa57exXJGe8OySER874Fkp88zLBE
	tZ0vNLeoDMJdYsUeMMxOYZzw5kuRQ9XbKDO8IWiVqAEh2BuAEJz6zm4iz8a8pE1n9Y2JvsPHlnK8l
	VeFtM9eg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlMFT-000WCp-30;
	Fri, 21 Feb 2025 14:10:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 14:10:55 +0800
Date: Fri, 21 Feb 2025 14:10:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <Z7gY71v069cGDke1@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <20250216033816.GB90952@quark.localdomain>
 <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>
 <20250216195129.GB2404@sol.localdomain>
 <Z7RcnKGNGP50mdb-@gondor.apana.org.au>
 <20250218174810.GA4100189@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218174810.GA4100189@google.com>

On Tue, Feb 18, 2025 at 05:48:10PM +0000, Eric Biggers wrote:
>
> In addition, your (slower) solution has a large amount of complexity in the
> per-algorithm glue code, making it still more lines of code *per algorithm* than
> my (faster) solution, which you're ignoring.

My patches make the per-alg glue code look bad, but the intention
is to share them not just between sha256 implementatinos, but
across all ahash implementations as a whole.  They will become
the new hash walking interface.
 
> Anyway, I am getting tired of responding to all your weird arguments that don't
> bring anything new to the table.  Please continue to treat your patches as
> nacked and don't treat silence as agreement.  I am just tired of this.

Talk about weird arguments, here's something even weirder to
ponder over:

Rather than passing a single block, let's pass the whole bio
all at once.  Then depending on how much memory is available
to store the hash result, we either return the whole thing,
or hash as much as we can fit into a page and then iterate
(just a single hash in the worst case (OOM)).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
