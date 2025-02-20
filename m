Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBA3A930;
	Thu, 20 Feb 2025 05:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740028587; cv=none; b=cBXjH3/A2eVRdwqMP2rUbBTKY8HmNoAkHE8Sy7cK8IxgCcgNM19UC9xLf/y1moLaCcRDioGJwNMNj3fWCeycLRXZeSnImiUuFxvtF3xaxDOsWU8iUd0+/4anhVbFqgv2IopBDzWcYpzI6/AyM5N+vooCwWYPxJM8pNKEpnwyedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740028587; c=relaxed/simple;
	bh=KqkamthdFH3SEg6xMpi7YCzCOJefi/zrVa3zI3N+U4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pMPjyKhH6CxseieyZz0sEbbpfIOOK5LriCuQ2/qosRuNIiRoxHvaOLyFFRpN8bSiDZMlHec7Mtf50O4ndu3YVDihLNnBbpdmViFDadqopCBBIOcYK1v4/6FhJTwKl/pt/RRGAO74rHoCO73LCi0Dct/m0MI6vA4CT4sPRU2lzUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXF3YBvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXF3YBvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF7C4CED1;
	Thu, 20 Feb 2025 05:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740028586;
	bh=KqkamthdFH3SEg6xMpi7YCzCOJefi/zrVa3zI3N+U4s=;
	h=From:To:Cc:Subject:Date:From;
	b=OXF3YBvObn35kRPTlfRtpFvrzwxPX+uAOlUkjagWTF3kjChcWYUNP3wQOLSrJmvsw
	 7bs2YY9nkvJ69rV6GyAR27KD603+h/Cs77zcrH66KdgKu6BjdzsxBLeFJHHBowhuSK
	 f9dCh8srMNcKi6R4V3LbnYx4awoI1jE4abFSaJV3fsFOx1MqvBDlZ9SmykCl2ym3Xq
	 LN06xmJthSfXbnG+g1KglEJi4VTW/c4pKEgcIWYRRGQtRVZGi+PIw9mOX7DlsKw7+D
	 unMlSbXnZimWem3mPqk2gn7Gqkmzl9fE/qtycjRVPd0tWCysMZFZ025SdUTDUKX4ss
	 fOdKaSW7JaHtQ==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC PATCH 0/2] Eliminate the no-SIMD en/decryption fallbacks on x86
Date: Wed, 19 Feb 2025 21:13:23 -0800
Message-ID: <20250220051325.340691-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patchset can also be retrieved from:
 
    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git x86-softirq-fpu-fix-v1

This patchset fixes a longstanding issue where kernel-mode FPU (i.e.,
SIMD) was not reliably usable in softirqs in x86, which was creating the
need for a fallback.  The fallback was really bad for performance, and
it even hurt performance for users that never encountered the edge case
where kernel-mode FPU was not usable.

This patchset aligns x86 with other architectures such as arm, arm64,
and riscv by making kernel-mode FPU work in softirqs reliably.  There
are a few possible ways to achieve that, and for now I just went with
the simplest way; see patch 1 for details.

Patch 2 eliminates all uses of the "crypto SIMD helper" from x86, as
patch 1 makes it unnecessary.  For the RFC it is just one big patch;
I'll probably split patch 2 up if this progresses past RFC status.

Performance results have been positive.  All en/decryption is now
slightly faster on x86, as it no longer take a detour through
crypto/simd.c.  I get a 7% or 23% improvement for AES-XTS, for example.

I also benchmarked bidirectional IPsec, which has been claimed to often
hit the edge case where kernel-mode FPU was previously not usable in
softirq context.  Ultimately, I was not actually able to reproduce that
edge case being reached unless I reduced the number of CPUs to 1, in
which case it then started being occasionally reached.  Regardless, even
without that case being reached, IPsec throughput still improved by 2%.
In situations where that case was being reached, or where users required
a synchronous algorithm, a much larger improvement should be seen.

Eric Biggers (2):
  x86/fpu: make kernel-mode FPU reliably usable in softirqs
  crypto: x86 - stop using the SIMD helper

 arch/x86/crypto/Kconfig                    |  14 --
 arch/x86/crypto/aegis128-aesni-glue.c      |  13 +-
 arch/x86/crypto/aesni-intel_glue.c         | 168 ++++++++-------------
 arch/x86/crypto/aria_aesni_avx2_glue.c     |  22 +--
 arch/x86/crypto/aria_aesni_avx_glue.c      |  20 +--
 arch/x86/crypto/aria_gfni_avx512_glue.c    |  22 +--
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  21 +--
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  21 +--
 arch/x86/crypto/cast5_avx_glue.c           |  21 +--
 arch/x86/crypto/cast6_avx_glue.c           |  20 +--
 arch/x86/crypto/serpent_avx2_glue.c        |  21 +--
 arch/x86/crypto/serpent_avx_glue.c         |  21 +--
 arch/x86/crypto/serpent_sse2_glue.c        |  21 +--
 arch/x86/crypto/sm4_aesni_avx2_glue.c      |  30 ++--
 arch/x86/crypto/sm4_aesni_avx_glue.c       |  30 ++--
 arch/x86/crypto/twofish_avx_glue.c         |  21 +--
 arch/x86/include/asm/fpu/api.h             |  17 +--
 arch/x86/kernel/fpu/core.c                 |  37 ++---
 18 files changed, 180 insertions(+), 360 deletions(-)


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
prerequisite-patch-id: ec1feea7e6f4d03e4e4c64c492197b89c957611a
-- 
2.48.1

