Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E6510A1C;
	Mon,  7 Oct 2024 04:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728275554; cv=none; b=ci7A3JUXIV5J7nPBrhD8bK4gvtmxda8LedsbFuBMd1T8HEGxwr6XbTWgel4DK3qWQ05snatH0YpLRDdJJrE1ra7JVN3glG5tgasVOzngh+9PZSxTsYNTBY7YzLtyDXDn5PGsHxp0uVF3IAYR3bPLr2ypeZPZuw5Mvrp+rdkTHrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728275554; c=relaxed/simple;
	bh=tFE3CU1ophiOk6md9C2q65zRM97zE0bXcqdRC63J2io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MyvKl64VjcS7Yu2F+c6lIrv+1QTlkTBSxvAjE6Bo3pYYR+FycBMWF/VsIBqLYuODo02u2yfWU5t3e5XTucIa84+ddnx4myIDR8DHoaQL7TdjqwDK/0EZWFkthBA0DtM8hv+iACCFBcBhZHxM7xtNOShe2Qm9u9tSr4aQ/Ihi+08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rUdzX5q3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rUdzX5q3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=o7SMnmFH+FyD3bxWmFoMm+ObZ1/7pInGDbzO+Qr22oc=; b=rUdzX5q3E3IzZGOmrTZexpSRkd
	/B47jUSaRYKufG6nVJz0ixWfJYozWlNTMloZFAbuccu3h1lt4rPvuVZ7tTkjygEt28Z4CcSTVpGkr
	KFdeCOfHZi6No6WMfDgq9vOdf9h8oCWuUSobaLGs1qPBNxWTyO2wIeCwTegpsyZA+gP7NARufsLDu
	fBy+yFodaw1YbYPa8OGhl29AVF7xPeFsEVRXtjoFuXNHivnb6HirZ5obgBwapmlH6MOyTYcdlE+2X
	kQkSNNW5DgkQt0A8DYdWEt5FXW/hVV5detVUbWhvV5Sun/+bkVLN6684V7PR+vucXNLHwJOIAPmyY
	cI3N6jAw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxfG5-007MaH-0n;
	Mon, 07 Oct 2024 12:32:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Oct 2024 12:32:22 +0800
Date: Mon, 7 Oct 2024 12:32:22 +0800
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
Message-ID: <ZwNkVv5WWrmpOmqN@gondor.apana.org.au>
References: <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
 <ZtZFOgh3WylktM1E@gondor.apana.org.au>
 <20241005222448.GB10813@sol.localdomain>
 <ZwHfiNsP7fUvDwbH@gondor.apana.org.au>
 <20241006030618.GA30755@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241006030618.GA30755@sol.localdomain>

On Sat, Oct 05, 2024 at 08:06:18PM -0700, Eric Biggers wrote:
>
> I'm not sure about that, since the code that looks up algorithms only looks for
> algorithms that already have the CRYPTO_ALG_TESTED flag.

For normal lookups (one without CRYPTO_ALG_TESTED set in the mask
field), the core API will first look for a tested algorithm, and
if that fails then it will look for an untested algorithm.  The
second step should find the larval and then sleep on that until it's
done.
 
> That problem is caused by the use of fallback ciphers, though.

Sure that particular deadlock may have been due to a fallback,
but such dependencies exist outside of fallbacks too.  Especially
now that we have the fuzz testing which will dynamically load the
generic algorithms, it's easy to envisage a scenario where one
module registers an algorithm, which then triggers modprobe's on the
generic implementation of the same algorithm that then dead-locks.

PS it looks like there is an actual report of things breaking with
async testing in mv_cesa so I might revert/disable the async testing
after all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
