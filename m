Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2228C153598;
	Thu, 12 Jun 2025 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749708597; cv=none; b=DbaDJOYc3+lkQfdODtH/Ev470r1NHwl23d+6SwQqcl9A++BqKSs+toV68d9/+EQE5exp+cBUq5E36XQqrdx8VmkBQl/bA7BAg9RiuEmu9shPU0JBoSCp1XoDpJJez3pUFMLKTkCwAWMBi5arIRb2taynfCA9jPPq4EGNeZTx0eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749708597; c=relaxed/simple;
	bh=IEGUOlpW1X54PDNCay0Qr6S34ApeUz4h95K/R1anWFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=soP6afcmKwyxt8aiMhhVvTQ4I5mXA0glM2ue7rYs0LV0saweI0dsHtgrUcvCd1eZjgKZbZsQBxpXjLPtKkEIa8YFsBFLtyNgbFfCnSgQdbQG4GGuv5nzC2RjTt8Lc9fG3ThZPAYDIFWe0j5W6+lr6wSZwvEzLVStVzDE7CkUhqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mkNQXNM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mkNQXNM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A43C4CEEA;
	Thu, 12 Jun 2025 06:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749708596;
	bh=IEGUOlpW1X54PDNCay0Qr6S34ApeUz4h95K/R1anWFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mkNQXNM0KxVz5Usl3tuBVd/uZp5Es7z8Nfrndsho1PPQJ/BcIjYEfGIRtvTUiGdu/
	 /WqPJE1jtFt0552JOdsKBh6yqcmO63pjq8QEcrNk6xaXjRkTn+EKeHJpBzE4fG6GRg
	 zrKgQ5ep/PciaJXbJfmVtiGeR2Uup6xb9OS0ZNmqRYXLakTm9rkiQYbyXedVEdliiU
	 07X5aKd3N27hrn1jxrrFj5AEPJmiLRuJ/mJZdddd4a4hKDTiCHr8Y/ErmFpdc28GpE
	 xHa3qvYjULeXjcaUQ9V2rk+Iz003lxcXSgHkyTammsE7KyRxKeFQRMGknxtq2/2EyR
	 8QtADe5FpiIZw==
Date: Wed, 11 Jun 2025 23:09:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <20250612060931.GA200686@sol>
References: <20250611175525.42516-1-ebiggers@kernel.org>
 <aEpryXbiFJ5mmsvj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEpryXbiFJ5mmsvj@gondor.apana.org.au>

On Thu, Jun 12, 2025 at 01:55:21PM +0800, Herbert Xu wrote:
> On Wed, Jun 11, 2025 at 10:55:25AM -0700, Eric Biggers wrote:
> >
> > diff --git a/crypto/Kconfig b/crypto/Kconfig
> > index e9fee7818e270..8612ebf655647 100644
> > --- a/crypto/Kconfig
> > +++ b/crypto/Kconfig
> > @@ -174,20 +174,30 @@ config CRYPTO_USER
> >  	  Userspace configuration for cryptographic instantiations such as
> >  	  cbc(aes).
> >  
> >  config CRYPTO_SELFTESTS
> >  	bool "Enable cryptographic self-tests"
> > -	depends on DEBUG_KERNEL
> 
> Please restore the dependency on EXPERT.  I do not want random
> users exposed to this toggle.

It used to be:

    config CRYPTO_MANAGER_DISABLE_TESTS
            bool "Disable run-time self tests"
            default y
            help
              Disable run-time self tests that normally take place at
              algorithm registration.

So the CONFIG_EXPERT dependency for the prompt would be new.  Are you sure?

> > +config CRYPTO_SELFTESTS_FULL
> > +	bool "Enable the full set of cryptographic self-tests"
> > +	depends on CRYPTO_SELFTESTS
> > +	default y
> > +	help
> > +	  Enable the full set of cryptographic self-tests for each algorithm.
> > +
> > +	  For development and pre-release testing, leave this as 'y'.
> > +
> > +	  If you're keeping the crypto self-tests enabled in a production
> > +	  kernel, you likely want to set this to 'n' to speed up the boot.  This
> > +	  will cause the "slow" tests to be skipped.  This may suffice for a
> > +	  quick sanity check of drivers and for FIPS 140-3 pre-operational self-
> > +	  testing, but some issues can be found only by the full set of tests.
> 
> Please remove the "default y".

If you insist.  I hoped to get the people working on drivers to actually run the
tests that they are supposed to.  The default y is appropriate for anyone
actually doing development and/or testing, which is what the tests are supposed
to be for.

But I guess that doesn't really happen, and distros are expected to run the
reduced set of tests in production because upstream doesn't test the drivers.
And they will want n here.

- Eric
