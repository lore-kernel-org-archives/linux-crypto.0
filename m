Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3B91D86DC;
	Thu, 11 Dec 2025 03:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765422580; cv=none; b=ARbQfVSPZp23KscyQEXCgMR/uX11+YzhPHxvpRRQ9nvefxJJ5dncDiy5IvcXvlPjqVtWwj/NzHPvngahOeGJzcCDLEX7pGG3AzD/0o3eW/XgKu0LRyZstoRgu6dOol1jrX66TgLgGoMzOvK8l6b/mdI01jWbXH+07AnxYA7zdy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765422580; c=relaxed/simple;
	bh=/LF25zgn7v/0xrbM7pjHEGtwoqdzQ5dWwF9KjsRhkb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlHZQdB2W5NOSjxRe87ArJnoftOigaB32LW6PKj7kziIue/38hDVH/vgrUHxFOKL6unpz6C7v7CKN2D43Le0dJgr1NYiGSNxoa0qab7Dm8UhMOt0outghTufy0KpG+Tv6bcsDX9ULi/lScc3PTsr8qGGSQFjkoyMyNGqC5j7Xxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PM6C4dhv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PM6C4dhv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ko9NypXMCTjyiPcLy3vvN94112+FkpkgkwB8QHdUZY4=; 
	b=PM6C4dhvHaVeVtxOdSerbBx2I4g8/H/hkNprGg4NlioMjgSiC0N8Q+lyDprv7fmtdCDTAQAx/WD
	Gz7cdowNBbgCrwTd/YWG0DdnZSPkYi44WMJj32IwaDKsd2elpYijurvxjT5TMPAW5W++ED4LOdDUg
	0YGscUgXeO7d94vpQT97lWAM6GNU4w0e5H9W18bMF+OnuNObjpKXYWdqJ/eU0GiVkIgM4tUUc7c1a
	pa1ZsqL29xNBHNKFY7DzhYwUxpgUC/j1Hl86Qk534WM8PDZCuPo8IUtdy1TvrozFtY9BEcJsFr6V+
	0eSNlMw6xgA+wtL6zYcfPUx0DGYwvSw6j82A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTX3Y-009PJV-05;
	Thu, 11 Dec 2025 11:09:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Dec 2025 11:09:28 +0800
Date: Thu, 11 Dec 2025 11:09:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scompress - Use crypto_unregister_scomps in
 crypto_register_scomps
Message-ID: <aTo16OvI0ffoHZV2@gondor.apana.org.au>
References: <20251210132548.569689-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210132548.569689-2-thorsten.blum@linux.dev>

On Wed, Dec 10, 2025 at 02:25:48PM +0100, Thorsten Blum wrote:
> Define crypto_unregister_scomps() before crypto_register_scomps() and
> replace the for loop with a call to crypto_unregister_scomps().  Return
> 'ret' immediately and remove the goto statement to simplify the error
> handling code.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/scompress.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index 1a7ed8ae65b0..3e026a6eefe8 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -377,34 +377,30 @@ void crypto_unregister_scomp(struct scomp_alg *alg)
>  }
>  EXPORT_SYMBOL_GPL(crypto_unregister_scomp);
>  
> +void crypto_unregister_scomps(struct scomp_alg *algs, int count)
> +{
> +	int i;
> +
> +	for (i = count - 1; i >= 0; --i)
> +		crypto_unregister_scomp(&algs[i]);
> +}
> +EXPORT_SYMBOL_GPL(crypto_unregister_scomps);

There is no need to move this function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
