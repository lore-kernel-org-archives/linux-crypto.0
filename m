Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881D717BA5
	for <linux-crypto@vger.kernel.org>; Sat, 17 May 2025 00:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747442713; cv=none; b=Xtk1mdQzSDDK8KOAnyZHXZniILmneXxqO00jw8TKmXbelzA4FCp7l+pIMQFSUQ0TFYcGvJWhFRVGdK8BtV2oYU5rMsNXh0iVe4D9qMMt8apxah9yOo2iYvJI7lJyCCgFWbA4SvXEYJDbygpUJabm6t9aZYn+h45gogg1sMYzrfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747442713; c=relaxed/simple;
	bh=x9i0fBAcvw3hSfXx0LyjNvt+DcYBL2U4e+wTE0q1MlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUAnEn7mDYvLZhpP+6ZL/mSfLF8PJD2VdAME5Cq+sDgvvbJ7eeW/bbRhO9aAAd6kolovycVI27TtPIFhr7oVp+UmovwPEqjJTWeEtwAgjeM3bhtNeimvM8+6Nx3pYG3r6xb4IMD1dxw3jqva/4jq2qOjgoyXySCqjssJoVZnl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r6vyDwoD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r6vyDwoD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aaJEu1t24JTQfAX234a2Q/91gBKaD6QvH34GW1dG4hI=; b=r6vyDwoD6rutgwRI4fBpK7H1HA
	RT+Sy0N/x96dtpjoP3qiDhGevFgWx7hvtaNR7gzMkQ+qsXAAT9ZL+cnKPWrKWI/gA/9bX2WVT2cbJ
	hzhK6c0DiFmgl8Jp7IRLRbusz8RI7FOjHkhAmf+sg1CL4BKaHirV7YsqxdMHO743FDirNsum1MfXW
	+IWoqLaSeqLjVCqtv/DDRN97aznBhhxDaWJx5J0sFvGrrrsbHbg7Zj0AYzgfmC3q8GIDPrnmYZxar
	8RUaLVJWDQzquVL7dfR2cUZRkowKEUwmY5rIbzEeoIYNaGNgFJCWPa+UpS0sfpgBlrQkJtxp3qMZ8
	xQlk/33Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uG5fg-006jL2-0g;
	Sat, 17 May 2025 08:45:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 May 2025 08:45:00 +0800
Date: Sat, 17 May 2025 08:45:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <aCfcDJX5XRUwnx-a@gondor.apana.org.au>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <20250515193529.GJ1411@quark>
 <aCcD92EWd_8oxlEU@gondor.apana.org.au>
 <20250516164326.GB1241@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516164326.GB1241@sol>

On Fri, May 16, 2025 at 09:43:26AM -0700, Eric Biggers wrote:
>
> So how come this hasn't been a problem until now?

It is the key to getting rid of the ban on memory allocation
for ahash drivers.  Small memory allocations fail very rarely,
yet we're banning the use of all drivers doing any memory allocations
because they may fail.

With a consistent export format, we could simply fallback to
software when the rare OOM strikes, thus getting rid of the
ban on memory allocations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
