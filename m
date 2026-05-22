Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1027938228E;
	Fri, 22 May 2026 12:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453049; cv=none; b=VnVLCmlCdKqSauGqImY2iJXf7zAW/1ZY4PWxabQKAGcYxAln3xZh2NeRPZSfO+zUueygX1Ou8CBAOCUmEDRDbHPpql3nHPoVJ1fopOmVSapN3fVhhp9wd5jM98gj0Hk7XRKvX3SYkRLxLZ4ch34sOzby6GkKNWPs5Qw0+VVdgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453049; c=relaxed/simple;
	bh=xE5unDuV/GqCC1ayD6U3USQ6yl8V99bh3zQw4sJg4AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtyVIMtjaKsY5P3skJo7CJTQKsJdaaHBi+vB7ao6LJutnqpeM7n09dVhnBV+nm3kWRkQ03i5TDpcOBALb21aCeb0L7jXq0iruuWvYqCUJk1uFNZT4GVhv8N5t3H8ELjLIpiJc5QYfe1VNROnvYrbK3HLgdPnq/ULqK5H1SUTypM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=anhfWrje; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="anhfWrje"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vFspBx/6QrUzSM01lxHt50DtUYWpGRNZZl3YEsES8yU=; 
	b=anhfWrje1aFfJanx3377a/NsebVYHtqU2ZNXzXGeUQQUg76+UOGzXsi0oG+x4/u0lUk6N+33NwJ
	+vuUAnd6OEizuUviEy2HeCcvOKpGMxT0nrbMHpDDOixoB3aGxlptfTsfS6kOtPbLQRecssxMIsmI+
	97EwxuLzjW3V3B0hQMg3Kbm0HhVzfAWhP8PUN2d+r3N+wbjAE2qUdXoURIlYtRt3w1SIJr17QlDp5
	KXJ/2Ngn057+qPZxGN0tLsIq2GvC4Rw4ZA+WHbgH+etEEEKikLnZF0N3xF4/B2BoEaK//SsmuGhB/
	zL7UH+ZLBY0u8Ur81d1CVLu5hQfET/SGOVyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP1R-00GSNu-1Q;
	Fri, 22 May 2026 20:30:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:30:37 +0800
Date: Fri, 22 May 2026 20:30:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	Ignat Korchagin <ignat@linux.win>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] X.509: Fix validation of ASN.1 certificate header
Message-ID: <ahBMbTiLfi-j75vz@gondor.apana.org.au>
References: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <782bc59d5939aa69b58cad42f71946f1c0a6dccb.1778741457.git.lukas@wunner.de>

On Thu, May 14, 2026 at 08:55:58AM +0200, Lukas Wunner wrote:
> x509_load_certificate_list() seeks to enforce that a certificate starts
> with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
> and less than 65535 bytes).
> 
> But it only enforces that *either* of those two byte values are present,
> instead of checking for the *conjunction* of the two values.  Fix it.
> 
> Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the kernel")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.org/
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v3.7+
> ---
>  crypto/asymmetric_keys/x509_loader.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
