Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795799831;
	b=YyZ5VRQVspFKNgY84jaWdraPQizHckgw8HERYVMRM+yRrlo62mZZSYmnszk7JPBqeMRa
	 JfJBpBMg/+RGN57Ds7SeEOSF6g80cnoUhY2eK2SCi0t32Dca1Ex0QHTFnwwQpeLUcPDww
	 GDmnRXQWvVhI73764gpacM2B202+LT2T0BoEgDcoIGLm8Ro+JLfEL5Guq3CvgpYV+AGnT
	 sbVJOBgRvk7Yaow49yu9pDG+jwXBYPWKRinmwNALcy/mjutlJOOM3NZC8IbwJVC5EVrVA
	 XlC22k/DC3PTFLNAnoT0JJanJChnL/ThQzaG2gD5gWVsR4xzY6zepYR8x8hokJEmQ5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795799831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=//RLGBPw/5DOea89jBvZ06LICSU5al5omphSkXrmyf8=;
	b=4s9UY0qxq+Xi6Y5Zi3zJLbO6dcHrwrr2F7Z3Ueosk5EmCn6wJTfrafpmStK3l8P6VH1X
	 mELtsmrgzgV2AxqUr7IilFCaKqFek2rzwfN5EnLurLxfWn7/BRv6O8yvp6hZt2ShcGDtF
	 FGSq8HtMrzTfG3gQyMWbA3nmfXTAkmIVOGzd03iZInf0tFoF2wAtXG3bbopjCsHhr20fH
	 TrREqGW0H2cH9ixRuFccjqoFE1+MET1Gyt/JqjlmXKJZMoUUhVWVpsFzhNnNFfSEUcsHb
	 coFmBZYFd5BZb2MHfRXRlOQMOI8ftEj/hJwMTXyvZtZCUHEg+XZUyPsDR9hYYCJpXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=snap.com;
	spf=pass smtp.mailfrom=snapchat.com;
	dkim=pass header.d=snap.com header.i=@snap.com header.a=rsa-sha256 header.s=google header.b=bORpA5Tq;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68EB606A321
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 17:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C68EB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=snap.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snapchat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=snap.com header.i=@snap.com header.a=rsa-sha256 header.s=google header.b=bORpA5Tq
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so48863455e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 09:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snap.com; s=google; t=1795799829; x=1796404629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=//RLGBPw/5DOea89jBvZ06LICSU5al5omphSkXrmyf8=;
        b=bORpA5TqK+Bck+ESGLjU2tQDL0e4H1P5ltQV6deGTTBOENlO2UeYCw6kqoLY40kjhV
         E1goB4Yn7nAAdsDa6kKCwmTlMaqDklbfioPyohIgqddzP2ZIjKKJzW8f787VqCR6xub4
         xJc7Mlvi9TtMz+hKIYFM7nbawYcAqiDEPEejA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795799829; x=1796404629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=//RLGBPw/5DOea89jBvZ06LICSU5al5omphSkXrmyf8=;
        b=dhM3KRMHotpCchpVud2t6iV9u+t3DcqzFqKgnciyXtoMSUSpHNpd3RJnIoQhqxdErk
         beoTNE+2WR+Vgv0F7jJ4w/D+GQvagpqkDmPU6M+PmZHREYsYKH3j2WWodHMIEf5x4pMT
         6IE+DjGkVI9RjSXJSKj3n9S2OzRL9hrERUEXDIj3psojlDojbcCJ4FHwTdqpkXOddYZR
         r7Jk7IEIykFxb2ud/wGhXo+K6ZaWsjS0zi7JQcgf84qBW7QktvrBGNEuu6wgjThjYQO4
         nsy8moZSfD+5yjf/o4sK02Gf+/jL/tHVdqzQ061TUgL8180MrAjODmLnPq1O0b9HZEU1
         wPlw==
X-Gm-Message-State: APuU4Z8eUnbsuejuO+D9uvDovbjUj1X/RKtqYS+m5PUdv243BoD/obdT
	kXCEOVqcTSXiv2LeKIyk8jyKOV0sOeClslnJcW1uFunIzZsf11qBI+uipUF7ZnMu98w=
X-Gm-Gg: AZFdTZfyQ2ItHUOz3zu2KcCG/CD2pDc5PGUPgUdWh2N3d0yJn8LcfIH3xO2kGjhHQpE
	9ibg6MK7sJG2WHUx6U9WfeR7gNKmXK5XDftcDor61hba/uEHzU/qE+PaBKBvIRWsB+uYGeH2LL8
	75LCoHd0SFvDrPjCwoWm7wgFKEdTAm7uxVcbcuw0NLNf9nM71I40cYTCy+21pfBLDhu2Y1xwK8S
	urjiwz4HHDiURD6Mt1FcVxW8Ahz+UUjVKSiTf7o8SdjuIX5L6E/GFyc3pS7B5ay+a2suoxNUa32
	hSvxuLWqK/89ApWYuT7K3CYIXbIVsZON8T4ByaS1iSWx6Al0RCCMiXFlKHNDkJh3+RlUjxLMQV3
	7a7a9x4bAC36u37s4cA22JNvW/rSjwEnz7sVHLDldZInfXfS0w5Jwv2PJuWwv8tNHvxcUNDjd/R
	pVeDOZJ2efRfnqVzOJwuiH1pvFJKwWt7XdMdNoLhFmWCwP0SIe+KikpUT4dlVvaEuYIrMku1rHF
	XdrTCJ4hgtVIZbRLsZWI9NB5QIyWZm6g1K6kbXWn1vT/nW0QeIQ/lTNmbKWNboxbqzbUFd7JIb+
	EtuCRD14FxJ/1yNdL6FLbLzKQU03k1Jki5glq/ZDmhxrEwD751GLzxkwdHngaWLHAEqzBdyAVGO
	td4VE7KZxEGXxkJB2jSOn0o3+2VxCuGoa
X-Received: by 2002:a05:600c:a117:b0:4bb:a5e1:7497 with SMTP id 5b1f17b1804b1-4bba5e18d83mr150330775e9.32.1795799829040;
        Fri, 27 Nov 2026 09:17:09 -0800 (PST)
Received: from lj8k2dq3.sc-core.net ([85.237.126.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm608413135e9.2.2026.11.27.09.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 09:17:08 -0800 (PST)
From: ecordonnier@snap.com
To: ebiggers@kernel.org,
	Jason@zx2c4.com,
	ardb@kernel.org
Cc: linux-crypto@vger.kernel.org,
	Etienne Cordonnier <ecordonnier@snap.com>
Subject: [PATCH] lib/crypto: mpi: use a 128-bit multiply for umul_ppmm() on arm64
Date: Fri, 27 Nov 2026 18:16:32 +0100
Message-ID: <20261127171632.3024874-1-ecordonnier@snap.com>
X-Mailer: git-send-email 2.43.0
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

From: Etienne Cordonnier <ecordonnier@snap.com>

longlong.h has no arm64 entry, so umul_ppmm() falls back to the generic
C version, which builds each 64x64->128 product out of four 32x32
multiplications plus carry handling. umul_ppmm() is in the inner loops
of mpihelp_mul_1(), mpihelp_addmul_1(), mpihelp_submul_1() and the
division code, so this slows down every mpi_powm(), e.g. each RSA
signature verification (module signatures, X.509).

Use a u128 multiplication, which the compiler turns into a mul + umulh
pair, as the MIPS64 entry already does with a 128-bit type.

On a Cortex-A55 at 1.5 GHz, the time spent in mpi_powm() per RSA-4096
module signature verification (measured with kprobes on a 6.1 kernel
with this change backported) goes from 1286 us to 1201 us (-6.6%).
A userspace build of the same code shows the same direction at other
modulus sizes (2048/3072/4096 bits: 0.42/0.85/1.44 ms before,
0.35/0.70/1.19 ms after).

The crypto self-tests (CONFIG_CRYPTO_SELFTESTS_FULL) pass for
rsa-generic on arm64 in QEMU.

AI assistance: this patch and its changelog were written by Claude
Sonnet 5.5 (Anthropic), used through Claude Code, and reviewed by the
submitter.

Signed-off-by: Etienne Cordonnier <ecordonnier@snap.com>
---
 lib/crypto/mpi/longlong.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/crypto/mpi/longlong.h b/lib/crypto/mpi/longlong.h
index 6d31c3a729f1..877f19778df3 100644
--- a/lib/crypto/mpi/longlong.h
+++ b/lib/crypto/mpi/longlong.h
@@ -225,6 +225,20 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 #define UDIV_TIME 100
 #endif /* __arm__ */
 
+/***************************************
+	**************  ARM64  ****************
+	***************************************/
+#if defined(__aarch64__) && W_TYPE_SIZE == 64 && \
+	defined(CONFIG_ARCH_SUPPORTS_INT128)
+/* The compiler turns a u128 multiply into mul + umulh. */
+#define umul_ppmm(w1, w0, u, v)		\
+do {					\
+	u128 __ll = (u128)(u) * (v);	\
+	w1 = __ll >> 64;		\
+	w0 = __ll;			\
+} while (0)
+#endif /* __aarch64__ */
+
 /***************************************
 	**************  CLIPPER  **************
 	***************************************/
-- 
2.43.0

