Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979021C3039;
	Thu, 12 Jun 2025 09:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719022; cv=none; b=CBUcMK2FmyHsChYRSFU5aiIjW1NF4SMbaWemYfWLvLm2C/2vUPmg8b9D4kFoSE+rHFi/TPLgpZ3hzBNxaht6/yqEsvxK1wbrgL/mXD4zjIvUW7IFdV+/wga9D8hWVMb6sZqVhPZ2SowWmCxTT/WmWeZT4hYJomxzW24YnsBHZJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719022; c=relaxed/simple;
	bh=02nKpYBSa2Tp4F/0iM6da6XQp+NtnDZubCS9cuXVfc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvLEJypa6c3urqnJUYxCGDx4PCz/2jQ3Ioc8BjMRfyPeKKdlwURBfSJqD5P4PkITLKdW1R+q2R04ayiPnXV3y0Av1wHR1+1BCxdzQ2+Sffc7CDqfo9OErxbMwPWtanr4DA5Oqou2AWl2nTAcbp6xZs3VoBmxjE59DcWuKcy1QzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ITx6tC7W; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ITx6tC7W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DRMUA5RlydC0U3sOfNTBJG3gFS5WXneRqrQgymldK3Q=; b=ITx6tC7WysYofV3UA3lYxBFxJ2
	RcY8dcWTZztAoDlCn7rVXmRKRG72/2YvteTtX+SeI1cJ0yf7IimyOKaVUOQhz+S5MSqQcdxltAjjH
	0OtW8MjZs1yW6dQLyYnoDGk2tEWzHod34XVJRVomkepHimzZi2mEnG/gBfnV9eJ0dw189YODfsEBV
	/N1zlWC7W0Rl2m1dMKBGe/DPZcxFt5gzhLhTKh8gj7e/zS9L5FObyVOPPHpWSMrYZS5bF2GoB9wlV
	pyYfC7Vvk0tjb8fWfVKR3L18A4mjUpHW7wmzygZ9J1KZbCaYMfH4zhXuVed6z3DomYuS++Pj43aTw
	kcHjv3Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPdqR-00Caj5-2X;
	Thu, 12 Jun 2025 17:03:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Jun 2025 17:03:35 +0800
Date: Thu, 12 Jun 2025 17:03:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Diederik de Haas <didi.debian@cknow.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <aEqX53xTnGX2b9Gc@gondor.apana.org.au>
References: <20250611175525.42516-1-ebiggers@kernel.org>
 <aEpryXbiFJ5mmsvj@gondor.apana.org.au>
 <20250612060931.GA200686@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612060931.GA200686@sol>

On Wed, Jun 11, 2025 at 11:09:31PM -0700, Eric Biggers wrote:
>
> It used to be:
> 
>     config CRYPTO_MANAGER_DISABLE_TESTS
>             bool "Disable run-time self tests"
>             default y
>             help
>               Disable run-time self tests that normally take place at
>               algorithm registration.
> 
> So the CONFIG_EXPERT dependency for the prompt would be new.  Are you sure?

When this was inverted I specifically asked for a dependency
on EXPERT so that normal users won't be bothered by a question
that had no relevance to them.

You then suggested a dependency on DEBUG_KERNEL which I accepted
because EXPERT happens to select that so they're practically
equivalent.

So make it depend on either DEBUG_KERNEL or EXPERT because normal
users should never see this question.  IOW we as developers should
select a sane default, whatever that may be.

> If you insist.  I hoped to get the people working on drivers to actually run the
> tests that they are supposed to.  The default y is appropriate for anyone
> actually doing development and/or testing, which is what the tests are supposed
> to be for.
> 
> But I guess that doesn't really happen, and distros are expected to run the
> reduced set of tests in production because upstream doesn't test the drivers.
> And they will want n here.

I share your concern.  One idea is to calculate a hash based on the
current time and print it out if and only if SELFTESTS_FULL is enabled.

Then we could require all driver submissions to include this message
as proof that they enabled this option.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
