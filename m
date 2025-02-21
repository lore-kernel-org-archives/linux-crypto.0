Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9409204C0E;
	Fri, 21 Feb 2025 09:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129849; cv=none; b=AFlY/ztpf/ljcodwuiHc3niGrnK67sjuyuiv0XjJLYNMlilMzdU//+yczBOuP1vbc1UaX2ZSVZuKPpddveMLnkR3Af4J00i3BMy1kUiH5KSV2L289K4J0YnKktL4eC3oEMc2GT1TV+UfWhtSzXC8z59PQhrVsM1vfC0RYYdut0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129849; c=relaxed/simple;
	bh=j3mwWCaLC21m0MC8FpSSUM9CpODuqjEdyWr9WgHfp7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jOH4PQ9nB6mH/6OmZeONbtssIawUStv/i+IUEpQLIVf5rrnzQ1PYd7ZRyGTASg2gvcV7t/s+71il9jTz4K99yrwWxIJjEtz9vL/fxHfhLSXsS66d2D5T93HWvB3kr57v265GQqvuvl8w2r0gtCYmXXao+eJZRF5jtxWgO8ck/yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sN7bvsVB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sN7bvsVB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U5FcsabVuGWT81RU+nUUy+iqfRsVRxU0xLqN8PLJKlM=; b=sN7bvsVB7qh7XsaEKAGFoyGJYo
	op97Rbx+lQ6r/LeyyLa9UWXpErER6UUKfLzYQQ1ghwSG4eJVBB+0sTF0zkJqJpHesLc+G90xhlUHb
	Z4P4FLF1f31iZuXIbfJSvgM8ekK7j0dinLwP6p9RWOZtb4rRO6llvMtBs+QBrAq0A2EGla0rBXoyw
	SQ80/rgdGEMxkk6+xf1qVeB6AjGM0UndgokmoK/S15wts9+2eQoEtn8x0hgqbGMv0UwrkWugaHn4a
	Gl3RHhniCig0P/Zzzb9xmw54zceQ+5srsugFyFkrgtGbQ0uFLSW3REoyxYxf+YxkkhSJVdUhcnwCZ
	zw0qjH5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPG4-000YLR-1t;
	Fri, 21 Feb 2025 17:23:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:23:44 +0800
Date: Fri, 21 Feb 2025 17:23:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Chen Ridong <chenridong@huawei.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: bcm - set memory to zero only once
Message-ID: <Z7hGIM9hOvSgr5qB@gondor.apana.org.au>
References: <20250210223647.362921-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210223647.362921-2-thorsten.blum@linux.dev>

On Mon, Feb 10, 2025 at 11:36:44PM +0100, Thorsten Blum wrote:
> Use kmalloc_array() instead of kcalloc() because sg_init_table() already
> sets the memory to zero. This avoids zeroing the memory twice.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/bcm/cipher.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
