Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A02830E0F2;
	Wed,  5 Aug 2026 19:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785959251; cv=none; b=cn9QglKi8GyqrvyGsAkDUx4RuyoNgumHy3WDwnc4O26HN4PKogq5U92XsQtld243K8dcZfmDIMgiTsvjFFR3Kav2nB7CU3nwNqN6zB6m+eg7VpUXZGftuNn91fNjITdRKEXSlLmuL1uAhNf0xqpNxaThIZ8Ym0gxIN1YS96nXHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785959251; c=relaxed/simple;
	bh=0EkNtZBs5utdOnDdy6XIeM0tBgekC9Ce3LcO7maY2sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sY8Nf1z92aetyoQu+fiDJ/CCy3MvrEzFX7ofAcykiOQchEaaOSvLWt3hhINDInrHG3C2GM+203dxcKvqLMPyoZ+ejghMEqjQIw4h/jGZpoPiIBauPEPiHknIZkIcuUnn3lSmj9ROPfSKOaY0BA50dipgDxVvCMEH708TeSrjlJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtIhNtaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtIhNtaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACB91F000E9;
	Wed,  5 Aug 2026 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785959249;
	bh=96XQ0g0zx/JjnvPKhzVs/gOAqoVdpDykAjKU1mnpRhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtIhNtaCpxXUi4yq7XkA82bIMq3OGI/0SeAUZaBDptF1hzLhq9JGtbxjTeYGLgZwP
	 odR5AGTVhO4Rkf5cmPJ5p3oeC8s6HUpA8GdQu7wMztuQwE0o6Fk/djHCyC0UNc5t1s
	 ZZnoiFj6TLIysiNApDT05laYWe4NJoaqak7Mt3Qmsv9CzbZ+TsegBpWIG/YNscGsqY
	 /UTHhC9E/bvhwxWAUMbn5WwzLooxvpLVZtMTMT5zZRLIAPjh/ZBQXUOYEZpQD8Qzu4
	 pNLMfbEE5+72+WxtB6lluvTResHY/hNort3oWWzj0pmyCUKhPJrHcemHJSyPf1I6rV
	 +Fys5cG9K8vcQ==
Date: Wed, 5 Aug 2026 12:47:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v2 0/5] lib/crypto: KUnit tests for AES-CCM and AES-GCM
Message-ID: <20260805194728.GB3438@quark>
References: <20260802233005.161467-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802233005.161467-1-ebiggers@kernel.org>

On Sun, Aug 02, 2026 at 04:30:00PM -0700, Eric Biggers wrote:
> This series applies to libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git gcm-ccm-kunit-v2
> 
> This series adds comprehensive KUnit test suites for the AES-CCM and
> AES-GCM library APIs.
> 
> This is a follow-up to the series
> "[PATCH v2 00/13] Library APIs for AES encryption modes"
> (https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/)
> 
> Changed in v2:
>   - Fixed crash in test_aes_ccm_data_len_too_large() on 32-bit kernels.
> 
> Eric Biggers (5):
>   lib/crypto: tests: Create test-utils.h
>   lib/crypto: tests: Use per-test-case buffers in hash tests
>   lib/crypto: tests: Add aead-test-template.h
>   lib/crypto: tests: Add KUnit test suite for AES-CCM
>   lib/crypto: tests: Add KUnit test suite for AES-GCM

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
