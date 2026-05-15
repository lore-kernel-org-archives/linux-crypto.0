Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1DD3B1009;
	Fri, 15 May 2026 10:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840351; cv=none; b=ijOVTiDuUHf53WZPntedChYeklOlGyeorM4Afzyiu0+gRYsH+1KxOu7gPzFiYuw3SAXe+Q5586Iam09sSykiIktTYjppFh4BreY9UzIdtqgId5SfelRb0IxmM9nbbNDsC6FXyf06DNVmJq4XygZStniugOM0mMjfbnRA2KxxLR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840351; c=relaxed/simple;
	bh=skUs5OObtvHIW5l9S1tai3j3C738SE8HZv8oD9ZpfN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/myxEHUAFCYrSZbiZ6hhTO+al3wXzMhMOkB0L+RCdhg7p57OiNyvLRmh8VWF+atuqg0DJqJ2e4mUQYLKfD+4+BWD23Zccvvo3Gw9OWB1knrn4IGgwuMMEqByOTNgiXog0GoVTTpPOb7+ivYUTJ7asyRiSNQIB26mE4BWW3hoWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=l07vNgJG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="l07vNgJG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BNP5P1RTLSMO2EZNZMRug211Ae1yzrAmUs+eI+V5368=; 
	b=l07vNgJGfze0G5/viKGJ2qFVe8/d3b7K17NbOhFk4oRTcyUn0puBePi7Da2mlaLnCt4/p8BcUI3
	3kckXdp+HMXlMSKvPQmvh/CNUSArblk5hnzqv5fbSx/Q1Dd/sRXL9fjZ1244jY0sOJQI1inx+a/bl
	/z63YIQVvq1ujagf9g1dYD7V7QhvwN0ZIJwCRxtk7GfO+fotWuOX7w01yZQzxNNWqqvN8nXZ9B3Yd
	80OQYij1pFeQ4AV9voPrNhoVFZ3F/v+bvhwvpRxFlE2jK9DrqArroHeeMwC0v//QcPDXEj0gHo3L0
	pMK+9a03LIHc1moHfYjI9rME46rXswxNniAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpdD-00EOPw-32;
	Fri, 15 May 2026 18:19:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:18:59 +0800
Date: Fri, 15 May 2026 18:18:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>,
	Lianjie Wang <karin0.zst@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] hwrng: core - drop unnecessary forward
 declarations
Message-ID: <agbzE0Cgd2wUbtzn@gondor.apana.org.au>
References: <20260505094555.158017-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505094555.158017-6-thorsten.blum@linux.dev>

On Tue, May 05, 2026 at 11:45:55AM +0200, Thorsten Blum wrote:
> The forward declarations for drop_current_rng() and rng_get_data() are
> not needed - remove them.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> No changes in patch 1/4.
> ---
>  drivers/char/hw_random/core.c | 4 ----
>  1 file changed, 4 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
