Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5EF1DEFE0
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 08:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766134313; cv=none; b=hcIT7Pb/fjBxdFq2FF2GudPtQgRm0Lf4QGYSz0ShODg7aP7ikXa6g/ZYmvqG1aQvGRiLMEa78zQyDG5Fn35Jg6o/S92Pi1nQ+LVjRPz402A6Aipi/uNlPfXuqME/7J9lEV2wJiX/k8ifQp5eG1ZOl4V53ezQHpOVWGnVtW8UPxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766134313; c=relaxed/simple;
	bh=tVdIkzPWg4MBxe4T1tw1pdFxGqiygb4nURBABqYmc8Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dW1SJbtyhS7qaNrvPXHguVp60wIKGIcOaJGTIsf4FXWmxCH2Izy03ARr3gddiVsY3t2oi8+ZAv8pJUhxDuaOHkHfABmYzkxbDiaIwFDGxIFCIKNYxCT1ppojNRm+ebKdKfcWxlN6m3XZi9ZpBkp8AQ9NaZa5UT5DdvjywMeHEgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1766134276-1eb14e3d89fb300003-Xm9f1P
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx2.zhaoxin.com with ESMTP id TIJ23XMU5YhNxcxB (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 19 Dec 2025 16:51:44 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 19 Dec
 2025 16:51:34 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Fri, 19 Dec 2025 16:51:34 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.59; Fri, 19 Dec 2025 16:03:57 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <ebiggers@kernel.org>, <Jason@zx2c4.com>,
	<ardb@kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v2 2/2] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Date: Fri, 19 Dec 2025 16:03:06 +0800
X-ASG-Orig-Subj: [PATCH v2 2/2] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Message-ID: <f262072cc32c551d654edff146d37692569e1bea.1766131281.git.AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
References: <cover.1766131281.git.AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: zxbjmbx1.zhaoxin.com (10.29.252.163) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 12/19/2025 4:51:32 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1766134304
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 6239
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.151782
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
instructions by PHE(Padlock Hash Engine) Extensions, including XSHA1,
XSHA256, XSHA384 and XSHA512 instructions.

With the help of implementation of SHA in hardware instead of software,
can develop applications with higher performance, more security and more
flexibility.

This patch includes the XSHA256 instruction optimized implementation of
SHA-256 transform function.

Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
---
 lib/crypto/Makefile             |  3 +-
 lib/crypto/x86/sha256-phe-asm.S | 70 +++++++++++++++++++++++++++++++++
 lib/crypto/x86/sha256.h         | 20 ++++++++++
 3 files changed, 92 insertions(+), 1 deletion(-)
 create mode 100644 lib/crypto/x86/sha256-phe-asm.S

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 069069377..f56c6e6c7 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -236,7 +236,8 @@ libsha256-$(CONFIG_SPARC) +=3D sparc/sha256_asm.o
 libsha256-$(CONFIG_X86) +=3D x86/sha256-ssse3-asm.o \
 			   x86/sha256-avx-asm.o \
 			   x86/sha256-avx2-asm.o \
-			   x86/sha256-ni-asm.o
+			   x86/sha256-ni-asm.o \
+			   x86/sha256-phe-asm.o
 endif # CONFIG_CRYPTO_LIB_SHA256_ARCH
=20
 ##########################################################################=
######
diff --git a/lib/crypto/x86/sha256-phe-asm.S b/lib/crypto/x86/sha256-phe-as=
m.S
new file mode 100644
index 000000000..404c6bed7
--- /dev/null
+++ b/lib/crypto/x86/sha256-phe-asm.S
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PHE Extensions optimized implementation of a SHA-1 update function
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * BSD LICENSE
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 	* Redistributions of source code must retain the above copyright
+ * 	  notice, this list of conditions and the following disclaimer.
+ * 	* Redistributions in binary form must reproduce the above copyright
+ * 	  notice, this list of conditions and the following disclaimer in
+ * 	  the documentation and/or other materials provided with the
+ * 	  distribution.
+ * 	* Neither the name of Intel Corporation nor the names of its
+ * 	  contributors may be used to endorse or promote products derived
+ * 	  from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include <linux/linkage.h>
+
+/*
+ * PHE Extensions optimized implementation of a SHA-256 block function
+ *
+ * This function takes a pointer to the current SHA-256 state, a pointer t=
o the
+ * input data, and the number of 64-byte blocks to process.  Once all bloc=
ks
+ * have been processed, the state is updated with the new state.  This fun=
ction
+ * only processes complete blocks.  State initialization, buffering of par=
tial
+ * blocks, and digest finalization is expected to be handled elsewhere.
+ *
+ * void sha256_transform_phe(u8 *state, const u8 *data, size_t nblocks)
+ */
+.text
+SYM_FUNC_START(sha256_transform_phe)
+	mov		$-1, %rax
+	mov		%rdx, %rcx
+
+	.byte	0xf3,0x0f,0xa6,0xd0
+
+	RET
+SYM_FUNC_END(sha256_transform_phe)
diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 38e33b22a..072b44480 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -31,6 +31,23 @@ DEFINE_X86_SHA256_FN(sha256_blocks_avx, sha256_transform=
_avx);
 DEFINE_X86_SHA256_FN(sha256_blocks_avx2, sha256_transform_rorx);
 DEFINE_X86_SHA256_FN(sha256_blocks_ni, sha256_ni_transform);
=20
+#define PHE_ALIGNMENT 16
+asmlinkage void sha256_transform_phe(u8 *state, const u8 *data, size_t nbl=
ocks);
+static void sha256_blocks_phe(struct sha256_block_state *state,
+			     const u8 *data, size_t nblocks)
+{
+	/*
+	 * XSHA256 requires %edi to point to a 32-byte, 16-byte-aligned
+	 * buffer on Zhaoxin processors.
+	 */
+	u8 buf[32 + PHE_ALIGNMENT - 1];
+	u8 *dst =3D PTR_ALIGN(&buf[0], PHE_ALIGNMENT);
+
+	memcpy(dst, (u8 *)(state), SHA256_DIGEST_SIZE);
+	sha256_transform_phe(dst, data, nblocks);
+	memcpy((u8 *)(state), dst, SHA256_DIGEST_SIZE);
+}
+
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
@@ -79,6 +96,9 @@ static void sha256_mod_init_arch(void)
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
 		static_branch_enable(&have_sha_ni);
+	} else if (boot_cpu_has(X86_FEATURE_PHE) && boot_cpu_has(X86_FEATURE_PHE_=
EN)) {
+		if (cpu_data(0).x86 >=3D 0x07)
+			static_call_update(sha256_blocks_x86, sha256_blocks_phe);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
 		   boot_cpu_has(X86_FEATURE_AVX)) {
--=20
2.34.1

