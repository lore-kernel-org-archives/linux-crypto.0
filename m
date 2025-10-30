Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DA820DD75
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761833336; cv=none; b=pSQIRTtrztn6FxjP4xhWGTCn27etArTl+n1l+vHBmTJLsS9+FXeDm2rccUgND1f6XQeM8lyyFwBbdRWrfUCpXhLG4yzUK1KeeeCtZLx06qbz8H0l4ELPVslKXfABoMk58gzObR/eA/huUnfvkYPEywU7Ad78W/i0VASF7v9zQik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761833336; c=relaxed/simple;
	bh=rGp1JBYK1mL0otpAztrc7nUrgT5FS8nLHRGVxjQo6Uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gt3UlCfwYlNH+Ut9CTRGJtW9dMCpzV+druuHQocIGe/qRLxcUMjpR8iXvNoTmLZxMbLdDqqBx2C1AlQdgeVpy6eltArTY2s+UPcohE4USDZbE7EsjnmfmBNi+Q3T46K7rc6JicUKFKLCaCWL5sJ0AHxKSysJ0KmY0sbDOkToOKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2VzhgQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2VzhgQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E277AC4AF0B
	for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 14:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761833335;
	bh=rGp1JBYK1mL0otpAztrc7nUrgT5FS8nLHRGVxjQo6Uk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=g2VzhgQuAetX4UqLApCRMz10hkDQCEIqCvlkYoYReeBjGRLeD5LLhTCz4nvy6JhuP
	 IMMTQCRsf2xT2ePf9bu/3HjjzfGHqYoetvgd+Dn/Mvb2X2V7ShlaKElXqLihuUmfeK
	 5dxszIYQMptoJHSlFziZ6/zKLZuPugn81vj9uI/Yj32oDqEJY2Q9K1iDKhwUT+3X5u
	 TKuyVKZ/6d0AhcGcbdu9HvgBT2oGZsid4YszYACOGNqR2Gk/VoVlogmYZARr5aQJEz
	 VmWKfsVWuWj5z43aCi9oDkcwih0Y1BTW0NoBsytI6RG7fnz2O0krWZDuM45Kxn/GrS
	 IHpxlAo5+Ilrg==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-586883eb9fbso1396069e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Oct 2025 07:08:55 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw0OUxRWK0DPQJLtn6lEcovDqsJDG7JcE9jzFKOVXcG6GVZKP9l
	CGPOmAb2E46tUDn8a8M8oWuLtKripiEwc3xOWoZpXDl2N9QogOjEOC0b2hlaUmqkjMxOLRx+g66
	iWNKa+6kqG0MMSsTAE5qKxMeyI6N7edY=
X-Google-Smtp-Source: AGHT+IHHbF/WjBxeq1E6VyXB5fSpfqArMxEc2iIkFLjyxdwV0+rh9GbWGUYmuc+y1VNP2dUtRDQQdQyMkTV5CrGpyPw=
X-Received: by 2002:a05:6512:15a0:b0:592:f40f:a39b with SMTP id
 2adb3069b0e04-594128cdef0mr2510717e87.47.1761833334300; Thu, 30 Oct 2025
 07:08:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251026055032.1413733-1-ebiggers@kernel.org>
In-Reply-To: <20251026055032.1413733-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 30 Oct 2025 15:08:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEi7FMANDmdXhL5w5HFs_Kbf--BvOn1D1QU1axFTrHn3w@mail.gmail.com>
X-Gm-Features: AWmQ_bkg3z1jPhxoXgHvPJUcxMYHgojNY5flDtxcrxvUxkgwYwbnfThirTljmPc
Message-ID: <CAMj1kXEi7FMANDmdXhL5w5HFs_Kbf--BvOn1D1QU1axFTrHn3w@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] SHA-3 library
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Holger Dengler <dengler@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Oct 2025 at 06:53, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha3-lib-v2
>
> This series adds SHA-3 support to lib/crypto/.  This includes support
> for the digest algorithms SHA3-224, SHA3-256, SHA3-384, and SHA3-512,
> and also support for the extendable-output functions SHAKE128 and
> SHAKE256.  The SHAKE128 and SHAKE256 support will be needed by ML-DSA.
>
> The architecture-optimized SHA-3 code for arm64 and s390 is migrated
> into lib/crypto/.  (The existing s390 code couldn't really be reused, so
> really I rewrote it from scratch.)  This makes the SHA-3 library
> functions be accelerated on these architectures.
>
> Finally, the sha3-224, sha3-256, sha3-384, and sha3-512 crypto_shash
> algorithms are reimplemented on top of the library API.
>
> If the s390 folks could re-test the s390 optimized SHA-3 code (by
> enabling CRYPTO_LIB_SHA3_KUNIT_TEST and CRYPTO_LIB_BENCHMARK), that
> would be helpful.  QEMU doesn't support the instructions it uses.  Also,
> it would be helpful to provide the benchmark output from just before
> "lib/crypto: s390/sha3: Add optimized Keccak function", just after it,
> and after "lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest
> functions".  Then we can verify that each change is useful.
>
> Changed in v2:
>   - Added missing selection of CRYPTO_LIB_SHA3 from CRYPTO_SHA3.
>   - Fixed a bug where incorrect SHAKE output was produced if a
>     zero-length squeeze was followed by a nonzero-length squeeze.
>   - Improved the SHAKE tests.
>   - Utilized the one-shot SHA-3 digest instructions on s390.
>   - Split the s390 changes into several patches.
>   - Folded some of my patches into David's.
>   - Dropped some unnecessary changes from the first 2 patches.
>   - Lots more cleanups, mainly to "lib/crypto: sha3: Add SHA-3 support".
>
> Changed in v1 (vs. first 5 patches of David's v6 patchset):
>   - Migrated the arm64 and s390 code into lib/crypto/
>   - Simplified the library API
>   - Added FIPS test
>   - Many other fixes and improvements
>
> The first 5 patches are derived from David's v6 patchset
> (https://lore.kernel.org/linux-crypto/20251017144311.817771-1-dhowells@redhat.com/).
> Earlier changelogs can be found there.
>
> David Howells (5):
>   crypto: s390/sha3 - Rename conflicting functions
>   crypto: arm64/sha3 - Rename conflicting function
>   lib/crypto: sha3: Add SHA-3 support
>   lib/crypto: sha3: Move SHA3 Iota step mapping into round function
>   lib/crypto: tests: Add SHA3 kunit tests
>
> Eric Biggers (10):
>   lib/crypto: tests: Add additional SHAKE tests
>   lib/crypto: sha3: Add FIPS cryptographic algorithm self-test
>   crypto: arm64/sha3 - Update sha3_ce_transform() to prepare for library
>   lib/crypto: arm64/sha3: Migrate optimized code into library
>   lib/crypto: s390/sha3: Add optimized Keccak functions
>   lib/crypto: sha3: Support arch overrides of one-shot digest functions
>   lib/crypto: s390/sha3: Add optimized one-shot SHA-3 digest functions
>   crypto: jitterentropy - Use default sha3 implementation
>   crypto: sha3 - Reimplement using library API
>   crypto: s390/sha3 - Remove superseded SHA-3 code
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
