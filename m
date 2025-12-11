Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8306828F5;
	Thu, 11 Dec 2025 03:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765422153; cv=none; b=Kn7qCl38bEUYi0Jm01/jBv+B9hQgTxYI9vxbg4cOzFPB8nO9x2N1re4U0Yewh88MDehgIYep8lrn0l0IKr8V7uG+N9PjfiJ6yGDh8V3ISiQxJ3QhVdfJNzTMMw4YAsM4ZAoeZ/Vylf3WD7Z8n5D7WHvNiG0ly0BA6P1sCt3PTko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765422153; c=relaxed/simple;
	bh=X1XzcWiPWBa7Y/2bqywMb3zCKjBbMHnVZpOKrkIa5Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C8ZkfwXjs0Q+nWD7Z+Qw9bE1DFoq3goRMP6YXMezcOrrb5N2F5rlk7QS8/FEIpos4PtKXlMlKkhGj94nbJWG7hm70zqvTT0/hjUlpERQO8J84nyymSma29AvkezqB6uBcFrgdso8t12BApQuqy5vwjvFK7rIsx5sKU4RBkmJadA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FgWA3Rlz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FgWA3Rlz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2qzAADVyJ7FleWNTOio9/8Kv9vp7azPgrzyvnUIJLTc=; 
	b=FgWA3RlzvG3iCj4VMM187zdN7gz7+382CTB9zZwcjMEp8JmXSDAgY21wHPzOYh1grzIvjoMYepd
	qXlPIzQZuBGSxnGXDNgp9WKqVyhIpAAF8yMbSxdJXtXvDnM6Jp0VqlFf0GnwkXRs0KiU7TNZEApUc
	uetg++uBcKcPwFWrDfi5a7Kwaz9Mdcuejo0BA8HxDTGEYm5T7jvkUMy6MQMg+1BwUcopIPClUh4YT
	AmcYyHMF6odS5eEWKJ28vEMrvccjxJrfrRtr/xNTPWjiZM6sURP9FWDeRujBHiGnX5kOgIo0XjtHP
	ghH2ZEC1V/4l5NF0dPY8+n9XKbSsoV5wbv7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vTWwa-009PDO-1f;
	Thu, 11 Dec 2025 11:02:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Dec 2025 11:02:16 +0800
Date: Thu, 11 Dec 2025 11:02:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 08/12] crypto: adiantum - Use memcpy_{to,from}_sglist()
Message-ID: <aTo0OIhv3IOHbzvy@gondor.apana.org.au>
References: <20251211011846.8179-1-ebiggers@kernel.org>
 <20251211011846.8179-9-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211011846.8179-9-ebiggers@kernel.org>

On Wed, Dec 10, 2025 at 05:18:40PM -0800, Eric Biggers wrote:
> Call the newer, easier-to-read functions memcpy_to_sglist() and
> memcpy_from_sglist() directly instead of calling
> scatterwalk_map_and_copy().  No change in behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  crypto/adiantum.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
