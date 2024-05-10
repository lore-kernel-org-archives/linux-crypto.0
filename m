Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B59131192;
	Fri, 10 May 2024 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328764; cv=none; b=FjVWntseeUEqeZhwFMsOixsznqRZpe6OKub4kPDi2t9+YSheq5zI6rLuDKC0Zu1+ly7kQGOFYcAuNZ6XW483ab+dMepgUlLznWriE1gBZTiiUBwR8lkUgu4TXhpM06M4Z4CcIgPQ6qErhvB6THhb5UcY+WsjEXOElt9RJTUjNj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328764; c=relaxed/simple;
	bh=/oP7Bpr10/EZ8eMNvRVeS4AOS3RDhZayb83Of5+S7Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9yku/uoKKqjFe917098zQAQzIx3d+2hTaXgA24z95vdjoaqIZioq7LW7c/jGjisMrHbk6AGzc1843WZyJNLonB+pHR4JYc18esbqtPn8EZuXF/+u1htL6V+M0Cd0jppKoLhVfqR9Dn2K9PCFK9qpE3zIOclzPrFjXjg0oQ8+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5LMh-00DHkn-1Q;
	Fri, 10 May 2024 16:12:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 16:12:28 +0800
Date: Fri, 10 May 2024 16:12:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 00/19] zram: convert to custom compression API and
 allow algorithms tuning
Message-ID: <Zj3W7OK9kDpneKXR@gondor.apana.org.au>
References: <20240508074223.652784-1-senozhatsky@chromium.org>
 <ZjzFB2CzCh1NKlfw@infradead.org>
 <20240510051509.GI8623@google.com>
 <Zj3PXKcpqUPuFJRu@gondor.apana.org.au>
 <20240510080827.GB950946@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510080827.GB950946@google.com>

On Fri, May 10, 2024 at 05:08:27PM +0900, Sergey Senozhatsky wrote:
>
> For some algorithms params needs to be set before ctx is created.
> For example zstd, crypto/zstd calls zstd_get_params(ZSTD_DEF_LEVEL, 0)
> to estimate workspace size, which misses the opportunity to configure
> it an way zram/zswap can benefit from, because those work with PAGE_SIZE
> source buffer.  So for zram zstd_get_params(ZSTD_DEF_LEVEL, PAGE_SIZE)
> is much better (it saves 1.2MB per ctx, which is per-CPU in zram).  Not
> to mention that zstd_get_params(param->level, 0) is what we need at the
> end.

For these algorithms where the overhead of allocating a default
set of parameters and then changing them on a setparam call is
too high, we could stipulate that the tfm can only be used after
a setparam call (just as we require a setkey before cipher ops).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
