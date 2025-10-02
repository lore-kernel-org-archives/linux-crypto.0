Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97724280017;
	Thu,  2 Oct 2025 02:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759372445; cv=none; b=Sx/XfWUn3p94aSkoZo2hP+aHtas1EWUE8AZcMCwVsyWX59V86cL+iIViGTwjuXpt6sXWnbeJJnBeOCI2xS3n2NJEpv1OIsUjAmUXbWEd9h5dF1OBzubrh8Usc/GPpoBvoGEOHw8qgUUmhosxH4tbIPDxzxTbjs1T5E+iXFZWVQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759372445; c=relaxed/simple;
	bh=rYlyz2EO1lm/dDN/Uwd0y3EdKskV/DbFPcfgcms6Wjk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a9m8f+oAXjXMVJjX0MFcXkvMLOovYKDztOpm6mjgzMxWLxTbXrWyOthhia6MFEFm6HAl+cvCnnjesrRbqIE49UBUhem1CRO26C5Rw8aWjzSF1ryxtTM7nS7zDHMGCiUvBk2fNYzojgcfSGFNRaTzGx15A8BcWnAUSfsHx/1mZLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TT/x4VJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TT/x4VJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AC1C4CEF1;
	Thu,  2 Oct 2025 02:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759372445;
	bh=rYlyz2EO1lm/dDN/Uwd0y3EdKskV/DbFPcfgcms6Wjk=;
	h=From:To:Cc:Subject:Date:From;
	b=TT/x4VJDn3JJbvvP6GWigs5N45VRFYXgmIWsk/gKhVHMagV9T9bo66MtqYrDOc1Ja
	 bUQ1dFKeRF7S3dLfrBHM23t+dZS5jRzO8vDbXyOMuVEEhK0eu6Wj3cYHiepjZ/T/qd
	 1Z8g8sTFSyxwDF75rrAjX+8NYFZMU0XuunTNYn3AigReJzNh5owj6OGS/Wa0DRzmRh
	 orloUGgY+qfxWmU5T9vAp6Sm0MZK4YrYL9ThExX7jew92ow7AA0RaAITflb6qXWt2T
	 fp8ldfQ+ZU+em1ezIZkQysI3h9Ec8HZnVOMt6rfKKHmEA3qKejJmxnVA3fmqRsCou4
	 YDE11rNS1lvfA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Date: Wed,  1 Oct 2025 19:31:09 -0700
Message-ID: <20251002023117.37504-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset replaces the 256-bit vector implementation of AES-GCM for
x86_64 with one that requires AVX2 rather than AVX512.  This greatly
improves AES-GCM performance on CPUs that have VAES but not AVX512, for
example by up to 74% on AMD Zen 3.  For more details, see patch 1.

This patchset also renames the 512-bit vector implementation of AES-GCM
for x86_64 to be named after AVX512 rather than AVX10/512, then adds
some additional optimizations to it.

This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
I'd prefer to just apply this myself.  But let me know if you'd prefer
to take it instead (considering that AES-GCM hasn't been librarified
yet).  Either way, there's no hurry, since this is targeting 6.19.

Eric Biggers (8):
  crypto: x86/aes-gcm - add VAES+AVX2 optimized code
  crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
  crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
  crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
  crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
    functions
  crypto: x86/aes-gcm - revise some comments in AVX512 code
  crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
  crypto: x86/aes-gcm - optimize long AAD processing with AVX512

 arch/x86/crypto/Makefile                      |    5 +-
 arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
 arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
 ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
 arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
 5 files changed, 1667 insertions(+), 486 deletions(-)
 create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
 rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)

base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
-- 
2.51.0

