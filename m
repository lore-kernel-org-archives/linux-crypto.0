Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD05347FCD
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878244; cv=none; b=GsRtOZbDXcXmg5Ih4xHW42v7F28b3s/k8hWeIFiZFVVSvBCyk+qaL9erWhw9pK3tTnkB8rC1Xu0h1JCHquyor0W5BWNSbhw67f79MDfb0yuDkSn+36QHEhL6U9Z2sLFZxnCsToCq1pPWE66JuJ1HJnp8VXSxakteO5hrPTfSJF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878244; c=relaxed/simple;
	bh=aun6IDXO/3MKxZnMQScKMPSrvptlelLJNm33rQjke34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6LqRX66N79BRwfAFyNnrNWBzrE2BhjGk3B27bg1Vw75QPKSVUva7qur695OyaC2nadtn+CaDFycQXoNC5Z/IqrBq1gLd4RmbIvwJjI+MQGaUcOZRI4gbfg/ce4zqGmpA4wMDW+B/t1W+Qeal8zI5uasQLxRZrfchfN3ytvVyb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DH75a+WG; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DH75a+WG"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b94062e85f9so519284366b.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 10:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776878241; x=1777483041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wcZCRUAU5LVHv9nGMNvJqrx7vxNVE1JvhlKQAgVhEas=;
        b=DH75a+WG5jHU/vEzpyqgEw1iJlKwnxLQnQ/xn8uFVWacBBrB39aeYAvTOt+usVFFdV
         JCm+ZpYk0AaYlgaX0C/XZueZydtG7+TMlIHCfMVUUioOxeKdgnai2YRRuWRJ2O9bui8k
         +KCCATrdYdCg+7hQRMTTqSWwse+nU+ByqYK2sbzbiZYG1+73L0oc0I5EcXT2sMlgKLqK
         zAW8SnHUh7e+P6P005aoUZAdKk/56DENFomRofbF7BmEOIn3UgjXm83TlFpcMFT5cqlx
         V7UFS18V/YyN6DR43yYVKbm7Rg1bHUzCez0PcN5dHDsugwuiNoqneKX0ymvQQlpQhB7m
         hLFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776878241; x=1777483041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcZCRUAU5LVHv9nGMNvJqrx7vxNVE1JvhlKQAgVhEas=;
        b=eTBlBG4lJsMipKbEFN/tTX3dK9HkCW+SBL64iUjg52ft7Mi+wWn5wC/bUEnL4su00x
         r4KaX/IQT212ksHbkX9u5ivbK6aQ/8X7hEkEVs/aatU0Gx+0JfzfyC/cGVOkvpeYXw2l
         qVtOwNg/In7HTotKRO2pNgTEQMOc5dxvbnx+9O8W0WQ91g0E8ZV67CTTDtbxCaGWrhIk
         tigByl+ytHBSa6f+FRmY8W8X8OrxRRc3spaDahQwlyKmRuH3rDMK52qez1FtyfQ+VExs
         U1UpgKs5Uw+LdxkDx9WMNNfEuFsbN3U9vJwl5KPDL+tddtywHe+SzJM6DZiZJxb7OKX/
         Rcmw==
X-Gm-Message-State: AOJu0Yz82EoBD1rr12IcXrSaoRJAi61QwplQhVuckoSZwAAgbw1tilaJ
	0vJXFrizSMu/iNlQNwzYS+wWagG/45a0uXGrZ8gsPgcZJRohKSEZZcX4wys+75Sgun7SOKPkSQ=
	=
X-Received: from ejdcm14.prod.google.com ([2002:a17:906:f58e:b0:b9c:fe2c:3a3f])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3d8e:b0:ba7:4cd9:ca12
 with SMTP id a640c23a62f3a-ba74cd9eeebmr444625566b.13.1776878240359; Wed, 22
 Apr 2026 10:17:20 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:17:00 +0200
In-Reply-To: <20260422171655.3437334-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260422171655.3437334-10-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=4418; i=ardb@kernel.org;
 h=from:subject; bh=ErLhjrwZtabJiZbBHdT2Zv/irzL+HhFBwdex5+husi0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfMlU9+kxjsequwlC/7+F1XOXzRv6cWlHOedvFubg7l7T
 391L4nuKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABN55sfIcFfPvUPS/ptzn9RD
 53NxYmw7m7/VXzx+kLX1Rtuy1dPfiDMydBqeWrSioMXYRO1/yI8Oy9YqhsuSAUGxjXtFKj/HKrM wAgA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260422171655.3437334-14-ardb+git@google.com>
Subject: [PATCH 4/8] lib/crc: Turn NEON intrinsics crc64 implementation into
 common code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>, Russell King <linux@armlinux.org.uk>, 
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

Move and rename the CRC64 NEON intrinsics implementation source file and
rename the function name to reflect that it is NEON code that can be
shared. This will be wired up for 32-bit ARM in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/Makefile                                   |  6 ++---
 lib/crc/arm64/crc64-neon.h                         | 21 ++++++++++++++++
 lib/crc/arm64/crc64.h                              |  4 +--
 lib/crc/{arm64/crc64-neon-inner.c => crc64-neon.c} | 26 +++-----------------
 4 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/lib/crc/Makefile b/lib/crc/Makefile
index ff213590e4e3..193257ae466f 100644
--- a/lib/crc/Makefile
+++ b/lib/crc/Makefile
@@ -39,9 +39,9 @@ crc64-y := crc64-main.o
 ifeq ($(CONFIG_CRC64_ARCH),y)
 CFLAGS_crc64-main.o += -I$(src)/$(SRCARCH)
 
-CFLAGS_REMOVE_arm64/crc64-neon-inner.o += $(CC_FLAGS_NO_FPU)
-CFLAGS_arm64/crc64-neon-inner.o += $(CC_FLAGS_FPU) -march=armv8-a+crypto
-crc64-$(CONFIG_ARM64) += arm64/crc64-neon-inner.o
+CFLAGS_REMOVE_crc64-neon.o += $(CC_FLAGS_NO_FPU)
+CFLAGS_crc64-neon.o += $(CC_FLAGS_FPU) -I$(src)/$(SRCARCH) -march=armv8-a+crypto
+crc64-$(CONFIG_ARM64) += crc64-neon.o
 
 crc64-$(CONFIG_RISCV) += riscv/crc64_lsb.o riscv/crc64_msb.o
 crc64-$(CONFIG_X86) += x86/crc64-pclmul.o
diff --git a/lib/crc/arm64/crc64-neon.h b/lib/crc/arm64/crc64-neon.h
new file mode 100644
index 000000000000..fcd5b1e6f812
--- /dev/null
+++ b/lib/crc/arm64/crc64-neon.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
+{
+	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
+						vgetq_lane_u64(b, 0)));
+}
+
+static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
+{
+	poly64x2_t l = vreinterpretq_p64_u64(a);
+	poly64x2_t m = vreinterpretq_p64_u64(b);
+
+	return vreinterpretq_u64_p128(vmull_high_p64(l, m));
+}
+
+static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
+{
+	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 1),
+						vgetq_lane_u64(b, 0)));
+}
diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
index 60151ec3035a..c7a69e1f3d8f 100644
--- a/lib/crc/arm64/crc64.h
+++ b/lib/crc/arm64/crc64.h
@@ -8,7 +8,7 @@
 #include <linux/minmax.h>
 #include <linux/sizes.h>
 
-u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
+u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
 #define crc64_be_arch crc64_be_generic
 
@@ -19,7 +19,7 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 		size_t chunk = len & ~15;
 
 		scoped_ksimd()
-			crc = crc64_nvme_arm64_c(crc, p, chunk);
+			crc = crc64_nvme_neon(crc, p, chunk);
 
 		p += chunk;
 		len &= 15;
diff --git a/lib/crc/arm64/crc64-neon-inner.c b/lib/crc/crc64-neon.c
similarity index 62%
rename from lib/crc/arm64/crc64-neon-inner.c
rename to lib/crc/crc64-neon.c
index 28527e544ff6..4753fb94a4be 100644
--- a/lib/crc/arm64/crc64-neon-inner.c
+++ b/lib/crc/crc64-neon.c
@@ -6,7 +6,9 @@
 #include <linux/types.h>
 #include <asm/neon-intrinsics.h>
 
-u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
+#include "crc64-neon.h"
+
+u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
 /* x^191 mod G, x^127 mod G */
 static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
@@ -15,27 +17,7 @@ static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
 				    0x34d926535897936aULL };
 
-static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
-{
-	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
-						vgetq_lane_u64(b, 0)));
-}
-
-static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
-{
-	poly64x2_t l = vreinterpretq_p64_u64(a);
-	poly64x2_t m = vreinterpretq_p64_u64(b);
-
-	return vreinterpretq_u64_p128(vmull_high_p64(l, m));
-}
-
-static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
-{
-	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 1),
-						vgetq_lane_u64(b, 0)));
-}
-
-u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
+u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 {
 	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
 	uint64x2_t v0 = { crc, 0 };
-- 
2.54.0.rc1.555.g9c883467ad-goog

