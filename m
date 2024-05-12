Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D164E556
	for <linux-crypto@vger.kernel.org>; Sun, 12 May 2024 07:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715498199; cv=none; b=R/UrAOe48Ic7cBs9KhSdYqtNlTqAOtFkYnDt6TJt6k1Ic/rYc+mjL7D23wrxXjWbcBYwfuZznS134RsBKh9wiJB46Vp5s0EgsvvdNQ+qolvI4YcjbtEr6R27MqHptlAOEft+b7LD1rhA93Tpz32dGIPUUW89re118rLev2nHofA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715498199; c=relaxed/simple;
	bh=f17paNO351xPVsuYYmVBn1087/rpG4wUcc4tknoQw84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiVWp66ozSgXhFd35EBkmtYzbeWT4VJNTvtYDCCqLrx/monMVKUX03MlBfQvBIJbFNyURq9M4JwnEaI+wfvdO5BVHqns0svmO7py/8At+Ztpg3N2GKQwsSj5qAglok4KQasDeX1i72ZZp4V8STeo/ZIuH/fGBSFC3uwkNR2Wmvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s63RO-00E911-1j;
	Sun, 12 May 2024 15:16:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 May 2024 15:16:15 +0800
Date: Sun, 12 May 2024 15:16:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
Message-ID: <ZkBsv0uSzqhxSXye@gondor.apana.org.au>
References: <20240511062354.190688-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511062354.190688-1-git@jvdsn.com>

On Sat, May 11, 2024 at 01:23:53AM -0500, Joachim Vandersmissen wrote:
> v4: FIPS_SIGNATURE_SELFTEST_RSA is no longer user-configurable and will
> be set when the dependencies are fulfilled.
> 
> ---8<---
> 
> In preparation of adding new ECDSA self-tests, the existing data is
> moved to a separate file. A new configuration option is added to
> control the compilation of the separate file. This configuration option
> also enforces dependencies that were missing from the existing
> CONFIG_FIPS_SIGNATURE_SELFTEST option.
> The old fips_signature_selftest is no longer an init function, but now
> a helper function called from fips_signature_selftest_rsa.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/asymmetric_keys/Kconfig        |   7 +
>  crypto/asymmetric_keys/Makefile       |   1 +
>  crypto/asymmetric_keys/selftest.c     | 218 ++++----------------------
>  crypto/asymmetric_keys/selftest.h     |  16 ++
>  crypto/asymmetric_keys/selftest_rsa.c | 172 ++++++++++++++++++++
>  5 files changed, 225 insertions(+), 189 deletions(-)
>  create mode 100644 crypto/asymmetric_keys/selftest.h
>  create mode 100644 crypto/asymmetric_keys/selftest_rsa.c

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
