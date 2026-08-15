Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31A9140E5F;
	Sat, 15 Aug 2026 01:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757508; cv=none; b=Qaln4eXdCH/H7XrHVpVuaSSGFsByZeuaOOIZlSRRydg2M3EZw1kiD90/sicRHqBdwALh1MSGtBmglQLPjsqQDz6ksr9h8iDp7TdxJBj55ytDCPe3D3u3NLadz1waoKTSl0NkIxZ3rY0ImF7JExrVL+WyHN6Vk3rkfDQjBNyB+iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757508; c=relaxed/simple;
	bh=Ed3rHP25PtC8jdRiYIJQ/Cog1YEQEJktsgIIRJW8tic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cde45R5U44biM4egKhA8oLWL3DucESEk8Ou674tzJhmWLsOa5hNQibdgUbdoIrIlfRRueI9DpiCbfxcjo6IDJZGHB/NkcmpmD41cEIAW9edY5jGGOvXpQgMutqIGAVu1lSDNhZ1eISBP9M1BZIyJ+/0yelk4PZhbGw75ychGROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jYP7kkMJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jYP7kkMJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7v4tKLMfw1lVhqUjt/P5cbjEztRib6oFPoXh95F7QsE=; 
	b=jYP7kkMJ6MrQPYD1PguZc35rJpHPCvUEaNKUxrYD8T8ndymiO58c0ijnuaCr2G81pNo8i6FwK8D
	TM958j3zM/mrw4iYgaONpqe1eGxnbJYipTXzR2Dm/P4vPfqrLO4/+kcertlGHHoyWC2NNEGvdLYdS
	bGw1qCJ0i9NzJHG7K+xrvx1gBozc1LWVdDxyP0VnPa0XC5Qq7iP1FLl8Z/DA3WLPlky6pb1AAabx2
	OWdHtUc28H7oW4/DOPeTaVdk1RHC2kTl4H2Tp+4uFUvE5pPiUY5RscutCWzpFEeq1RGluApqNa2K3
	v9cAosvod0CVyuRual8JZdJGXuU8YkB3xiUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3FP-0000000554c-0Bgy;
	Sat, 15 Aug 2026 09:31:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:31:43 +1000
Date: Sat, 15 Aug 2026 11:31:43 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David C.C.M. Gall" <david.ccm.gall@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] crypto: sa2ul - use crypto_memneq() to compare AEAD tag
Message-ID: <an_Bf_LUswjwudbo@gondor.apana.org.au>
References: <anX9UKJ66Aak4ICV@fudgebox>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anX9UKJ66Aak4ICV@fudgebox>

On Fri, Aug 07, 2026 at 05:44:16PM +0200, David C.C.M. Gall wrote:
> Use crypto_memneq() for a constant-time comparison.
> 
> sa_aead_dma_in_callback() compares the computed authentication tag
> against the received tag with memcmp(), which short-circuits on the
> first differing byte. An attacker who can submit decrypt requests and
> observe completion latency could recover the expected tag byte by byte.
> 
> Valid tag forgery for AEAD breaks the INT-CTXT guarantee.
> 
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: David C.C.M. Gall <david.ccm.gall@googlemail.com>
> ---
>  drivers/crypto/sa2ul.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
