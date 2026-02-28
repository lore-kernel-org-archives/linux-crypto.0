Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E314221A459;
	Sat, 28 Feb 2026 08:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268536; cv=none; b=IM8Rbp42QzPKlSNyTlOEq3pSJMbfUSRPzLIW2KCq78/qtAs+2CSXWnSWOsB+f8JamlCHDty0AuG7nvJ8v9A7iN5tizI3zVGwmKjwW8ptrU9bT9nVyiseR82ulS8ITK87UFDrJm/Cwx7XHONtr0g7pqO3OZq4xI6Sk9AaUy1hw2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268536; c=relaxed/simple;
	bh=rGTAnL5yPjGit+bZ0dAy1+AH7uGzggMbjSEln0qkmSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K59WdSdmmqmk3adFpi/hLwTnRAQ1KXaGtWe1G8Ir2dwEoMQ7jBs7Ge3sfLElR3V1TxI7UfSPjW7grAwD2IVO3LnLFB1VJWDINasuGv/fi4cDOyP6a3ZcT2ApL2qD5evuYS5pNTw3/wBDYTnM7of1f2vBIL8eOe5+rp0TQgFtIrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GXom2qhr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GXom2qhr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=utVUTvkDaRFs1KjtJ8lUX61qZxYSAsEUcGdk9IgvdKo=; 
	b=GXom2qhrf/Z/VBUOeUacG3CWnl3rCA7UtczjEoauWhPL+kktPg+HTcrFdB+mwOndHQ9rgi6KiF8
	maLMhjNeYhNCZ8A18edW8wsnZ9M9/EJNxEXiEc88y8svyDiAywgVzBwLnSX5PMClZKOrvF6RzCdVS
	8Fb1yGxqRRGtolrvslpDchyYw5vhdY64aJC+GuRWt573O5UDcpZ7Vwxf3OMoaLpnCWr1sL0E+eKYv
	PMrCFEi73FvIMVpwMsBVMbtOt8/0gqIappUjlRjIvlyPG2N35Duy+6JHWHoI5x6h8JuPaK6J8HnV2
	nOZKQ6FhiEnNB6jn/p7DK1dVezr2HEbrk+og==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwG07-00ADsK-2Y;
	Sat, 28 Feb 2026 16:48:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:48:39 +0900
Date: Sat, 28 Feb 2026 17:48:39 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - Fix OTP sysfs read and error
 handling
Message-ID: <aaKr5_c7nFZnBDCI@gondor.apana.org.au>
References: <20260216074552.656814-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216074552.656814-1-thorsten.blum@linux.dev>

On Mon, Feb 16, 2026 at 08:45:51AM +0100, Thorsten Blum wrote:
> Fix otp_show() to read and print all 64 bytes of the OTP zone.
> Previously, the loop only printed half of the OTP (32 bytes), and
> partial output was returned on read errors.
> 
> Propagate the actual error from atmel_sha204a_otp_read() instead of
> producing partial output.
> 
> Replace sprintf() with sysfs_emit_at(), which is preferred for
> formatting sysfs output because it provides safer bounds checking.
> 
> Cc: stable@vger.kernel.org
> Fixes: 13909a0c8897 ("crypto: atmel-sha204a - provide the otp content")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Compile-tested only.
> 
> Changes in v2:
> - Return the total number of bytes written by sysfs_emit_at() after
>   feedback from Lothar (thanks!)
> - Link to v1: https://lore.kernel.org/lkml/20260215124125.465162-2-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/atmel-sha204a.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
