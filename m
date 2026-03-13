Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1DA36495D
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 08:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388998; cv=none; b=B3l3kOjgBMJoPTEhGFBw+Pgo2fzUuf6oxxAlxXLTWiOAQJrLFcdZJ5q5diTtp/Q4O4jdgD2rqn2DXKWPk2UKVBKXCcWrPNk7su6j7iPdk7c335V1KfursBvMJDsrMTg2cu/NsC6MfqnaPCgFlxhlUiL9mxXPhXVOZiZID8+HZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388998; c=relaxed/simple;
	bh=KaTGPq+xrxvJF5YHRh6JEcg9t5cDC7aHbfVEj3FKzPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UsqzTPURx01djEkyu4nUTBD+MkleKNHSfr5UHgvK/okC7FpGsUyHt1yVD/5tmZ2t0mTTXTaE4pnZUv0lpeYkB9ALXIG9jIr0yRPOmYMj8P0/daMvON/rs/LCaUiwM5gMqCN14E9hxEE3Z1HN9bS9M3Q7oPaoLAoPigZoS3RqtK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1773388991-1eb14e06e90ffb0001-Xm9f1P
Received: from zhaoxin.com (zxmail.zhaoxin.com [10.28.208.166]) by mx2.zhaoxin.com with ESMTP id LFHokJeTn5gJH5ko; Fri, 13 Mar 2026 16:03:11 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.208.166
Received: from desktop-a4i8d8t.zhaoxin.com (desktop-a4i8d8t.zhaoxin.com [10.32.65.156])
	by zhaoxin.com (f222c4) with ESMTP3e539d0ed8c289fc3e9fde6efa59502d
	Fri, 13 Mar 2026 16:03:10 +0800
X-Eyou-Smtpauth: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.32.65.156
X-Eyou-EnvelopeSender: AlanSong-oc@zhaoxin.com
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: CobeChen@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com,
	YunShen@zhaoxin.com,
	GeorgeXue@zhaoxin.com,
	LeoLiu@zhaoxin.com,
	HansHu@zhaoxin.com,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v4 2/2] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Date: Fri, 13 Mar 2026 16:01:50 +0800
X-ASG-Orig-Subj: [PATCH v4 2/2] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Message-Id: <20260313080150.9393-3-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
References: <20260313080150.9393-1-AlanSong-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <alansong-oc@zhaoxin.com>
X-Barracuda-Connect: zxmail.zhaoxin.com[10.28.208.166]
X-Barracuda-Start-Time: 1773388991
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 5441
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155781
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

Zhaoxin CPUs have implemented the SHA(Secure Hash Algorithm) as its CPU
instructions by PHE(Padlock Hash Engine) Extensions, including XSHA1,
XSHA256, XSHA384 and XSHA512 instructions. The instruction specification
is available at the following link.
(https://gitee.com/openzhaoxin/zhaoxin_specifications/blob/20260227/ZX_Padlock_Reference.pdf)

With the help of implementation of SHA in hardware instead of software,
can develop applications with higher performance, more security and more
flexibility.

This patch includes the XSHA256 instruction optimized implementation of
SHA-256 transform function.

The table below shows the benchmark results before and after applying
this patch by using CRYPTO_LIB_BENCHMARK on Zhaoxin KX-7000 platform,
highlighting the achieved speedups.

+---------+--------------------------+
|         |          SHA256          |
+---------+--------+-----------------+
|   Len   | Before |      After      |
+---------+--------+-----------------+
|      1* |    2   |    7 (3.50x)    |
|     16  |   35   |  119 (3.40x)    |
|     64  |   74   |  280 (3.78x)    |
|    127  |   99   |  387 (3.91x)    |
|    128  |  103   |  427 (4.15x)    |
|    200  |  123   |  537 (4.37x)    |
|    256  |  128   |  582 (4.55x)    |
|    511  |  144   |  679 (4.72x)    |
|    512  |  146   |  714 (4.89x)    |
|   1024  |  157   |  796 (5.07x)    |
|   3173  |  167   |  883 (5.28x)    |
|   4096  |  166   |  876 (5.28x)    |
|  16384  |  169   |  899 (5.32x)    |
+---------+--------+-----------------+
*: The length of each data block to be processed by one complete SHA
   sequence.
**: The throughput of processing data blocks, unit is Mb/s.

After applying this patch, the SHA256 KUnit test suite passes on Zhaoxin
platforms. Detailed test logs are shown below.

[    7.767257]     # Subtest: sha256
[    7.770542]     # module: sha256_kunit
[    7.770544]     1..15
[    7.777383]     ok 1 test_hash_test_vectors
[    7.788563]     ok 2 test_hash_all_lens_up_to_4096
[    7.806090]     ok 3 test_hash_incremental_updates
[    7.813553]     ok 4 test_hash_buffer_overruns
[    7.822384]     ok 5 test_hash_overlaps
[    7.829388]     ok 6 test_hash_alignment_consistency
[    7.833843]     ok 7 test_hash_ctx_zeroization
[    7.915191]     ok 8 test_hash_interrupt_context_1
[    8.362312]     ok 9 test_hash_interrupt_context_2
[    8.401607]     ok 10 test_hmac
[    8.415458]     ok 11 test_sha256_finup_2x
[    8.419397]     ok 12 test_sha256_finup_2x_defaultctx
[    8.424107]     ok 13 test_sha256_finup_2x_hugelen
[    8.451289]     # benchmark_hash: len=1: 7 MB/s
[    8.465372]     # benchmark_hash: len=16: 119 MB/s
[    8.481760]     # benchmark_hash: len=64: 280 MB/s
[    8.499344]     # benchmark_hash: len=127: 387 MB/s
[    8.515800]     # benchmark_hash: len=128: 427 MB/s
[    8.531970]     # benchmark_hash: len=200: 537 MB/s
[    8.548241]     # benchmark_hash: len=256: 582 MB/s
[    8.564838]     # benchmark_hash: len=511: 679 MB/s
[    8.580872]     # benchmark_hash: len=512: 714 MB/s
[    8.596858]     # benchmark_hash: len=1024: 796 MB/s
[    8.612567]     # benchmark_hash: len=3173: 883 MB/s
[    8.628546]     # benchmark_hash: len=4096: 876 MB/s
[    8.644482]     # benchmark_hash: len=16384: 899 MB/s
[    8.649773]     ok 14 benchmark_hash
[    8.655505]     ok 15 benchmark_sha256_finup_2x # SKIP not relevant
[    8.659065] # sha256: pass:14 fail:0 skip:1 total:15
[    8.665276] # Totals: pass:14 fail:0 skip:1 total:15
[    8.670195] ok 7 sha256

Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
---
 lib/crypto/x86/sha256.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 38e33b22a..5816b8928 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -31,6 +31,27 @@ DEFINE_X86_SHA256_FN(sha256_blocks_avx, sha256_transform_avx);
 DEFINE_X86_SHA256_FN(sha256_blocks_avx2, sha256_transform_rorx);
 DEFINE_X86_SHA256_FN(sha256_blocks_ni, sha256_ni_transform);
 
+#define PHE_ALIGNMENT 16
+static void sha256_blocks_phe(struct sha256_block_state *state,
+			     const u8 *data, size_t nblocks)
+{
+	/*
+	 * On Zhaoxin processors, XSHA256 requires the %rdi register
+	 * in 64-bit mode (or %edi in 32-bit mode) to point to
+	 * a 32-byte, 16-byte-aligned buffer.
+	 */
+	u8 buf[32 + PHE_ALIGNMENT - 1];
+	u8 *dst = PTR_ALIGN(&buf[0], PHE_ALIGNMENT);
+	size_t padding = -1;
+
+	memcpy(dst, state, SHA256_DIGEST_SIZE);
+	asm volatile(".byte 0xf3,0x0f,0xa6,0xd0" /* REP XSHA256 */
+		     : "+a"(padding), "+c"(nblocks), "+S"(data)
+		     : "D"(dst)
+		     : "memory");
+	memcpy(state, dst, SHA256_DIGEST_SIZE);
+}
+
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
@@ -79,6 +100,10 @@ static void sha256_mod_init_arch(void)
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
 		static_branch_enable(&have_sha_ni);
+	} else if (IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN) &&
+		   boot_cpu_has(X86_FEATURE_PHE_EN) &&
+		   boot_cpu_data.x86 >= 0x07) {
+		static_call_update(sha256_blocks_x86, sha256_blocks_phe);
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
 		   boot_cpu_has(X86_FEATURE_AVX)) {
-- 
2.34.1

