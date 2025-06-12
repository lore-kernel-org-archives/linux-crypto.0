Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4E71798F;
	Thu, 12 Jun 2025 05:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706720; cv=none; b=chU/2RZt8DLH5GJwB5R20XFnL7v+8FsqWWIMHWJN+otbTNgAJEI7bmzyFuqM8iBf2HZKzyol6uxX1af2g6x5vUrpFaMRLYRzM+5/4Lc7yDDdGOmjzekxjSHoWSAZuxQRZYbMWVuQPd9ZfEFp9/l1f+N51s7vrjtA+v4JCIuBs68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706720; c=relaxed/simple;
	bh=S4t6wWm9dt6+lgS6bSOCmRYtthZMLHH+VlRRYOFSnZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZzy2V2xrpDbhcfd7zMyYiXKJSn/c1XANV4i/vxVt0yEaBwYjUksLP9PlzwqZKPReVv0bRURf1BGMjs/gbLi3wkM7dagP1H6oPD4qJ2HGbYJ59/y3HvMuhHT6HuQpxmumn3fCw++EFEdX60AYV8GfRNZfYz2iUlXGRWsHt2yBUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NQTOTy1t; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NQTOTy1t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Qz9CYYFLIpHohinfJ8GhpQOes7nBnWlubx3xdUuVdDU=; b=NQTOTy1tg5+zdNbWEJ7Tq+uQZb
	55kckaQxQdPNWoSk63+18ZOQUL8ScnFU5Sj5b/lCt+rIUl8NJqTtpCJZF2qwhgAZ1s72NYpvjqYnk
	Zt/6Ee/7RpMTQARDh2TOB3nHzmn/TkP5VTEw+bDMxkingNftuXqva0FVtw/lxQHGFjjxA1c1wRLgC
	IPU5oL4UzjDWas1mRLtIXyp2QSpEPaeZCAK6xkvNiwL3mYxkOPzdwyDQ48NnYvChVB3m2wBxJ8y9N
	OQP5ijYbGYCmx23j6RD3h17PVsTOSqu5lAWfYN4lmyyGZ1ion3paAufZSulzk8H5vsW84UQgtv3wB
	sCYSHKnA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPads-00CYA1-1i;
	Thu, 12 Jun 2025 13:38:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Jun 2025 13:38:24 +0800
Date: Thu, 12 Jun 2025 13:38:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Fix race condition when probing IAA devices
Message-ID: <aEpn0B6CrMNcD-Oj@gondor.apana.org.au>
References: <20250603235531.159711-1-vinicius.gomes@intel.com>
 <aEjnbdoqzLoMifRn@gondor.apana.org.au>
 <878qlyugea.fsf@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qlyugea.fsf@intel.com>

On Wed, Jun 11, 2025 at 02:17:49PM -0700, Vinicius Costa Gomes wrote:
>
> >From what I could gather, the idea of the per-cpu workqueue table ("map"
> really) is more to "spread" the workqueues to different CPUS than to
> reduce contention.
> 
> If the question is more about the choice of using per-cpu variables, I
> can look for alternatives.

Prior to your patch, the compress/decompress paths simply did a
lockless per-cpu lookup to find the wq.  Now you're taking a global
spinlock to do the same lookup.

That makes no sense.  Either it should be redesigned to not use
a spinlock, or the per-cpu data structure should be removed since
it serves no purpose as you're always taking a global spinlock.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
