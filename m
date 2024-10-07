Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67413E40F;
	Mon,  7 Oct 2024 07:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728287889; cv=none; b=Fv5rCeo2rpNNo3a/1xzgFzTJLnI1pqi2Nl0ZOd9K59pSB5RvKvXODzm/VLoR0jOK0HypVPDa1DAqmfI+YVEVBWm8pV3jVNtgSxR2keYV5n32wruotOEsPx/By6hvCTdifhGNuV6KagdYXgxR+UjDh35RV0j3QJWstUj6ZooG3GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728287889; c=relaxed/simple;
	bh=FXaj9OF91fM3JBEbxEE09M4zqeZDBfsY87UGCQKjhXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sda/rDkpsSwlXZIFyqXVs5TahNWV+3kHRr3rOAJxX4JjsJs3i/ggPiwIPQ+214HTiggVlIE8EQdYso+4xz1lBCAp7xhgcferIgNcrCz9uqNWy4LiTDAcLPiLdESGvV5rXPyBBpYnc8s0lmiahnrV6ZV9xcS8Z+wIrrztT5AaAHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BuW2cOQr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BuW2cOQr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ux19mWauQ7boi+6LoWvIzChBwm+z3gI4jolScsUjUqo=; b=BuW2cOQrh3VoWGswVcM4S3rK17
	TH0xpp+XvSAnw2NUwRTlgwdvHdfaxe+h0wUAz98EwBcF6LQDKRrVecqFhmmABbVriYPfY64mLHIwt
	JFuFh5n/9Y8LqLGv59+6SU0PtAx/GV/rJA7Vemc6XGfQVTBUIpqHJvkZ0IsgWsoJ+DicCU/mw3nrI
	E13eb/BpOPgZKBvaRlwnvzrsGi7W6xCGmtkVLDoL+7stSYoB6anI2N+0I4cVWDZ2jqU4HzGt06+Fi
	3Vqx7B/zKCpai65OrjzLNSZl1N0JOthV81DuOd4QIpXl2W8bBSHQrvsmmlK3BII9EfbmErUlH14Oe
	C+cZwbHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxiT4-007OY3-2C;
	Mon, 07 Oct 2024 15:58:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Oct 2024 15:58:00 +0800
Date: Mon, 7 Oct 2024 15:58:00 +0800
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
Message-ID: <ZwOUiBXrUF0Lj2u5@gondor.apana.org.au>
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
> For normal lookups (one without CRYPTO_ALG_TESTED set in the mask
> field), the core API will first look for a tested algorithm, and
> if that fails then it will look for an untested algorithm.  The
> second step should find the larval and then sleep on that until it's
> done.

Actually that's not quite right.  The test larval is registered
with TESTED set so normal lookups will latch onto that and then
wait.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
