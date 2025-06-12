Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC352AE6D;
	Thu, 12 Jun 2025 05:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749707729; cv=none; b=pkTmY55ZKDsday5xVfz/u/VOJRfHNmzceirNiSp3r1p6Bw9MEjS6tgjKfYhGUzdiDUw1DlFBMYSvJJTe9bBDUQU0/J/qhQym2WmnwwJxQWeuRyIm625FamMJYcmkL+6y6qEmw39nhAcm69E+Rin+SdK+NV2IjIJcOWZ+3taEhVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749707729; c=relaxed/simple;
	bh=8+H/tr96YZjUd6UCg+BS6Q3khuu+sPU8yba5aX51SoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8c5vRTZl1I2rGK/cTpN7SQ8viTZrpK9gFFAM4FwhS1k809Fwaa/YkK1guj+Xo7eyp+snrjdxgNlU10PYvjMLDrmiUwNjfV0eK6Z60vQKZ7xpsNkuDdveEMu4ZZkGN/mZyEkvyM/rf97S+aBR73onVP7mYgq3AjjaNI9k7ombjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=k0a4qQP3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="k0a4qQP3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rc74KEKSZcVOTVA/X0fklZuVaLUXgUh7vebuiIcruL8=; b=k0a4qQP3qpSqZjk6gHZ8m/K26L
	mtwxJx5P23LDqdPMEW3EbrHOevA/Kp5rCrHQsNnBxneuHKohHbbLj4CXiVX16q1gOQrT7RFdod62y
	3tat1rIObAbIB1g4SzrdX5jjXbLRpO0CWIt/4OUfGuX0e3wmA5tkctk+WZH2lBFh1uIsnL8vb99HV
	3ngHRw3otW1VooHIB0R/b7VL7k6bttiDxnI4XPauFqtz1rVhhc3r3so+sP1zHpozmz5ZO1hGV2ahp
	ZUU2DLZvviZxP0nNK7w2SRhQvPcNQ1SmAw9KgjRKOWo018iY0bednf1QglSjVhHHirHftWHcoYxNc
	t7o6LraQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPauH-00CYGr-2Y;
	Thu, 12 Jun 2025 13:55:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Jun 2025 13:55:21 +0800
Date: Thu, 12 Jun 2025 13:55:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <aEpryXbiFJ5mmsvj@gondor.apana.org.au>
References: <20250611175525.42516-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611175525.42516-1-ebiggers@kernel.org>

On Wed, Jun 11, 2025 at 10:55:25AM -0700, Eric Biggers wrote:
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e9fee7818e270..8612ebf655647 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -174,20 +174,30 @@ config CRYPTO_USER
>  	  Userspace configuration for cryptographic instantiations such as
>  	  cbc(aes).
>  
>  config CRYPTO_SELFTESTS
>  	bool "Enable cryptographic self-tests"
> -	depends on DEBUG_KERNEL

Please restore the dependency on EXPERT.  I do not want random
users exposed to this toggle.

> +config CRYPTO_SELFTESTS_FULL
> +	bool "Enable the full set of cryptographic self-tests"
> +	depends on CRYPTO_SELFTESTS
> +	default y
> +	help
> +	  Enable the full set of cryptographic self-tests for each algorithm.
> +
> +	  For development and pre-release testing, leave this as 'y'.
> +
> +	  If you're keeping the crypto self-tests enabled in a production
> +	  kernel, you likely want to set this to 'n' to speed up the boot.  This
> +	  will cause the "slow" tests to be skipped.  This may suffice for a
> +	  quick sanity check of drivers and for FIPS 140-3 pre-operational self-
> +	  testing, but some issues can be found only by the full set of tests.

Please remove the "default y".

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
