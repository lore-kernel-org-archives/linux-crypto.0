Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34676217733;
	Sat,  7 Mar 2026 05:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861265; cv=none; b=rLw9hZJrpgIwjPOxqzGipmDlfbsQK9Jj/3qHu7NUY8YS9HshXl4eqJ5+M0TRVa+SHexdyWs5kNBSxKJ+teCb03ju0kgwFc49abpEXQJ+dquFxdhuBaW5N3OvEe0Nh/Lpjea0Civ4h4N6rUAqtymsuy5QAhjigT6ClXQpKY57i/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861265; c=relaxed/simple;
	bh=uKz3EsiwEVc3021aQ/2iKQeWyA28noKv6A+7acQo8Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QfGrAGctW2h7czClA3CT1ZU3I7UOaLVH3MRzKgwr2i22MniL7o0da8QlgPu5GwIXL1tCyGmLKhZwDPJTVQAAasmYDN+Uf0ggGNbT1HauikIZbVwtUGeyInqkSpLPNKmXUH7FTZJzq6YZcsSD1OFtN3DQ8NpYqCKpxo5pn4sAfVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DCweGE8n; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DCweGE8n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ef99pQ6BhbQYKEJKAhkUF+17RAs4E6wJGMJKDzOyINg=; 
	b=DCweGE8ntf+8aj2qaJolSLw/3ZnU9TpvTh4jnoC8S/bZvGIDJ+UdBfQ+zCNmMRk0TbEIoUMr79D
	XAj1arCr1AmKeANaHjIg2wsVKEBtx1oSUvNPwyyH0R1keS3WslUo3hE9BGcve4u9WrOYNEuaFf+J5
	DSCyra9B3XJwRz2fWU137R2/5ifeN4BVO8ZXQT8ZrqARSUT5InM8Hy3egiujMeziX7FEEdlYvek6V
	gbzlw5hf7e21SRc9ggtQ03WSLpMieX91fTseqBMi2StPBV8yncX7es5vtlVDwIN719DV0RxDqOn08
	hQbMYeHji/VnJ5Yxd3BNi2FrDaS1c8F0cstA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykC8-00CJS0-06;
	Sat, 07 Mar 2026 13:27:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:27:20 +0900
Date: Sat, 7 Mar 2026 14:27:20 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Lothar Rubusch <l.rubusch@gmail.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - Fix uninitialized data access on
 OTP read error
Message-ID: <aau3OCCHGZFARas8@gondor.apana.org.au>
References: <20260220133135.1122081-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220133135.1122081-2-thorsten.blum@linux.dev>

On Fri, Feb 20, 2026 at 02:31:36PM +0100, Thorsten Blum wrote:
> Return early if atmel_i2c_send_receive() fails to avoid checking
> potentially uninitialized data in 'cmd.data'.
> 
> Cc: stable@vger.kernel.org
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-sha204a.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
