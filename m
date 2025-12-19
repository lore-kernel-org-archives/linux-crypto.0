Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BB32DC76F;
	Fri, 19 Dec 2025 07:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127872; cv=none; b=Vv9MSeYdCvkHurfulhYOGu6Kkpht+il64fzk2H+qnexXd4RVEti+t2vRLax2zXVpAuVYpcb6iIRrbDfs/L4BFUuNgNofBaDu7RODFGLdsPATFmqqZPMtWqxjiNr+A67hJ3xAFqO8Lna0DhASd3zKRBJwAMrlCPaP/8RxBiYmvvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127872; c=relaxed/simple;
	bh=O3cLl0g72fQ8GEjNck8m04VnQPvKRXC99Qhbt2Wbibc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1gum9XiBoYpKSeMRlxvXfb1QkwHuqUtZow1qyn0k24GM7QgvofQh6alrCFmC4NQvvYLLezbk3sw3nCrctdjuNHOfMRVEfdX/jBPONflYuWnpoxGuQzWS+gUtSVDTAdrO/NB/9bwKnb47tlbN3Z/hXwc40ufKcdYeyqqsACF7ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pTkWmIRG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pTkWmIRG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4FosRYBJlEbkLLUD00ELRY8vYMErI29hJDh6Qfnjors=; 
	b=pTkWmIRGUv7thqGV+wct2HuxeKWgf3aOlzDgIqwNUT0arlN9tw4LpAIz4rBdCzXabNGO1ppzMmp
	qXql21didp5FASdn1X3WuLLABS1HtVGij+pJxyAc/4lt+CNMmhxCerJUa7o5RYYIf0PmDLFS5Vxh+
	dajkByNngMOYJ11gs+tPtb3zFIXVKt2KK5fl5bkOVqlRgdX4TMzE9m4NTyH/PWykyvQkwJqMEAiLG
	daFOzJ9FAX5LIbGTocEL+GbSazqenEqtWnbbfe+xWf0OW7T+NZjgThwU17rrcKcg6cag1vc+gQAvA
	XOPQOcKNR9ece0wnKMkfvQFefGKvPcu2f3ww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUXD-00BEfN-1G;
	Fri, 19 Dec 2025 15:04:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:04:19 +0800
Date: Fri, 19 Dec 2025 15:04:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: iaa - Simplify init_iaa_device()
Message-ID: <aUT489P2u_YJ4dK_@gondor.apana.org.au>
References: <20251127222058.181047-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127222058.181047-1-thorsten.blum@linux.dev>

On Thu, Nov 27, 2025 at 11:20:58PM +0100, Thorsten Blum wrote:
> Return the result directly to simplify init_iaa_device().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
