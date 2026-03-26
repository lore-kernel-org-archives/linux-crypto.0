Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD3A3603F8;
	Thu, 26 Mar 2026 09:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516411; cv=none; b=bDNPxgQK5vb06WqwPv/WuKSL1xQtzYIMQRr5tcCPQg3Bnp3o029+AtXXME+PeUYMMXxF2RRUb5JiJ6A0Fu7SN9eCntABqazJ8jN+6isfgrDnU7gU8NS5kP9ihonv2JkRPJJlJ8iPGyRaWPhYsgWNMGihkt1hvq82jeqh92j04TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516411; c=relaxed/simple;
	bh=UcGOaUW4vIMDim6Du3h8RwTOk9PaaLsY2ZDdFlp2acA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qXdheJdvru9jahZUdatdg0gimSYphNNEcOEC/pKq3QF7/BlEoloPJMyPWC0LM1XV9KWYyygH8VACfmJP/tS5OkYJxHVsb8TeNjZH4k/US9Jpp4CST9IgUGUQGUmMU+1JYRUB5H9T7xhbUAUngF942faXokZ1yWCnxLwPoSM5hZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UktIlGpl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UktIlGpl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xXlozw5ZxvJtkL5U8Gx0ZwZfsv7OX27yb2mdCK68AQs=; 
	b=UktIlGplI9MSTiPdbAO/nKO85jnsiwwrAXVsrzMyBsCmglzFoXEXSzYtGejivSKk1igiciNGJzg
	DERUFh1klWuM1cW+rQ0Ifue9g2P8TNwMIP1RaZe9xZovynwz7NXL2HJXO2gM/YyegZpNlvAcwb5fE
	3HueSqf0JKPJ9nOTVO8a7Q8GO7W38Zf08zaSgA1ZmIwzyVStBhsu3dbMKTKNF8f2KRRgcPBCuYQAX
	rJPxYfhkKTJWY4J5Z3Nlt2GDd+9MJTFwDSjv41a3qrNKGzLpPbmDfVPSpTRPLja5GYOgOTnN6T8Q4
	I08VRB7RXA0yqPyC4Q9u3KAgewD68WhuhmiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5gMq-001FqR-20;
	Thu, 26 Mar 2026 17:13:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 18:13:23 +0900
Date: Thu, 26 Mar 2026 18:13:23 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Paul Bunyan <pbunyan@redhat.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	NXP S32 Linux Team <s32@nxp.com>, imx@lists.linux.dev
Subject: Re: [PATCH] crypto: caam - fix overflow on long hmac keys
Message-ID: <acT4swDknzAK2eBL@gondor.apana.org.au>
References: <20260317102514.3882809-1-horia.geanta@nxp.com>
 <20260317102514.3882809-2-horia.geanta@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260317102514.3882809-2-horia.geanta@nxp.com>

On Tue, Mar 17, 2026 at 12:25:14PM +0200, Horia Geantă wrote:
> When a key longer than block size is supplied, it is copied and then
> hashed into the real key.  The memory allocated for the copy needs to
> be rounded to DMA cache alignment, as otherwise the hashed key may
> corrupt neighbouring memory.
> 
> The copying is performed using kmemdup, however this leads to an overflow:
> reading more bytes (aligned_len - keylen) from the keylen source buffer.
> Fix this by replacing kmemdup with kmalloc, followed by memcpy.
> 
> Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
