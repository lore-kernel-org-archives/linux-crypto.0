Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25B44718F5;
	Thu,  8 Oct 2026 08:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448422; cv=none; b=KW2SsEz1Kf8rbNfTw1BKSXAgFzS2lVOP2fSZc8byduTqS+HtLuoxWKAn98gQwA58bYQluLQyIF7Ax/b+4PQNHNbOrYF5nut6qAdMK5OWuAFWcCmbK5L6ushcL9r/ylSLtoSlgUBzNpQkhNAJspR2GLzYOj1oje7bJ09VyIPzLas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448422; c=relaxed/simple;
	bh=T6wB9wtoy7knoPtK23AmO5a8VV9ZRQGnDBgTdXGqPmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNxua/+R7XbVx4fYUnPh05hYjcB4TLg9ZR9Gd5DisD4cTYvVIeU/fstGCNLaPyhK86x0uWrdaQ/0o5DP8bfy/TApL428mOcUVOGWt8M24qkcaWB8PQDbg25CihvEXzHiNzHpQ0Y6H+f7AnyDK7TFZZCEj01EwkC1Bk1nIfXauIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HlfNLCPY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HlfNLCPY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=M7qvxvycRKUr3VRn/IAwsM25G2ry91n1nwMcSratYqU=; 
	b=HlfNLCPYtxyycidMuK5BooFkXup13eA5Jryh9Ix5r9xdMkKng3wDXiY7hssWnxy+UGZyjm6mCge
	GHNXLBQiXB+FOmek0FDUXNHzkH8dzXDMMolsSAYPA2FKd9m7rWiH69MoTnTZ8950KPvUpGPhMXrv6
	3w74ryOFxBXqM1tmIBVbCEszB7V3gazFuZf6nbztmmMWdVfP+W8WHQhvutHYOv2LI5ylrFZlBi7FU
	XiEnSAEXfmxflYlEfDKWEHvTCSgQBQXudTQsLZO/Mv1WP2FdJRsFcvHGvlC8ZHdCQMJUXVBgkjMF+
	eFNNLlwtlCVrSewCLm0V0xB9WiwFKqezDiWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjZC-00000001o4n-497l;
	Thu, 08 Oct 2026 16:33:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:33:30 +1100
Date: Thu, 8 Oct 2026 19:33:30 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Can Peng <pengcan@kylinos.cn>, Linus Walleij <linusw@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32 - use devm_platform_ioremap_resource() in
 stm32_rng_probe()
Message-ID: <asdVWtkRsWWnaV8H@gondor.apana.org.au>
References: <20261002144839.51627-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002144839.51627-3-blum@kernel.org>

On Fri, Oct 02, 2026 at 04:48:38PM +0200, Thorsten Blum wrote:
> The resource pointer is unused - use devm_platform_ioremap_resource()
> and remove the unnecessary local variable.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/stm32-rng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
