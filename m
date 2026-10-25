Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792963317;
	b=ksbO4cx4/z23j+r974HW/GvkkU9Ei81LT0i8legROSxbM8X5uAXte/7tcEmognR7Xehc
	 ZJaTV/xuGBTfU5EiRKGmjOOIIX5oKiEUiOaO7NnA4dDGJICJEeH/MXqhCcIhF8ahjwCpX
	 tjqFI6OztE2aMNS71ISa6jALoyykeHqhIqjpxGscLkkcUZeVwAYOUJifdkJZaJS9urkYa
	 gjKZ5Nu50h1sO9I5lzv0PVRlrik9hk02DG3ktVK2bg/RxA91FU5+urcWMvish5U+Gb+sg
	 u2ULc2cqKUzZbipX4S64eIrPifyHUX9LDJzhiJekywPaoMeLjYS9SJkzBO6zBh2rQQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792963317;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5YTyVIjg3R9ec/UkCXhGbiXvnIeBe1z7Gt+w7J3Zegk=;
	b=DfgwDBO8O0R9Tlzh657m8nSu5QQOcrVx9F1VpsVrw9LwMscMBkHiY3A9f8TyW1fXQAs5
	 N1ulIfdnWRx9KfH4QLxE3/M44LwD3ROy1UcVtkfoJKYuDQZH5MRjgfk+mO9ijfbPX/EUD
	 0lq+HJVcpi34T8FIIW6HMrdov1jO0AtBDVN+oAUlKJxpTTdhbz/bwEg4l/moMv2XfmwcN
	 T5qKWdPOI/4TvgiegpH6sa0/8jSMdNC8p12lmW24yf9rOuxuFjtftcwLP/5HPBDdZjHzC
	 QV8OxYztfPIKSE8vMlZ7DL/kCqzPXJ0HAn5ewTjFnviOPrju60Nv9/G13/7GfGH4z7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kwh2T0re;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA222606A31A;
	Sun, 25 Oct 2026 21:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kwh2T0re
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2A61F01825;
	Sun, 25 Oct 2026 21:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792963316;
	bh=5YTyVIjg3R9ec/UkCXhGbiXvnIeBe1z7Gt+w7J3Zegk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kwh2T0rePDXFrH8JMowPaYx6pXSH9Rsi0qyAAgOF+k6CeQG+nWqOkdBdeCiBu9meX
	 G0QfFEpgIKAkWqYbOhTOkep1EF6j1r0p7b8DQxxX/smJvzbt2fA1j+qOx8pu8vy7ow
	 XTXXfiqA0nnNIy0M5o0Bbz5bzrDOPwdk33q13km3rmvbcViMGBvYEVqpozKtwrzcdD
	 uMfKn24TDUuNj4BtJhaR21NU378szWqGPAwAQBUMa/W+OBe4G3KKogJuvdJbaqjMrW
	 bwtG59L/mgWkT0G+RA4TAJdhHhUxSL1fwxtx1AQOcZ5dC3apZXYMmKYFZ+iUxIFL+Z
	 PYEC0g/LYuqJw==
Date: Sun, 25 Oct 2026 14:21:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: jitterentropy: Fix debugfs leak on register
 failure
Message-ID: <20261025212155.GA4509@quark>
References: <20261025031835.2354-1-tangbin@cmss.chinamobile.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025031835.2354-1-tangbin@cmss.chinamobile.com>

On Sun, Oct 25, 2026 at 11:18:35AM +0800, Tang Bin wrote:
> jent_mod_init() calls jent_testing_init() to create debugfs entries, but on
> success of jent_entropy_init() it returns crypto_register_rng() directly.
> If registration fails the module does not load so jent_mod_exit() never
> runs, leaking the debugfs entries. Capture the return, call
> jent_testing_exit() on failure before returning.
> 
> Fixes: dfc9fa91938b ("crypto: jitterentropy - avoid compiler warnings")
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  crypto/jitterentropy-kcapi.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 652852649..43a0694e6 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -296,7 +296,10 @@ static int __init jent_mod_init(void)
>  		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
>  		return -EFAULT;
>  	}
> -	return crypto_register_rng(&jent_alg);
> +	ret = crypto_register_rng(&jent_alg);
> +	if (ret)
> +		jent_testing_exit();
> +	return ret;

The call to crypto_register_rng() is already being removed by
https://lore.kernel.org/linux-crypto/20261018204618.104876-12-ebiggers@kernel.org/

- Eric
