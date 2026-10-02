Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BC448034C;
	Fri,  2 Oct 2026 10:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935969; cv=none; b=btdFJdNwpdjf9Utz/MjHqzV2RzmZzn+WrBE+YluHeWUdqowJCL/XiyDBgqZv4AFmcyQUw51epJcTqoLs1roqeo7KwjARKeIWAo75PurB05edvNsP9EB0YnX7XZzdS7VSY/5Rg+D17egy5mAxqLni3tDLoGUAE8BNf+P17ijXJ+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935969; c=relaxed/simple;
	bh=ELzx1Myt0HbycjxOUesaE4UMaAKuLIOUQrMmgEck3iM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HU5P9h9U1osGECsdRW1AQKQBC578AFBV+xxy06v7gYZ5OQwGbN+6oX/7L2CDqirMv1u2ITMkN11jxiTTyoVUTyzmbvXtXRXkuj+iHfYdJOq2Uuz91ryqyVuTlUG9QjUNPKQlVclFp7VIq03HghoTkiXhZ9HgeR+SAN0dGGzSlNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=V5qw1LVn; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="V5qw1LVn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=O82th6InjMMx3QQFoBLa7VrOx3w6ri8p45sSvWxRJHE=; 
	b=V5qw1LVngYI323NGZkU15q8M7mYZdWhLqzoAWVv/vRf+z5BaCjbW1TnAlZUktFXfBfRSqQzMbNy
	gM4QwnQRSphefu98lW/Pb2j5d+8UOLoskMQXHGcxtOw6UwJZWAULV+ttiwGYC+wbqc4/Ze5TNX+5+
	Pf7t2ihNeCNm6KzU3qKtP5FsOImfsjobxG87pxQLopuJc6ZVXHmF2S4Z0S6wxRMxbaQODlZ7Wp5Ym
	+0fTO3HOUkeNzTCOeIDR+rjoBH6X31saJENkTrezSZ7fwCRYMKS9vuE1x3+JQRKsKaprGEJKdplL7
	izOXn8mb/FkAv2vKxp2xgciRZfnw7ABWmK9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaFm-000000001hR-0TNC;
	Fri, 02 Oct 2026 18:12:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:12:34 +1000
Date: Fri, 2 Oct 2026 20:12:34 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Olivier Sobrie <olivier.sobrie@silexinsight.com>,
	Waleed Ziad <waleed94ziad@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: ba431 - fix reported byte count
Message-ID: <ar-Dkl6ekb9pRb28@gondor.apana.org.au>
References: <20260924093401.113713-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924093401.113713-2-blum@kernel.org>

On Thu, Sep 24, 2026 at 11:33:59AM +0200, Thorsten Blum wrote:
> Use the size of the buffer element instead of the pointer size to report
> the number of bytes read. Since data is a u32 pointer and sizeof(data)
> is 8 bytes on 64-bit systems, using the pointer size reports twice the
> number of bytes actually read.
> 
> Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/ba431-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
