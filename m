Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B353644BB;
	Fri, 27 Mar 2026 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774644166; cv=none; b=mn+cTjAm4ROhVWxcbcpJOSSnZNj71Q6yEQcofohfgb5GijlJKyFmNtLqPujiZFnvQRyN69ESRiRrRmBoC10II52rLrXVanKSCVn1oTnd3DPcfO2Sajy0yHQPUa2CiD4k0XRpiA5ileOHgkIB0hgRJsatI1yuU4imMQ7E7yoIaTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774644166; c=relaxed/simple;
	bh=GUwTJ+AUklF4tfkJKsmupMy9ODQKFmYM1yyDv+OKmIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+XDFmrTJo6/McA2cnywXxFeqcF7MBlOYej9LeKMKo7aJqaBgEJ2zUki6qPfb43Uf9gS+YHVTuPGhhZA1tZobcqFnUU75IPSvVqyXVqlrcbWSgY0F2AeZwqwvpN8OnFff+n0m0xhZGysX+smsq3b0Qz0Wuhk0W2kei/3kSpYChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=saT7JU0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="saT7JU0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF27DC19423;
	Fri, 27 Mar 2026 20:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774644166;
	bh=GUwTJ+AUklF4tfkJKsmupMy9ODQKFmYM1yyDv+OKmIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=saT7JU0TvsPESpqKzvgvXLBDubmwdua/dBJu5K5G0cR01QPRAClfUbZsl6gnmkH3B
	 1YvKAyS98N8nz5APhEqsiAlDbxgstNFya+hDl2IFcogIbsPUl58dPhgX1YJXf/Z1Xm
	 fCjNvhx1MlmcdJh/lovknkP1zWs53kl5BrmHSv5wx7FoEjHdeK0JmrK6vl8UKPy5Ot
	 sIHZrvwGTL1tJ/5ft7WCPWiGXzFHPwiTLTY0IndLV82CH4TEIhrVwshMsxU9hRg7xH
	 IVMH9UKOj4iFQOb2ZpzFNiS3/NziyNTFVGAHVaUXrZW4WJSlRxVsw3nbSCxLYAxZMe
	 JVAhUjLDClAZQ==
Date: Fri, 27 Mar 2026 13:42:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: chacha - Zeroize permuted_state before it
 leaves scope
Message-ID: <20260327204104.GA61750@quark>
References: <20260326032920.39408-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326032920.39408-1-ebiggers@kernel.org>

On Wed, Mar 25, 2026 at 08:29:20PM -0700, Eric Biggers wrote:
> Since the ChaCha permutation is invertible, the local variable
> 'permuted_state' is sufficient to compute the original 'state', and thus
> the key, even after the permutation has been done.
> 
> While the kernel is quite inconsistent about zeroizing secrets on the
> stack (and some prominent userspace crypto libraries don't bother at all
> since it's not guaranteed to work anyway), the kernel does try to do it
> as a best practice, especially in cases involving the RNG.
> 
> Thus, explicitly zeroize 'permuted_state' before it goes out of scope.
> 
> Fixes: c08d0e647305 ("crypto: chacha20 - Add a generic ChaCha20 stream cipher implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-fixes

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
