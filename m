Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF091BDC8;
	Thu,  6 Jun 2024 05:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652481; cv=none; b=UKGNpS4nsUMQ2rS1H7VV6UJ62Pe1j1q4AEJQmPGVIsNNEnO3AiF1DCEYu3yEH2QLbkb1o27nuwa+rJYasOuvXFtY8iWkkAk0bNXNkJ9zSz5mebdqPb77Jeka4z3xqHCNXTyfTg3vE/d56Sp3Ul8mHaVLQhRVxR5xRMwB1JnM65w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652481; c=relaxed/simple;
	bh=/VTOrt/1XHNs3a8jbXUgLT/8p5NnvBG8hPczolpeemI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nO7m5wrBcTVDa5OV/Yp3PVG4acO5mel4ysETaJV8pJAK5x+oq0MYJ2ZhiwU7NoLbEh2IEV1Wll6RJ4vdDWbvhplltOdF2cFHGnZ4gzJIrnNZJRFAGfw7PLsLRNYVg9QAY442G9aEoDU4v6UrZcKXebw1FcKx/lLl/hwvD8QhhbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sF5s6-006GEb-1W;
	Thu, 06 Jun 2024 13:41:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jun 2024 13:41:12 +0800
Date: Thu, 6 Jun 2024 13:41:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
 <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
 <20240606052801.GA324380@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606052801.GA324380@sol.localdomain>

On Wed, Jun 05, 2024 at 10:28:01PM -0700, Eric Biggers wrote:
>
> With AES, interleaving would only help with non-parallelizable modes such as CBC
> encryption.  Anyone who cares about IPsec performance should of course be using
> AES-GCM, which is parallelizable.  Especially since my other patch
> https://lore.kernel.org/linux-crypto/20240602222221.176625-2-ebiggers@kernel.org/
> is making AES-GCM twice as fast...

Algorithm selection may be limited by peer capability.  For IPsec,
if SHA is being used, then most likely CBC is also being used.

> In any case, it seems that what you're asking for at this point is far beyond
> the scope of this patchset.

I'm more than happy to take this over if you don't wish to extend
it beyond the storage usage cases.  According to the original Intel
sha2-mb submission, this should result in at least a two-fold
speed-up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
