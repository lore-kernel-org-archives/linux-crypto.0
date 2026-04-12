Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F143285041
	for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 07:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775978303; cv=none; b=Khi96XKEiAW3GNuZqxhf6LWzOznHunctanFJSUH85fcC7ziv2/WkO2VQ/9uMBjpb94QlTgqKDD9QivDD78g5pAnwZ4dWqwpLwGdMoU/XK3PSUD+CI9CcGlLdt3A2oQ//mGrE9F2VPh/bFml03TnVuK4bCVKZye/vXzVNxKRqkUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775978303; c=relaxed/simple;
	bh=7FZjoNTBQGMY3y6KcLIwvae+g6bNeS361jS+pJOYa3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr+tv+JPaiNBIZHqJ9Am6nAWdcUt8V83qT4wl9jL2kNPCwI7bQwMmTI5y+EtfK6Ahehut8JYRhpkCxryLFmiGkbHfJYA4NTz5dcNcyr9BiSpSs67guVErK6omI9TPF/hNCv1LZ4NY1Ir/xPsIlF8THuSjpw08+Dn8H9JUIqNhNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aYFajoX9; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aYFajoX9"
Date: Sun, 12 Apr 2026 09:18:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775978299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UrOHZVZL38C6MgwICRN4Rb/b7X1X7UQKjoQlDB9L2ho=;
	b=aYFajoX9/l0+IIExwKph5VA+Fe71nYSPR2sNFgBZnutveAXeMIKuTJLMXmtjuyyRGNrMx/
	YA5kNnSvlgl1QATt2ZZ3pncYG7AlvO07Nzd70RC6GJTBJAmj/SZA/J8b1LC/C4nSco05K7
	Pvqh7P98KD2SBy6teLKPvzn45BfpQqg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: atmel-ecc - add support for atecc608b
Message-ID: <adtHNa-eMUQO0JqX@linux.dev>
References: <20260330100800.389042-3-thorsten.blum@linux.dev>
 <adsyzmm3WSZ1ao4a@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adsyzmm3WSZ1ao4a@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 12, 2026 at 01:51:10PM +0800, Herbert Xu wrote:
> On Mon, Mar 30, 2026 at 12:08:00PM +0200, Thorsten Blum wrote:
> > Tested on hardware with an ATECC608B at 0x60. The device binds
> > successfully, passes the driver's sanity check, and registers the
> > ecdh-nist-p256 KPP algorithm.
> > 
> > The hardware ECDH path was also exercised using a minimal KPP test
> > module, covering private key generation, public key derivation, and
> > shared secret computation.
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > ---
> >  drivers/crypto/atmel-ecc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> Is there supposed to be a 2/2 or should I apply this patch on its
> own?

Patch 2/2 is here:

https://lore.kernel.org/lkml/20260330100800.389042-4-thorsten.blum@linux.dev/

Thanks,
Thorsten
