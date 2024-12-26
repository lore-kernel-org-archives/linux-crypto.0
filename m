Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B342647;
	Thu, 26 Dec 2024 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735222050; cv=none; b=Jw5bw2ucjB+AQgYv4fbAZiyuYpKZ7ksjx4/MAsdHdFENvChgMzGZPi84iHkMBJHNhaIRjV+W/H8ZqcKJj3lBqUMSfSZxCTK6cmC/oeM5rVvTYuC7izqlklAlX33/qW1u1p44UkoF7ge1KdpNa4+nuvpRuV4hNNZzrFSlU0KiBP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735222050; c=relaxed/simple;
	bh=fJJsUSDuTHRogc28O1/d1YDXQ/1V/TYiq7UKwHKpUKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7FUj5NXXmQkIHaFysHtqPqZsYl8p3ZnVQTIuNVgwW+HOIvkwY7EZzlfXvIukUVEhUTmc39g+BlmZpOBPXXPIW1/UqPY9ExDlGsbnEIvOn75SWn7qRCK4oC6K2nZlLZcjnN3f5qB/hT95nyk7I8uPeR+hpBQW1DeSZLhBH8V2lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=swFFMuqU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="swFFMuqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6iGirQJWy135vs8ZFBTd6WQXibUXBJ+eFblbRdSNPaU=; b=swFFMuqUkoN/0TmPXx6SQN+uAQ
	j3U3IzpoySkXhW6ZbkEOGe4a0KiJTWcjx3ZhppCXKoGBfeOj0g4D1dE3uDTPv/KoNRBY/2i1QF6zl
	N0nNuxzVbqTIQxEW/fHOA7dysQys1BOx7T55PA9FAe/DngJdL4wW6u0FWUTWHqJhD5WD75MtlUTke
	eAfmo4cgM/FYB8Lygxy7olYFzh+zmyCBiKm948eco2uYH7KHrwyZLqHJWslOfJFVs+NQkLizUeWPR
	WrdPP+MnCix7jeKKGHvpfDVGZT4k6+okov08yAZpJI04rccc8jcj86TjlUWnLEEAHhGWDdIDxt7lU
	v/zc5aWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tQoJF-0038mM-21;
	Thu, 26 Dec 2024 22:07:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Dec 2024 22:07:14 +0800
Date: Thu, 26 Dec 2024 22:07:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atharva Tiwari <evepolonium@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: vmac: fix misaligned pointer handling in
 vmac_update
Message-ID: <Z21jEkVKwzrpxjW_@gondor.apana.org.au>
References: <20241226134847.6690-1-evepolonium@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226134847.6690-1-evepolonium@gmail.com>

On Thu, Dec 26, 2024 at 07:18:47PM +0530, Atharva Tiwari wrote:
> Handle pontential misalignment of the input pointer(p) in vmac_update
> by copying the data to a temp buffer before processing.
> 
> Signed-off-by: Atharva Tiwari <evepolonium@gmail.com>
> ---
>  crypto/vmac.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/vmac.c b/crypto/vmac.c
> index 2ea384645ecf..8383a98ad778 100644
> --- a/crypto/vmac.c
> +++ b/crypto/vmac.c
> @@ -518,9 +518,19 @@ static int vmac_update(struct shash_desc *desc, const u8 *p, unsigned int len)
>  
>  	if (len >= VMAC_NHBYTES) {
>  		n = round_down(len, VMAC_NHBYTES);
> -		/* TODO: 'p' may be misaligned here */
> -		vhash_blocks(tctx, dctx, (const __le64 *)p, n / VMAC_NHBYTES);
> -		p += n;

Please use the get_unaligned_le64 helper instead of copying.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
