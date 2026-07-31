Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113D3B42D9;
	Fri, 31 Jul 2026 07:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785483776; cv=none; b=X/k5WJRouETTKjQJkI4EHA5NOvPQJKbxd6npMQNmFsscleX6H2fkNQ/+g7pPBcY3N+jRLJo09zglqpQEhuzqcroTiycrA41B4amJaXtaxb2Tb0eTDJbIYB7siLpvNLNksnILeR0JxhHoOGB4uQFWzm8UQIgcitFBpLtOr1skcl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785483776; c=relaxed/simple;
	bh=UjWcLXws4M/kbaelWFzadm58X/wE0jp7oF5YsieijbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fc6ygFWr9yM27yPQx3+BtKkYlxt7C3ZUEqKHvoHFS/rutHTNdbvil3POfDxlMj+8pGqQGLJzjf0yy8DBKh6nWvMDC3wMj0U8NU0PUTAPgOQCqlpC9Vrv+hiL0xxBSTWjd6+gb/I2XdkdFCH1Y7KA7j5ZnZjpRQr2StjI8hBJcVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YVcfdXbs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YVcfdXbs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YocYVi5nduWkDlNOsrQIp4QmqG8pvPheZ6euQZKEJqk=; 
	b=YVcfdXbsv3elrU7NWgdEuE/u5WA19nq8u/Q91hnbNsE9geKYsBQ096mdMrj9W5dhOPO0bYkmqD8
	uUKYVmbwHhsEaEJwzMahW18GMuCOI7CcFaEaU6vZ6CyxXaCzWzisNsa2Y/Zr2lUECiL5996eV8w9N
	ISvoxswQbMvKe3QePyMf9eC4XEMZ/JxBhIMzia6Z2UnnGZHXO7IoU0B/IRBAbag4j8hrGcGMMNGom
	jBdTtzZwdfBEzFOp9/3kklzdEkefDN+eKDjV2bqr9jVoaTbt7V5CuQAUhG29Qqb9oT0ap3pPzXIy2
	ApOJ7Dk1F0xsWYoB319v7bTmoxJFkI9l9ezw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpht8-00000000n7i-0YZD;
	Fri, 31 Jul 2026 15:42:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Jul 2026 17:42:38 +1000
Date: Fri, 31 Jul 2026 17:42:38 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <amxR7jTWI8YT4okY@gondor.apana.org.au>
References: <20260726192716.2351505-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726192716.2351505-1-richard@nod.at>

On Sun, Jul 26, 2026 at 09:27:16PM +0200, Richard Weinberger wrote:
> Commit 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> breaks a special use case.  The cbc-paes-caam driver implements the
> algorithm cbc(paes), it offers a way to use AES in CBC mode with key
> material unknown to userspace.  Instead of an AES key a CAAM BLOB is
> passed to the kernel.  So, this crypto operation cannot be
> implemented in a userspace library and needs always help from the
> kernel.
> 
> Explicitly allow this use case.
> 
> Cc: Demi Marie Obenour <demiobenour@gmail.com>
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Fixes: 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU cryptography")
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  crypto/algif_skcipher.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
