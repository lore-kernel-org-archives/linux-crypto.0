Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911CE367F25;
	Sun,  5 Jul 2026 08:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240091; cv=none; b=GDG7Ga5euJdt8wYOOoFIp7Huka2imie0GYjQAlcy+lGL/+UBzrRR0/xol8PtH88Sdoi2zJARjCTv/7Rv4IgbppgjY26wcjxMIwSkpTdyAWeEUrlLdpm8i1nzPsx5ZL0/zqxDAAL8RTVASK3Ewc8X3HxzQ9tCt4UUlsOlmwLo+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240091; c=relaxed/simple;
	bh=k75elt+eyD9YDBjNhXvbk5/JL2OCqJuB712+DBx/Grk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ/rE0LCT3/WoCAImATmZDr2LLkxQ5LcqXH7AMSY5+wfWA9fyF/RnZCgIifCCZ3wdEqHalsQHSO/HXSUfTve9zLVUjLqo2ltldMZ5ahmgYj9KszFw0w7J5OHefVq+BEFXzJhva8mMKueX7Tp0wYvqHm7JNoj5Jha9B/ICjqaJOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pFXxJCeC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pFXxJCeC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/NBII0BMp4fa4Zg7Dwve5MwdwbOFNBeaugYhi2j46os=; 
	b=pFXxJCeC94YKMvrKpNVRWm3lhw5VmWiwAhEyP9FTVAuk8m01+iQTxCrfHHGr//b3/0htR69GYV1
	ne6cm8yEELa/nVjC00rqnMHORaPMsllWofq2IhcN8USvPY2jhW4B5NAiK7jljqXg4N+hbVPqlwT5I
	/BaPuOgxLIoglDAbUYgje4fB1lnovYJ2qIoYzQaEFxWwqMFaZnIZ/gWEdrhUiab+q0ynjtZZKiREN
	E2OawUNb4msMJML7kT7+699+ZMb0XH0i8lYYaQFu/HzTeocTuFgezvxjOTsiGkYJK7R/UkCYrVqc9
	BdKGrNhA5VTBIUVLJ5RzCa220YThxiee1E1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgICh-0000000Akuo-0WG4;
	Sun, 05 Jul 2026 16:27:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:27:55 +0800
Date: Sun, 5 Jul 2026 16:27:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: atmel-i2c - improve comment in
 atmel_i2c_init_ecdh_cmd
Message-ID: <akoViy68bvKvD7jM@gondor.apana.org.au>
References: <20260609100552.233494-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609100552.233494-3-thorsten.blum@linux.dev>

On Tue, Jun 09, 2026 at 12:05:53PM +0200, Thorsten Blum wrote:
> Clarify that a P-256 public key is encoded as two 32-byte coordinates.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> No changes in patch 1/2.
> ---
>  drivers/crypto/atmel-i2c.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
