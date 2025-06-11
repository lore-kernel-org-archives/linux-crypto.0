Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCAD224B12;
	Wed, 11 Jun 2025 02:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749610551; cv=none; b=SJGV8znGFMAhEFikOuQK1lhD5oupzZH86C2hgmYTJ5BycWJGBNKTE0NmeVjMZk6WiPjJEvjqhJpXH1j5tK5wqmTCEe2mDABQfmnTu6ZAPo2AHYJLaZ6dfQkk90RoMQW2ZJhTmHsZV8ML4Z/qlTGylL+c6asIB2GoxLrITWxhgRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749610551; c=relaxed/simple;
	bh=/jUVPdqMLuUUIzZFHHrSUDdQ5Mbyy729MmizuS2hlx4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jwN2E7BhIrLBsJSlD7cx5qkMt4X2ryQ97aj0VRGAzCXPcaD1kOrBJlnB1tS3IrJVmwK4SQ83lqNA+iy59JSu7aIa61wjqNDbd7nqImsu356P3WiLIo/rUkSwLe3+tPIco0LdITNgW2MKLTM9G1Orhya7QueDxyhmitNdnmPI7U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=JwghL2Sz; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="JwghL2Sz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1749610312;
	bh=/90nqrY1vyZY/h758unnj+VRuTFMnwM1PxLJGrq/F/s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JwghL2SzeSJDQYx+O5IWUpK5eRxIQiHAQNCGK7e16IZ7NO9CEeIKN3Botwgd5txIK
	 JHQKHeBOzQ/qxNNo5EP8pL2Rm3fn3Hq/+pn3FJJT3Xh7Twaw+3H9CnGN96dF8BuOJ+
	 6yNhx8drKiu6OoIz3UMU/jFJv/ql42jPDxtDOp9U=
X-QQ-mid: zesmtpip3t1749610295t4b528a64
X-QQ-Originating-IP: sxQqspGd8fDkBeqA+Br850ElBLn7JgXYk6xUPYmfJJg=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 11 Jun 2025 10:51:33 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2112763599155669831
EX-QQ-RecipientCnt: 11
From: =?UTF-8?q?=E2=80=9CChengZhenghan=E2=80=9D?= <chengzhenghan@uniontech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
	ChengZhenghan <chengzhenghan@uniontech.com>
Subject: [PATCH] x86_crypto: Fix build warnings about export.h
Date: Wed, 11 Jun 2025 10:51:31 +0800
Message-Id: <20250611025131.22055-1-chengzhenghan@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-QQ-XMAILINFO: NKv2G1wnhDBn/euhrLYpriicw8CliXMWI8qUHgYlP7lJY1/7FqcUZlDd
	OSZC98bnNJJo+2qewKXliqHxv6WEv4BXXX6FytfHsCq/KXOmkhbtmEYu32aIl92GPtXeSMO
	0bpQ8vImT4NzcqMWcGV/Kzo74Ru/5kJLhH+fEGmUbVZR8YL9im6JfKDhz9Wxj5hz0edb2r4
	s+wb94acyW9o20YPrZ6U5hye8wx5zqFav+QqHtbHbAF7jntndBn4abVKiF/cYwfXPBICKYo
	FTt0zvSRQjiHuZVje3DA2BM7o8nyUGEFGZL5amrXckWX4nuzLe4fkF0kTs8VCSUDCmjRitj
	dArB3r+vgmIpcpxINsI9Lmr0vHb5GhfwggWDkyvpBYBpjcTHjO1fMn0ACUhZXOqePMvGN9b
	07/nOindKUNGHMOaP6fJmP0/4zpsx3z3gOpYHpjqk2mEYxIeWpoJsLy0kBgi6JOS5WPDLsa
	loxavsJnpIoq1GRp/MinMDspI6PcdJL6GrxKyv3vijcfxEety1DPVs3pZqat7D4UQAB1uv7
	1k5O+NBMTdNk30GFhGRN6aJiMja1uqRESFmbROqkK+qDmz7yW6YnOF0BWkt/60c78axdMY4
	zn7Ztrtq5Xc7BWlDDfWKYhwdpxiWHCvq2U97yiYLeJQNDzgCWTRQl1ZSIKJc6f6OB00kstc
	7kZLb8IKPt/v3OURrVroz5PzV6j1h3p8ZLLtiVONVdfoFr4xo2IlEIV2+FzFZWpXwS/ium/
	YLF+qVPoq9l3H5k9RE7mRfiVGD482pdVqJDo1QloxDWvruzv4NwggQEyQNRS134AoPBL3xO
	cfWxkJLshrDPWl3UIQpev2ukcYUsygITyejwhsbirRYJ+QbQIKbvjgsh/+xTvxB0dCMCkeJ
	PrCNozgOtk2xQwFH/a6NcTmqmRfF4B5hGN9kyTOoMHjuRbIBkQiEdC7TnhBmrnlh1JjYrnU
	75rht6vAXf+b6GJPbomsSR8bN20vg0PP5tNKpDs32LRoZJSo3gjwElEdCY+fAo8asM8Y=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

From: ChengZhenghan <chengzhenghan@uniontech.com>

I got some build warnings with W=1:
arch/x86/coco/sev/core.c:
arch/x86/crypto/aria_aesni_avx2_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/aria_aesni_avx_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/camellia_aesni_avx_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/camellia_glue.c: warning:
 EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/curve25519-x86_64.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/serpent_avx_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/sm4_aesni_avx_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/twofish_glue.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
arch/x86/crypto/twofish_glue_3way.c:
 warning: EXPORT_SYMBOL() is used,
 but #include <linux/export.h> is missing
so I fixed these build warnings for x86_64.

Signed-off-by: ChengZhenghan <chengzhenghan@uniontech.com>
---
 arch/x86/crypto/aria_aesni_avx2_glue.c    | 1 +
 arch/x86/crypto/aria_aesni_avx_glue.c     | 1 +
 arch/x86/crypto/camellia_aesni_avx_glue.c | 1 +
 arch/x86/crypto/camellia_glue.c           | 1 +
 arch/x86/crypto/curve25519-x86_64.c       | 1 +
 arch/x86/crypto/serpent_avx_glue.c        | 1 +
 arch/x86/crypto/sm4_aesni_avx_glue.c      | 1 +
 arch/x86/crypto/twofish_glue.c            | 1 +
 arch/x86/crypto/twofish_glue_3way.c       | 1 +
 9 files changed, 9 insertions(+)

diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index b4bddcd58457..007b250f774c 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -9,6 +9,7 @@
 #include <crypto/aria.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index ab9b38d05332..4c88ef4eba82 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -9,6 +9,7 @@
 #include <crypto/aria.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index a7d162388142..5c321f255eb7 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -8,6 +8,7 @@
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <linux/module.h>
 #include <linux/types.h>
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 3bd37d664121..cf4cb5daee92 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/export.h>
 #include <crypto/algapi.h>
 
 #include "camellia.h"
diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index dcfc0de333de..d587f05c3c8c 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -7,6 +7,7 @@
 #include <crypto/curve25519.h>
 #include <crypto/internal/kpp.h>
 
+#include <linux/export.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index e640abc1cb8a..9c8b3a335d5c 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
+#include <linux/export.h>
 #include <crypto/algapi.h>
 #include <crypto/serpent.h>
 
diff --git a/arch/x86/crypto/sm4_aesni_avx_glue.c b/arch/x86/crypto/sm4_aesni_avx_glue.c
index 72867fc49ce8..88caf418a06f 100644
--- a/arch/x86/crypto/sm4_aesni_avx_glue.c
+++ b/arch/x86/crypto/sm4_aesni_avx_glue.c
@@ -11,6 +11,7 @@
 #include <asm/fpu/api.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
+#include <linux/export.h>
 #include <linux/kernel.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/sm4.h>
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 4c67184dc573..9f6b5e858f1d 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -42,6 +42,7 @@
 #include <crypto/twofish.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/export.h>
 #include <linux/types.h>
 
 asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 1a1ecfa7f72a..8ec3adb085f3 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/export.h>
 
 #include "twofish.h"
 #include "ecb_cbc_helpers.h"
-- 
2.47.2

