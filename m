Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C230A305689;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782448765; cv=none; b=h3jSNR2nRNaXAe7y22OCimKOOks3ze+URkIyE+P1xYYrTRVI2poLRWhEPDBUxXHxz45w21Qng13nZFXqlAM9CgAW7hBiTOsi+2gIFaFr8+0pzETGaMtB0Ib/F9lv6N20jQu07Se7FB7u43kfi81dWiP/SqC5Rf0bvQInolbJIj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782448765; c=relaxed/simple;
	bh=DAkG5ZcHe5k3NDWVAeg+i2n9Jn/8ibRQsvfnigbcnLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7+4sBIMD4EUdRcJW4rFvz95y7UHrOW24aUvM4z7HgFGi7PTjeNLaeUxy7Bp6BxYd8L7wZ5Vu37SjP/xF4+vnypwPOGodyn64Co14Cx0V1tKq6P8ocayb2Ikpxj+tB7UpDfSrZR/+Nxsv0DlGfWKkdpBskGpxwSrmh+ag7YFRVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/7sEja+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/7sEja+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730D71F00A3F;
	Fri, 26 Jun 2026 04:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782448764;
	bh=qlf7k2IWeCHamtcpWOO1GJP/ujnSA1ip2v29jSHJHMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/7sEja+Br7/M1lEynfT8OwuQ/+YvF6oXhZU+4Vl12jUOb/LUccVKsNtGMr2pj1Kf
	 JRjry17LzPYDw0iAWjQdf2Z3HZHy1ppusY7WgYrfFMGMenxDpmMstZu9E0/M3AaB9a
	 iKfC7LnvKgXeUZR7FTPZeMzasd+Zyjqx9WRws151/oHa3SJS5GVyertH92R3j9j+Y/
	 qe1yQe6B85p2lqhxK5zw3zT0XJdDV54yYXi2ncK7KnB9zp8nz4JG+kcnXjUiLlrt4m
	 Uwk07RexC0raptQdFZ36f+fn+qwS9SMmQsWnErwv/leJaasfYx18pMejllOUGBDwhp
	 DOxomO2AN/zHw==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org
Cc: linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
Date: Thu, 25 Jun 2026 21:37:25 -0700
Message-ID: <20260626043731.319287-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626043731.319287-1-ebiggers@kernel.org>
References: <20260626043731.319287-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the CPU declares AVX or AVX-512 support, verify that all the
corresponding xstate bits are also set.  If any are missing, warn and
don't set the corresponding X86_FEATURE_* flags.

This eliminates the perceived need for UML-supporting AVX and AVX-512
optimized code in the kernel (that is, lib/raid/ currently) to start
checking the xstate bits in addition to X86_FEATURE_AVX*.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/um/kernel/um_arch.c | 78 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 2141f5f1f5a2..aafbaef2ae82 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -262,16 +262,92 @@ EXPORT_SYMBOL(task_size);
 
 unsigned long brk_start;
 
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
 
 static void __init parse_cache_line(char *line)
 {
-- 
2.54.0

