Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A07930F957;
	Sat, 31 Jan 2026 02:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827727; cv=none; b=kRsFY9qX/xBoAk/20Qm9Z4D0PJnHrLAjyB86lfgDTDaO6ScAlCBovZVSbT0qNznBu8Z54U6Q21SrvmN6SYJzeybB9MZYEWWIGyRTTPX5tQPxV+hx/5pDsfbyvwSWuHd0375MF7KCzKlI6wXyAYJ5sxD99ma8pfDIIjP1U0Modbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827727; c=relaxed/simple;
	bh=g+4AiQposzrilp+nizOy3u9YT6zltgTmGEQ5KCXFxNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujMBDB1aphVsPYvIsfracYccgRMMNZPh3UwTOb1WyXfKGB99OLm9bowT/ap3lhV3lqa/0Ub9Ut61d9cxbSSwmb6APrkq7hjylTykWhP4gjNwTjtnk8BYDWVTepGV3F/VurGisl3+SZ9JRUiDOTCAy44egbMgqV7YVD41QBw+cEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O+8c0mX0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O+8c0mX0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ykINfR+68595rbydHn6nTQMnB5GoHxZgrU275cHex9c=; 
	b=O+8c0mX09K+V1RawkhytBx8jZqlVw7Ah/1SBBsVzh9QQiphRIJdqV8a6h+KHop7h2mcC3iSgDce
	oWjYZb/gyMXLpqV5UJMGF6xQXBiNeZn1QZgDDsKGXUvdNTa2Zmn1wIBFfd6fXLXj+O793g554Df28
	1Q/2mr3bOAQmcScDidTW+fsTsRqAs/T/sQHXxPLaSCmj+c427GhUNFuRtvnCARSgC+BLOuso+PQQQ
	hJkprPR3IYIqbQi+gitcBSRVG7FvueB2PQpDYEv09FRAemhHm02sVnG2UUFnuZFh9B3OZ61Ot8odW
	p8oT1b0bUp7obduwG15WPW1Gpu52+7VYrItQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm126-003RrU-0m;
	Sat, 31 Jan 2026 10:48:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:48:22 +0800
Date: Sat, 31 Jan 2026 10:48:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: stm32 - Remove unnecessary checks before calling
 memcpy
Message-ID: <aX1tdmQERL25z2Al@gondor.apana.org.au>
References: <20260109142039.220729-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109142039.220729-2-thorsten.blum@linux.dev>

On Fri, Jan 09, 2026 at 03:20:36PM +0100, Thorsten Blum wrote:
> memcpy() can be safely called with size 0, which is a no-op. Remove the
> unnecessary checks before calling memcpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/stm32/stm32-hash.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
