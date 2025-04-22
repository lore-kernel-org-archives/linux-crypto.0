Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF39F2F37;
	Tue, 22 Apr 2025 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745331388; cv=none; b=c+FrRheOZIjE1CI1KEOSFhWGL18Oa61wGlBqs0Ohg7MoPs0hL4hzRKxNEUjqK5eMss60LLHbctxiJAULHYth3w5+XTfRR5DjnQGfjaPuQKyFp2/SzlhXwO1gIhEs63GOEzPZpc1vAfKilO6NCgS8sw1vW33ysAO3AX0+mWCpprw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745331388; c=relaxed/simple;
	bh=fTQYKsQu+QIX6vKu1CNgck+u+htNJM8BuxeBg9H3Ncw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNmi6v7odRtIUnwV92g3RB6yvG8MhlzUGJ1k2ALQUP+yymYfVek/PhMMCVyET9DaJkMTagEuroDKkyOYkG9Pc8chBbWBTkTQnfyBhE1q/hV18eRoBFxx/adNTl5vLHQ853fbWUsM/KchT2UUsle3kk3XYq94gZZVF3C1carXXnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O9B3eU/X; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O9B3eU/X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X1iB3P09c3OCc6TeaNE/sjxKLRzl4DmSZont3k5A34E=; b=O9B3eU/XO44sQ/COW2TsYSFVeC
	8HaxsYfeE4ViRZXzyJVKR1GhXZUYEorsPPknJO1tVFEcumPvQvbFxbcv5x7MhALrOUAxaGcbpTiKI
	Czg+jvzOISJm4elGJBAT1MVzhJx0s9833QCqJTXPKS85fGA8z+4oSNKGdkl6hUwPfc+1jhMu/22oB
	KYxn9Ovd/56p062KKoVz14R0zo2Av2V3xI5HiPMqWIElRqyw9QKAbs2cE3HnLNPsnTizxfWL9wI3A
	8ooW19keW8XR9u18v+nhbDGVDtSSR/sMtm0SOJdHIVkCWIjMHW1KINe76S6O8IZQwu7wyr7JBJrwV
	OHUeVnkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7EPx-00063n-2B;
	Tue, 22 Apr 2025 22:16:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Apr 2025 22:16:09 +0800
Date: Tue, 22 Apr 2025 22:16:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Su Hui <suhui@nfschina.com>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: using size_add() for kmalloc()
Message-ID: <aAekqQH3yWk_GhMN@gondor.apana.org.au>
References: <20250421055104.663552-1-suhui@nfschina.com>
 <aAY0lyWzsRVDge_f@gondor.apana.org.au>
 <2169828c-127c-4bf7-b953-2f1194b72830@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2169828c-127c-4bf7-b953-2f1194b72830@stanley.mountain>

On Tue, Apr 22, 2025 at 01:24:22PM +0300, Dan Carpenter wrote:
>
> This is exactly what Kees did with the mass conversion to
> struct_size().  I occasionally run across places where Kees's mass
> conversion patches did fix real integer overflow bugs.

The point is that the reqsize shouldn't even exceed a page in size,
let alone be anywhere near 2^32.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
