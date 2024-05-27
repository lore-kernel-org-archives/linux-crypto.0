Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC3B36120;
	Mon, 27 May 2024 07:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716796676; cv=none; b=E53CiT/kqNC6fL4khzS9teU+RI6OzMNmZy4xdOKzrc/Fib46g3yF8Urdcn5RsndEKjJzutmJESeKDNjkvEqHDxSqtiE87vWQMvJm+MyecAxxkTM06Q+1IaqIL2652YC/iXSw/cDD2xHOe9tBJv+QeRiP/xmRTp5RPh1uYHhxbr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716796676; c=relaxed/simple;
	bh=unPcFSscR7nEC2MTNvUbr/YbqEm/EKh/dYHH6S/9Gps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILBznsbBMp0fIhtmtwJmeauB4qUvcNC9Q6zrRSyH5aZ9eWlTgo1ZUoMYdrbIXAT9mCgUHXbl9oXvS67RKjL5TLOlC75F3v94HQcdhw3GljYtNjibY1yHAX2nv/qBYcl6ho5TgXNX4jd6QG95NH47dXR+NenW2pkbkaZMQ8y+oV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRq1QuIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRq1QuIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93A1C2BBFC;
	Mon, 27 May 2024 07:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716796675;
	bh=unPcFSscR7nEC2MTNvUbr/YbqEm/EKh/dYHH6S/9Gps=;
	h=From:To:Cc:Subject:Date:From;
	b=jRq1QuIU3eeMrzqUWg5btVS4dd+odV7hxViAMmY0Zh4unDEdXTzZVopzXqIPWjudb
	 KkGmylvQObz9LCm/XbagFPpvhwY2+GTBbktlEAcWW7Up4wiHt9ko/oALrpxJt0Nhwk
	 /bCsAo0SJP4YpAYCiEvt6p41/kQzU1q8yrpQxWpfUfHYgPYYZVke3EeDlSOZH5R+ef
	 5vOJkPxSWtTBbuCS270WFM5ZbzRO+RBkbTXB6dZjeKe6Lw74hgUSSoa6Ln3WCmUf8y
	 jb6en1T9mvQYFxoOx4It8zDlw94WHUCzOS30qG7QYbIW2QE+EHDDGDplTtcCqZD8aT
	 9seBNRt0e0eEA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] x86_64 AES-GCM improvements
Date: Mon, 27 May 2024 00:56:24 -0700
Message-ID: <20240527075626.142576-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset adds a VAES and AVX512 / AVX10 implementation of AES-GCM
(Galois/Counter Mode), which improves AES-GCM performance by up to 162%.
In addition, it replaces the old AES-NI GCM code from Intel with new
code that is slightly faster and fixes a number of issues including the
massive binary size of over 250 KB.  See the patches for details.

The end state of the x86_64 AES-GCM assembly code is that we end up with
two assembly files, one that generates AES-NI code with or without AVX,
and one that generates VAES code with AVX512 / AVX10 with 256-bit or
512-bit vectors.  There's no support for VAES alone (without AVX512 /
AVX10).  This differs slightly from what I did with AES-XTS where one
file generates both AVX and AVX512 / AVX10 code including code using
VAES alone (without AVX512 / AVX10), and another file generates non-AVX
code only.  For now this seems like the right choice for each particular
algorithm, though, based on how much being limited to 16 SIMD registers
and 128-bit vectors resulted in some significantly different design
choices for AES-GCM, but not quite as much for AES-XTS.  CPUs shipping
with VAES alone also seems to be a temporary thing, so we perhaps
shouldn't go too much out of our way to support that combination.

Changed in v4:
- Added AES-NI rewrite patch.
- Adjusted the VAES-AVX10 patch slightly to make it possible to cleanly
  add the AES-NI support on top of it.

Changed in v3:
- Optimized the finalization code slightly.
- Fixed a minor issue in my userspace benchmark program (guard page
  after key struct made "AVX512_Cloudflare" extra slow on some input
  lengths) and regenerated tables 3-4.  Also upgraded to Emerald Rapids.
- Eliminated an instruction from _aes_gcm_precompute.

Changed in v2:
- Additional assembly optimizations
- Improved some comments
- Aligned key struct to 64 bytes
- Added comparison with Cloudflare's implementation of AES-GCM
- Other cleanups

Eric Biggers (2):
  crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM
  crypto: x86/aes-gcm - rewrite the AES-NI optimized AES-GCM

 arch/x86/crypto/Kconfig                  |    1 +
 arch/x86/crypto/Makefile                 |    8 +-
 arch/x86/crypto/aes-gcm-aesni-x86_64.S   | 1131 +++++++++
 arch/x86/crypto/aes-gcm-avx10-x86_64.S   | 1222 ++++++++++
 arch/x86/crypto/aesni-intel_asm.S        | 1503 +-----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 2804 ----------------------
 arch/x86/crypto/aesni-intel_glue.c       | 1269 ++++++----
 7 files changed, 3128 insertions(+), 4810 deletions(-)
 create mode 100644 arch/x86/crypto/aes-gcm-aesni-x86_64.S
 create mode 100644 arch/x86/crypto/aes-gcm-avx10-x86_64.S
 delete mode 100644 arch/x86/crypto/aesni-intel_avx-x86_64.S


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.1

