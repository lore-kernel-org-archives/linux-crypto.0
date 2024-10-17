Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C2F4A01;
	Thu, 17 Oct 2024 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123333; cv=none; b=YMRz+R8hwl7suAHWUdHIcgVwKMHa5z4bp/9QwpDKPN2SZ3jNIKK5ufFkIlnC3eKRaI0GLlwbOp2/XUh1yx5vZUXO014OA4UjjLrFU9MNDTGsHBSaGI5oY6g7Q4EHeSQL86S32HKiasB6jYNFkR93CIvv+6tB/VxiSEEvwFQxVwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123333; c=relaxed/simple;
	bh=ufBJmA+SwW2VZK57F4mSzKck8mfw3CXosgK8OhypXSY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M0h2aBlhczmSnJnI4b4Ovr9G6coHwWjNzxKfigI8Cjc19t8QnjbwiLEKBwloNVrhiLmv7kHkX9sozJsN0aGAvLocd3EIsEKoEUZquFNnfq4oezuDxvEdjrScdswHHavOiGQ8Gg8e3pRPmn8ZD57kYNFZKONF7JGL33PSuIlnGuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dy2Vn2Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dy2Vn2Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21B3C4CEC5;
	Thu, 17 Oct 2024 00:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123332;
	bh=ufBJmA+SwW2VZK57F4mSzKck8mfw3CXosgK8OhypXSY=;
	h=From:To:Cc:Subject:Date:From;
	b=Dy2Vn2ZusFeuYzprDEiWh21x5GrztxOH5CrNPzBNCG8U1gUHVTu0IaYYoc7RoWe8P
	 0fFArwmZi2/jtDBWrcGFHxi/g9ruHp1kw/hhI9jvnokhpx6xyKphrIARPQ2d8NjwqB
	 XqGQZQoxPZSY7o6XS0IZOXMoYAFZ8rzWZ8iK/aXckFgspQYUhFUc4GQ6JUgvm+osXf
	 GVGScG9nofOwKm/0/wYXT6eqZGz6E+ptfv2yLJ/YFLYXSKC8+g7aolt1D9K94DwIqq
	 KGtT6yGrb4ZX9tPMDaDzOifGhN5XTeptiGOKAf9/RhFqzXfXslhWXZF9yaO2sUg3Gx
	 ttqwEjzddR+4Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/10] AEGIS x86 assembly tuning
Date: Wed, 16 Oct 2024 17:00:41 -0700
Message-ID: <20241017000051.228294-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up the AES-NI optimized implementation of AEGIS-128.

Performance is improved by 1-5% depending on the input lengths.  Binary
code size is reduced by about 20% (measuring glue + assembly combined),
and source code length is reduced by about 150 lines.

The first patch also fixes a bug which could theoretically cause
incorrect behavior but was seemingly not being encountered in practice.

Note: future optimizations for AEGIS-128 could involve adding AVX512 /
AVX10 optimized assembly code.  However, unfortunately due to the way
that AEGIS-128 is specified, its level of parallelism is limited, and it
can't really take advantage of vector lengths greater than 128 bits.
So, probably this would provide only another modest improvement, mostly
coming from being able to use the ternary logic instructions.

Changed in v2:
- Put assoclen and cryptlen in the correct order in the prototype of
  aegis128_aesni_final().
- Expanded commit message of "eliminate some indirect calls"
- Added Ondrej's Reviewed-by.

Eric Biggers (10):
  crypto: x86/aegis128 - access 32-bit arguments as 32-bit
  crypto: x86/aegis128 - remove no-op init and exit functions
  crypto: x86/aegis128 - eliminate some indirect calls
  crypto: x86/aegis128 - don't bother with special code for aligned data
  crypto: x86/aegis128 - optimize length block preparation using SSE4.1
  crypto: x86/aegis128 - improve assembly function prototypes
  crypto: x86/aegis128 - optimize partial block handling using SSE4.1
  crypto: x86/aegis128 - take advantage of block-aligned len
  crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
  crypto: x86/aegis128 - remove unneeded RETs

 arch/x86/crypto/Kconfig               |   4 +-
 arch/x86/crypto/aegis128-aesni-asm.S  | 532 ++++++++++----------------
 arch/x86/crypto/aegis128-aesni-glue.c | 145 ++++---
 3 files changed, 261 insertions(+), 420 deletions(-)

base-commit: 5c20772738e1d1d7bec41664eb9d61497e53c10e
-- 
2.47.0

