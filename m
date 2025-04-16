Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D6C22DF96;
	Wed, 16 Apr 2025 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790373; cv=none; b=U8N5gKmoh09rwcrlP1TMEYKCAfq5R7UaLxK87axnIlyc5bOyhpthJhbZqQ89WrQI0gyQbVdOEbf2qa4WFvTXtO7yT+Q+V1o4ND8zpPXmGBwSmmLOVtpDskyLbX0qP0XI4dn9Uclc0ne+8eA8C1qUQcED2PuGjeVZcnYywxN4Rp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790373; c=relaxed/simple;
	bh=mOxBpRgtcyJIhsNVhF20F/Xs7vhTgJEsIpqDQe2I2hE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyHtv9wEkq/5RLUiZOyB6Y4TMJ5eNTTVfDb7sS9rk0JYXvTUijHrD8lsrTyHGwfqv0H5DCUUVjS+IhCYhTlV8DdWgBVeiRsjYRulLb1zVOVJr59cr18vHB/NDMxEWEK4iRBk2h4Usbh1HPkcG0NK1HRgsseSJMUnzTxkU2Qdgtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YZOlpOyv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YZOlpOyv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WrhhNGGmHGn82GqlBOWy7dzaZJhKoFDZvvGJM5Qchb0=; b=YZOlpOyvwuZb8ro5AbjIQh4G46
	Fp2VpfwNAQRKyM50eq+k2vuYKXr1pIqSSkydQ8FCAmPql/4oX91KX+QTzw499oks1G9EO9EGipZ+R
	huR0rNUY8b/Lf3M3YwxJhL/Sj8QnnuvYzmduL9kZDwyj5/h11/yiJ6wwqYY3aEuseMB12rTki+BPS
	9wy2g/Zjsw7Gt9u6aBXMCUzgvlfbeLbxqfShwFU4MgmIC2TtR/rsFUGDvYtskuI39mA3nj7qUTkWu
	mjyBV2DvPSL0EUwO11bzM3rWm+QA9EYMB1ZXzdXl4OjM1mawvwZCda48zp1bhp8Kbjz1mvBNSmQ55
	dJPkruJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xg0-00G7xM-1d;
	Wed, 16 Apr 2025 15:59:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:59:20 +0800
Date: Wed, 16 Apr 2025 15:59:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: ardb@kernel.org, haren@us.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: deadcode structs from 'comp' removal
Message-ID: <Z_9jWI3l-HKEzHX1@gondor.apana.org.au>
References: <20250412233241.1167401-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250412233241.1167401-1-linux@treblig.org>

On Sun, Apr 13, 2025 at 12:32:41AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Ard's recent series of patches removing 'comp' implementations
> left behind a bunch of trivial structs, remove them.
> 
> These are:
>   crypto842_ctx - commit 2d985ff0072f ("crypto: 842 - drop obsolete 'comp'
> implementation")
>   lz4_ctx       - commit 33335afe33c9 ("crypto: lz4 - drop obsolete 'comp'
> implementation")
>   lz4hc_ctx     - commit dbae96559eef ("crypto: lz4hc - drop obsolete
> 'comp' implementation")
>   lzo_ctx       - commit a3e43a25bad0 ("crypto: lzo - drop obsolete
> 'comp' implementation")
>   lzorle_ctx    - commit d32da55c5b0c ("crypto: lzo-rle - drop obsolete
> 'comp' implementation")
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  crypto/842.c     | 4 ----
>  crypto/lz4.c     | 4 ----
>  crypto/lz4hc.c   | 4 ----
>  crypto/lzo-rle.c | 4 ----
>  crypto/lzo.c     | 4 ----
>  5 files changed, 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
