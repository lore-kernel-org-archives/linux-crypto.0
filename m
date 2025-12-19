Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C00914F112;
	Fri, 19 Dec 2025 07:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766128210; cv=none; b=G0taQrWeXBv4jOaUrQC13NBN/8yU7MD5dVnUxqZ9KuR96DPq/IF42ngEMaGf8djKwU3tV1vbzQzns6SwNf7+vEaXgjKPxJyPtSN7m11vIroyL4Q9pcxaM2jBEusPe1g71WUokAu+4DRb/hy2daxNpXh4Evx8+ZTqLNe4OCkSLU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766128210; c=relaxed/simple;
	bh=maC0ROtczFcX3gwpSbFFs6TSJFqmGwGbjLl7MbwA+bo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctsOp5KTGmVx5L1+SU8v84S9FRqGtz6NB6BEMUDGXTy06BZ0aouCPkzjndq3sYHIG0EN1CWGyHDs1ICX2PDknhn9UGkNTI1DM6fyacaTqrUrfWYhgi/j9hkstdXg5d65nO/kdcD/Zzrl2BiKR7uix2SKeugDJ/HQRlbKW6dzhq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NNDn/Cc2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NNDn/Cc2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1VZJ9RSm+Hq4gCkBvqlHUKpVeHfOvHNrLvA8y+BXCBo=; 
	b=NNDn/Cc2uIPwevEkVqwV9yKaTkCHobgbgshaN4JTfGgEsJQqyoaRPYZ9ZYkSprwMRACCBexkXiS
	deROZjCH8yPa7bN1FqV7eSzoSWeeZ+JJglZ3etLuKfon+pNiC3mQl0llVzPes5Kz4t3bicb+OutAv
	rPYZsUyQAVwlU22UZOgPMJWhNa109c2b9HpKrDQuewoMWWFhMJi1YFIrEdJYdMl9lYqC1gAEu4kXJ
	LVoLdRC06YUJe2HAOfBoJgvkRscKLHPEPOMMzyaUqLSSyYb4vFR9xx2ydUVjPaVUazZdux/y0mOdZ
	wFjiAdxqRmG5YC8655FU05QiT+Zq3XMB9ItA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUcj-00BEk4-2y;
	Fri, 19 Dec 2025 15:10:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:10:01 +0800
Date: Fri, 19 Dec 2025 15:10:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: scompress - Use crypto_unregister_scomps in
 crypto_register_scomps
Message-ID: <aUT6ScI_pUO5yvRM@gondor.apana.org.au>
References: <20251211085251.799114-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211085251.799114-2-thorsten.blum@linux.dev>

On Thu, Dec 11, 2025 at 09:52:51AM +0100, Thorsten Blum wrote:
> Replace the for loop with a call to crypto_unregister_scomps(). Return
> 'ret' immediately and remove the goto statement to simplify the error
> handling code.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Leave crypto_unregister_scomps() as is (Herbert)
> - Link to v1: https://lore.kernel.org/lkml/20251210132548.569689-2-thorsten.blum@linux.dev/
> ---
>  crypto/scompress.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
