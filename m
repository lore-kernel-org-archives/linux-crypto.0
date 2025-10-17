Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAD227FD5B;
	Fri, 17 Oct 2025 08:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689109; cv=none; b=LfbbAVwHuQJVohog1cAZACHERB1L4AzAMskavXjBPU1Oo0Afr8+li1DCKwNmCnM7IJJ0kfZ4VMK/FK9INgjwsawfSMLhU3I7mUc9uv4AcgcLtbTE1WUfrFU6JvEzZ8JpUXaGmr5UjTK5n83YsPgmPWzW8/cjnC90J132Y5qt/As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689109; c=relaxed/simple;
	bh=BYKpWu9LzXbMiD3TiFvSQ5Xlk3bKT8EpdAsHmXRB/OY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=na552kvkkE/o9J+FGf5ZObSiBw7rpR50v9rEbhWIHfbaVh8x/5SR/RC4cEhK9+YsJ2pONEJNglkHIGEcRHRj1cGAkJbRyh53BhfYNbVOTDTbxUfBFt2zJwzwsEcseiz4bqRlR2869LpCVNwaVztpteM5I7Twr7Vvx/+b4jNm9H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=r3XujzG+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="r3XujzG+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bo0e6pieeECqFqokjv2Deq0xWP/S8pCHoI67xV/q/LA=; 
	b=r3XujzG+pYn8FWRufbKg/apIALprem/ih48ldhq73aV9xzXwWFiYjarsu4AZj6/glyuYSEqxhH2
	W5VMg0cMwt4jJSSg8PJcmWkNCKb5WqN/FRvEWs1MKilLC0hKFah/RDN+jd3ZTAmCnGsalefBiKa1Z
	DXlfUZUtOwwukaItm/SU0YS9PvlKcu8F5abRfS7Z/EjSm5SxNm/byKojZ47c87vnil0abJgw2XIQK
	w0neF70btF5ahhU4eG9KpOV6cENwYxzv7NJXsJTPq5OnCAM/9uWqPxljQGPekVWGoBXLqc7lZ9GiA
	zTVaA6sMGDFdddlfklIXjBeGdeEIEArWu8Lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9ffH-00DN1i-2G;
	Fri, 17 Oct 2025 16:18:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:18:19 +0800
Date: Fri, 17 Oct 2025 16:18:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Karina Yankevich <k.yankevich@omp.ru>
Subject: Re: [PATCH v2] crypto: drbg - make drbg_{ctr_bcc,kcapi_sym}() return
 *void*
Message-ID: <aPH7y-MX8lT6YjZr@gondor.apana.org.au>
References: <1bb8aa58-7f40-4ba7-959a-e44655aa4a83@omp.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bb8aa58-7f40-4ba7-959a-e44655aa4a83@omp.ru>

On Thu, Sep 25, 2025 at 12:00:10AM +0300, Sergey Shtylyov wrote:
> From: Karina Yankevich <k.yankevich@omp.ru>
> 
> drgb_kcapi_sym() always returns 0, so make it return void instead.
> Consequently, make drbg_ctr_bcc() return void too.
> 
> Found by Linux Verification Center (linuxtesting.org) with the Svace static
> analysis tool.
> 
> [Sergey: fixed the subject, refreshed the patch]
> 
> Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> ---
> The patch is against the master branch of Linus Torvalds' linux.git repo
> (I'm unable to use the other repos on git.kernel.org and I have to update
> Linus' repo from GitHub).
> 
>  crypto/drbg.c |   38 ++++++++++++--------------------------
>  1 file changed, 12 insertions(+), 26 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
