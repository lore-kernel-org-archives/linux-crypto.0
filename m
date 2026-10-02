Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0062544A418;
	Fri,  2 Oct 2026 08:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929357; cv=none; b=RfxJLhvxo5A5s34NBQlpErxC7bqR/BtxJ+mXUeaSrmNH4rAe4wvZJ5pO1nFzulHpk9ptUVK37mz+e4FCWmDLZQcACkTzuiq70pMVy0/dO1b1C7yAiYgKONrr8ksspVH62MLso+9MFERf57Y5jTkBldBlgaWhTHaFERMahLU8fZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929357; c=relaxed/simple;
	bh=4ONRrTsSyqtWVjeDxG4XLM9JKJ83FKKBgXd3S3HLER0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWzr+yscDTcc594tWQ63rQJKChOMGwK4t3wUhwhlOki4RnfjifhKDTzEK6uXdQ8BpL+PZc8MO9UhZ9jy1CeU7qj3aBLdLu5y41YpJEnC3giZOrvlsY0ElSX9p+cImwjWzNleqcj92/g1pD6W+RbWTCKdnh2zapfUH6S0a8plKP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Z3oarPXV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Z3oarPXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GXm+uHlHfZgedQy7awQGODnu0Y7BrstQqwvkQcn0G/I=; 
	b=Z3oarPXVmBdSH7uO8JIcZjqyZ8sV2zsrQm7KUmePRt3EVssn9iQA8vDHfq7TNxptA21gXbjb0ls
	K2fbRSeGdUI5/ygNMg7Omn8iFozvQW82oiOqHbovWAv6ZzpveC2zhx7yMb0hlxHhtrCTQiPswHwaI
	R+d9zQDfnF52RXW1kUPTaM/OexYAUnis0czxpig/71WQfq48wlQfcwSL1TmSgE+P9pcXHsaUfsMn+
	O6Y3G2UdP+LZKY2WDClQeUUl7thzeLbKkPiI5MSuXZz6NDePPWNIGLlOHvu/wyn9XnEeAjbhd5h9z
	dV0RyfqludBoUefYW5I4lpC3IFqWQKxCgRvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYX6-00000002mc7-3Pgz;
	Fri, 02 Oct 2026 16:22:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:22:20 +1000
Date: Fri, 2 Oct 2026 18:22:20 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: phucduc.bui@gmail.com
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, davem@davemloft.net,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Gilad Ben-Yossef <gilad@benyossef.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: Use pm_runtime_resume_and_get()
Message-ID: <ar9pvDoD-JXb704Y@gondor.apana.org.au>
References: <20260922031954.320895-1-phucduc.bui@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922031954.320895-1-phucduc.bui@gmail.com>

On Tue, Sep 22, 2026 at 10:19:51AM +0700, phucduc.bui@gmail.com wrote:
> From: bui duc phuc <phucduc.bui@gmail.com>
> 
> Hi all,
> 
> This series replaces open-coded pm_runtime_get_sync() and
> pm_runtime_put_noidle() error handling with
> pm_runtime_resume_and_get() in several crypto drivers.
> 
> No functional change intended.
> 
> Best regards,
> Phuc
> 
> bui duc phuc (3):
>   crypto: sun8i-ss - Use pm_runtime_resume_and_get()
>   crypto: ccree - Use pm_runtime_resume_and_get()
>   crypto: sl3516 - Use pm_runtime_resume_and_get()
> 
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 3 +--
>  drivers/crypto/ccree/cc_pm.c                      | 8 +-------
>  drivers/crypto/gemini/sl3516-ce-cipher.c          | 3 +--
>  drivers/crypto/gemini/sl3516-ce-rng.c             | 6 ++----
>  4 files changed, 5 insertions(+), 15 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
