Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B60239594;
	Thu, 18 Dec 2025 19:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766085943; cv=none; b=rEOSmwtMkcmsgpLtVzQD2zrhyAiGjXCTV605nMkYztB5rv1aCkfaNBhrxwQRAYIaD47D9DTxkDFo+tornF1Hsa+f6ErCZOVNV5v7XYx4Ke/Jb752dd+D0WA2l0MJGjIBDIHSn3S2lwzqOylo/hX5bKGmGRmxhbmx4MTUm6U4k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766085943; c=relaxed/simple;
	bh=EeA/uIIER8xGnPTtMGmDdUUAJB0XNIpA9vTz9cWG0lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KV4AdQ7nuCgj3aKTW/TS+nE7pSB2+/6gufqkQMD4JiHnWfBugrr2Uf4x8/CWbz4SxZik5NaM6eNheSS0FKzaI1erO25AZg13BqHsM0Ja35j6uS6Afgmq6ONooNoNLWznelVC2r/el5kmHInHJqCpNbceCpwLsTNetoghTOa2KxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDESX0/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDESX0/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6899C4CEFB;
	Thu, 18 Dec 2025 19:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766085943;
	bh=EeA/uIIER8xGnPTtMGmDdUUAJB0XNIpA9vTz9cWG0lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PDESX0/70smiWQZJNo5er4Hcg6E8Ub7P7/eE2AXCSnG7mkqP17s6MbNJS6xdbHZIP
	 GR9THrLrzXopP0pjC1K6RrzDAjziJia9C4O2cs5s9hMsq33vqy9FGRE3YW1TRMtqX2
	 vjvSF47likKoq1b98J/h4RlpIWW8YMrngqKhZBZ+amC9V5P2ZNnzR4U+m96zJ+LdEJ
	 BqH808XGTtSfUCANaiqHKSmAOjZV9kHaqc5pMJmOV+spAtJtOQrUYjumXoJ7QAdUuN
	 KX/y6tdbWU37PcVuCGPBEcYADbmP19lUP345fkJeOGF4C02/7ckTrB6qXgnGzQkwk0
	 6QX9Q34opRatw==
Date: Thu, 18 Dec 2025 11:25:34 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 00/12] NH library and Adiantum cleanup
Message-ID: <20251218192534.GD21380@sol>
References: <20251211011846.8179-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211011846.8179-1-ebiggers@kernel.org>

On Wed, Dec 10, 2025 at 05:18:32PM -0800, Eric Biggers wrote:
> This series can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git nh-lib-v1
> 
> This series removes the nhpoly1305 crypto_shash algorithm, which existed
> only to fit Adiantum hashing into the traditional Linux crypto API
> paradigm.  It replaces it with an nh() library function, combined with
> code in the "adiantum" template that handles the Poly1305 step.
> 
> The result is simpler code.  As usual, I've also fixed the issue where
> the architecture-optimized code was disabled by default.
> 
> I've also included some additional cleanups for the Adiantum code.
> 
> I'm planning to take this via libcrypto-next.
> 
> Eric Biggers (12):
>   lib/crypto: nh: Add NH library
>   lib/crypto: tests: Add KUnit tests for NH
>   lib/crypto: arm/nh: Migrate optimized code into library
>   lib/crypto: arm64/nh: Migrate optimized code into library
>   lib/crypto: x86/nh: Migrate optimized code into library
>   crypto: adiantum - Convert to use NH library
>   crypto: adiantum - Use scatter_walk API instead of sg_miter
>   crypto: adiantum - Use memcpy_{to,from}_sglist()
>   crypto: adiantum - Drop support for asynchronous xchacha ciphers
>   crypto: nhpoly1305 - Remove crypto_shash support
>   crypto: testmgr - Remove nhpoly1305 tests
>   fscrypt: Drop obsolete recommendation to enable optimized NHPoly1305

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

More reviews and acks would be appreciated!

- Eric
