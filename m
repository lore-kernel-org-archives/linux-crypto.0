Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9429B8E1;
	Tue, 28 Jul 2026 02:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785205158; cv=none; b=se08yBbELmXCcJ+fwuvjqqturk7GOeYKdcxiUwbjXe99xWxKDybA+aJTn9OcvASnQ4svKEUqrsNkBp3sQhGJMfuTvwMIx2noIEtz+7ezHZDZRYkiP3z5kPZ/934qXRbr8+i445CyCdivniOgADmrWfmjvG4bzPynxBi5a+zbxMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785205158; c=relaxed/simple;
	bh=UNuMeak/cvv9YYG4SN94PyC9gK6KM0hK5UftGHHxMtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+c/clxMvI/DXp3idISQUvEcEUMHkVJdyUjok3OQAf3yzXGPCuSLQBbTWAsrT+kDnef2HK078uC5lZZ1+JNKh7pjddCH7Fu7OgyYNvuAPDdVHtOvRwBG1i+GgHp8BzTRpZZe7H73c1UwT3nWqRKICLBoRcBtMM1kXvutK3tgwUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikigeG6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikigeG6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6E81F00A3A;
	Tue, 28 Jul 2026 02:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785205157;
	bh=TxdxesZL18DYv+BtbnHTQMnsRojgJD62AU2Qj40/G4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikigeG6yT+rsre9P5IYljLo8CYgeR0QHiiTS07u8JU/P9EHBR8xxtJ159iBUZ/tuQ
	 mcxTixckhbaUeVJzj5mweQ8gdmdh6tx5J/7JolP20G3Jcn8XfAz+t8dK4gQ392e9gT
	 Db18PXaTq2qNYyfUbZoSXOSDNDnzMlc5sy0AYYt1bvTr3fDCTQ/1U/cRN8uBXegU8M
	 wHdvWYTsaLmdcHWySKPw8YDX9sXNooQzR9xNdMSK2KdvvshwlKn9Gp/bXzUMkA+k0H
	 p/p4ASPo2690wGKhdoBMg6SyEc5Tq2MFOp9tb7xBcJs4RNMiND0M8N2OI0Z4GQ8P14
	 81RLtmQtGAm8A==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/8] um: Check for missing AVX and AVX-512 xstate bits
Date: Mon, 27 Jul 2026 19:15:57 -0700
Message-ID: <20260728021603.79870-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728021603.79870-1-ebiggers@kernel.org>
References: <20260728021603.79870-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the CPU declares AVX or AVX-512 support, verify that all the
corresponding bits are set in the XCR0 register.  If any are missing,
warn and don't set the corresponding X86_FEATURE_* flags.

This eliminates the perceived need for UML-supporting AVX and AVX-512
optimized code in the kernel (that is, lib/raid/ currently) to start
checking the XCR0 bits in addition to X86_FEATURE_AVX*.

This aligns UML with the vast majority of userspace programs, which
check the XCR0 bits before considering AVX and AVX-512 to be supported,
as per the procedure documented in Intel's CPU manual.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/um/kernel/um_arch.c | 78 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 2141f5f1f5a20..aafbaef2ae82f 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -264,12 +264,88 @@ unsigned long brk_start;
 
 #define MIN_VMALLOC (32 * 1024 * 1024)
 
+static u64 __init read_xcr0(void)
+{
+	u32 a, b, c, d;
+
+	asm volatile("cpuid"
+		     : "=a"(a), "=b"(b), "=c"(c), "=d"(d)
+		     : "a"(0), "c"(0));
+	if (a >= 1) { /* max_leaf >= 1 */
+		asm volatile("cpuid"
+			     : "=a"(a), "=b"(b), "=c"(c), "=d"(d)
+			     : "a"(1), "c"(0));
+		if (c & (1 << 27)) { /* XSAVE enabled by OS */
+			asm volatile("xgetbv" : "=d"(d), "=a"(a) : "c"(0));
+			return ((u64)d << 32) | a;
+		}
+	}
+	return 0;
+}
+
+static void __init validate_and_set_cpu_cap(int cap, u64 xcr0)
+{
+	/*
+	 * Check for missing xstate features right away, so that there's no
+	 * perceived need for all optimized code in the kernel to do so.
+	 */
+	switch (cap) {
+	case X86_FEATURE_AVX:
+	case X86_FEATURE_AVX2:
+	case X86_FEATURE_AVX_VNNI:
+	case X86_FEATURE_FMA:
+	case X86_FEATURE_VAES:
+	case X86_FEATURE_VPCLMULQDQ:
+		if ((xcr0 & 0x7) != 0x7) {
+			static bool warned;
+
+			if (!warned) {
+				os_warn("Disabling AVX support due to missing xstate features\n");
+				warned = true;
+			}
+			return;
+		}
+		break;
+	case X86_FEATURE_AVX512F:
+	case X86_FEATURE_AVX512BW:
+	case X86_FEATURE_AVX512CD:
+	case X86_FEATURE_AVX512DQ:
+	case X86_FEATURE_AVX512ER:
+	case X86_FEATURE_AVX512IFMA:
+	case X86_FEATURE_AVX512PF:
+	case X86_FEATURE_AVX512VBMI:
+	case X86_FEATURE_AVX512VL:
+	case X86_FEATURE_AVX512_4FMAPS:
+	case X86_FEATURE_AVX512_4VNNIW:
+	case X86_FEATURE_AVX512_BF16:
+	case X86_FEATURE_AVX512_BITALG:
+	case X86_FEATURE_AVX512_FP16:
+	case X86_FEATURE_AVX512_VBMI2:
+	case X86_FEATURE_AVX512_VNNI:
+	case X86_FEATURE_AVX512_VP2INTERSECT:
+	case X86_FEATURE_AVX512_VPOPCNTDQ:
+		if ((xcr0 & 0xe7) != 0xe7) {
+			static bool warned;
+
+			if (!warned) {
+				os_warn("Disabling AVX-512 support due to missing xstate features\n");
+				warned = true;
+			}
+			return;
+		}
+		break;
+	}
+	set_cpu_cap(&boot_cpu_data, cap);
+}
+
 static void __init parse_host_cpu_flags(char *line)
 {
+	u64 xcr0 = read_xcr0();
 	int i;
+
 	for (i = 0; i < 32*NCAPINTS; i++) {
 		if ((x86_cap_flags[i] != NULL) && strstr(line, x86_cap_flags[i]))
-			set_cpu_cap(&boot_cpu_data, i);
+			validate_and_set_cpu_cap(i, xcr0);
 	}
 }
 
-- 
2.55.0

