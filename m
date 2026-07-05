Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD38364EA4;
	Sun,  5 Jul 2026 08:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240156; cv=none; b=CGnhbS1RexpXyBxuhL9YWY7WIYsp2LQet9U1iIOVfashB6+rhKrhvzChH14RNcZyo2wxrHqo+yx+SBEwn6dXO5yI9AUFU9q9vyJTMUtI5nWW0Ocxg21y5+kq2oH4iEjYJhnt4T/g31yLrEchSumxFM/fi+FrM40MmcGnN5dHsmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240156; c=relaxed/simple;
	bh=3QDFaMhhMCUIMfMqOV+NR36TEeJXm/HFQjrUwr4cPy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=svOmBAP8JvV2JSdbn19yc7OrZgrfXa2HOIu2H8LSIRluandefXpTXzLSCxb0H5wIq2LgFMfrxKfmB0JzYl4aoyAtDCIkUqoUC0xql+qsKvesZkqutkOTKD2qqIQD0R0yCrCzurMex+1zStXFzo1nTTUa4y5Tvy9OWBA0ST4vz2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jODBXUDN; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jODBXUDN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=t8Thjx+J/avbZvs0RPyGjgsts0CA4hDykNPO3CuFqU4=; 
	b=jODBXUDNhMBHZ1sPurm69z089Jl5jMQO+5SpQcwoD73mIipzRI+QmfLFINL81UiEa/+hq2ymBcg
	VBPFj77qIwhHt86wgIiQnVIXhsildjSpCTSm/U2++dm3LCKg48dP+jNCasN43Mntvjnj4nKblZGAj
	1YLf9jeZ9XlvW63/SnkvPyX9H/aQFpBRZ1QBPYDER4DAXqukzsJ/+Npk4lMQHVXqUDLTjFq0ZtwlH
	dblGgl7iwsG2C51MUfMlzZYUXJSxGinQjp7l3RJxyHi+M6iFAXIEaEC3PzDLP0fIMOi2rUcY6Twfd
	gssj22KWS8MqsQ/Vaw0AWCy9qK4JCyy8ohog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIDr-0000000Akwd-3Nz0;
	Sun, 05 Jul 2026 16:29:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:29:07 +0800
Date: Sun, 5 Jul 2026 16:29:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - drop unused curve id from
 atmel_ecdh_ctx
Message-ID: <akoV0wUfeiEKH7nY@gondor.apana.org.au>
References: <20260611105159.460794-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105159.460794-3-thorsten.blum@linux.dev>

On Thu, Jun 11, 2026 at 12:52:01PM +0200, Thorsten Blum wrote:
> ->curve_id is only set once, but never used - remove it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 3 ---
>  1 file changed, 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
