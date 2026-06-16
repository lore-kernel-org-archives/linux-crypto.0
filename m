Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDE435F5E6;
	Tue, 16 Jun 2026 04:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781583205; cv=none; b=KpF/ZEXLMeuMx0rlCD2bVak0ZofpBWpjvCsTB7UvXtQDYJTnXz54cIKiUb+WOWyx2g3FyHeA7owl7FqDf7CxiPjLX5qKPb3gWSuk6bPEVMVW5QetaKSRTHL8T8ddmnKF3d34VSuEoM0Qi2eu36BzyEFD8JUfE3ExXOrhaHghqrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781583205; c=relaxed/simple;
	bh=fL+yNcQM4NsVam4PUbHcK9wcXXUdDOeDNjVpdEKwApw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dms+CfzvOFzCGcWfHur5DeGWL9Xe+V8oYKX5xiexGNedo+B3loJRAIIN7u7TpdmeQke2736vFApxCYWh0Q0xi9xa7nhHCq2M7wrRrNA0EI/raQ1QvnIK9ZcIpwI31tI+EocrapkGezR9G/VSNG987jzx7ReJNQn6w7EWUbHZoj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WZUzi6mg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WZUzi6mg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Y1N+GvYq6xElzdgziM72NUoqM1EdeAJBxUHhzuYJT7s=; 
	b=WZUzi6mg/wIg1VzD51An/zc+cljsCDeadP5AYsEkJQrlOSjIee1dGMmOBua0N8ai0ZDrIPKuovd
	qRxdvLOBYfv6mA40j5U7Ppi9qmBE3QMrPFakO91/MEOkC74me3opgQj28Tt2MORlXDzWeja+bKjcK
	B75NrOa1a4Bz91A8crMlgc72SMQ2MlFQwzjMfuIFaPKPZ7M3ON8bEvYxAzgELXtksb6Gyad1w1IOI
	A1ybx45rAz/AkIpOiIDAlL0JRucXLN8FNOGxapWLMgi5V2cPTkq/yioUMwUhVuLce2I9YCGZf5+Ma
	Qexr9jrAP6edfhaHEI+lb710w0op6m57zPKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wZLAd-00000005kxl-1lxQ;
	Tue, 16 Jun 2026 12:13:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Jun 2026 12:13:03 +0800
Date: Tue, 16 Jun 2026 12:13:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Leonid Ravich <lravich@amazon.com>, Alasdair Kergon <agk@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Horia Geanta <horia.geanta@nxp.com>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit
 batching
Message-ID: <ajDNT5jVGgRtiNH6@gondor.apana.org.au>
References: <20260615111459.9452-1-lravich@amazon.com>
 <20260615225317.GB28589@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615225317.GB28589@quark>

On Mon, Jun 15, 2026 at 03:53:17PM -0700, Eric Biggers wrote:
>
> So in other words, this series slows down dm-crypt and crypto_skcipher
> for everyone to optimize for an out-of-tree driver.  And there's also no
> benchmark showing that your driver is even worth it over just using the
> CPU.

There is no reason why the software fallback should be slower
than the status quo.  Existing callers of the Crypto API will
be issuing one indirect function call per data unit.  With the
new scheme, the indirect calls per unit moves from from the caller
into the Crypto API.

In fact, we could move it down further and improve upon the
status quo by splitting the data in each algorithm implemntation
so that the calls per unit become direct function calls and only
the overall call into the Crypto API remains indirect.

But yes it would be nice to provide numbers for the fallback
path to verify that we didn't get this case terribly wrong.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
