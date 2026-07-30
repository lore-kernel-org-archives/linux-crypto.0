Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326F4346ADB;
	Thu, 30 Jul 2026 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411357; cv=none; b=WiZH9RKe99jXXLxrK5aZjq+OwDWxc+MmDI5meHEQQeOtglr0R6xhLgLNgsO0AicIuTNCtOHujDc2WR0H0iMcJCJ5VKcXtuuSlvgCU6Q3n1G5aD9R1uKKc9rteUu/i8LbPIUfNEiII9oYV4J3AuaqPVNjZ3L77Gh9TtBlu7H9PL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411357; c=relaxed/simple;
	bh=wajGIBdtitKSoEzSdCti7+oYXhPPw1cGPTPYs3s6lmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NEq5S8IXkYfsL9V/eO6wpLAPMSSvp993+GJYH9qRWXsdKgWTWDrqCIVkkVSXrfrqFRV6M6FCBcVijpeRu2uWxO+TqivCJuYUt9fJN++9rcfIQ4/x8wzOqADHS8kLInwVop2WIJV4kwiot7++zZO9li5LR6Yk7r4AthqacQgSbYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id EBD961062B;
	Thu, 30 Jul 2026 13:35:44 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E6D1D606F4E7; Thu, 30 Jul 2026 13:35:44 +0200 (CEST)
Date: Thu, 30 Jul 2026 13:35:44 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: Martin.Kepplinger-Novakovic@ginzinger.com, davem@davemloft.net,
	herbert@gondor.apana.org.au, ignat@linux.win,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: Re: [PATCH v4] crypto: rsassa-pkcs1 - Avoid cacheline sharing with
 underlying driver
Message-ID: <ams3ED05SiobrDap@wunner.de>
References: <20260730112026.1612066-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730112026.1612066-1-changwei.zou@canonical.com>

On Thu, Jul 30, 2026 at 09:20:26PM +1000, Changwei Zou wrote:
> +++ b/crypto/rsassa-pkcs1.c
> @@ -227,6 +227,7 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
>  	struct scatterlist sg;
>  	unsigned int dst_len;
>  	unsigned int pos;
> +	u8 *key_buf __free(kfree_sensitive) = NULL;
>  	u8 *out_buf;
>  	int err;
>

Hm, why use an additional key_buf variable instead of using the existing
out_buf?

key_buf also seems to be misnomer, the buffer contains a digest.

For neatness, could you move the new declaration up below the one for
child_req so that the variable declarations sort of adhere to inverse
christmas tree convention.

Thanks,

Lukas
