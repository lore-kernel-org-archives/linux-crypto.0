Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E481B3A3836;
	Fri, 22 May 2026 12:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453310; cv=none; b=rc9EiRnMLhminM6kCk2PGO5HchH+a9Oj2CFZpQV+kPmMNsBAIVo7FNeVdq6mywqQTVGIy3Jp7NwFiZduAc+PB2LOeukrbBD77v8s95wgesWCwrB3m1iag/Excj6b1VSrcRw1x7GdRWzgkiTGHURfkcrt1BON5M9vEPglxB23cxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453310; c=relaxed/simple;
	bh=TrV2a//xaZxE3+nUb+7gAYEo9oZLcEl4EzddOZi2DbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTJBXgyYGWFJx0B8FTdF4pq+rFzRkcmJdCL43S9W4IUNHE13ML2yNYIK+P8MUpbjPNbI42JlaVfdsFl+ukQlw2HzYpLCUI3mi4RXFELG/q+nyDNb14YdffJTAq+HQMMnoB91ikxR9oIjirYzxEimPaTfqUcuGsJlZdi9wSIyIRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Dc+Dck1M; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Dc+Dck1M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=hZjt7QJa/u6Dwk+HGvsbdEV499LGYZqKQzTxwEWV1mU=; 
	b=Dc+Dck1MB3Op6tGcXDR3A9i3puEkq2w4R+tGQgXGR7qAMCjrSCflaj+E04AF/b65d4DqScAa3M4
	wFp4WVhRy0AWaIfd3Ds5enH4xr5+Cb17Ls2zzHc1LQZkbM06pif+4SrkFh/rF8cT4kRfak0kbJk5s
	Fw79MyFkJhU/hux6qqNYD2nW6uIXSBIDlvVLroCQfdTmgRadlmbppJAI556Aa9DDyGX6Tdbcyv9jM
	aQ8Y843cmFhqEnlfSG7OYZ7YjAz0EwH9qABBEIO/u1Hx9arzmMXiNx+Xs8B/DBJeYA20LaldyOGPZ
	rAj35G45rpWp804l8a5eBjEvHmZ0hgBz8t6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP5k-00GSTN-38;
	Fri, 22 May 2026 20:35:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:35:04 +0800
Date: Fri, 22 May 2026 20:35:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: loongarch@lists.linux.dev, linux-crypto@vger.kernel.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] LoongArch: Remove unused arch/loongarch/crypto directory
Message-ID: <ahBNeKRMgUVF7OBi@gondor.apana.org.au>
References: <20260517031430.102984-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517031430.102984-1-enelsonmoore@gmail.com>

On Sat, May 16, 2026 at 08:14:26PM -0700, Ethan Nelson-Moore wrote:
> All LoongArch crypto code was moved to arch/loongarch/lib in
> commit 72f51a4f4b07 ("loongarch/crc32: expose CRC32 functions through
> lib"). However, arch/loongarch/crypto still contains stub Kconfig and
> Makefile files. Remove these unnecessary files.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  arch/loongarch/Makefile        | 2 --
>  arch/loongarch/crypto/Kconfig  | 5 -----
>  arch/loongarch/crypto/Makefile | 4 ----
>  crypto/Kconfig                 | 3 ---
>  4 files changed, 14 deletions(-)
>  delete mode 100644 arch/loongarch/crypto/Kconfig
>  delete mode 100644 arch/loongarch/crypto/Makefile

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
