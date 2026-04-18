Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CD872623
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776506725; cv=none; b=NquFMp1WEP81nR+WwDmx361jvRbJ2BEK444t58iSqasIdfQye2kEksl64Q7P4uSoTB8hlNf0mUNxTtXOOtyCpJBUYdEI4bWoxGVoK6+01508M9yUA5rVvi+SlMB9XZ3qV5Bkq/6CQHrbPLnXpGFuGSVCozkctjPByuPtnC+6dEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776506725; c=relaxed/simple;
	bh=uRvbZFAiIEDOs7j8V7AGDtnxhhz9AC/oPl92SD80dvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ggu5o/u9kbPdPeDcOJVoKcofbST/UOhbGSvnumYQKEzdtEtT+hoVM3c/vkZfsvQPBNyV7GyGCEefc5DYnQ4/LYcw4m69+xNgCJX61B+zERDQItBMPXdPHRdzeO3sbtO3VeAaftObE+4MYDxlbTDt/3KhYWoLdJVViYbpz2Wz4MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JJgGg6Dz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JJgGg6Dz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8j9X7kh23OpE+ezHs1hAucPvG16I7bPuYdTRY7NN3mw=; 
	b=JJgGg6Dza3Gldb+hG/YwmIIZfvm3N3aipHTya2KpdlwK9NaC7qusRpD3KhJ1YTCRnURdStu2uko
	hZR0XYNuNIUaWFK6vsAxyiGvSVgBxTut1pXxmckDPa2u3MKaIk2rBSdDmdN0zq/KPbNNzEuQHs4Ud
	50xuwZsts5deMOMuSWCwAJYvry0yi17Opd5l/AMiWOqVJYLlC/RDQE/DUw9THbXUoVw7P23lCkkq8
	ACnY7brIM3HnKC/V/W8cdzLHao5PPgokbJqpmZnNcsaccAiDs3BeLJZrAbbQBX+RNs7ZiQQUb90FH
	MOyVf7h8D5XTVWbLhztv9TY5pd/nzszEDFrQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wE2Y2-006zUv-1V;
	Sat, 18 Apr 2026 18:05:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Apr 2026 18:05:10 +0800
Date: Sat, 18 Apr 2026 18:05:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, tr0jan@lzu.edu.cn, kanolyc@gmail.com,
	ldy3087146292@gmail.com
Subject: Re: [PATCH 1/1] crypto: algif_aead, ccm - stabilize IV handling for
 async CCM requests
Message-ID: <aeNXVhZIAxxwk2Jg@gondor.apana.org.au>
References: <cover.1775841543.git.ldy3087146292@gmail.com>
 <9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com>

On Sat, Apr 18, 2026 at 03:34:57PM +0800, Ren Wei wrote:
> From: Douya Le <ldy3087146292@gmail.com>
> 
> AF_ALG AEAD AIO requests currently use the socket-wide IV buffer during
> request processing.  For async CCM requests, later socket activity can
> update that shared state before the original request has fully completed,
> which can lead to inconsistent IV handling.
> 
> Fix this in two places:
> 
> - snapshot the IV into per-request storage in algif_aead before
>   submitting an async AEAD operation, so in-flight requests no longer
>   depend on mutable socket state;
> - make CCM keep a private IV copy for authentication, separate from the
>   working IV that is consumed by the CTR walk.
> 
> Together these changes make async CCM IV handling stable without
> changing normal AF_ALG or CCM behaviour.
> 
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Tested-by: Yucheng Lu <kanolyc@gmail.com>
> Signed-off-by: Douya Le <ldy3087146292@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
>  crypto/algif_aead.c | 10 ++++++++--
>  crypto/ccm.c        | 19 ++++++++++++-------
>  2 files changed, 20 insertions(+), 9 deletions(-)

Thanks, your fix looks good to me.  But please split into two
patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
