Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C6E2D47EF;
	Fri, 21 Nov 2025 18:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763749642; cv=none; b=LLLeEVM9AM80LjGkz/j7MB3rrwUsaOXm0NzcfrxjyukDzYdd7ie4eW/dvwle4Atr/OdEkusqBQvjmzl3TuB9oGsKlEqoozqg/K2wvnvueKO8h+/YonC98fhueXEEakavr6cavTVA1+jQWtcHlU7V4PYoMqdAVMKGHp/PUe83b14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763749642; c=relaxed/simple;
	bh=Zt8d+YLyy7orfoIerQlqV9AJTRsPXVW1xnMbq1QDIcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTkKya5B60z2Piw74m/ARQe28dbGuufuDzDUvg8t6nWfynybZ/JWgcFElpbYXM0agx1u3FYMuByXZrDFJ/6m3EQlbpDMCY8RCoomOVVzZ+1lml9d9jrUSR8BD1pyWs8sSrhy5BWHOrRRw1yo4OZ9qQAL32J1rJYVjR1d1+wkafA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRzq3bED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRzq3bED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E5EC4CEF1;
	Fri, 21 Nov 2025 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763749641;
	bh=Zt8d+YLyy7orfoIerQlqV9AJTRsPXVW1xnMbq1QDIcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BRzq3bEDAPJv4iufe2UzvigHn9aqiZW5+X3iME8mHJmX3OiIvFBcd9l2Zni09oXAt
	 kg2egoCkobnrj5KQst+78RHt3aVAcKgAbTw5xjxK6zCJmlIZNxfIUU6/x7rCePvwOM
	 IUDF8aZ1eQy0gDAwQzvzqqpG2RHfGuZ2yAYjbmug1ypsfthUFx6QTqs1fh7ZvMHE4O
	 jJaTVQwPZn3cP6tAXuzaY/SL/uLyjiZdimNh/yKQA7d2pBfZ3OAFRlVvWW5NSc/4EH
	 tjIWq7oeoMTV+IMFXtnonaRyOjm8c3yih3UZD71QfRMoUPv8aUspY7znMR2S1Wv6DH
	 ylZm/9VR0cd9Q==
Date: Fri, 21 Nov 2025 10:25:34 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Fix KMSAN warning in
 test_sha256_finup_2x()
Message-ID: <20251121182534.GA6822@sol>
References: <20251121033431.34406-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121033431.34406-1-ebiggers@kernel.org>

On Thu, Nov 20, 2025 at 07:34:31PM -0800, Eric Biggers wrote:
> Fully initialize *ctx, including the buf field which sha256_init()
> doesn't initialize, to avoid a KMSAN warning when comparing *ctx to
> orig_ctx.  This KMSAN warning slipped in while KMSAN was not working
> reliably due to a stackdepot bug, which has now been fixed.
> 
> Fixes: 6733968be7cb ("lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/tests/sha256_kunit.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes
(I dropped the Cc stable.  I'll just send it in for v6.18-rc7 instead.)

- Eric
