Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7751435958;
	Sun, 22 Mar 2026 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774210085; cv=none; b=AWpKLTojmXm5onzmeiYLOXQ8AmgD61l507cd88/RO6IyzSLIz/pWWFE+VKzlXPRqyxlkjeEmpfltZfDM+xyiHCgSbFaWQruFYhQYAf6oLGyCr98vaKlflpkfbGqGxTmXU46mBevZ6TYkG6ze1uy/Dzlblu7yo3k5Rcf22DQvsHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774210085; c=relaxed/simple;
	bh=etzGaZDOBI/LvsGIvyod3j6hR633ROO6BrUYIQqIqxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGjBS6RRn+3I9Z4lmXs3v+gDpCKaj6ETl1Zjdk3ZR9fBbHZ3V8ovwu5w+LJFA+rIyakdrgTFGLXcKnwYrKJLDwbfNBIBameO5E6OxpZfRCywyt48VsrPt/6bIz6p7r8EuL4e+zgorwtWlDNOf/X/Xqvypz+T/3YJDLD20u68FCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=COejGBS2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="COejGBS2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ejFZ3rN0lLbdKwV9umW51UZDg0IATpp9eBORcXXmZdo=; b=COejGBS2L/v8hAz/AJBlWUe+R0
	APZN/V8q3ReKK3zZuAHpsm06XNj5bvTVPvNWykHLX1/1TcSliLqpqKEJaREsBHurrSoDgrqWNGVKd
	/lM1vEhgTkwZW8rQPJs3B5oPzCxZwMxiKJciHEMo7Xhzr5TvFSZL9sAl6cEeYgIgUGHtP10ajIUWP
	pYJBNRNYAibr1UvjEMVAhs5wS9QB4OyL33jI3A70r1jTRNigoc+qIZZl8A8b8HXmNamcO00NSEsLD
	6d8CmeduaOW3DqCNcwRF+vH/ioAJ+eg6SSg6+EqEXLT6nZgzFutx4inSscaJ/XpIf24u4p5/g9Hus
	TesvY7Zg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4P5e-0000000Fcfl-0ZQU;
	Sun, 22 Mar 2026 20:08:03 +0000
Message-ID: <d0fc3b93-2535-473b-9f60-bd7854ba0b34@infradead.org>
Date: Sun, 22 Mar 2026 13:08:01 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib: Move crypto library tests to Runtime Testing menu
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org
References: <20260322032438.286296-1-ebiggers@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260322032438.286296-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/21/26 8:24 PM, Eric Biggers wrote:
> Currently the kconfig options for the crypto library KUnit tests appear
> in the menu:
> 
>     -> Library routines
>       -> Crypto library routines
> 
> However, this is the only content of "Crypto library routines".  I.e.,
> it is empty when CONFIG_KUNIT=n.  This is because the crypto library
> routines themselves don't have (or need to have) prompts.
> 
> Since this usually ends up as an unnecessary empty menu, let's remove
> this menu and instead source the lib/crypto/tests/Kconfig file from
> lib/Kconfig.debug inside the "Runtime Testing" menu:
> 
>     -> Kernel hacking
>       -> Kernel Testing and Coverage
>         -> Runtime Testing
> 
> This puts the prompts alongside the ones for most of the other lib/
> KUnit tests.  This seems to be a much better match to how the kconfig
> menus are organized.

Ack.

> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

> ---
> 
> This patch is targeting the libcrypto-next tree
> 
>  lib/Kconfig.debug  | 2 ++
>  lib/crypto/Kconfig | 6 ------
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 93f356d2b3d9..146358530010 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -3056,10 +3056,12 @@ config HW_BREAKPOINT_KUNIT_TEST
>  	help
>  	  Tests for hw_breakpoint constraints accounting.
>  
>  	  If unsure, say N.
>  
> +source "lib/crypto/tests/Kconfig"
> +
>  config SIPHASH_KUNIT_TEST
>  	tristate "Perform selftest on siphash functions" if !KUNIT_ALL_TESTS
>  	depends on KUNIT
>  	default KUNIT_ALL_TESTS
>  	help
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index 4910fe20e42a..f7a21d20e470 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -1,9 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
> -menu "Crypto library routines"
> -

Ah, I see, no menus or user prompts remaining there.

>  config CRYPTO_HASH_INFO
>  	bool
>  
>  config CRYPTO_LIB_UTILS
>  	tristate
> @@ -265,9 +263,5 @@ config CRYPTO_LIB_SHA3_ARCH
>  	default y if ARM64
>  	default y if S390
>  
>  config CRYPTO_LIB_SM3
>  	tristate
> -
> -source "lib/crypto/tests/Kconfig"
> -
> -endmenu

-- 
~Randy
