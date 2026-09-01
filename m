Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AA837C10C;
	Tue,  1 Sep 2026 14:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274694; cv=none; b=uKwfDShxM8BMPycVib6nFUWwfGm45hEkWDJJONt174qH57bRx8BDpVyqyE37JozfaL017x/2vldgHukJx7Cd0JnotSOJCaO9wBOgtcJNefioFVRgbwQKKXDVte7WTbI5EacGZWX5rM4jVBEYXzv3TdfwfzlGe7nW53IMAA4sq3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274694; c=relaxed/simple;
	bh=Qt2g2f/NZEH5KtGE2aMVUqWOlU4GnccZTM2AkpbZgCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNpKNoEOvId1L+tw9MZBt50RzCrWbhdovi1tTwv5atRT9Z2Z78XZ2oTF1u2ElOCP+8wc20tNwz88NFGqSKbNh466hJhs7Pfnecb27EMJt1QAEok4WwetOAai6I0zF33ggta2emCOWSWc9YyF/7xh6pIQSh5JbLS2O2Yk1KAadCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LbmV/iL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LbmV/iL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C491F00A3E;
	Tue,  1 Sep 2026 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788274693;
	bh=GjHnvhTUIuOR14d0OFZbby0ThaLZzSviDPcvynF6ARQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbmV/iL1gmV5lbQzrEMjAHuwjKpDYu0O8yaAsMGyAEJLPpqDGy7IvC4HA4g5B2PKf
	 2VWwCKAOhGUW7gGkejv/Acnva8zIS1wdH2e8wV5f1OGIdilBPyBOagxCL+LUzT5EQw
	 ni3ApPIWXnImGpAaOd8UN5+ecRYLYIIotuihFZZ0p2q68nY2qPxEQOb7pZ5rr6U7E1
	 lDJ5Jd3YB3MuxJ8TBaRWNzI+UrcVoJajygPSHchEDMyTUyyrk/o5VVm5QVyUcCZD0/
	 Y1EZipLsaqlWWTTwGbKlFsyPRlc9G39gJa7EdyXOXy2Y+41FoI3zMjiSZpE/tCz4Gc
	 5//xo9ymGV/Zw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 2/8] um: Check for missing AVX and AVX-512 xstate bits
Date: Tue,  1 Sep 2026 07:57:34 -0700
Message-ID: <20260901145740.42337-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>
References: <20260901145740.42337-1-ebiggers@kernel.org>
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

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/um/kernel/um_arch.c | 78 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index e4ee693961e4..9d53cc6a783d 100644
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

