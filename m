Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A21F1DCB1B;
	Fri, 13 Sep 2024 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223437; cv=none; b=PlhVGUqJQVvexmcJBw820iyvtIzGdflL1YArttPwwEnz3g6dYn3EyukUL39e4i9EFEiibCZXMHJ1GDGHFD6C6BNPLJnM0x+TjNGgcqplQC1vhx6LXtlvzwgGKKQTiRdFoiLgwH0IM9U1kiZ8vsjope7Afo9lCo64nzRUMWb/gL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223437; c=relaxed/simple;
	bh=BnjPmVb0BSKWEXaBQTjdWyLgDL3ZHVxYPNSE1X5mmFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=su/uZ6jkrQxRU+PXoxCfK+G3zri1IJveFq34Ffz5GyL5guDRVHM1W4GLCdp2OXTqKN2yjPUXYW5QfxkS/9AqOtNLsVcJS2i7u1/vI0Q+tU/bdloNUQKiH63zEihXrBExtB3HOYkYRFOT+NRJvT2q56ma6V4uNYbajV3FZ0VdAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s73hu5C4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s73hu5C4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9BWWxqzXVcGdS8wOTgfzpZaI3rs4ar7k4VF3nwXPb+g=; b=s73hu5C41QWsKrseJPCPSsxqaL
	71qGa5FmajoGKgiTQ674DlIbR9PAhxuGbU3td8R4sMGX+/o2EY0KzJ4uOqQ5T6YqvTXkSMVMgFdkX
	dtGRTG8Mi0DiIh+r9HI/6cPFb2mjKDG2GWZJ9fCzTZvwrZpqmrDt1+wTNpqg1IRPEdHycE4KqrAC4
	OqhmhUAspb88uDL65XWfesCNNCKLi7QcrUAIAQigffbZigD4gzaczPnj3dzSwa9L582Fk8Mvy9U0q
	AZ/d7j+YpBfmYVsg+vaJjIC8ef+rl0u6Aucvv2mYY+sbwY/eqhud3wNdI4kCxGPA+vZ7Dyh9qZ6uh
	y0y+sNSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sp3PT-002DsL-22;
	Fri, 13 Sep 2024 18:30:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Sep 2024 18:30:29 +0800
Date: Fri, 13 Sep 2024 18:30:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Riyan Dhiman <riyandhiman14@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aegis128: Fix indentation issue in
 crypto_aegis128_process_crypt()
Message-ID: <ZuQURVsiGsrhYYjO@gondor.apana.org.au>
References: <20240903125539.12679-1-riyandhiman14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240903125539.12679-1-riyandhiman14@gmail.com>

On Tue, Sep 03, 2024 at 06:25:39PM +0530, Riyan Dhiman wrote:
> The code in crypto_aegis128_process_crypt() had an indentation
> issue where spaces were used instead of tabs. This commit
> corrects the indentation to use tabs, adhering to the
> Linux kernel coding style guidelines.
> 
> Issue reported by checkpatch:
> - ERROR: code indent should use tabs where possible
> 
> No functional changes are intended.
> 
> Signed-off-by: Riyan Dhiman <riyandhiman14@gmail.com>
> ---
>  crypto/aegis128-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
