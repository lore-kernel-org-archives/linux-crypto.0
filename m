Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10069477981;
	Thu,  8 Oct 2026 08:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448395; cv=none; b=UFBhnRvcIIooZXNFdT9iyOC7w7B5YHW8RCas2VxnmiX/A7Mna6+U6d8huIK7pYKGhNjkyQp76L3QqIWKYwGzCSoygUAud0CYTllKME62+A9T1+T/uMnUbY2+k7IqAU1zc9FxSoOn2X5nGert32tPJo13pFfCQNYYIT9aR8mKTjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448395; c=relaxed/simple;
	bh=ptejbEzhjlHkJeDA+/Bs3sqxLGtI/WvVVQHo3ywd/QU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBiZ27jeBv503ABmiCwIeAZz7R6d1e/rnyfjCCQB+cc8pkG1NXXKbjeYdW5mkLF8ImJcNlARRzm39RVuBxHQk2lbdKsLzcAg2Tj/mONMR12+sp/dOgnjN5ia8KJrXGILjEMzQpVs7etzCSZ+pzY5XoRCrmoFgKKph/7vy1TFxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gmJ7RRJS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gmJ7RRJS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W4NQNsSMsFCFnhKtJBsz3rtWAf/X/kctiS51Qf8P//8=; 
	b=gmJ7RRJSA7CZ8/A0UJCAk1E6gQpSWh1gnowUBskaRPS+dyMc0rS3NDaomI4VLuNutsWOc5NiSpD
	krnuDSeKHSJgWSs6cyMQJnYYCiiPngRBuTDEOJfwBUhJIim/3MjzpPgs0evUVpl1DSGq6TPQokl9Z
	/cq6FGFWuhYuW+CNcPuptPKEYPFU8PJ8lH9+w1vrc9lkv4wmi5bb9pcfMaAGaN8TqwiBViIL/BiNU
	5jZ4LTl2ybEfare7TEri8d5vEristSnCYMMWeS7mmA6Q+TCKKUxWnwkkW16AFEcHNmHDi+PK9qLKe
	87IWID6aMNlGwSglDgw6xmNaH4L8ixC7v1kg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjYr-00000001o4W-30hr;
	Thu, 08 Oct 2026 16:33:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:33:09 +1100
Date: Thu, 8 Oct 2026 19:33:09 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: amd - simplify control flow in amd_rng_mod_init()
Message-ID: <asdVRa8q5pAkHJtj@gondor.apana.org.au>
References: <20261002141952.169528-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002141952.169528-2-blum@kernel.org>

On Fri, Oct 02, 2026 at 04:19:51PM +0200, Thorsten Blum wrote:
> Replace the goto found statement with a break and check pdev after the
> loop. Also consolidate the cleanup paths.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/amd-rng.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
