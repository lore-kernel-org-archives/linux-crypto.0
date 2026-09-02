Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5223769EC;
	Wed,  2 Sep 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338317; cv=none; b=cJ36xMJA5DF+SzFv7YmA7pgI1nb7UaQ5hRuqg/irgIl83YXSxY5gNkMFBkD2oIZKm5nuTSm82G25/Y7HYhdgCWzPtC+xSp8rwIwMCB1ZeOXI6nuhQjKt8aKFiDMmylpQsBFfvIl+g+yBZxLlpCUQwSb85yy1Tn6Jy2WScNxwDh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338317; c=relaxed/simple;
	bh=lPJYlzyokiTQSjXVgfakt3zZOMcexHQ+9rv8f9bKPkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9CINyAdfi/PV6qspvs/j/XUKsO+KdwqjUhoQupsfdHQ4ji0zphp3Ner5In4xvCg1mIaAO95ldDuzkJ5IcmVzAbU1mFcjQjRL4ppNKIXmoDdR8g21qknNBwzPOKQCTna6ueBlOkspHOUj3JCFbZJxYrVwyhMKb5yechL5A4xePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IrNGfo1m; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IrNGfo1m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IUGtGzF98psluIMwFKKhWZ1F2aTDu/oFCty2F4RSaRc=; 
	b=IrNGfo1msBTd2jJSmtp6stKWgZPmtFNohA21TwwxaLT06/OMEH5Nz/liCs95wvhXyjXnM0zrRHi
	14t2qAjv3b1o74RNHx4CHsQXt0P+pmqdA+cKksMIHpFM8JjU9H+2VFczthuZmlrEV2rl/QOOCiZ3t
	VJD2En1G9lJihZ8isAEoRtj9xPAU03G74NPuM2EE/7ubO5Rt2BdlFBluXwxotvOIaJoCVhRu3Gv4N
	82hZ+q/1rUBqontM+XFgWOQYlP7skUB3+8KfbUliswb7ok3D7kb8+2qSssX9Wy8YOiwDPUplRzOyo
	hbcu2rzafGHt/GSk+y9yRxdtCfTkaylK6uLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x1gUH-0000000A14t-0vh0;
	Wed, 02 Sep 2026 16:38:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Sep 2026 18:38:29 +1000
Date: Wed, 2 Sep 2026 18:38:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in AVX2
 code
Message-ID: <apfghSk4CWshYcUF@gondor.apana.org.au>
References: <20260831211715.213121-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831211715.213121-1-ebiggers@kernel.org>

On Mon, Aug 31, 2026 at 02:17:15PM -0700, Eric Biggers wrote:
> Since the AVX2 optimized ARIA code uses YMM registers, execute
> vzeroupper before returning from it.  This is needed to avoid degrading
> the performance of any later SSE code that may happen to be executed.
> 
> Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
> Cc: stable@vger.kernel.org
> Cc: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This didn't get picked up by the x86 maintainers yet.  Herbert, can you
> take this through the crypto tree?

OK I could do that.  I presume you want this to go into 7.3, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
