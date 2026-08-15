Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764D5274FD1;
	Sat, 15 Aug 2026 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786755569; cv=none; b=iwgZvEr9ihF7DHDfPih4lxGhE9aFX9Qc7ut4YJszvn9zK6cdbKmNZUZ83Rcz6UqtNXyb2yfJ7D/kwGupiJe3zev2wqAqB4JV7sV9o9aeFdzcfVIZfmMeN+eeXrmPUI7ushTIm9Uu2VIdLqhYzTbGHkvmv2psXbSvQq/kP3OOosk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786755569; c=relaxed/simple;
	bh=bo0SOJ9EN7uWa6UVy23zO5l1qLAcnrGAwy56O0FzRdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5EA/xs01vnM7WAePZ1MvEhM3s6kBW4Ix10ZveszuBMPkDedyZaLA7uyprmVi+1QBQVvW3RP4OrEBm4aYbVOr7tJkM4QfJG07ZCD7CdYTDxTZc8ClVT0bVdLqUh7RHEOakb82ZNAgb344BaflQDxMa5VGCfGaazulnmo45A5yKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fbwAZV+0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fbwAZV+0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fQ1M/Z2UiormYLhNFRsOy4Hk0IfdXk/ul+rhgM8NgII=; 
	b=fbwAZV+0Xdxs+nss53VBwjhZiL52Ad8bmj4fL5o/g3FSkMpKFwSN/T+H6bRV/CFbtcKxAaoocj9
	kLzDzd2BZxG7pTgXpFKA2+nEf6AQ0vl3kKYkgfwPykXuUDMLwZxNcnRIq3uaJlZLygRg3bd1r003I
	F/1fXSK7PgoMLKU2b2uSVgmgMPpIuy5HL+jDzKckCvqvvrdJmYwF4fSPh2OiT+IYi63unTenhOGnZ
	fywV0xm0iMQCkpCRQyeRgQdhkMVnNrhw635hUtj/e3ht4ER5nRn9wtCRKJt7gmwjSRSYOaNeIxg+l
	VkfpdET1h54OUt5u8qm9Os5Xuoa+mhsKBdCw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv2k6-000000054gB-0D2z;
	Sat, 15 Aug 2026 08:59:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 10:59:22 +1000
Date: Sat, 15 Aug 2026 10:59:22 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] s390/crypto: Enable CONTEXT_ANALYSIS
Message-ID: <an-56jLbR6bfPwvk@gondor.apana.org.au>
References: <20260804113736.1423667-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804113736.1423667-1-hca@linux.ibm.com>

On Tue, Aug 04, 2026 at 01:37:33PM +0200, Heiko Carstens wrote:
> Enable CONTEXT_ANALYSYS for s390's crypto code.
> 
> Static code checking for acquiring and releasing locks used to be done
> with sparse. That was removed with [1] and replaced with a clang based
> approach [2]. The new approach requires that each subsystem needs to be
> explicitly enabled for checking.
> 
> Do that for s390's crypto code. In order to avoid false positives the
> code has to be slightly reworked, since conditionally acquiring and
> releasing locks does not work with the checker (besides that this is
> sub optimal coding style).
> 
> [1] 5b63d0ae94cc ("compiler-context-analysis: Remove Sparse support")
> [2] 3269701cb256 ("compiler-context-analysis: Add infrastructure for Context Analysis with Clang")
> 
> Note:
> 
> - "Pre-existing issues" reported by AI will not be addressed in the
>   context of this series
> 
> Heiko Carstens (3):
>   s390/crypto: Rework ctr_aes_crypt() to remove conditional locking
>   s390/crypto: Rework ctr_paes_do_crypt() to remove conditional locking
>   s390/crypto: Enable CONTEXT_ANALYSIS
> 
>  arch/s390/crypto/Makefile    |   2 +
>  arch/s390/crypto/aes_s390.c  |  54 +++++++++++-------
>  arch/s390/crypto/paes_s390.c | 104 ++++++++++++++++++++---------------
>  3 files changed, 97 insertions(+), 63 deletions(-)

I presume this is going through the s390 tree?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
