Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976186;
	b=fXc7fGE6KrE4Kz938VkvfDtk1Niku94ItxKanwVr9Drj3QXw2BRtbdKmmbibr6GMUPGi
	 zbKXbUwvyX730G1MmCI+/Dg1DGyWi+ZVTRyYdqoAPCR3nI5kme5y3ZZ/5tw5fmbTuZ9Oa
	 vol9Nacl691ckDjEhY+bXp1bfuxGVEzPDtxvS4qn5pqi6Rq9x9Van5NtlsNQYAoERzjQZ
	 VneMmt4iEgsN28VOEX9Oicy08pvm8cS9vVHzr6MTmUMe96Bdi5/mHBTt+MLpcnxpuelUU
	 u1M/duml0F0wrSKKaWJnG6Fxi9NzLOORJ3+82GHmMrC0CBmCKZqYh+YXa14kFsIlW+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976186;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Transfer-Encoding:Message-Id:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=tE044CLT+O9aM7ggt8NgUVH7lY5mxY8O8ZwLuiN0opU=;
	b=cCGE1yh6S2GRxT65jM7iWrVyXyO8IvomlhQRebTiDkof4ojL4V8K3zh9LL7gxMDlNN2x
	 ahXHA5aOiKh57hRXxwubyEhyLmWhicVUxC/3Iipo7IViqBoSrJgnrlwXxNinIvYkHETbe
	 4DL7G+BnrJ4VEtxZNErT4jX3l1W73fgsrgzpi1mBGHVyLmFKZUXrAvd8TbTCvyxHCWWrj
	 S0/5t8+1KtFiK0xsUt+RRzlNZDFtxGRmb4xMfMeRj+SbvAwyJNagwkwszarkpSF7GY/e6
	 Kjc/4iMm3EXRpCOtIngEGVKRpOLcPobhScb59mDrhpZCELr0bUH50IXkHRxiIRdiXfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="Lk/Elm8B";
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A185606D81F;
	Fri,  6 Nov 2026 14:43:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A185606D81F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=Lk/Elm8B
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144303euoutp02eabd0503bf6a619d2956065db44053c9~le9WZOv5z1426614266euoutp02Y;
	Fri,  6 Nov 2026 14:43:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144303euoutp02eabd0503bf6a619d2956065db44053c9~le9WZOv5z1426614266euoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976183;
	bh=tE044CLT+O9aM7ggt8NgUVH7lY5mxY8O8ZwLuiN0opU=;
	h=From:Date:Subject:In-Reply-To:To:Cc:References:From;
	b=Lk/Elm8BzZ3Q4byd+GCj1SL7xKT/tfnydUR7wmEZIeYeK5icO/drRV6YTcmoosbxh
	 sNOuJN5kVo/Sc1xTgjo4ea30TYQSqNTYDIC7R4GxK4fqUABPcNXWA5r7RiU/QcCqXK
	 Qn2MQfJEmc35oOItF0ahIwT7NDcEt/1+K3K5loAI=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144303eucas1p10d145c55d4e168ac6d2d12758125a532~le9V8N_4w0320903209eucas1p1j;
	Fri,  6 Nov 2026 14:43:03 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144301eusmtip168e2556b5065823be9a76df286f79ad9~le9UV2Sji0540305403eusmtip1R;
	Fri,  6 Nov 2026 14:43:01 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Date: Fri, 06 Nov 2026 15:42:49 +0100
Subject: [PATCH v2 09/15] arch: boot: put the LZ4 freestanding headers on
 the decompressor path
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-lz4-vendor-upstream-v2-9-ee04c3f0d7dc@samsung.com>
In-Reply-To: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>,  Nathan Chancellor
	<nathan@kernel.org>,  Nick Desaulniers <ndesaulniers@google.com>,  Bill
	Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,  Russell
	King <linux@armlinux.org.uk>,  Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>,  "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,  Helge Deller <deller@gmx.de>,
	Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>,  Christian Borntraeger
	<borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,  Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,  Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,  Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Eric Biggers
	<ebiggers@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>,  David
	Laight <david.laight.linux@gmail.com>,  Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,  Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4734;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=EjARMhFoCMzWsj3vk/VEbPmoiRLB6nbA/8uSS+4Yr4M=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ4aecc/V2jNh+JNaSsN3dnetDZNjgrI3DbH40Pks
	hKOkE2OHaUsDGIcDLJiiixnN0YbSf5jeFp+/PEvmDmsTCBDGLg4BWAiDjIM/6tSdvGlxk421Z/E
	7VuzkYPn56FdL38IdArmOPQ9n+a1lJGR4dlfTjmH+/Hq02s4CnPWcPF2nbgSLpF+T/271NZdghN
	fsAMA
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144303eucas1p10d145c55d4e168ac6d2d12758125a532
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144303eucas1p10d145c55d4e168ac6d2d12758125a532
X-EPHeader: CA
X-CMS-RootMailID: 20261106144303eucas1p10d145c55d4e168ac6d2d12758125a532
References: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
	<CGME20261106144303eucas1p10d145c55d4e168ac6d2d12758125a532@eucas1p1.samsung.com>

lib/decompress_unlz4.c pulls lib/lz4/lz4_decompress.c into the pre-boot
decompressor on these five arches. A later patch makes that file include
the vendored LZ4 sources, which include ISO C headers that -nostdinc does
not provide, so put lib/lz4/freestanding on the include path first.

Only the one object that includes decompress_unlz4.c gets it, so the
rest of each boot directory keeps -nostdinc's view.

Signed-off-by: Michal Wilczynski <m.wilczynski@samsung.com>
---
 arch/arm/boot/compressed/Makefile    | 3 +++
 arch/mips/boot/compressed/Makefile   | 4 ++++
 arch/parisc/boot/compressed/Makefile | 3 +++
 arch/s390/boot/Makefile              | 3 +++
 arch/x86/boot/compressed/Makefile    | 3 +++
 5 files changed, 16 insertions(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index e3f550d6285786c8405b16768255af87b4dc8222..713225008aa71e614af8c9c6472fda180354569b 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -92,6 +92,9 @@ targets       := vmlinux vmlinux.lds piggy_data piggy.o \
 		 head.o $(OBJS)
 
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+# decompress.c includes decompress_unlz4.c, which builds the vendored LZ4
+# sources; they include a few ISO C headers -nostdinc drops.
+CFLAGS_decompress.o += -I$(srctree)/lib/lz4/freestanding
 
 ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin \
 	     -I$(srctree)/scripts/dtc/libfdt -fno-stack-protector \
diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index e0b8ec9a9516281933b6cc5b175e82f4013c2f54..48f8a63c54a66826889634a54d3537d735f63512 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -30,6 +30,10 @@ endif
 KBUILD_CFLAGS := $(KBUILD_CFLAGS) -D__KERNEL__ -D__DISABLE_EXPORTS \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) -D"VMLINUX_LOAD_ADDRESS_ULL=$(VMLINUX_LOAD_ADDRESS)ull"
 
+# decompress.c includes decompress_unlz4.c, which builds the vendored LZ4
+# sources; they include a few ISO C headers -nostdinc drops.
+CFLAGS_decompress.o += -I$(srctree)/lib/lz4/freestanding
+
 KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 	-DBOOT_HEAP_SIZE=$(BOOT_HEAP_SIZE) \
 	-DKERNEL_ENTRY=$(VMLINUX_ENTRY_ADDRESS)
diff --git a/arch/parisc/boot/compressed/Makefile b/arch/parisc/boot/compressed/Makefile
index 14eefb5ed5d1d781a4ee0cb2ef61ab86c905cc56..9e82f9d1285f62b164073bdacc0d4a1828d4965c 100644
--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -12,6 +12,9 @@ targets += $(OBJECTS) sizes.h
 
 KBUILD_CFLAGS := -D__KERNEL__ -O2 -DBOOTLOADER
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+# misc.c includes decompress_unlz4.c, which builds the vendored LZ4
+# sources; they include a few ISO C headers -nostdinc drops.
+CFLAGS_misc.o += -I$(srctree)/lib/lz4/freestanding
 KBUILD_CFLAGS += -fno-strict-aliasing
 KBUILD_CFLAGS += $(cflags-y) -fno-delete-null-pointer-checks -fno-builtin-printf
 KBUILD_CFLAGS += -fno-PIE -mno-space-regs -mdisable-fpregs -Os
diff --git a/arch/s390/boot/Makefile b/arch/s390/boot/Makefile
index 10b75e053a6f6bb9083548e8f82796f0aa9a9958..44355051a8c7f96b5c4dab5d110bc8aaf79c8f55 100644
--- a/arch/s390/boot/Makefile
+++ b/arch/s390/boot/Makefile
@@ -21,6 +21,9 @@ KBUILD_AFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_AFLAGS_DECOMPRESSOR))
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_MARCH),$(KBUILD_CFLAGS_DECOMPRESSOR))
 KBUILD_AFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
 KBUILD_CFLAGS += $(CC_FLAGS_MARCH_MINIMUM) -D__DISABLE_EXPORTS
+# decompressor.c includes decompress_unlz4.c, which builds the vendored LZ4
+# sources; they include a few ISO C headers -nostdinc drops.
+CFLAGS_decompressor.o += -I$(srctree)/lib/lz4/freestanding
 KBUILD_CFLAGS += $(call cc-option, -Wno-default-const-init-unsafe)
 
 CFLAGS_sclp_early_core.o += -I$(srctree)/drivers/s390/char
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 06934f9691d6a9d6952532ae5f7d96f5858719dd..328eafcfc35bd14a16bc4ec5472f6c6dc72336a1 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -30,6 +30,9 @@ KBUILD_CFLAGS += -fno-strict-aliasing -fPIE
 KBUILD_CFLAGS += -fno-jump-tables
 KBUILD_CFLAGS += -Wundef
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
+# misc.c includes decompress_unlz4.c, which builds the vendored LZ4
+# sources; they include a few ISO C headers -nostdinc drops.
+CFLAGS_misc.o += -I$(srctree)/lib/lz4/freestanding
 cflags-$(CONFIG_X86_32) := -march=i386
 cflags-$(CONFIG_X86_64) := -mcmodel=small -mno-red-zone
 KBUILD_CFLAGS += $(cflags-y)

-- 
2.34.1

