Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5D913C673;
	Thu,  6 Jun 2024 07:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717659281; cv=none; b=EkfgLa1bNrhzP5R9Kj99T/gqM+Vz0TF9kKK6gxXd7utslMamIH28g+fwaKpYAnk/zHnpY02/o1QmZGz+6CSdDgZKs2NySsOV1bp9tPte4CncSWlrTc3y43h7CxnWOuPo/CWvd1myAy6zOCfui+N0Z7vFg5X6wQ+4Nx3VHwlAWeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717659281; c=relaxed/simple;
	bh=zBd5D/R5ctDfeNBpJQ5EP1hix9MxnGPa0eqBKD6ftk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lPEJQH94WCdNspofJvVsyiXe3LimrzaGJizo+e39shdBtP45Q7Rb6XXlBcv2uRyMccnCapvUHjzNfitDY/zo6wfT2pGgMOWWeqyJ1MWAZG3Bw+M1S6Nb+0DK9rLJ7nvvL4llpit7t/7Bzy8H/IsGkmwM79cDGOH0DmVTE1XqPNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sF7dn-006I9G-0c;
	Thu, 06 Jun 2024 15:34:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jun 2024 15:34:33 +0800
Date: Thu, 6 Jun 2024 15:34:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmFmiWZAposV5N1O@gondor.apana.org.au>
References: <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
 <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au>
 <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>

On Thu, Jun 06, 2024 at 08:58:47AM +0200, Ard Biesheuvel wrote:
>
> IPSec users relying on software crypto and authenc() and caring about
> performance seems like a rather niche use case to me.

It's no more niche than fs/verity and dm-integrity.  In fact,
this could potentially be used for all algorithms.  Just the
reduction in the number of function calls may produce enough
of a benefit (this is something I observed when adding GSO,
even without any actual hardware offload, simply aggregating
packets into larger units produced a visible benefit).

> I'm struggling to follow this debate. Surely, if this functionality
> needs to live in ahash, the shash fallbacks need to implement this
> parallel scheme too, or ahash would end up just feeding the requests
> into shash sequentially, defeating the purpose. It is then up to the
> API client to choose between ahash or shash, just as it can today.

I've never suggested it adding it to shash at all.  In fact
that's my primary problem with this interface.  I think it
should be ahash only.  Just like skcipher and aead.

My reasoning is that this should cater mostly to bulk data, i.e.,
multiple pages (e.g., for IPsec we're talking about 64K chunks,
actually that (the 64K limit) is something that we should really
extend, it's not 2014 anymore).  These typically will be more
easily accessed as a number of distinct pages rather than as a
contiguous mapping.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
