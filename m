Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4AC3AC0F1;
	Fri, 27 Mar 2026 10:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606171; cv=none; b=bXhmeBgURcSL62LP8vIua0YujiJ57IMqAzoRUQHNex7CRrePpHylJ+pFYIhwExHC512FpiOeLxqKg8KNGLEusyfnQuM/o2bCSCG+iTKhUoViyAEjZgO2YRuxnVJ3r5vw3lm3sjaOF29viilWNfLmmz3xokgixNIHF+lIbNjYREQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606171; c=relaxed/simple;
	bh=m+g54bgFjEeNIeN5rDj0Rp/5IZ+j0+Y7vLSRHt2kNwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grnz4n57Hw/8cNzYYikHbfCIM4P7eDC5bsYdCHMfz391QhdtKGxCAi5kjVWmNRwlwNDqONzBOzBwu2H28wggkCXJtu5WKs8RLAGVV75GtIXnq9i2nA0dzomO5AhtqqG1XuzWRbu/j2tDCiKxtAdlNE4HxNpxaJQ6MAGNlktgla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Of2njq76; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Of2njq76"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ug6KQeKU90/8ytgLrLm9lw8LnN82lF3wPwmFFLQbIwg=; 
	b=Of2njq76FdkIclNaIEopTiU7xXao5bXf0nwdQk+MrbyzMs6sgFz7tMFTSWZ8QIPhItguu+6LppE
	g4xsZMS7S9jWysu0t00JGkejbB2LkMC2EE367PKcpCvcWRTnj5EcOvWR8dji89v4Bp1QompvBqc2g
	wwfF63EhRsLkvnLxYobXFOyBSuecqJdMg/lGDiMxjrui2ZqrNbq+E3NSzxYt2IyfKmJ9Gx2kr8/nF
	U7OEQlu524iMQ1m8S3yodrVZuCrfoxJu06TM+ic5HIXCZIX93XYMbYHMmzMQ4fOcIk7gewjHzTK2h
	3m30LUHcxVL3yO6XvMXW5wfW+0zfeAC7N0lQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63id-001br9-3C;
	Fri, 27 Mar 2026 18:09:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:09:26 +0900
Date: Fri, 27 Mar 2026 19:09:26 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: cryptd - Remove unused functions
Message-ID: <acZXVtF7xAVpS0AK@gondor.apana.org.au>
References: <20260320221727.38346-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320221727.38346-1-ebiggers@kernel.org>

On Fri, Mar 20, 2026 at 03:17:27PM -0700, Eric Biggers wrote:
> Many functions in cryptd.c no longer have any caller.  Remove them.
> 
> Also remove several associated structs and includes.  Finally, inline
> cryptd_shash_desc() into its only caller, allowing it to be removed too.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting cryptodev/master.  It has a dependency on
> "crypto: simd - Remove unused skcipher support"
> (https://lore.kernel.org/r/20260314213720.91525-1-ebiggers@kernel.org/)
> 
>  crypto/cryptd.c         | 112 +---------------------------------------
>  include/crypto/cryptd.h |  33 ------------
>  2 files changed, 2 insertions(+), 143 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
