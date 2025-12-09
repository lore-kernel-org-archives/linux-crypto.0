Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F345021FF48;
	Tue,  9 Dec 2025 22:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765320846; cv=none; b=gRV7meGMfnfeQ+UX+3ZrgtKKYXGSZCxtajMmQsKLfYaHrnkxtLyiQmR1ZFREXlzANpyp0Ib1ymVukZtSw0Z0SzA+TxzCshttUYOWW33SXxP8uHCQo9gLWz/epZysS71tdqqvywOWhc6udNCmSBh8hgAlY2Ch5L6jlDOioKtyei0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765320846; c=relaxed/simple;
	bh=nNcZbBu3Hgen6E5pf5lr4Ktz9w1aWYdcK4Dw7Sufh0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjAbFfEyABjKFtKWIScbqCH/Jxl6VNUTWAedQUFihBAIIJCu/DamrcO8IwR4Cf+QH4IvgOBq+m742UKm95IkHKTrnC96QLsUB7s/1TO4Nqovzjkrsdu/hUswZDE6AZxDOs1WR7apLKIh6qS6ITh9lz9IZOoOIjMv5w66KXKa66k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=anJmVC/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="anJmVC/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D370AC4CEF5;
	Tue,  9 Dec 2025 22:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765320844;
	bh=nNcZbBu3Hgen6E5pf5lr4Ktz9w1aWYdcK4Dw7Sufh0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anJmVC/i7fZSXZmb8wFcS04Z0ycgmp3yjGi5HZKjUU6/hsgNaVdyNvFNmdT0XCZqI
	 n7Z+HsRfAez7XH4m0yXXqMH4TYeeltb63c0vMVEcoXIPma4vXIFXYdXhHmyWQZ1dA2
	 2SQ2ALq/HQ4PL0wvmJuwq8Imy7Vx7AcPhMf70ew4jR1KNzijRILGvSvlKpMSd9gsLv
	 J0CtNfqkEerbs96tYhif6b9tC6H6Qy+HKe7xoiXp1wx6a3rqVo+GH4E6tD1uNLPlB6
	 NPBMZpwfj56yMTrQy6ZzV/NxfaInFm8eUgK3lcBZjCmxaTDe+UgO5M5O3pIi6cf9Ac
	 aC4qHXAmqBzug==
Date: Tue, 9 Dec 2025 14:54:01 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC] crypto/hkdf: Skip tests with keys too short in FIPS
 mode
Message-ID: <20251209225401.GA54030@quark>
References: <20251205113136.17920-1-litian@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205113136.17920-1-litian@redhat.com>

On Fri, Dec 05, 2025 at 07:31:36PM +0800, Li Tian wrote:
> FIPS mode mandates the keys to _setkey should be longer than 14 bytes.
> It's up to the callers to not use keys too short.
> 
> Signed-off-by: Li Tian <litian@redhat.com>
> ---
>  crypto/hkdf.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/hkdf.c b/crypto/hkdf.c
> index 82d1b32ca6ce..73d318f3f677 100644
> --- a/crypto/hkdf.c
> +++ b/crypto/hkdf.c
> @@ -10,6 +10,7 @@
>  #include <crypto/internal/hash.h>
>  #include <crypto/sha2.h>
>  #include <crypto/hkdf.h>
> +#include <linux/fips.h>
>  #include <linux/module.h>
>  
>  /*
> @@ -462,7 +463,12 @@ static const struct hkdf_testvec hkdf_sha512_tv[] = {
>  };
>  
>  static int hkdf_test(const char *shash, const struct hkdf_testvec *tv)
> -{	struct crypto_shash *tfm = NULL;
> +{
> +	/* Skip the tests with keys too short in FIPS mode */
> +	if (fips_enabled && (tv->salt_size < 112 / 8))
> +		return 0;
> +

As I've explained before, in HKDF the secret is in the input keying
material, not the salt.

What problem are you trying to solve?

- Eric
