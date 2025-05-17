Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C91C2CA8
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 01:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747445155; cv=none; b=GfUDy/Gd+r2mfigcF9eHJvCwkpklW39dXV8hHPO4AV30EeFRONzd2LpSkOqIHXNGCm1cpPCKFJOkBh94DIB3UguppGWXvWP9YsbjMCCkXhaC1NlNYAm0oNg5zJNK56jsuwivdBUWSQWhkf9e3baW8dMlxHqkwCcxOex4V9gBdUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747445155; c=relaxed/simple;
	bh=p7oUaygr3SrVMzUAXs+jxw0ixJ1u9iFLy3yYhkGUm3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsZRumitleAXRN+7qzPCJs0Zzs6paa44h4JbrfXS4SQ0z6w4GWum5kPpTZF4PC8/bqp7xebD31Du51EkXursEfMaaiGX9GinoUKUbBvlhY6KuSDbZLbKZdKQ7TVeIdi5sCLpgFs1fk66fDWnLAY5idb+CMSpWJj8WAdjGH6zHcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iOb6m+vi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iOb6m+vi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jknP3EIb1jIy6hJYH6SV0GcqhWSBw3owA4mPr6FuyYM=; b=iOb6m+viv8iNsUANWduts6IVAL
	yCo4Yc88GMmt/S/J6e27/n/FfV/CBC0vnXJsXSMZKQMZo6VjS2EgI3N+LhKmjvgCPOjPCXbWzFO4C
	stu7TLd1qI1Yj2xW28kujONrphExZ8dgTUof8vfaWgaobAQTwt8Wjg0a71O6Zg8ztuYfIzlTboPlH
	+L/HO4RtDcZCOGClVN6WRvXKZNmjjLH/VLxDSXct2skQI2NaVXMRwQrRFo6CVW/2HqDWd0Tdz32gN
	3KV6JQFYcGeUi+cJ2YeqpAMD3pCwElxHyrhuFRjt1nR2/88+YxmDEsaufFO1klpSNI9HCcJ3UUgeH
	1wHBrdyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uG6JA-006jbI-1p;
	Sat, 17 May 2025 09:25:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 May 2025 09:25:48 +0800
Date: Sat, 17 May 2025 09:25:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <aCflnGXIXBr9Qlm2@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <20250515193529.GJ1411@quark>
 <aCcD92EWd_8oxlEU@gondor.apana.org.au>
 <20250516164326.GB1241@sol>
 <aCfcDJX5XRUwnx-a@gondor.apana.org.au>
 <20250517011704.GA1220@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250517011704.GA1220@sol>

On Fri, May 16, 2025 at 06:17:04PM -0700, Eric Biggers wrote:
> 
> There's already a huge quality problem with the drivers.  The last thing they
> need is to have special code that runs only when an OOM condition occurs, which
> won't be tested.

I totally agree that we have a quality problem with the drivers.
Which is the main reason why I moved the partial block handling
out.  The less work the drivers do the less likely they're to
screw it up.

For test coverage, we could easily add something similar to
crypto_reenable_simd_for_test.

Another thing we could do is to just let the drivers fail in these
cases and return ENOMEM and handle the fallback in the Crypto API.

> Can they really not just use mempools?

I don't see how that solves the problem, they can still be exhausted
can't they?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
