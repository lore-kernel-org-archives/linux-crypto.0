Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC11CAA61;
	Thu, 23 Jan 2025 21:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667987; cv=none; b=W6yqs+fD9jAwiKLe/FG6AiYyzGZJazbmdljgefIreh8eRgPr5RDiGQBuX0WW47RFqxNpv1+zFH62B+SnMQc34mPqL/I1aCQzTdT+Cz4RI/pjCqsY1Qw/vzxX3dUNw0B7Ud4U4Vplv1Raj+dp1mgiIj1SY/6oYciUOLoJJfGXDP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667987; c=relaxed/simple;
	bh=Rifba78kwJtuPEybMJk6ZGP9vF4splfTZNkJSVBo0Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+gOh157HZ9BxgXH+8rf69mrB9cS9EDvTm/ua7Qjb4PVEBlPSeiIsLKSmsMYGovMRS3ibjDNQgEoUc9wvB1XFKkv2zRIyzOhR4SyD65U7q8VrmJlEOq4fQ4achFTDqaAjsS6OEYeuU6kPjmmFRkaYzNJTqTdbwqi6Zt2Gu3u7U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQwChkcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQwChkcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EACC4CEE3;
	Thu, 23 Jan 2025 21:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737667986;
	bh=Rifba78kwJtuPEybMJk6ZGP9vF4splfTZNkJSVBo0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQwChkcLsEfjaqRja2/+dfe9vCaOdHA6z3O0KmMA6bWOMGZT1XubSBSegJ9aIU6lO
	 kBSuwJFlu8CKtNjEymPa5rZn20kfDyEQ1ETDiPbUZDqvfNxcCr+Kbp2ONHoPI3BTBT
	 6Tsp8tJKYhVP+OIOm5AtIsaAU+GkKx29QR24wGm8KZEzqpvoW5zvGU3zlkMQ//8eQK
	 nLafQ1LWSGkLj+84aOxMeytIOn5/rWTojIhovuFRpE1Ujjpp1mlSscPdDuJW0rVTaS
	 7jVxxuDMxH9RU29j28DrHn8DQcLL1XuvyYk9pW/m/MgXN8PX58I4Hz9519Tp8I7Fgs
	 P+PfLFyXWNl5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 1/2] lib/crc: simplify the kconfig options for CRC implementations
Date: Thu, 23 Jan 2025 13:29:03 -0800
Message-ID: <20250123212904.118683-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123212904.118683-1-ebiggers@kernel.org>
References: <20250123212904.118683-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Make the following simplifications to the kconfig options for choosing
CRC implementations for CRC32 and CRC_T10DIF:

1. Make the option to disable the arch-optimized code be visible only
   when CONFIG_EXPERT=y.
2. Make a single option control the inclusion of the arch-optimized code
   for all enabled CRC variants.
3. Make CRC32_SARWATE (a.k.a. slice-by-1 or byte-by-byte) be the only
   generic CRC32 implementation.

The result is there is now just one option, CRC_OPTIMIZATIONS, which is
default y and can be disabled only when CONFIG_EXPERT=y.

Rationale:

1. Enabling the arch-optimized code is nearly always the right choice.
   However, people trying to build the tiniest kernel possible would
   find some use in disabling it.  Anything we add to CRC32 is de facto
   unconditional, given that CRC32 gets selected by something in nearly
   all kernels.  And unfortunately enabling the arch CRC code does not
   eliminate the need to build the generic CRC code into the kernel too,
   due to CPU feature dependencies.  The size of the arch CRC code will
   also increase slightly over time as more CRC variants get added and
   more implementations targeting different instruction set extensions
   get added.  Thus, it seems worthwhile to still provide an option to
   disable it, but it should be considered an expert-level tweak.

2. Considering the use case described in (1), there doesn't seem to be
   sufficient value in making the arch-optimized CRC code be
   independently configurable for different CRC variants.  Note also
   that multiple variants were already grouped together, e.g.
   CONFIG_CRC32 actually enables three different variants of CRC32.

3. The bit-by-bit implementation is uselessly slow, whereas slice-by-n
   for n=4 and n=8 use tables that are inconveniently large: 4096 bytes
   and 8192 bytes respectively, compared to 1024 bytes for n=1.  Higher
   n gives higher instruction-level parallelism, so higher n easily wins
   on traditional microbenchmarks on most CPUs.  However, the larger
   tables, which are accessed randomly, can be harmful in real-world
   situations where the dcache may be cold or useful data may need be
   evicted from the dcache.  Meanwhile, today most architectures have
   much faster CRC32 implementations using dedicated CRC32 instructions
   or carryless multiplication instructions anyway, which make the
   generic code obsolete in most cases especially on long messages.

   Another reason for going with n=1 is that this is already what is
   used by all the other CRC variants in the kernel.  CRC32 was unique
   in having support for larger tables.  But as per the above this can
   be considered an outdated optimization.

   The standardization on slice-by-1 a.k.a. CRC32_SARWATE makes much of
   the code in lib/crc32.c unused.  A later patch will clean that up.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/Kconfig | 116 +++++++---------------------------------------------
 1 file changed, 14 insertions(+), 102 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index a78d22c6507f..e08b26e8e03f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -162,38 +162,13 @@ config CRC_T10DIF
 	  SCSI data integrity subsystem.
 
 config ARCH_HAS_CRC_T10DIF
 	bool
 
-choice
-	prompt "CRC-T10DIF implementation"
-	depends on CRC_T10DIF
-	default CRC_T10DIF_IMPL_ARCH if ARCH_HAS_CRC_T10DIF
-	default CRC_T10DIF_IMPL_GENERIC if !ARCH_HAS_CRC_T10DIF
-	help
-	  This option allows you to override the default choice of CRC-T10DIF
-	  implementation.
-
-config CRC_T10DIF_IMPL_ARCH
-	bool "Architecture-optimized" if ARCH_HAS_CRC_T10DIF
-	help
-	  Use the optimized implementation of CRC-T10DIF for the selected
-	  architecture.  It is recommended to keep this enabled, as it can
-	  greatly improve CRC-T10DIF performance.
-
-config CRC_T10DIF_IMPL_GENERIC
-	bool "Generic implementation"
-	help
-	  Use the generic table-based implementation of CRC-T10DIF.  Selecting
-	  this will reduce code size slightly but can greatly reduce CRC-T10DIF
-	  performance.
-
-endchoice
-
 config CRC_T10DIF_ARCH
 	tristate
-	default CRC_T10DIF if CRC_T10DIF_IMPL_ARCH
+	default CRC_T10DIF if ARCH_HAS_CRC_T10DIF && CRC_OPTIMIZATIONS
 
 config CRC64_ROCKSOFT
 	tristate "CRC calculation for the Rocksoft model CRC64"
 	select CRC64
 	select CRYPTO
@@ -212,100 +187,26 @@ config CRC_ITU_T
 
 config CRC32
 	tristate "CRC32/CRC32c functions"
 	default y
 	select BITREVERSE
+	select CRC32_SARWATE
 	help
 	  This option is provided for the case where no in-kernel-tree
 	  modules require CRC32/CRC32c functions, but a module built outside
 	  the kernel tree does. Such modules that use library CRC32/CRC32c
 	  functions require M here.
 
 config ARCH_HAS_CRC32
 	bool
 
-choice
-	prompt "CRC32 implementation"
-	depends on CRC32
-	default CRC32_IMPL_ARCH_PLUS_SLICEBY8 if ARCH_HAS_CRC32
-	default CRC32_IMPL_SLICEBY8 if !ARCH_HAS_CRC32
-	help
-	  This option allows you to override the default choice of CRC32
-	  implementation.  Choose the default unless you know that you need one
-	  of the others.
-
-config CRC32_IMPL_ARCH_PLUS_SLICEBY8
-	bool "Arch-optimized, with fallback to slice-by-8" if ARCH_HAS_CRC32
-	help
-	  Use architecture-optimized implementation of CRC32.  Fall back to
-	  slice-by-8 in cases where the arch-optimized implementation cannot be
-	  used, e.g. if the CPU lacks support for the needed instructions.
-
-	  This is the default when an arch-optimized implementation exists.
-
-config CRC32_IMPL_ARCH_PLUS_SLICEBY1
-	bool "Arch-optimized, with fallback to slice-by-1" if ARCH_HAS_CRC32
-	help
-	  Use architecture-optimized implementation of CRC32, but fall back to
-	  slice-by-1 instead of slice-by-8 in order to reduce the binary size.
-
-config CRC32_IMPL_SLICEBY8
-	bool "Slice by 8 bytes"
-	help
-	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
-	  This is much slower than the architecture-optimized implementation of
-	  CRC32 (if the selected arch has one), but it is portable and is the
-	  fastest implementation when no arch-optimized implementation is
-	  available.  It uses an 8KiB lookup table.  Most modern processors have
-	  enough cache to hold this table without thrashing the cache.
-
-config CRC32_IMPL_SLICEBY4
-	bool "Slice by 4 bytes"
-	help
-	  Calculate checksum 4 bytes at a time with a clever slicing algorithm.
-	  This is a bit slower than slice by 8, but has a smaller 4KiB lookup
-	  table.
-
-	  Only choose this option if you know what you are doing.
-
-config CRC32_IMPL_SLICEBY1
-	bool "Slice by 1 byte (Sarwate's algorithm)"
-	help
-	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
-	  is not particularly fast, but has a small 1KiB lookup table.
-
-	  Only choose this option if you know what you are doing.
-
-config CRC32_IMPL_BIT
-	bool "Classic Algorithm (one bit at a time)"
-	help
-	  Calculate checksum one bit at a time.  This is VERY slow, but has
-	  no lookup table.  This is provided as a debugging option.
-
-	  Only choose this option if you are debugging crc32.
-
-endchoice
-
 config CRC32_ARCH
 	tristate
-	default CRC32 if CRC32_IMPL_ARCH_PLUS_SLICEBY8 || CRC32_IMPL_ARCH_PLUS_SLICEBY1
-
-config CRC32_SLICEBY8
-	bool
-	default y if CRC32_IMPL_SLICEBY8 || CRC32_IMPL_ARCH_PLUS_SLICEBY8
-
-config CRC32_SLICEBY4
-	bool
-	default y if CRC32_IMPL_SLICEBY4
+	default CRC32 if ARCH_HAS_CRC32 && CRC_OPTIMIZATIONS
 
 config CRC32_SARWATE
 	bool
-	default y if CRC32_IMPL_SLICEBY1 || CRC32_IMPL_ARCH_PLUS_SLICEBY1
-
-config CRC32_BIT
-	bool
-	default y if CRC32_IMPL_BIT
 
 config CRC64
 	tristate "CRC64 functions"
 	help
 	  This option is provided for the case where no in-kernel-tree
@@ -341,10 +242,21 @@ config CRC8
 	help
 	  This option provides CRC8 function. Drivers may select this
 	  when they need to do cyclic redundancy check according CRC8
 	  algorithm. Module will be called crc8.
 
+config CRC_OPTIMIZATIONS
+	bool "Enable optimized CRC implementations" if EXPERT
+	default y
+	help
+	  Disabling this option reduces code size slightly by disabling the
+	  architecture-optimized implementations of any CRC variants that are
+	  enabled.  CRC checksumming performance may get much slower.
+
+	  Keep this enabled unless you're really trying to minimize the size of
+	  the kernel.
+
 config XXHASH
 	tristate
 
 config AUDIT_GENERIC
 	bool
-- 
2.48.1

