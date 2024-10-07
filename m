Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC5B18BC0E;
	Mon,  7 Oct 2024 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728289889; cv=none; b=pumCg5KHFumv0yWFoKGBcJ5ZwZb8Ryi6zutgO0zlVbGZG+79fiw4ecPQC0CM5PNcy1079dN8pRAvflq+72gQicB3CU5hgJ9HmK2f5E5C9cuNn5wz29o+qpvV6ldBz5ma7ScE4fIrfR8LbWymHkc3NEdvqHZ14oRU9f+DH6PRuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728289889; c=relaxed/simple;
	bh=89urqJJgFTOZNaFSFBdrQbwkUJpxAwJPDjwRzmGQk8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZ0hVXA8zXmYjG8vCCcSjmh0xgAfWd+5ZtypyXloGEo5yLMCmpxIo5n94IkIEIFCXmR1LFLCNLfjbZJDEIi3sXBQzfN0Cg+HN3i8vtLi/bNCYqDcOL4hmA7bnyQvGQR80KaIpV+PK3gjxVxS3+hFDJ8g2F/oZaS2gxlkR/MYaQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LGLOdpO+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LGLOdpO+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GcToCRPaIztkagLop0+41I63NBz+F4uN8r4VJ4+Mb3M=; b=LGLOdpO+ZiyWz5P8pqeemo5ZDZ
	k+5YEArr0MzSrn/sdR/n5yZkbGPY/9numMySxhYRDCATlRqyJCx1PPJYm7MXeubgs1uK4R0SNCvkN
	bahmEHYesIlRGRrVTrAWTXOb4E3qCjvxHKJvw9P4n32xvkF0clFu8C7YP8NX43h9b7kddvxV0/Uhs
	qycBoSEpMdIuksTeoZkjvxmUFORbcny9c6sVncCohiPz7HavDCblR4DTjX7HnzbeFrxy1j0pvucLS
	GFCGQxJ+I0AGS7EyHkZYq/Rg4156Khy2OaObcLEtw5JKBT7rOwDTAMucpw0McXhrx5VQyzavQrGlY
	wbHUgWAw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxizN-007Ouk-0m;
	Mon, 07 Oct 2024 16:31:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Oct 2024 16:31:22 +0800
Date: Mon, 7 Oct 2024 16:31:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <ZwOcWtgj3YaAvocJ@gondor.apana.org.au>
References: <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
 <ZtZFOgh3WylktM1E@gondor.apana.org.au>
 <20241005222448.GB10813@sol.localdomain>
 <ZwHfiNsP7fUvDwbH@gondor.apana.org.au>
 <20241006030618.GA30755@sol.localdomain>
 <ZwNkVv5WWrmpOmqN@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwNkVv5WWrmpOmqN@gondor.apana.org.au>

On Mon, Oct 07, 2024 at 12:32:22PM +0800, Herbert Xu wrote:
>
> PS it looks like there is an actual report of things breaking with
> async testing in mv_cesa so I might revert/disable the async testing
> after all.

It looks like it wasn't a bug in the async self-test.

Instead this appears to be a real bug that was discovered by the
async testing (because we now run all the tests at the same time,
thus testing the whether the driver deals with parallel requests
or not).

This is a bit accidental, because the driver in question registered
multiple hash algorithms.  Had it only registered one, then nothing
would have changed.

Is this something that we could improve in testmgr? Perhaps we can
add a bit of parallelism ourselves to cover the case where a driver
only registers one hash algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
