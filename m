Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C753D961;
	Fri, 19 Apr 2024 10:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522899; cv=none; b=LFV/pzpBvTjkSO0oFs6My43FbCdVZWjIXHyHuA5ceY4wOvr2M5IEKQLvrgAjQPTaneFJSgz+3viMHa5wbi4DDklyHQ4k36cxeYnQRuYpl91aR/QH0PkC0lufOvqLXhBTm/dVobqdAer1Z0HcOxzlNoXVGTl0HrT0Sb242U3NSpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522899; c=relaxed/simple;
	bh=DFouNATQPkRDNIqJ6w8LCJMonzEE71C5cEC1VoXWFng=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=JhhrFApDRdfiJUBaoVZ7qIyPtzbd+lb6iDbko9Fp4e8uNU3hHtkR5Im/M1FvTdudwNI6bRNi6pwqxx8yKhbqbPesdDSspl0UsllpjFPRUhpY7hVuM1IKLVBOr8AdQpBgUdsv0MoAy+nsol2ZDWhXBuO90OAio/ndJzDRcTWkuQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rxlZr-003s7X-Bf; Fri, 19 Apr 2024 18:34:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Apr 2024 18:35:01 +0800
Date: Fri, 19 Apr 2024 18:35:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 1/8] crypto: shash - add support for finup2x
Message-ID: <ZiJI1RhdHUsCDELY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240415213719.120673-2-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> The new API is part of the "shash" algorithm type, as it does not make
> sense in "ahash".  It does a "finup" operation rather than a "digest"
> operation in order to support the salt that is used by dm-verity and
> fs-verity.  There is no fallback implementation that does two regular
> finups if the underlying algorithm doesn't support finup2x, since users
> probably will want to avoid the overhead of queueing up multiple hashes
> when multibuffer hashing won't actually be used anyway.

For your intended users, will the SIMD fallback ever be invoked?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
