Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284443EC830;
	Thu,  8 Oct 2026 08:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447181; cv=none; b=WIpqnY0WmQGe0erkrlWudfjV/Nybw9SIQqe1+xFFLyTvSsop2DU5hHpYHeyxc3uyr5bVElHQ9afekdOwjjayYBnxLCAweoEwDyV7p9S46b4VQ7WzxKrxUAoHKdZfuy2oH6Ifu1sXhr5qFS2n+ebFQ/srCFl+Yng+KGkFycqBjxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447181; c=relaxed/simple;
	bh=4XRIzFva09Wy+HYE3F4rXVPE6UznRI9eXz8GXTGfqfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qb1m9fYpvQhyEN391OuEc09sF1Bteq/PvkHJ0S0wawoMbovSDpNor3Gr8y40BrPj5OFg0C34YR21z7Mz5VubXdq1gwmZK5iny2HKq3rPP8UJ+PIci8/INgUfXvTRKVbZCZl+XRwn55RPgoKeu3WywFJwqR2MUDBK8oh5zBae35o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UPHtbnfu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UPHtbnfu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ac7EMFljepk0Jyd/TX4T0XlDpZfkDGr6F+1vB1qVH8A=; 
	b=UPHtbnfuIARHYzTPcthKj7ILW4F+HmTHUlgmY+F02e5gRSzbixr4Q0F0PqOGCei2Cpp4866oWwq
	FMr92KfKqQMaicSee+HmxlNXGPtHke9V7b3p1GVuMKV4uvrjhfs1g7aOT5WhQMczn1eR9fbpRIj08
	rE6tTBFAabWkyq/B9UcSkQn0W8OQCJNtPhMFEMY0Fjf2YGZZOUhGzLV8Wy6TdPTdjrW/GM4SPAdPt
	ViAhZ6S6lDwpUVxT03Dqp9yNJ3/tLfDXZzEiX9grfFH/B3K3uDk8itUhisd9XcSYD5o/G+8tVADea
	vBAFBKSbOPQxtrL6e8uyi8Yj9x3ZaN7IMSgg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjFH-00000001nYQ-253F;
	Thu, 08 Oct 2026 16:12:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:12:55 +1100
Date: Thu, 8 Oct 2026 19:12:55 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: vjardin@free.fr
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam/qi,qi2 - set plain_keylen for skcipher
 descriptors
Message-ID: <asdQh0Z3F3mjj0dL@gondor.apana.org.au>
References: <20260928-for-upstream-caam-qi-plain-keylen-v1-1-6edb56649cf9@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-for-upstream-caam-qi-plain-keylen-v1-1-6edb56649cf9@free.fr>

On Mon, Sep 28, 2026 at 04:09:16PM +0200, Vincent Jardin via B4 Relay wrote:
> From: Vincent Jardin <vjardin@free.fr>
> 
> Since the commit 66b9a095f7f9
>   ("crypto: caam - Add support of paes algorithm")
> 
> The shared descriptor then loads a zero-length key and the SEC decodes
> the inlined key bytes as commands.
> 
> Test: with CONFIG_CRYPTO_SELFTESTS on LX2160A every skcipher but xts fails:
> 
>   dpaa2_caam dpseci.0: 40000307: DECO: desc idx 3: Invalid LOAD Command
>   alg: skcipher: ctr-aes-caam-qi2 encryption failed on test vector 0; expected_error=0, actual_error=-22, cfg="in-place (one sglist)"
> 
> caamalg_qi.c is compile-tested only.
> 
> Fixes: 66b9a095f7f9 ("crypto: caam - Add support of paes algorithm")
> Signed-off-by: Vincent Jardin <vjardin@free.fr>
> ---
>  drivers/crypto/caam/caamalg_qi.c  | 2 ++
>  drivers/crypto/caam/caamalg_qi2.c | 2 ++
>  2 files changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
