Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657476;
	b=RbJecu8t+RBRy5AeMc5s+DwmsJI+as6dJyD90FX09Axgpd9RgPC+8dGmnbNroldZ0oJ2
	 Ekb0OeTeEPYhoTIpXEyR5GsKfJpaUohGhwMNd3rwuSXR28wKeyBkwMBQyKgxtTqsW59jr
	 0R0hvP6o5rb9KNFHT8DVmmBCsrCi7wtWP/+0Z/ppK3ysFGTKImfYH4zNk/9ReJ+Mr2qPD
	 MXeqico4so/I/NzGjzaelGZFHwP0+D4Kr8vTzys8vPad/mRvFPoI+S0SsZVHeB6J+YaQ4
	 m8SUy0KQMKqm/gesnvRmN1gdecapEQJBzU6plaIAsIjFNUJiF2ZEwhK8dQ516OP+fgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657476;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TBc3FAJWiEoUIU9L+YPFWNtaRtKrauEafmCqOuSZDio=;
	b=1DBGfTe8dyYf9K3jQ8lUkGJSGJuoxwBpNoWsaxQ/Ywv9grFCvhJ3yz/2LVMr2Z0g6lKo
	 JJ/6wHPMSpt30LifNIY2aBmWX1/mXqyNOsAadTaKvViMvh0RC2MTJTdCyFRzWpsSJ7wGG
	 oJaVPi7jkIibeAPae5aOUQhUorKPFZp6zvdfW3P1jjZ8NZBRJnHqBUpnFM/WDAeOCe7mh
	 7nB/dGm1x2a4OErr2qs/443wzPRkkL10vJk2hriVKBrtfS42SkjcSFReUVE8mc6ejPzgW
	 SXTQJsKKZGKdIqxOa1jc2IdmkR8xH+PgUzaiQxsETwqRB2/w+fBXHML78NA2VmYmJBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sZTh8j8t;
	arc=none smtp.remote-ip=74.125.82.170
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A2C606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 11:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61A2C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sZTh8j8t
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3835238eec.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 03:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794657475; x=1795262275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TBc3FAJWiEoUIU9L+YPFWNtaRtKrauEafmCqOuSZDio=;
        b=sZTh8j8t2qsr0POjskK9rv4f36J6KGFonk3SGZ9eG3HpY6QHjz1XfueYesojQtYQLl
         LJjbAtZ9wmPGsOqcwmNFdolbsWxSSk19cWnKgfU1px5PGp+uX1Yj13Oxb3Y/hix8+8vG
         hVLErqgLFROIX7X3biqa6z5+4xiqGMaTbC+tk5B69VSRuIVqmU8QCbKo3rShTr20EoUr
         yv1JW7N1asiL40WgtNiKfozH5xojJ83TO2OXXfCx3LGIdZ1zHLmOwMITScmlasGUmmXd
         3MuzmfkDjK3X8MlHMpW/puxbe5oGsbd1X9hik6AvzNHlcHk5RkhzKhZneqpFA0frdCpx
         WZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794657475; x=1795262275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBc3FAJWiEoUIU9L+YPFWNtaRtKrauEafmCqOuSZDio=;
        b=Y/AA7nj10UaZ/CgtErdnbAcFdslrEKbVnPlgpeYqGqR30GvXB8ckZxc3fLf88FxfuA
         WfLiXtxOxjuIH59lt9OXGm3fuMR9PtAqJ4uazRSxWqjGW6RbkusW8ttp+In9qlxNjAHH
         RIZICNeBq9wPXowoAYCQks37k/Lll7zlAISIsenj2/dCUE0hAeOpshrgk3OfT88U62q7
         JVXu/d62nEFgbPpVbE5HH0Mn8MveKo+ibTJAgKJKooj1fGENfXS90jATIgOyTgtj2pro
         Yglsj2NihfNTK39EkIsgJnijykW2wGz/FrfoM+4ApT7G1DOOPfIIAcROxGhaxst4i4sR
         NMlA==
X-Gm-Message-State: APuU4Z+LlDPY7c6gG9uo41sRFiFJylIbjyNkaONdQARCn5AvVJ5tUeRx
	BKaKIF2pSGpMTbln67ly1A2vqYLQ+hPJGsji8jnRD4t9G7M5OC3LBqEn
X-Gm-Gg: AYBFou3kOoIF7M0gYaytv9VryDYFNGu57vAPHIcMwgtXuBzMgKcOVKqZfGjwotAlZ6U
	3eSwctq390fyKzilWSnlQcD/HjrjH/zx/vHMsAaw7m/K54uY+i3Tp4fs7ke2CTfBHfOsrNzLdZG
	iJXg6TWo+KgMbyqLhrf7us98oVq5WZYkykFygccfV34Klo3EUhbC7KzuqWde2aZ94tpM82KCux6
	S9BRcE7/QDUjlA2f73psaNx1QNQbWWFcIGP3tIkchw6HMU8YTHuokC1nOgxf2SCZ9OxDyQr4ASr
	gd5TVes8PBzUFIbuXeLSxX9Swar5RPz+5OJAeKQggVJZ7Ev3RnoLuA0MHej/v5W/FBcckIkrxuz
	OyurtCxbaSSCpBe77/7ucu71jaNub+XoG0ZnaCP/CbPZEcM8MeeDttGE1ycCtqYLutR7pTRSBIk
	nq18c7JeN1ss/3iN1VSIpVsUOTI+A7ZmS/UBZ5234V+8REdUFSFjCpvNDy8iRVjU7V6fuPPqjtY
	2sVtcO3Lx9R8iOe339B8j7Ql8SuC2NxYizI/AyvyKgMluOfwRIYYFGc6CxTiF1K/Fplvv89teoA
	4H+xSJA9Y9fJBcICrmtyLukIh9Jf2A==
X-Received: by 2002:a05:693c:3e0a:b0:36b:d3dd:2e9d with SMTP id 5a478bee46e88-37966192e10mr4859293eec.19.1794657475379;
        Sat, 14 Nov 2026 03:57:55 -0800 (PST)
Received: from gentoo ([49.204.145.8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795378c2fesm16275945eec.1.2026.11.14.03.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:57:54 -0800 (PST)
From: Shreesh Adiga <16567adigashreesh@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme implementation
Date: Sat, 14 Nov 2026 17:27:45 +0530
Message-ID: <20261114115749.1061233-1-16567adigashreesh@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a 4x-folding implementation for CPUs with FEAT_SHA3 which benefits
newer ARMv9 CPUs like Cortex-X925.
Usage of EOR3 from SHA3 extension improves performance by 20% compared
to the regular PMULL without EOR3 on Cortex-X925 measure in userspace
application via libbenchmark for 512 byte input size.
Measured about 3x speedup for 512 byte input compared with the existing
NEON single fold implementation on Cortex-X925 in userspace.

Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
---
 lib/crc/arm64/crc64.h |  6 +++-
 lib/crc/crc64-neon.c  | 79 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/lib/crc/arm64/crc64.h b/lib/crc/arm64/crc64.h
index c7a69e1f3d8f..003fd452aca3 100644
--- a/lib/crc/arm64/crc64.h
+++ b/lib/crc/arm64/crc64.h
@@ -9,6 +9,7 @@
 #include <linux/sizes.h>
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
 
 #define crc64_be_arch crc64_be_generic
 
@@ -19,7 +20,10 @@ static inline u64 crc64_nvme_arch(u64 crc, const u8 *p, size_t len)
 		size_t chunk = len & ~15;
 
 		scoped_ksimd()
-			crc = crc64_nvme_neon(crc, p, chunk);
+			if (cpu_have_named_feature(SHA3))
+				crc = crc64_nvme_neon_pmull_eor3(crc, p, chunk);
+			else
+				crc = crc64_nvme_neon(crc, p, chunk);
 
 		p += chunk;
 		len &= 15;
diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
index 4753fb94a4be..6c589b23ed06 100644
--- a/lib/crc/crc64-neon.c
+++ b/lib/crc/crc64-neon.c
@@ -10,6 +10,14 @@
 
 u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
 
+#ifdef CONFIG_ARM64
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len);
+
+/* x^575 mod G, x^511 mod G */
+static const u64 fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
+					   0x62242240ace5045aULL };
+#endif
+
 /* x^191 mod G, x^127 mod G */
 static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 					0x21e9761e252621acULL };
@@ -45,3 +53,74 @@ u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len)
 
 	return vgetq_lane_u64(v0, 1);
 }
+
+#ifdef CONFIG_ARM64
+#define SHA3_TARGET __attribute__((target("arch=armv8.2-a+crypto+sha3")))
+
+SHA3_TARGET
+static inline uint64x2_t fold_single_round(uint64x2_t fold,
+					   uint64x2_t temp,
+					   uint64x2_t consts)
+{
+	uint64x2_t temp1 = pmull64(consts, fold);
+	uint64x2_t temp2 = pmull64_high(consts, fold);
+
+	return veor3q_u64(temp, temp1, temp2);
+}
+
+SHA3_TARGET
+u64 crc64_nvme_neon_pmull_eor3(u64 crc, const u8 *p, size_t len)
+{
+	/* Assumes len >= 64. */
+	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
+	uint64x2_t fold_consts_4x = vld1q_u64(fold_consts_4x_val);
+	uint64x2_t v0 = { crc, 0 };
+	uint64x2_t zero = { };
+	uint64x2_t v1, v2, v3;
+
+	v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
+	v1  = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+	v2  = vreinterpretq_u64_u8(vld1q_u8(p + 32));
+	v3  = vreinterpretq_u64_u8(vld1q_u8(p + 48));
+
+	p += 64;
+	len -= 64;
+	while (len >= 64) {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p +  0));
+		uint64x2_t t1 = vreinterpretq_u64_u8(vld1q_u8(p + 16));
+		uint64x2_t t2 = vreinterpretq_u64_u8(vld1q_u8(p + 32));
+		uint64x2_t t3 = vreinterpretq_u64_u8(vld1q_u8(p + 48));
+
+		v0 = fold_single_round(v0, t0, fold_consts_4x);
+		v1 = fold_single_round(v1, t1, fold_consts_4x);
+		v2 = fold_single_round(v2, t2, fold_consts_4x);
+		v3 = fold_single_round(v3, t3, fold_consts_4x);
+		p += 64;
+		len -= 64;
+	}
+
+	v0 = fold_single_round(v0, v1, fold_consts);
+	v0 = fold_single_round(v0, v2, fold_consts);
+	v0 = fold_single_round(v0, v3, fold_consts);
+
+	while (len >= 16) {
+		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
+
+		v0 = fold_single_round(v0, t0, fold_consts);
+		p += 16;
+		len -= 16;
+	}
+
+	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
+	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
+
+	/* Final Barrett reduction */
+	uint64x2_t bconsts = vld1q_u64(bconsts_val);
+	uint64x2_t final = pmull64(bconsts, v0);
+
+	v0 = veor3q_u64(v0, vextq_u64(zero, final, 1),
+			pmull64_hi_lo(bconsts, final));
+
+	return vgetq_lane_u64(v0, 1);
+}
+#endif
-- 
2.56.1

