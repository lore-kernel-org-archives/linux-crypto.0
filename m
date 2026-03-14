Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF952269CE6
	for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 04:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773463394; cv=none; b=Ni+qgbQzm9bYzVRU9s//o/dxc/ksNWD2fQmoiGz96mmR+xoKBA8v6cXhqK0LDnmnLK3FkGtANseva/oiFG0FXB298DCYWNYopydfd+RXOJrcxGqKsA4zwOVVNu9S9f8MY2VGpyHNzswHxZfWrTS6AuMtdDGAVJ1e6Dot1PmW5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773463394; c=relaxed/simple;
	bh=sFho3O30Le7KbNw4w40wZUArV1ruxth795zGX93sZRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2myZuYliqglImqMx+v0qRFx+gxI4LKSaUy9dKoHiokWELTMWalJ8afgrk0TpeljaMhwo0jt/5iuiyLWeJLU21VjMD+ENabgfITCI8QuyMKXDg8pUZ8MU/ZnbG99vrbNJzLCdSczSP6oJdV8E+IcAVkwRcQjJBAUQZXI/XDSlT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OIkLqHBP; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OIkLqHBP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=R8e1irycja7YA3R558/UBXZuuI971LmvO1hUjVVS0H0=; 
	b=OIkLqHBP1V3n5/C4BH2NrGG1p+30c9edcGVWKc5h7dhHZbzfb6y+6iK6LyAwQm8hshfoSsBcDeX
	NlmhG1gEYt1qqtxhI8l/OCbjRc9k+QexnYlJIojYnI1ysUQLA2LZMODCTHfvfiAu8I/cDdzxVwdLp
	aAJLca4jQQ8jz4ZrX+uRLtI5WU1PayC7e5/9ru3pKwAIRmqDi5X6OpJmX7ZYOg2i5yK9Tf5GCNW5Z
	CB+Xo2R8rT0ytDnALJjvmF9O3AeRf7eustiitT6ybKgNtILspizYMnXy9cp7BhKXdlO+NEjAZEbgy
	rXkh+nb00niYiAzdGc8r63Tx3Ivcfm6z/umQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1GqC-00EKqz-17;
	Sat, 14 Mar 2026 12:43:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 13:43:08 +0900
Date: Sat, 14 Mar 2026 13:43:08 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	michal.simek@amd.com
Subject: Re: [PATCH 2/6] crypto: zynqmp-sha: Change algo type from shash to
 ahash
Message-ID: <abTnXEe-sm5kzXCH@gondor.apana.org.au>
References: <20260303071953.149252-1-h.jain@amd.com>
 <20260303071953.149252-3-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303071953.149252-3-h.jain@amd.com>

On Tue, Mar 03, 2026 at 12:49:49PM +0530, Harsh Jain wrote:
>
> -static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
> +static int zynqmp_sha_init_tfm(struct crypto_tfm *tfm)

Please don't use the obsolete cra_init functions.  You should
use the ahash-specific init_tfm hook instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
