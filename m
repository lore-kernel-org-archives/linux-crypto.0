Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFFB317716;
	Sat, 16 Aug 2025 08:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755333490; cv=none; b=NKjj6VYEdOgLbB9NPOXTzix9xctpwGindvlplXJYNXvCExN6qb9PhwJ1+puzhKEgu3I/IE5eQ+n6GwdkQV5+dEXsIXUhcmRlsQoCve8qIUteaosFKdIM43cKAi+7zUrfIwwQGqEyknOzeGU4ox/R69WDHzcEAJbHbACGTLa/RgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755333490; c=relaxed/simple;
	bh=LHQf5pp4mUrrGm4R6gJfc2G3qyNgFL9d4gqNCCrD1rM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOgVFtqfYUK7M6dCAIB573ybG0hQIteh3rpIh+MqaWPD4enqcPN3+C5oCPaDAbyVsHSURbwL3XuBCGIy19ZVag9NXkpKpS1ZlOxARbbVj9fni5dj2a7iVNJQJBvspRXRvDfuEtsFUUNuG2mJ9Ve3py+lkCwDj6OJIXR7ROv0bKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QI+TiE6X; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QI+TiE6X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XpB1brMcmh9RAgPWvmmPKFij5xOGK33MU6mT4rsoGv0=; b=QI+TiE6XCb3vwhmnze3RvuBpag
	QbGZd5Nx4WI++L30YYtCVA9qHxDLpt9vp/Cb+oY0uV0sJgEsfNzdmOs3NYkKCl0z07nfASSVkaDta
	7E1gTM47aMRmUVleMUtaO27RHthaI3aibm3JoyfRZlsKfai/hJqysIL6FgsiykrwNdkKbYszD9fRB
	v7s0pDaDeGi45JD+wiD0pnbRFUupBcgKUtVvLBkdh0TzpbI+96vAnb5zsEE51tKn+M+g1xOzDjZvR
	g8N+0UeNldhIN7J6u4YEAym/2XRdr5fCrbUs4Ry2qPM3p3kTlECv2foHaulxHgaXpnlaXgH2Q+fc1
	PMPNZ48w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCAi-00ElrH-12;
	Sat, 16 Aug 2025 16:37:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 16:37:48 +0800
Date: Sat, 16 Aug 2025 16:37:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xiao Liang <shaw.leon@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Reset next CPU when reorder sequence wraps around
Message-ID: <aKBDXMe1y16V40Va@gondor.apana.org.au>
References: <20250715062401.172642-1-shaw.leon@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715062401.172642-1-shaw.leon@gmail.com>

On Tue, Jul 15, 2025 at 02:23:57PM +0800, Xiao Liang wrote:
> When seq_nr wraps around, the next reorder job with seq 0 is hashed to
> the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
> to the first one when pd->processed wraps around. Otherwise, if the
> number of used CPUs is not a power of 2, padata_find_next() will be
> checking a wrong list, hence deadlock.
> 
> Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> ---
>  kernel/padata.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 7eee94166357..ebb52c6db637 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -290,7 +290,11 @@ static struct padata_priv *padata_find_next(struct parallel_data *pd,
>  	if (remove_object) {
>  		list_del_init(&padata->list);
>  		++pd->processed;
> -		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);
> +		/* When sequence wraps around, reset to the first CPU. */
> +		if (unlikely(pd->processed == 0))
> +			pd->cpu = cpumask_first(pd->cpumask.pcpu);
> +		else
> +			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu);

This patch does not apply to the current mainline kernel.

Please check whether it is still needed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
