Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF7E3D968
	for <linux-crypto@vger.kernel.org>; Wed,  1 May 2024 02:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714532293; cv=none; b=oAif4qNb0xBpwq+mxCErbcliddvkwy4yCGN4aYPOcD8AbcZaExmVtWEN7piD7g3hFOzFzdpURyAI0kS5I1/fvN+9Jnh+4WFMJFUcNDlCSiQfQqq5o71UjsnkZGpuNgxmyZ/M0XJJa164JIq7Lr3fMiW21o2aV+bWNAGRBv8fbZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714532293; c=relaxed/simple;
	bh=3UrPN+n0abOzo8c1+wpLVkOzoVNh2LA/1aasFAFOdB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQb7Cz3NQtvQC6ep/xz0dh3nnsvmrgXyh5SghypKWsIhrvVgk1agXQizH7i2x84pcwZ4j8aT7VWXHkfIu7t3mUrt4+mtke/bq57VcEuwY/kAlTgAQpuo37RiAi5mj14oFEBKczS2H8OqOwHdSa6lI0VfdrNlDCF5N3lZgKYYIO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s20AN-008zfC-1A;
	Wed, 01 May 2024 10:57:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 May 2024 10:58:13 +0800
Date: Wed, 1 May 2024 10:58:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/2] certs: Move RSA self-test data to separate file
Message-ID: <ZjGvxVKXu8JRc1bT@gondor.apana.org.au>
References: <20240420054243.176901-1-git@jvdsn.com>
 <Zinnl2Y11i0GHLEO@gondor.apana.org.au>
 <b2787b62-fd1e-4815-a1c1-6b2d567ab977@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2787b62-fd1e-4815-a1c1-6b2d567ab977@jvdsn.com>

On Tue, Apr 30, 2024 at 09:52:44PM -0500, Joachim Vandersmissen wrote:
>
> I'm currently leaning towards adding FIPS_SIGNATURE_SELFTEST_RSA (and
> similarly FIPS_SIGNATURE_SELFTEST_ECDSA) as user-facing configuration
> options that depend on CRYPTO_RSA (and CRYPTO_ECDSA) and
> FIPS_SIGNATURE_SELFTEST. Then, it is up to the user to select the correct
> self-tests they need. It would still allow the user to create the same
> configuration "error" where FIPS_SIGNATURE_SELFTEST=y and
> FIPS_SIGNATURE_SELFTEST_RSA=m, but I think that users which care about
> FIPS_SIGNATURE_SELFTEST are doing it in the first place for FIPS compliance
> reasons. In that case, a FIPS laboratory should review the configuration to
> verify that the correct self-tests are executed at the correct time.

If the combo results in a crash then I think we have to fix it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
