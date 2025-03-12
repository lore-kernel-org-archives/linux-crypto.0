Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803CA1487ED
	for <linux-crypto@vger.kernel.org>; Wed, 12 Mar 2025 02:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741746192; cv=none; b=iFtViGPgsPKP2KBYddYrrYNKJhsw4VZQXx98Qgn9W5iF0T1ErkhTCa1XchuiLSW+QXteNc0z3elDUNJaoE5GB4u1HSpwBWueWqD1xYPx+eY2EBjfAltAFgRBO8Ugb8MLWKXaxx8FQnZ3wNQW9Su0cJrbP+XRUHzHUX5VZtTT0t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741746192; c=relaxed/simple;
	bh=JyNgD7oxNirj2QMmt941VwbB31f1yHGd6yaM+YJvr3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEPPnxPNueXbBJd/j6QhczmUQ4Tb6HNkFJkgZNRVMNuTLCeBEUOOnCzjLBnW3p8wWMgYr7jXbfFZXezIgDodvddowj04t5BQJT1GWmThzpqawUABn2yFozcMea12ZMiGqExWGU3GZKwRGfhWrAhbA4zvv927KWjKTirk2FgAqSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dZ0N6zgV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dZ0N6zgV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sg8ZdR03H2J3SsMAg5EWMeol19gpeiUa0gIphtcAHjU=; b=dZ0N6zgVe0+qMdZROtqeG5YZcL
	51v9vG1cC8HwC3rOW3rlHCd4DBT5yJf81GsE9tbwTWTkgt0+HAeK56eniAL6xEAJHW/PFl3tEaI1z
	Rxze3QUBGxrHwwVkP1b2pdM6wGMAd+uXqe0ks+8RshDX1t45VjbufTy79rFjFeM+kHXIP1Mc0B/YW
	JVHayMATfDi2YJCQhlwHQ8efatXAXlBhOqwdzM3yFgMQ3BTl9tM4NkiNKHP8F155tLsoXUYRAZArI
	LpjP24Kd2+xjn0C0YhvtmZcI+PF7Tpw8DRq+KfmCjgcXepdclbr5gxPC1GZ22SiUznY0coljmw2t4
	sIG62mKA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsBkO-005lWl-0u;
	Wed, 12 Mar 2025 10:23:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Mar 2025 10:23:04 +0800
Date: Wed, 12 Mar 2025 10:23:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scatterwalk - Use nth_page instead of doing
 it by hand
Message-ID: <Z9DwCC1SoUKKw0Ql@gondor.apana.org.au>
References: <cover.1741688305.git.herbert@gondor.apana.org.au>
 <9c5624f2b3a0131e89f3e692553a55d132f50a96.1741688305.git.herbert@gondor.apana.org.au>
 <20250311172624.GA1268@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311172624.GA1268@sol.localdomain>

On Tue, Mar 11, 2025 at 10:26:24AM -0700, Eric Biggers wrote:
>
> In the !HIGHMEM case (i.e., the common case) this is just worse, though.  It
> expands into more instructions than before, only to get the same linear address
> that it did before.  You also seem to be ignoring the comment that explains that
> we're working in the linear buffer of the whole sg entry.

Thanks for letting me know.  I had assumed that this would all get
optimised away.  Let me look into this atrocious code generation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
