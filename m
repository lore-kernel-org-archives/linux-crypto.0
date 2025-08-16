Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB7922F01;
	Sat, 16 Aug 2025 09:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336970; cv=none; b=VUuWAqYBUPZElo+ixKqddrVELaZ+QIUP3m9Y92nnoMkBbN1YXXQCxpeFDCvj9xLsB7g/LaC8XZRe32fw4bRb3SzAAXW1CydaB7ycg3W/vZkC8F4ZXLds001O18uddQ7gaoMYhZw/eVl9b7IjClS7jMb2y3520B5JvbeOcoIP2Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336970; c=relaxed/simple;
	bh=/1pt/Ax149Ucup7Nt2txYOsEIyWEw6+gO1tzzeaHwIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=el/ruZFUhHb+KwInUUSTu50osovehfdbrhMoNYqLSEBbM1z2BVYEj5mqq8mBQ3YDx5trjQoo6l5qnfCHe9job07t17Q8a951q7AUVIwN8QeUMx/FkKAVnS5CuCeOTAzSg08asoBSU/3gyciYlWjArk9UuocvPyjM6bD7IdmuWeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LdtfESGE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LdtfESGE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Fq6RIGRHETJQRN6GMQSC7EpCGvHuhx6pqf+/Q+p0nLs=; b=LdtfESGEvjtEwMxpr3R//KUaN4
	MQEmTiWg/4tQOMRlmqQs7CmywuvRPUKqAgKwYIaunCtABLv16fxr4KZl4tfvK8TDuVNhy53uiFmd1
	IR4CO1hM2c/0ZZ+yGUTl6s4Oj2xOd/yrxyUdQJryFwy6E9c6GHfWFYgnKAUhISz+0Op9vC8OnJ4s4
	VRkBmz7eonTv2t8GaJ0cHf3lJQZsaLuJDNu5PqsuwvuA7wyw+yPVWcQ4J3bgaYj6HW5VvVhhUyezy
	qOu877GAA3wyKNK/JFKoHXBP7gCFkWh5n96O+f/Rqc0RaRXK4rtp3UtVaHPiHYCjZtLJYqLSh7z2u
	CuIs/taQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unD55-00EmPW-35;
	Sat, 16 Aug 2025 17:36:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:36:04 +0800
Date: Sat, 16 Aug 2025 17:36:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Sterba <dsterba@suse.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	ebiggers@kernel.org
Subject: Re: [PATCH] lib/lzo: add unlikely hints to overrun checks
Message-ID: <aKBRBLnPYhI02QnJ@gondor.apana.org.au>
References: <20250807114444.1341921-1-dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807114444.1341921-1-dsterba@suse.com>

On Thu, Aug 07, 2025 at 01:44:44PM +0200, David Sterba wrote:
> The NEED_* macros do an implicit goto in case the safety bounds checks
> fail. Add the unlikely hints as this is the error case and not a hot
> path. The final assembly is slightly shorter and some jumps got
> reordered according to the hints.
> 
>    text    data     bss     dec     hex filename
>    2294      16       0    2310     906 pre/lzo1x_decompress_safe.o
>    2277      16       0    2293     8f5 post/lzo1x_decompress_safe.o
> 
>    text    data     bss     dec     hex filename
>    3444      48       0    3492     da4 pre/lzo1x_compress_safe.o
>    3372      48       0    3420     d5c post/lzo1x_compress_safe.o
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  lib/lzo/lzo1x_compress.c        | 2 +-
>  lib/lzo/lzo1x_decompress_safe.c | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
