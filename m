Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902C04B129D;
	Wed, 16 Sep 2026 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552721; cv=none; b=Ey0Vdjfjks6XWj3uhJR4W2dS4PY8E8uOBIo9sGkc4sqa7bJZi9fwJ5yQt3GTJ/TLYf8mNPmJg0G9SXZtIhh+z6lo5jrdN6xvXuzmiOE2T7LAorVTZDnuxdmx0VjYicscXUDRF9dvYjCw+XOP0H8yvYsaKWTarYQpqAIGb9VVPCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552721; c=relaxed/simple;
	bh=z9ws1T8a0UFllH31exEygxNTiTXIKMX/8UQCjrHnq54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mff/7Kr/0evjhJGm/xH3OH8rOlxpSxYy9vATtmJoDuLJYOA+mT++VtvqP/j14M3IeJNWzVNaL51ETRE9kHZHrq3jJg+zTldDp7OruNjjYpxbUM4mztDIItFE/Fxp0Shljh4kd0ASorq0oQI262b9RPzgtSanIBfNtkSozgU9cVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RQvx7XBg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RQvx7XBg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=WGbNBs3yLnaaPzsst7Hh6viCa4Co74eh6YnBkCnlEz0=; 
	b=RQvx7XBg80cQ/nYilbdQ8LYXCZgai4NXqb1Bv8SyXnkRyKSeFC7BDK1sKeaLSCpHVYKDAPenSYa
	1Ir6EkzUeL9QDIk1/4Ss2t2hfh7olJnlDbUyhaWiv8O3PmFIju4w+X+6MezQJwpt8quaIwDTn1D35
	FBqzRaTgPCLBWiEXqiM2Nvddsm7TFEwBbDB01rJ9F9gTw878rdO79Q/qT/lFl4MFjPpZ/zVSwWEgi
	Xxy0XWqtwdwQAbe/uhiXURPMWVjfPltyNoycB4kYlzPekjTt8DXEC1RDSxhTj6llJvmvBGqdlZZCk
	wKPs3i6HrMtGRS+BgoBEGjyHkcdTFebWv2Mw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6mP9-0000000EZCF-0uOc;
	Wed, 16 Sep 2026 17:58:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:58:15 +1000
Date: Wed, 16 Sep 2026 19:58:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - simplify
 atmel_ecdh_compute_shared_secret
Message-ID: <aqpoNxZBkvkmIzAG@gondor.apana.org.au>
References: <20260901081126.44790-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901081126.44790-2-blum@kernel.org>

On Tue, Sep 01, 2026 at 10:11:27AM +0200, Thorsten Blum wrote:
> Free work_data and return ret directly to simplify the control flow.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/atmel-ecc.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
