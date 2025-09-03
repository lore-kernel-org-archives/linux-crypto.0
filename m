Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C831F4174;
	Wed,  3 Sep 2025 02:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756865602; cv=none; b=s9oLFKN7DwVzD1wYm4nlvQ6FBRfkMT43N6joJze443TK702rv1k8UctM6HANidzeRB9XBRgCacmR6X6vpJacGbLeMD5rLT4W2YEyR4TwE4APvDMxGI+rLEkC1Ljp/WqRPIv6g4fJaMotnG1sldRyuZng28+mpZxfXkrNMfkx7aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756865602; c=relaxed/simple;
	bh=zyVMQLH4t1KwmbWNdntt9uhUCwn5poLa8UFhIZx/Pnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OAHs0hdWngxLT1HurtyXkQuNx8Ly2/2FCciKumo/hXLBldTPpiguyHii879AHz71uzGQSq/Z0+nBn7R2gSO4TBSw30BxwAA4JpF2xMlDjYljL2l7kxf19LXvSCHWV/fckSxt/1U6C9cSOph7qArgZzfJBhp4VXyEJfcG2xFoPCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2T/DDg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2T/DDg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB390C4CEED;
	Wed,  3 Sep 2025 02:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756865602;
	bh=zyVMQLH4t1KwmbWNdntt9uhUCwn5poLa8UFhIZx/Pnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2T/DDg4H3W2Qnd6UfRqBJJq2wFkaiwudQpczhYMpOVzwyf/KBVJzBWYVfqVM0ENk
	 qYR1qUloo7QHSld2UKIRIHi/cCLrO+IySgGM91h1lq7OkDzS++ShWlr52g3PgnfyH+
	 670IUhCaWtoae06dTZyRo7eeWbzqdGefKEnFg810WEtMJ1b52l2yDPQ4Y29ToCCd8N
	 GWIWqlda9QeWhbEv8qUYwwAcB27bvNB7TBS/8plpKYrOoOZX5aPxm2zMSrbth+0iAW
	 CJdwgsG3L9Syy83WtDqLRnus2h9Fmo1OdWQY3gYYTgiPen6zgsMJuB8VSuHPz9Zs/T
	 dnc6RMZ9+DXeg==
Date: Tue, 2 Sep 2025 19:12:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/6] lib/crypto: curve25519: Consolidate into single
 module
Message-ID: <20250903021211.GA6491@sol>
References: <20250901201815.594177-1-ebiggers@kernel.org>
 <20250901201815.594177-6-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901201815.594177-6-ebiggers@kernel.org>

On Mon, Sep 01, 2025 at 01:18:14PM -0700, Eric Biggers wrote:
> diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
> index 7e4e66f30a7a6..c0f3b64489dd6 100644
> --- a/lib/crypto/tests/Kconfig
> +++ b/lib/crypto/tests/Kconfig
> @@ -11,13 +11,14 @@ config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
>  	  KUnit tests for the BLAKE2s cryptographic hash function.
>  
>  config CRYPTO_LIB_CURVE25519_KUNIT_TEST
>  	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
>  	depends on KUNIT
> -	default KUNIT_ALL_TESTS
> +	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
>  	select CRYPTO_LIB_BENCHMARK_VISIBLE
>  	select CRYPTO_LIB_CURVE25519
> +	select CRYPTO_LIB_CURVE25519_GENERIC
>  	help
>  	  KUnit tests for Curve25519.

Small correction above: adding 'select CRYPTO_LIB_CURVE25519_GENERIC'
is unnecessary here.

- Eric
