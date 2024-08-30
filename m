Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D19C188A34;
	Fri, 30 Aug 2024 10:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014389; cv=none; b=s/aYBbllzEXlDc9dl8MTzquPSVNuQl4VD56YNDkWgwpze195bPvyAzDDETWLGjzmVU0tjx2spdfj06YODx/1DQeQBiOCws9dJbf+re5QarEffwSbXIAtnmzN4RLh+bXOvkmP0Z2/pf6/E+fFFh/SsAUjxXHnRT/U+G0gJVzR/Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014389; c=relaxed/simple;
	bh=ndbHB8FL13EXXITWif/5S6XY+CQ7u/Fe9YqEyt0dmp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaX1mguyo3Qovhoyz91aA8NbXvLozIeWTXbhbr3/KL4iBp8q7hsBMZXCud0LE02ajfLqIkQHKu+qnwurTwvgt8PPIRQ4JidWKkWPMtsaBvSwPRhfQAPxuF2K3QWhDDihHIUgV1NTiYWt0LyYteMQJaHzKCkAGsDh9WTtaNeH1Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjytx-008UrA-32;
	Fri, 30 Aug 2024 18:39:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:39:31 +0800
Date: Fri, 30 Aug 2024 18:39:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Waiman Long <longman@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Honor the caller's alignment in case of
 chunk_size 0
Message-ID: <ZtGhYmNAAyBJxega@gondor.apana.org.au>
References: <20240822-max-v1-1-cb4bc5b1c101@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822-max-v1-1-cb4bc5b1c101@ti.com>

On Thu, Aug 22, 2024 at 02:32:52AM +0530, Kamlesh Gurudasani wrote:
> In the case where we are forcing the ps.chunk_size to be at least 1,
> we are ignoring the caller's alignment.
> 
> Move the forcing of ps.chunk_size to be at least 1 before rounding it
> up to caller's alignment, so that caller's alignment is honored.
> 
> While at it, use max() to force the ps.chunk_size to be at least 1 to
> improve readability.
> 
> Fixes: 6d45e1c948a8 ("padata: Fix possible divide-by-0 panic in padata_mt_helper()")
> Signed-off-by: Kamlesh Gurudasani <kamlesh@ti.com>
> ---
>  kernel/padata.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
