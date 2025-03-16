Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9E22E336F
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 05:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742103836; cv=none; b=LghOKDQjLNSv65hH585HW2Apn+Y8W9a7P8YAbyB17U5tbxIBG4452JUk1QKg94VqwPdHjkDypPvfr4rhRQ5BfFd/2FZ3U8uYZ6H+6IiUuhiP5OpS+fXYWCEYlFNhWQAsVK/GlYX8MWQBttmrC0zlAsQsxDbql1dj2iQIVbRO9Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742103836; c=relaxed/simple;
	bh=+FT2fkVXn8qYgZvMLHvWK00133cN3AV6wL2/bQxekis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBbmI9nIkEUFpfiRsLFjyWp4lSAa5pY7X35ZzWNESQyQkgsYr+MJF896BZf8UrjsrYhAmu/OtHHUGLtibMcTGZnmLuKJguQWBl069OzgJhqefDImuPL7lvVI090K3vOJb817ksHz8xYYqbd9+uUgXlgpc2KwqkFib6Bz7pzc2tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=P/6tXJqO; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="P/6tXJqO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WwB0tnZBj2NGzoy+NLLn4Z4RrhQr2MSys97LYtvoAxQ=; b=P/6tXJqOkilL84SPkrlZoHs2cN
	lKY61wN6OZswYEXdV9ivo0NpPRX43XRIeFJyAjj4vNxD2arThrrSKBX1kWqKiFyDT7tzlMot9EcjD
	NZXVgUTtCuuVY1+s3e58A9/w0V8cEZZ3x6xUhFS8q5/1h6rvbAwz+zI0yVFcn3oiflslOq7x0VvZG
	Xp3sI/jsdNIR5VkB2JXfuM1BbKDXRn/4ScKEDxSnkcQsT5fWwg4S+yVl/WxoptAPuPV5IeJA/H9Bf
	R8w9GrncK6mPLxKt1lJUawQqEqrA64yKiUFrVSGHGxybEv38eej4YP8Y9IdW1HNZbf3QHbV2MH2eM
	pXw+KX+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttgmr-006zNN-0G;
	Sun, 16 Mar 2025 13:43:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 13:43:49 +0800
Date: Sun, 16 Mar 2025 13:43:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
Message-ID: <Z9ZlFXGbDNNheKhZ@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
 <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
 <20250316044937.GE117195@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316044937.GE117195@sol.localdomain>

On Sat, Mar 15, 2025 at 09:49:37PM -0700, Eric Biggers wrote:
>
> As I've said before, this would be much better handled by a function that
> explicitly takes multiple buffers, rather than changing the whole API to make
> every request ambiguously actually be a whole list of requests (whose behavior
> also differs from submitting them individually in undocumented ways).

This is exactly how we handle GSO in the network stack.  It's
always an sk_buff regardless of whether it's a batch or a single
one.

In fact I will be using that to handle GSO over IPsec so the
array-based interface that you proposed simply does not fit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
