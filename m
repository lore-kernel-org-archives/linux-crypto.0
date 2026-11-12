Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794488081;
	b=GDa5xN+Y+im2BqJFw4KedjGx51fGIGYdMqIpGlA9ck0KvNcLLHu06QtKqqc8nLUHOZmP
	 YVW+6n+iQRzekjnYM5l/CimvYDpp2ueg2N/8TSpxbsBjq6iNdnkaN1Vi72p55RwKeh+UJ
	 DIXVAGJkySnUDyISa09hmka+hrkpVhDgQCUki0XhXCVta/nrrS0ifwTrOe2l5iWdltqFA
	 PnXQvqTu/CXya6+cWe0BkqYAO1fstbRjgjVcaJAJGdpBbuGyAYTBPRpewIHQepGPqqMbd
	 xtcIMCAqVxU387ghk80kzWzTu3SCFrVDqIswh4mVPaiRESk2GN/JyaexuO9OZIE5BAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794488081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hzlxXvnC/+YdOqjz3c1czoZaHe3EM9JRnCB94dj8Gmc=;
	b=0TsAlEVVDFcsS+srdZYw04NxLduKHyHSC0s8lnGHxyKy2BKsAlKNvvKf44C7pVfgrjsP
	 Lo3hrGecnA8lSMB7vce4jh7Fpu6tfeBtcMpOX+H9zAsryVNOyb5ulra9ggiJmZyzAVM90
	 7ReXoWgVQdDl+k2n7Nb+mg6xn+w0rLZRgCBxbxtg+gaw2yPeHRNYFyku2Sn7XtBvD1PLk
	 7TufcVP2m3f4VNIuoaS0Agjsf1x+kIonuZHE5AGxWY9TAwTVgqJwGr95/NlbsYf77bDWJ
	 8H5fwuZIyneIE31ykMkukHec2L0BWHidDXNSEAKGOq9KyNZ0TfoFjjORypvrgrViDQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=openvpn.net;
	spf=pass smtp.mailfrom=openvpn.com;
	dkim=pass header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=U+EoLLG3;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971D606A332
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 12:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1971D606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.a=rsa-sha256 header.s=google header.b=U+EoLLG3
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e10a70540so2566943f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 04:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1794488079; x=1795092879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzlxXvnC/+YdOqjz3c1czoZaHe3EM9JRnCB94dj8Gmc=;
        b=U+EoLLG3OTjdBrWxKD5k+XOSW96yP9lCNyb39cl7tgCjqVfocPv0+JJWB0JUVbdQP9
         QwNWi8KKIetB830UjJK68TzxsNVqbnUHV1WBcwZxI0sA03UBrGjz3FioxjyMxh5CF4fk
         tQMG/Kto3ZCEttoE7OyloE38iGE86ycGj5CKioQNkctyBbwRaTDOlvJnTJXEx/8jht7N
         DIGUNDwH+V8IqmWupX84XC+QK0wkyYTEfwRKjGY0YVVua5QvrJaqja0lIPsQ5o/RLCE3
         uUDqX5h8pM257NNXPjnyiFrcuMEg2lUg+qeoZi/COJwbv4okYIHPoGqV9gwVHaieDLaG
         t8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794488079; x=1795092879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hzlxXvnC/+YdOqjz3c1czoZaHe3EM9JRnCB94dj8Gmc=;
        b=SgTaPfXIa6vZ5rkHeNRzFip+BTPVYTaxzcy3/1XYgrNW82ECSbpckEe8iPjFgEU+eg
         mcywkMOpaeL3hQ0buWpCKwfMSrZqzkagnaUCWJX1QBjHNeSGIz7LKubca/DkhmJaxa7C
         yyM9i3jDVmFvBbo7IeL3EtngQC7RzEczHR7QvkCeRBP1J7uwIkmmk0XhN+btsdskqytT
         Q63WtnO6RPHoen0r7dxEwkxVmF0ETSHC5ldXRhSoAtAavsPtLFMIiOuuYXmrDDlVSCjx
         vWprhaE6JAdBWOGktig1d33Y66YLjhUHiYjYgDXPINr7vKqZopYEbRG1zR/s220btNCT
         a9yQ==
X-Gm-Message-State: APuU4Z/0fIRJJxESW/yYMMuCR3z6gVr+ndIb5Zb+uPRrSjr4mj1Nkf/D
	f2mEZINVUGfo5Vf/k5bmFjaekxs0voVT6PeDDqTUZ9WSPFfiibvuIj///2HmOxC5nkFGMc2gXx/
	Gp+3z81OQG2d2VJfJZ4Vu5pZwXVdc6QD/LD8IC6fUt7z3PbVRRoHD69GBfa7/zoV8Yr/i7v0t
X-Gm-Gg: AYBFou0JJ7H0XrkjzzLreSIuXgkQe2FoZhNRLgystjP8OxzT2YdHx9ijqE9Xwzoh1ye
	Swxzd2UCgx0tyvgUVAw6TJ6JWfleZH3ThndAuaFcnD5TU4+xxUxvdXdz6U0sEG1WVefrpGcNmXl
	ZFEfITxWK6+AnxY9JcfKMrCgPdEsWNFZwXs1R+WcckU8EDfPBFZ4bwcDx4NhMAwV2XqJKVbZeSI
	3hHGP9lHoD6VaDWzoCC+NOgnYM5kofDqYVajescljuCNzIRTmDX/VmglAs1SuPpNUMxCM9wV7+T
	Y0U2dKiM5ro28AeFo5uWDOI9lANiyKX/L67EOQeqCV+mdxcwLUYs9xhO07jozteTfToT3YimM61
	f8QD48+Q59o2JAzfg4FgHFpPUBjka0alifQlLzsWYebmAfEIJFe8rL/En3JeHy0X1/HKztbIZJx
	Hk5oGJJKwmpDlfbWGL5nwP22wb0mzc5NcaudKKVTJJx3OFsSmEJ4UabTbu7jVTQ75WK+8nD1Nuu
	VykGjYeXwMHK7wjWZ1oSS5r35TAig1ifiMO6pBT22Sbi0PxcL3ZuOMpPJSIOAEfEBrfpJ9KNV1Q
	Fkdts0IYqIlaoCGCnNX0vvfhIZTbSgrgJVA2I76LArWuhnMEs6V9BaVAHYEDCLH6sGrjoE4ePA=
	=
X-Received: by 2002:a05:6000:4699:b0:49c:192f:cf19 with SMTP id ffacd0b85a97d-49c192fd095mr468043f8f.39.1794488079292;
        Thu, 12 Nov 2026 04:54:39 -0800 (PST)
Received: from inifinity.homelan.mandelbit.com ([2001:67c:2fbc:1:56b9:769a:f836:6390])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49835858f26sm17202726f8f.18.2026.11.12.04.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:54:38 -0800 (PST)
From: Antonio Quartulli <antonio@openvpn.net>
To: linux-crypto@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [RFC PATCH 4/5] lib/crypto: x86/aegis128x4: Add VAES-AVX512 optimized code
Date: Thu, 12 Nov 2026 13:54:29 +0100
Message-ID: <20261112125432.3064939-5-antonio@openvpn.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112125432.3064939-1-antonio@openvpn.net>
References: <20261112125432.3064939-1-antonio@openvpn.net>
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

From: Antonio Quartulli <antonio@mandelbit.com>

Add an x86_64 implementation of AEGIS-128X4 using VAES and AVX-512,
ported to assembly from the libaegis AVX-512 code by Frank Denis, which
uses C intrinsics and is MIT licensed, so the file is dual-licensed
GPL-2.0-only OR MIT.  Each state word is a zmm register holding the
corresponding block of the four AEGIS-128L instances, so that the update
function takes eight VAESENC instructions.

Messages of up to 4 KiB are processed by one call that keeps the state
in registers.  Longer messages and the incremental API go through the
per-block functions, in kernel-mode FPU sections of at most 4 KiB.

There is no 256-bit code yet, so unlike AES-GCM this code is used on
CPUs with X86_FEATURE_PREFER_YMM too.

Encryption throughput from the KUnit benchmark on a Ryzen 9 9950X,
in MB/s:

  data_len   generic   VAES-AVX512
        16        10           581
        64        41          2351
       256       159          8986
      1420       576         34521
      4096       987         46761
     16384      1308         79588

Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
 lib/crypto/Kconfig                      |   5 +
 lib/crypto/Makefile                     |   4 +
 lib/crypto/x86/aegis128x4-vaes-avx512.S | 470 ++++++++++++++++++++++++
 lib/crypto/x86/aegis128x4.h             | 167 +++++++++
 4 files changed, 646 insertions(+)
 create mode 100644 lib/crypto/x86/aegis128x4-vaes-avx512.S
 create mode 100644 lib/crypto/x86/aegis128x4.h

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 3e53dd570b78..195c047843ac 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -15,6 +15,11 @@ config CRYPTO_LIB_AEGIS128X4
 	  Select this if your module uses any of the functions from
 	  <crypto/aegis128x4.h>.
 
+config CRYPTO_LIB_AEGIS128X4_ARCH
+	bool
+	depends on CRYPTO_LIB_AEGIS128X4 && !UML && !KMSAN
+	default y if X86_64
+
 config CRYPTO_LIB_AES
 	tristate
 	# Select dependencies of modes that are part of libaes.
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index be43ab974c0f..cbb8b9c93de8 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -23,6 +23,10 @@ libcryptoutils-y				:= memneq.o utils.o
 
 obj-$(CONFIG_CRYPTO_LIB_AEGIS128X4) += libaegis128x4.o
 libaegis128x4-y := aegis128x4.o
+ifeq ($(CONFIG_CRYPTO_LIB_AEGIS128X4_ARCH),y)
+CFLAGS_aegis128x4.o += -I$(src)/$(SRCARCH)
+libaegis128x4-$(CONFIG_X86) += x86/aegis128x4-vaes-avx512.o
+endif
 
 ################################################################################
 
diff --git a/lib/crypto/x86/aegis128x4-vaes-avx512.S b/lib/crypto/x86/aegis128x4-vaes-avx512.S
new file mode 100644
index 000000000000..080f83a14ca9
--- /dev/null
+++ b/lib/crypto/x86/aegis128x4-vaes-avx512.S
@@ -0,0 +1,470 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MIT */
+/*
+ * VAES + AVX512 implementation of AEGIS-128X4
+ *
+ * AEGIS-128X4 is the 4-way parallel variant of AEGIS-128L defined in
+ * RFC 10032.  Each of the eight state words is a 512-bit
+ * vector holding the corresponding word of four independent AEGIS-128L
+ * states, one per 128-bit lane, so that every AES round in the update function
+ * is computed with a single VAESENC on a zmm register.
+ *
+ * Ported to assembly from the libaegis AVX-512 implementation, which uses C
+ * intrinsics (https://github.com/aegis-aead/libaegis).  See RFC 10032 for the
+ * algorithm.
+ *
+ * Copyright (c) 2023-2026 Frank Denis
+ * Copyright (c) 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+
+#include <linux/linkage.h>
+
+#define STATE0		%zmm0
+#define STATE1		%zmm1
+#define STATE2		%zmm2
+#define STATE3		%zmm3
+#define STATE4		%zmm4
+#define STATE5		%zmm5
+#define STATE6		%zmm6
+#define STATE7		%zmm7
+#define MSG0		%zmm8
+#define MSG1		%zmm9
+#define T0		%zmm10
+#define T1		%zmm11
+#define T2		%zmm12
+#define T3		%zmm13
+#define ZERO		%zmm15
+#define ZERO_XMM	%xmm15
+
+/* Size of the AEGIS-128X4 rate, i.e. of the data absorbed by one update */
+#define RATE		128
+
+.section .rodata.cst32.aegis128x4_const, "aM", @progbits, 32
+.align 16
+.Laegis128x4_const_0:
+	.byte 0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d
+	.byte 0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62
+.Laegis128x4_const_1:
+	.byte 0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1
+	.byte 0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd
+
+/*
+ * Per-lane context injected during initialization: byte 0 is the lane index,
+ * byte 1 is the number of lanes minus one.
+ */
+.section .rodata.cst64.aegis128x4_ctx, "aM", @progbits, 64
+.align 64
+.Laegis128x4_ctx:
+	.octa 0x0300
+	.octa 0x0301
+	.octa 0x0302
+	.octa 0x0303
+
+.text
+
+/*
+ * aegis128x4_update
+ * input:
+ *   STATE[0-7] - input state
+ *   m0, m1     - message vectors (128 bytes in total)
+ *   ZERO       - all-zeroes vector
+ * output:
+ *   STATE[0-7] - output state (same positions)
+ * changed:
+ *   T0, T1
+ *
+ * AESENC(x, k) == AESENC(x, 0) ^ k, therefore the two words that absorb the
+ * message are computed as AESENC(x, 0) ^ S ^ M with a single VPTERNLOGQ, which
+ * also allows updating every state word in place.
+ */
+.macro aegis128x4_update m0, m1
+	vaesenc		ZERO, STATE7, T0
+	vaesenc		ZERO, STATE3, T1
+	vaesenc		STATE7, STATE6, STATE7
+	vaesenc		STATE6, STATE5, STATE6
+	vaesenc		STATE5, STATE4, STATE5
+	vpternlogq	$0x96, \m1, T1, STATE4
+	vaesenc		STATE3, STATE2, STATE3
+	vaesenc		STATE2, STATE1, STATE2
+	vaesenc		STATE1, STATE0, STATE1
+	vpternlogq	$0x96, \m0, T0, STATE0
+.endm
+
+/*
+ * Initialize STATE[0-7] from the key at KEYP and the nonce at IVP, and set
+ * ZERO.  Changed: MSG0, MSG1, T0-T2.
+ */
+.macro aegis128x4_init
+	vpxor		ZERO_XMM, ZERO_XMM, ZERO_XMM
+
+	/* broadcast nonce and key to the four lanes: */
+	vbroadcasti32x4	(IVP), MSG0
+	vbroadcasti32x4	(KEYP), MSG1
+
+	/* load the constants: */
+	vbroadcasti32x4	.Laegis128x4_const_0(%rip), STATE2
+	vbroadcasti32x4	.Laegis128x4_const_1(%rip), STATE1
+	vmovdqa64	.Laegis128x4_ctx(%rip), T2
+
+	vpxorq		MSG0, MSG1, STATE0	/* key ^ nonce */
+	vmovdqa64	STATE0, STATE4		/* key ^ nonce */
+	vmovdqa64	STATE1, STATE3		/* c1 */
+	vpxorq		STATE2, MSG1, STATE5	/* key ^ c0 */
+	vpxorq		STATE1, MSG1, STATE6	/* key ^ c1 */
+	vmovdqa64	STATE5, STATE7		/* key ^ c0 */
+
+	/* update 10 times with nonce / key: */
+	.rept 10
+	vpxorq		T2, STATE3, STATE3
+	vpxorq		T2, STATE7, STATE7
+	aegis128x4_update MSG0, MSG1
+	.endr
+.endm
+
+/*
+ * Encrypt (\enc=1) or decrypt (\enc=0) the 128 bytes in MSG0/MSG1 in place
+ * using the keystream of the current state:
+ *   z0 = S1 ^ S6 ^ (S2 & S3)
+ *   z1 = S2 ^ S5 ^ (S6 & S7)
+ * On encryption the result goes to T2/T3 and MSG0/MSG1 keep the plaintext.
+ * On decryption MSG0/MSG1 are replaced by the plaintext.
+ */
+.macro crypt_msg enc
+.if \enc
+	vmovdqa64	STATE2, T2
+	vmovdqa64	STATE6, T3
+	vpternlogq	$0x6a, MSG0, STATE3, T2		/* (A & B) ^ C */
+	vpternlogq	$0x6a, MSG1, STATE7, T3
+	vpternlogq	$0x96, STATE6, STATE1, T2
+	vpternlogq	$0x96, STATE5, STATE2, T3
+.else
+	vpternlogq	$0x78, STATE3, STATE2, MSG0	/* A ^ (B & C) */
+	vpternlogq	$0x78, STATE7, STATE6, MSG1
+	vpternlogq	$0x96, STATE6, STATE1, MSG0
+	vpternlogq	$0x96, STATE5, STATE2, MSG1
+.endif
+.endm
+
+/*
+ * Encrypt or decrypt the 128-byte block at SRC into DST and absorb the
+ * plaintext.  Changed: MSG0, MSG1, T0-T3.
+ */
+.macro crypt_block enc
+	vmovdqu64	0x00(SRC), MSG0
+	vmovdqu64	0x40(SRC), MSG1
+	crypt_msg	\enc
+.if \enc
+	vmovdqu64	T2, 0x00(DST)
+	vmovdqu64	T3, 0x40(DST)
+.else
+	vmovdqu64	MSG0, 0x00(DST)
+	vmovdqu64	MSG1, 0x40(DST)
+.endif
+	aegis128x4_update MSG0, MSG1
+.endm
+
+/*
+ * Encrypt or decrypt the partial block at SRC into DST and absorb the
+ * zero-padded plaintext.  %k1 and %k2 must hold the masks set up by
+ * tail_masks.  Changed: MSG0, MSG1, T0-T3.
+ */
+.macro crypt_tail enc
+	/* masked loads zero the padding and never fault past the end */
+	vmovdqu8	0x00(SRC), MSG0{%k1}{z}
+	vmovdqu8	0x40(SRC), MSG1{%k2}{z}
+	crypt_msg	\enc
+.if \enc
+	vmovdqu8	T2, 0x00(DST){%k1}
+	vmovdqu8	T3, 0x40(DST){%k2}
+.else
+	vmovdqu8	MSG0, 0x00(DST){%k1}
+	vmovdqu8	MSG1, 0x40(DST){%k2}
+	/* zero the keystream bytes past the end before absorbing: */
+	vmovdqu8	MSG0, MSG0{%k1}{z}
+	vmovdqu8	MSG1, MSG1{%k2}{z}
+.endif
+	aegis128x4_update MSG0, MSG1
+.endm
+
+/*
+ * Encrypt or decrypt LEN bytes (nonzero multiple of RATE) from SRC to DST,
+ * advancing SRC and DST.  LEN is zero on exit.
+ */
+.macro crypt_loop enc
+.Lcrypt\@:
+	crypt_block	\enc
+	add		$RATE, SRC
+	add		$RATE, DST
+	sub		$RATE, LEN
+	jnz		.Lcrypt\@
+.endm
+
+/* Absorb the 128-byte block at \src. */
+.macro ad_block src
+	vmovdqu64	0x00(\src), MSG0
+	vmovdqu64	0x40(\src), MSG1
+	aegis128x4_update MSG0, MSG1
+.endm
+
+.macro load_state
+	vmovdqu64	0x000(STATEP), STATE0
+	vmovdqu64	0x040(STATEP), STATE1
+	vmovdqu64	0x080(STATEP), STATE2
+	vmovdqu64	0x0c0(STATEP), STATE3
+	vmovdqu64	0x100(STATEP), STATE4
+	vmovdqu64	0x140(STATEP), STATE5
+	vmovdqu64	0x180(STATEP), STATE6
+	vmovdqu64	0x1c0(STATEP), STATE7
+.endm
+
+.macro store_state
+	vmovdqu64	STATE0, 0x000(STATEP)
+	vmovdqu64	STATE1, 0x040(STATEP)
+	vmovdqu64	STATE2, 0x080(STATEP)
+	vmovdqu64	STATE3, 0x0c0(STATEP)
+	vmovdqu64	STATE4, 0x100(STATEP)
+	vmovdqu64	STATE5, 0x140(STATEP)
+	vmovdqu64	STATE6, 0x180(STATEP)
+	vmovdqu64	STATE7, 0x1c0(STATEP)
+.endm
+
+/*
+ * Set %k1 and %k2 to the byte masks covering the first \len bytes of a
+ * 128-byte block, split into its two 64-byte halves.  1 <= \len <= 127.
+ * \len is a 32-bit register and \len64 its 64-bit alias; both are clobbered,
+ * as well as %rax and %r11.
+ */
+.macro tail_masks len, len64
+	mov		$-1, %rax
+	bzhi		\len64, %rax, %r11	/* bzhi only uses bits [7:0] */
+	kmovq		%r11, %k1
+	xor		%r11d, %r11d
+	sub		$64, \len
+	cmovl		%r11d, \len
+	bzhi		\len64, %rax, %rax
+	kmovq		%rax, %k2
+.endm
+
+/*
+ * XOR the four 128-bit lanes of the zmm register \z together into the xmm
+ * register \x (the low part of \z).  \y is the ymm alias of \z.
+ */
+.macro fold_lanes z, y, x, tmpy, tmpx
+	vextracti64x4	$1, \z, \tmpy
+	vpxor		\tmpy, \y, \y
+	vextracti128	$1, \y, \tmpx
+	vpxor		\tmpx, \x, \x
+.endm
+
+/*
+ * Finalize and store the AUTHSIZE-byte (16 or 32) tag at TAG, then return.
+ * ASSOCLEN and CRYPTLEN are 64-bit registers.  Changed: %rax, %r9, MSG0 and
+ * all the state.
+ */
+.macro aegis128x4_final_and_ret
+	/* t = S2 ^ (LE64(assoclen * 8) || LE64(cryptlen * 8)) in each lane */
+	mov		ASSOCLEN, %rax
+	shl		$3, %rax
+	mov		CRYPTLEN, %r9
+	shl		$3, %r9
+	vmovq		%rax, %xmm8
+	vpinsrq		$1, %r9, %xmm8, %xmm8
+	vshufi64x2	$0, MSG0, MSG0, MSG0
+	vpxorq		STATE2, MSG0, MSG0
+
+	.rept 7
+	aegis128x4_update MSG0, MSG0
+	.endr
+
+	cmp		$16, AUTHSIZE
+	jne		.Lfinal_256\@
+
+	/* tag = fold(S0 ^ S1 ^ S2 ^ S3 ^ S4 ^ S5 ^ S6) */
+	vpternlogq	$0x96, STATE2, STATE1, STATE0
+	vpternlogq	$0x96, STATE4, STATE3, STATE0
+	vpternlogq	$0x96, STATE6, STATE5, STATE0
+	fold_lanes	STATE0, %ymm0, %xmm0, %ymm10, %xmm10
+	vmovdqu		%xmm0, 0x00(TAG)
+	vzeroupper	// This is needed after using ymm or zmm registers.
+	RET
+
+.Lfinal_256\@:
+	/* tag = fold(S0 ^ S1 ^ S2 ^ S3) || fold(S4 ^ S5 ^ S6 ^ S7) */
+	vpternlogq	$0x96, STATE2, STATE1, STATE0
+	vpxorq		STATE3, STATE0, STATE0
+	vpternlogq	$0x96, STATE6, STATE5, STATE4
+	vpxorq		STATE7, STATE4, STATE4
+	fold_lanes	STATE0, %ymm0, %xmm0, %ymm10, %xmm10
+	fold_lanes	STATE4, %ymm4, %xmm4, %ymm11, %xmm11
+	vmovdqu		%xmm0, 0x00(TAG)
+	vmovdqu		%xmm4, 0x10(TAG)
+	vzeroupper	// This is needed after using ymm or zmm registers.
+	RET
+.endm
+
+/*
+ * void aegis128x4_init_vaes_avx512(union aegis128x4_state *state,
+ *				    const u8 key[AEGIS128X4_KEY_SIZE],
+ *				    const u8 nonce[AEGIS128X4_NONCE_SIZE]);
+ */
+SYM_FUNC_START(aegis128x4_init_vaes_avx512)
+	.set STATEP, %rdi
+	.set KEYP, %rsi
+	.set IVP, %rdx
+
+	aegis128x4_init
+	store_state
+	vzeroupper	// This is needed after using ymm or zmm registers.
+	RET
+SYM_FUNC_END(aegis128x4_init_vaes_avx512)
+
+/*
+ * void aegis128x4_absorb_vaes_avx512(union aegis128x4_state *state,
+ *				      const u8 *src, size_t len);
+ *
+ * len must be a multiple of 128.
+ */
+SYM_FUNC_START(aegis128x4_absorb_vaes_avx512)
+	.set STATEP, %rdi
+	.set SRC, %rsi
+	.set LEN, %rdx
+
+	test		LEN, LEN
+	jz		.Lad_out
+
+	vpxor		ZERO_XMM, ZERO_XMM, ZERO_XMM
+	load_state
+.Lad_loop:
+	ad_block	SRC
+	add		$RATE, SRC
+	sub		$RATE, LEN
+	jnz		.Lad_loop
+
+	store_state
+	vzeroupper	// This is needed after using ymm or zmm registers.
+.Lad_out:
+	RET
+SYM_FUNC_END(aegis128x4_absorb_vaes_avx512)
+
+/*
+ * void aegis128x4_enc_vaes_avx512(union aegis128x4_state *state,
+ *				   u8 *dst, const u8 *src, size_t len);
+ * void aegis128x4_dec_vaes_avx512(union aegis128x4_state *state,
+ *				   u8 *dst, const u8 *src, size_t len);
+ *
+ * len must be nonzero and a multiple of 128.
+ */
+.macro aegis128x4_crypt enc
+	.set STATEP, %rdi
+	.set DST, %rsi
+	.set SRC, %rdx
+	.set LEN, %rcx
+
+	vpxor		ZERO_XMM, ZERO_XMM, ZERO_XMM
+	load_state
+	crypt_loop	\enc
+	store_state
+	vzeroupper	// This is needed after using ymm or zmm registers.
+	RET
+.endm
+
+SYM_FUNC_START(aegis128x4_enc_vaes_avx512)
+	aegis128x4_crypt 1
+SYM_FUNC_END(aegis128x4_enc_vaes_avx512)
+
+SYM_FUNC_START(aegis128x4_dec_vaes_avx512)
+	aegis128x4_crypt 0
+SYM_FUNC_END(aegis128x4_dec_vaes_avx512)
+
+/*
+ * void aegis128x4_final_vaes_avx512(union aegis128x4_state *state, u8 *tag,
+ *				     u64 assoclen, u64 cryptlen,
+ *				     unsigned int authsize);
+ *
+ * authsize must be 16 or 32.
+ */
+SYM_FUNC_START(aegis128x4_final_vaes_avx512)
+	.set STATEP, %rdi
+	.set TAG, %rsi
+	.set ASSOCLEN, %rdx
+	.set CRYPTLEN, %rcx
+	.set AUTHSIZE, %r8d
+
+	vpxor		ZERO_XMM, ZERO_XMM, ZERO_XMM
+	load_state
+	aegis128x4_final_and_ret
+SYM_FUNC_END(aegis128x4_final_vaes_avx512)
+
+/*
+ * void aegis128x4_encrypt_vaes_avx512(const u8 key[AEGIS128X4_KEY_SIZE],
+ *				       const u8 nonce[AEGIS128X4_NONCE_SIZE],
+ *				       const u8 *ad, size_t adlen,
+ *				       const u8 *src, u8 *dst, size_t len,
+ *				       u8 *tag, unsigned int authsize);
+ * void aegis128x4_decrypt_vaes_avx512(...same arguments...);
+ *
+ * En/decrypt a whole message, keeping the state in registers throughout.
+ * authsize must be 16 or 32, and the computed tag is stored at tag.
+ */
+.macro aegis128x4_oneshot enc
+	.set KEYP, %rdi
+	.set IVP, %rsi
+	.set ADP, %rdx
+	.set ASSOCLEN, %r10
+	.set SRC, %r8
+	.set DST, %r9
+	.set LEN, %rcx
+
+	mov		%rcx, ASSOCLEN
+	aegis128x4_init			/* KEYP and IVP are free after this */
+
+	/* absorb the associated data: */
+	cmp		$RATE, %rcx
+	jb		.Lad_tail\@
+.Lad_loop\@:
+	ad_block	ADP
+	add		$RATE, ADP
+	sub		$RATE, %rcx
+	cmp		$RATE, %rcx
+	jae		.Lad_loop\@
+.Lad_tail\@:
+	test		%rcx, %rcx
+	jz		.Lad_done\@
+	tail_masks	%ecx, %rcx
+	vmovdqu8	0x00(ADP), MSG0{%k1}{z}
+	vmovdqu8	0x40(ADP), MSG1{%k2}{z}
+	aegis128x4_update MSG0, MSG1
+.Lad_done\@:
+
+	/*
+	 * en/decrypt the payload; len, tag and authsize are passed on the
+	 * stack at 8(%rsp), 16(%rsp) and 24(%rsp) respectively.
+	 */
+	mov		8(%rsp), LEN
+	mov		LEN, %rsi
+	and		$RATE - 1, %esi
+	and		$~(RATE - 1), LEN
+	jz		.Lcrypt_tail\@
+	crypt_loop	\enc
+.Lcrypt_tail\@:
+	test		%esi, %esi
+	jz		.Lcrypt_done\@
+	tail_masks	%esi, %rsi
+	crypt_tail	\enc
+.Lcrypt_done\@:
+
+	.set TAG, %rdi
+	.set CRYPTLEN, %rcx
+	.set AUTHSIZE, %r8d
+	mov		16(%rsp), TAG
+	mov		8(%rsp), CRYPTLEN
+	mov		24(%rsp), AUTHSIZE
+	aegis128x4_final_and_ret
+.endm
+
+SYM_FUNC_START(aegis128x4_encrypt_vaes_avx512)
+	aegis128x4_oneshot 1
+SYM_FUNC_END(aegis128x4_encrypt_vaes_avx512)
+
+SYM_FUNC_START(aegis128x4_decrypt_vaes_avx512)
+	aegis128x4_oneshot 0
+SYM_FUNC_END(aegis128x4_decrypt_vaes_avx512)
diff --git a/lib/crypto/x86/aegis128x4.h b/lib/crypto/x86/aegis128x4.h
new file mode 100644
index 000000000000..dcb9853062fd
--- /dev/null
+++ b/lib/crypto/x86/aegis128x4.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * AEGIS-128X4 optimized using VAES and AVX-512
+ *
+ * Copyright 2026 Antonio Quartulli <antonio@mandelbit.com>
+ */
+
+#include <asm/fpu/api.h>
+#include <linux/jump_label.h>
+#include <linux/sizes.h>
+
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_vaes_avx512);
+
+asmlinkage void
+aegis128x4_init_vaes_avx512(union aegis128x4_state *state,
+			    const u8 key[AEGIS128X4_KEY_SIZE],
+			    const u8 nonce[AEGIS128X4_NONCE_SIZE]);
+asmlinkage void aegis128x4_absorb_vaes_avx512(union aegis128x4_state *state,
+					      const u8 *src, size_t len);
+asmlinkage void aegis128x4_enc_vaes_avx512(union aegis128x4_state *state,
+					   u8 *dst, const u8 *src, size_t len);
+asmlinkage void aegis128x4_dec_vaes_avx512(union aegis128x4_state *state,
+					   u8 *dst, const u8 *src, size_t len);
+asmlinkage void aegis128x4_final_vaes_avx512(union aegis128x4_state *state,
+					     u8 *tag, u64 assoclen,
+					     u64 cryptlen,
+					     unsigned int authsize);
+asmlinkage void
+aegis128x4_encrypt_vaes_avx512(const u8 key[AEGIS128X4_KEY_SIZE],
+			       const u8 nonce[AEGIS128X4_NONCE_SIZE],
+			       const u8 *ad, size_t ad_len, const u8 *src,
+			       u8 *dst, size_t len, u8 *tag,
+			       unsigned int authsize);
+asmlinkage void
+aegis128x4_decrypt_vaes_avx512(const u8 key[AEGIS128X4_KEY_SIZE],
+			       const u8 nonce[AEGIS128X4_NONCE_SIZE],
+			       const u8 *ad, size_t ad_len, const u8 *src,
+			       u8 *dst, size_t len, u8 *tag,
+			       unsigned int authsize);
+
+static bool aegis128x4_simd_usable(void)
+{
+	return static_branch_likely(&have_vaes_avx512) && irq_fpu_usable();
+}
+
+static bool aegis128x4_init_arch(union aegis128x4_state *st,
+				 const u8 key[AEGIS128X4_KEY_SIZE],
+				 const u8 nonce[AEGIS128X4_NONCE_SIZE])
+{
+	if (!aegis128x4_simd_usable())
+		return false;
+	kernel_fpu_begin_mask(0);
+	aegis128x4_init_vaes_avx512(st, key, nonce);
+	kernel_fpu_end();
+	return true;
+}
+
+static bool aegis128x4_absorb_arch(union aegis128x4_state *st, const u8 *src,
+				   size_t nblocks)
+{
+	size_t len = nblocks * AEGIS128X4_BLOCK_SIZE;
+
+	if (!len)
+		return true;
+	if (!aegis128x4_simd_usable())
+		return false;
+	do {
+		size_t n = min_t(size_t, len, SZ_4K);
+
+		kernel_fpu_begin_mask(0);
+		aegis128x4_absorb_vaes_avx512(st, src, n);
+		kernel_fpu_end();
+		src += n;
+		len -= n;
+	} while (len);
+	return true;
+}
+
+static bool aegis128x4_crypt_blocks_arch(union aegis128x4_state *st, u8 *dst,
+					 const u8 *src, size_t nblocks,
+					 bool enc)
+{
+	size_t len = nblocks * AEGIS128X4_BLOCK_SIZE;
+
+	if (!len)
+		return true;
+	if (!aegis128x4_simd_usable())
+		return false;
+	do {
+		size_t n = min_t(size_t, len, SZ_4K);
+
+		kernel_fpu_begin_mask(0);
+		if (enc)
+			aegis128x4_enc_vaes_avx512(st, dst, src, n);
+		else
+			aegis128x4_dec_vaes_avx512(st, dst, src, n);
+		kernel_fpu_end();
+		src += n;
+		dst += n;
+		len -= n;
+	} while (len);
+	return true;
+}
+
+static bool aegis128x4_enc_arch(union aegis128x4_state *st, u8 *dst,
+				const u8 *src, size_t nblocks)
+{
+	return aegis128x4_crypt_blocks_arch(st, dst, src, nblocks, true);
+}
+
+static bool aegis128x4_dec_arch(union aegis128x4_state *st, u8 *dst,
+				const u8 *src, size_t nblocks)
+{
+	return aegis128x4_crypt_blocks_arch(st, dst, src, nblocks, false);
+}
+
+static bool aegis128x4_final_arch(union aegis128x4_state *st, u8 *authtag,
+				  u64 ad_len, u64 data_len, size_t authtag_len)
+{
+	if (!aegis128x4_simd_usable())
+		return false;
+	kernel_fpu_begin_mask(0);
+	aegis128x4_final_vaes_avx512(st, authtag, ad_len, data_len,
+				     authtag_len);
+	kernel_fpu_end();
+	return true;
+}
+
+/*
+ * Process a whole message in one call, keeping the state in registers, if it
+ * is short enough for a single kernel-mode FPU section.  Longer messages go
+ * through the incremental functions, which split them.
+ */
+static bool aegis128x4_crypt_arch(u8 *dst, const u8 *src, size_t data_len,
+				  u8 *authtag, const u8 *ad, size_t ad_len,
+				  const u8 nonce[AEGIS128X4_NONCE_SIZE],
+				  const struct aegis128x4_key *key, bool enc)
+{
+	if (ad_len + data_len > SZ_4K || !aegis128x4_simd_usable())
+		return false;
+	kernel_fpu_begin_mask(0);
+	if (enc)
+		aegis128x4_encrypt_vaes_avx512(key->key, nonce, ad, ad_len, src,
+					       dst, data_len, authtag,
+					       key->authtag_len);
+	else
+		aegis128x4_decrypt_vaes_avx512(key->key, nonce, ad, ad_len, src,
+					       dst, data_len, authtag,
+					       key->authtag_len);
+	kernel_fpu_end();
+	return true;
+}
+
+#define aegis128x4_mod_init_arch aegis128x4_mod_init_arch
+static void aegis128x4_mod_init_arch(void)
+{
+	/*
+	 * There is no 256-bit code yet, so unlike AES-GCM this is also used on
+	 * CPUs with X86_FEATURE_PREFER_YMM: the alternative is the much slower
+	 * generic code.
+	 */
+	if (boot_cpu_has(X86_FEATURE_VAES) &&
+	    boot_cpu_has(X86_FEATURE_AVX2) &&
+	    boot_cpu_has(X86_FEATURE_AVX512BW) &&
+	    boot_cpu_has(X86_FEATURE_BMI2))
+		static_branch_enable(&have_vaes_avx512);
+}
-- 
2.56.0

