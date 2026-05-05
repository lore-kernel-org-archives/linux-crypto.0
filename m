Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D33326ED59;
	Tue,  5 May 2026 08:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777970732; cv=none; b=HoCxb3MZWGy3fuGLIeaXTgntwc1Kn3cL+CPgK8pWpNaTnjVwys+L9Hpw3UcYKSVgPQvLCU5+j1p6OuHjeZ91+1xt1giRueoWZfOINbuYzqqqoCkPyPKA01JEkbi9F8TPCeOjKBpjz3nnswxLB71SYv8LS8TQaZVAODG73Fev69A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777970732; c=relaxed/simple;
	bh=F7jB0WzRB0Hr+hN4m7S5Inrxfg4j9FA/8a2DnW5wVbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVX3X9wKKRj1/X9wgRWSvqHEvTXzMjg6Xn3kmRSochpAPIRHlvUliD5TVm5NkyqSf5VZ9TnZUg+5sraruodacu8jA0n7D2lZKCh9q9Se0rzX4Pi1MyCh7HlFmY0v92bJv30L++U032zlJmQIC7fkAgwBDdGAlrhVUSz9f5hRKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Of7G8VU2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Of7G8VU2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=d21l9thPG17ZaU29OAiBQhhxEX9vxclzw3MCyu9PyB0=; 
	b=Of7G8VU2vN3kRwwD/48+B2F0NgG8quny3E+/uskbLy617vgSNdGQQFDRrMJgNN8bq+KJILI+D94
	qIoa/xyjVJXfCn4vMp30VamC/CeROoygM63+nkS9SeAysVUtaMT4FuU7RjJsy/JRgkaTAVl/mJLVq
	GbWM0OFASt6hPKr3SLT9q6qd5zlOGxrLnGtzXY1VHPcMz/wjlmTQbSLNtBTJ/iHGwNxVqqh7VP5Lw
	7PCzK65DiBeXGh5I70M6YPOAnmtdXkOqgdH6PR9VREJtDF7/G4WQtRf6DSRmU9Jv2X+lp/GMyEhSo
	yxpAs2lSrijAh5FitJ7EkywVexbjQaj2RxWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBOj-00BN39-0i;
	Tue, 05 May 2026 16:44:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 16:44:57 +0800
Date: Tue, 5 May 2026 16:44:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/2] crypto: atmel-ecc - add support for atecc608b
Message-ID: <afmuCSMMPWPbzONk@gondor.apana.org.au>
References: <20260412095642.120815-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412095642.120815-3-thorsten.blum@linux.dev>

On Sun, Apr 12, 2026 at 11:56:43AM +0200, Thorsten Blum wrote:
> Tested on hardware with an ATECC608B at 0x60. The device binds
> successfully, passes the driver's sanity check, and registers the
> ecdh-nist-p256 KPP algorithm.
> 
> The hardware ECDH path was also exercised using a minimal KPP test
> module, covering private key generation, public key derivation, and
> shared secret computation.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Resending to include linux-crypto in patch 2/2.
> ---
>  drivers/crypto/atmel-ecc.c | 3 +++
>  1 file changed, 3 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
