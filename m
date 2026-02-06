Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C527A22301;
	Fri,  6 Feb 2026 11:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375730; cv=none; b=Z1TmuerSnhcJ7mJoXJn21cW1XSUvePkQdJFy/WYvmVhJcPWhvHuHeyZp6hEcCUNbwcjJvb0itTQmNsW7g/sIQVWnqKzLoe0mmx3Y+1cchdURpvaAxe2bbuK7xeH+hMRBtBg2mdmt1TqrnbWNvDdFgGyK/OWEiGC7P5oaMNRkyzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375730; c=relaxed/simple;
	bh=ZFT/J5IZFi2raGMpv46P4jupO6mnVJgx8ZJlZWQQ3vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoOA4WnsLqoaYQhivbWpvArDgLXw8ReVDivSVlR9Kdi7ikMBfdHfYv9ITNxcSf+oU1bR1pr+8DDwsz5PIk3ceStrZU0nlPsbkFATNzjGpdQCO9nIoOMFVRlZFgxPHexpLbUmzgOZRf8nuU/c8+eFFqEKf1yjFYVF7+EsBfgqdfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UPzFOGmA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UPzFOGmA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7t6+yDO8eeNGPouZY7wy/I0B38I21LpHM224gOaecsU=; 
	b=UPzFOGmAZ3w6NvIPol5swbV28+CX2SVPs0ZKmz4CQx9i9dSrznc0XqSgRU72m9YX8kQZGFD125O
	pk9KprajVt6lPWOUqE0OH/qPC/ktx08JNrDdh664tZRFpz2g+k8SdR9jtU5oYsUIyVWldjV7r/hZ5
	KeXZvshK8PnA5EwFtpt0FNsGJRMgCmVC8Loj1daUmKxjuFMO17rhmF/hndJbvkTwtq3JoqFQT3HsM
	xWXsCikiVOl9K6tFnJs/EN70XxNewXxy7II9kSPkFC2ql/GRebEjhSUQ6w9cQvHtzZPZ2Feeg7unB
	i/MTZrUzbKjhgxOVMpyvQ75POR5FfW5VK3Dg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJb9-004zYA-1U;
	Fri, 06 Feb 2026 19:02:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:02:03 +0800
Date: Fri, 6 Feb 2026 19:02:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: img-hash - Use unregister_ahashes in
 img_{un}register_algs
Message-ID: <aYXKK5zNsZyXpVhN@gondor.apana.org.au>
References: <20260201175632.662976-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201175632.662976-2-thorsten.blum@linux.dev>

On Sun, Feb 01, 2026 at 06:56:33PM +0100, Thorsten Blum wrote:
> Replace the for loops with calls to crypto_unregister_ahashes(). In
> img_register_algs(), return 'err' immediately and remove the goto
> statement to simplify the error handling code.
> 
> Convert img_unregister_algs() to a void function since its return value
> is never used.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/img-hash.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
