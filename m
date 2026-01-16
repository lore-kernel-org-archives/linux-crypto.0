Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E20F30AD13
	for <linux-crypto@vger.kernel.org>; Fri, 16 Jan 2026 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768547930; cv=none; b=S7y/Jt22yV/1dU5G5gE0uzCUrmD+hdujpF7mkM50Qo+Vna9X7TquTMxT+9WdyDHQY3oV/pZ2RROaqwfijZXQ8q7oGoOI6BXY6KqVBUfjRVqBWIEoe3FXtB3Ir0tvpdVi+nuscU2nF/Axzaf0bRLMx9FongDxYSOXWdvOEIX9ymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768547930; c=relaxed/simple;
	bh=zpMjvvLJ7dls+Bl/nwUOdIQyIXVvMfpL6hgos2ZRr0k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlBYSqFbPzpQz5T9ygDvlkaGaUYFxDqd8GxL/IdlVh2XcREYtktolGbMtcf/ZIN5u63Lbw2/hGbqEv8Adrhtz+zqx0E9nqxIhMX5CYfHPSidm3pesSRuOQjRtpStA8wkjLp5f7NhTK+ob8nzF5fbqMqkVNZHyOEMlKU70wFBzLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1768547908-086e2306f621770001-Xm9f1P
Received: from ZXSHMBX3.zhaoxin.com (ZXSHMBX3.zhaoxin.com [10.28.252.165]) by mx1.zhaoxin.com with ESMTP id bFvG41esLxIymw6P (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Fri, 16 Jan 2026 15:18:28 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from ZXSHMBX1.zhaoxin.com (10.28.252.163) by ZXSHMBX3.zhaoxin.com
 (10.28.252.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.59; Fri, 16 Jan
 2026 15:18:28 +0800
Received: from ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85]) by
 ZXSHMBX1.zhaoxin.com ([fe80::936:f2f9:9efa:3c85%7]) with mapi id
 15.01.2507.059; Fri, 16 Jan 2026 15:18:28 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.165
Received: from DESKTOP-A4I8D8T.zhaoxin.com (10.32.65.156) by
 ZXBJMBX02.zhaoxin.com (10.29.252.6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.59; Fri, 16 Jan 2026 15:17:00 +0800
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <Jason@zx2c4.com>, <ardb@kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>
CC: <CobeChen@zhaoxin.com>, <TonyWWang-oc@zhaoxin.com>, <YunShen@zhaoxin.com>,
	<GeorgeXue@zhaoxin.com>, <LeoLiu-oc@zhaoxin.com>, <HansHu@zhaoxin.com>,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>
Subject: [PATCH v3 3/3] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Date: Fri, 16 Jan 2026 15:15:13 +0800
X-ASG-Orig-Subj: [PATCH v3 3/3] lib/crypto: x86/sha256: PHE Extensions optimized SHA256 transform function
Message-ID: <20260116071513.12134-4-AlanSong-oc@zhaoxin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
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
X-Moderation-Data: 1/16/2026 3:18:27 PM
X-Barracuda-Connect: ZXSHMBX3.zhaoxin.com[10.28.252.165]
X-Barracuda-Start-Time: 1768547908
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://mx2.zhaoxin.com:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2262
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.153109
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
 lib/crypto/x86/sha256.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/crypto/x86/sha256.h b/lib/crypto/x86/sha256.h
index 38e33b22a..70b68bad0 100644
--- a/lib/crypto/x86/sha256.h
+++ b/lib/crypto/x86/sha256.h
@@ -31,6 +31,26 @@ DEFINE_X86_SHA256_FN(sha256_blocks_avx, sha256_transform=
_avx);
 DEFINE_X86_SHA256_FN(sha256_blocks_avx2, sha256_transform_rorx);
 DEFINE_X86_SHA256_FN(sha256_blocks_ni, sha256_ni_transform);
=20
+#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
+#define PHE_ALIGNMENT 16
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
+	memcpy(dst, state, SHA256_DIGEST_SIZE);
+	asm volatile(".byte 0xf3,0x0f,0xa6,0xd0"
+			: "+S"(data), "+D"(dst)
+			: "a"((long)-1), "c"(nblocks));
+	memcpy(state, dst, SHA256_DIGEST_SIZE);
+}
+#endif /* CONFIG_CPU_SUP_ZHAOXIN */
+
 static void sha256_blocks(struct sha256_block_state *state,
 			  const u8 *data, size_t nblocks)
 {
@@ -79,6 +99,11 @@ static void sha256_mod_init_arch(void)
 	if (boot_cpu_has(X86_FEATURE_SHA_NI)) {
 		static_call_update(sha256_blocks_x86, sha256_blocks_ni);
 		static_branch_enable(&have_sha_ni);
+#if IS_ENABLED(CONFIG_CPU_SUP_ZHAOXIN)
+	} else if (boot_cpu_has(X86_FEATURE_PHE_EN)) {
+		if (boot_cpu_data.x86 >=3D 0x07)
+			static_call_update(sha256_blocks_x86, sha256_blocks_phe);
+#endif
 	} else if (cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM,
 				     NULL) &&
 		   boot_cpu_has(X86_FEATURE_AVX)) {
--=20
2.34.1

