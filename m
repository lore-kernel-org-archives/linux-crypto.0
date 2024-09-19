Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5BA19923A;
	Thu, 19 Sep 2024 09:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737316; cv=none; b=PETmN+jTaOpBNUje4z8iYL//1ieGLC4IPHyiQ65gDbZE+a0kEb1+HZmSjFXBeC7KEwwfSB0hM3xvYJY6z9fD5JwaTVrSZ9pyFMNwGllB0uxv/4bpbUhrriKgXZm+aGThnfo68LtXShFrgf2KsCqvp12CjrBTdN3S3KxkPSRswTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737316; c=relaxed/simple;
	bh=fATvW7iQsYXiTRNgtaIKzfalGKexhL+LRn4S4Af4+5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GTwgixVjiu9G3aZ+6jeNFHg1fLJMyU+/ONRtt+DD7PrqvRVTX+eNsPiLcXWO9tbnQuayz1wRPIOKEnv4LnAO6qI91h+AGQt7pKK8bzOll4mm/rAFBe09IEAWcc1x+StgXdSZsIujNTE23VOii1+bENu0zc0FpLPXK60whueogMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Clk8+ZPi; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Clk8+ZPi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1726737312;
	bh=aFKJJmURFaPw+asq2tdcv0On18yd9zEY6SJL9ZneaXI=;
	h=From:To:Cc:Subject:Date:From;
	b=Clk8+ZPizELyKP6lNUu192JUSy6d44q5qDSKnWBV/5/Ic7Yfr3cy7CpedRj5Ybb2H
	 ChO+RVqyMpB9/UY5Tf7f1Aa8kCWv2odpVLUdtv7Jjf1EcQHzlLxuxvYCVWxKJ3Kkjx
	 3wijvGKKnRYMeFJj56ofD0OAzfa0fBaFrtZB9sJo=
Received: from stargazer.. (unknown [IPv6:240e:454:4210:56c7:2cd3:45cf:a0a4:496e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id D7B211A404B;
	Thu, 19 Sep 2024 05:14:22 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH] LoongArch: vDSO: Tune the chacha20 implementation
Date: Thu, 19 Sep 2024 17:13:59 +0800
Message-ID: <20240919091359.7023-1-xry111@xry111.site>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As Christophe pointed out, tuning the chacha20 implementation by
scheduling the instructions like what GCC does can improve the
performance.

The tuning does not introduce too much complexity (basically it's just
reordering some instructions).  And the tuning does not hurt readibility
too much: actually the tuned code looks even more similar to a
textbook-style implementation based on 128-bit vectors.  So overall it's
a good deal to me.

Tested with vdso_test_getchacha and benched with vdso_test_getrandom.
On a LA664 the speedup is 5%, and I expect a larger speedup on LA[2-4]64
with a lower issue rate.

Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/all/77655d9e-fc05-4300-8f0d-7b2ad840d091@csgroup.eu/
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/loongarch/vdso/vgetrandom-chacha.S | 92 +++++++++++++++----------
 1 file changed, 55 insertions(+), 37 deletions(-)

diff --git a/arch/loongarch/vdso/vgetrandom-chacha.S b/arch/loongarch/vdso/vgetrandom-chacha.S
index 7e86a50f6e85..0c5f1183c480 100644
--- a/arch/loongarch/vdso/vgetrandom-chacha.S
+++ b/arch/loongarch/vdso/vgetrandom-chacha.S
@@ -9,23 +9,11 @@
 
 .text
 
-/* Salsa20 quarter-round */
-.macro	QR	a b c d
-	add.w		\a, \a, \b
-	xor		\d, \d, \a
-	rotri.w		\d, \d, 16
-
-	add.w		\c, \c, \d
-	xor		\b, \b, \c
-	rotri.w		\b, \b, 20
-
-	add.w		\a, \a, \b
-	xor		\d, \d, \a
-	rotri.w		\d, \d, 24
-
-	add.w		\c, \c, \d
-	xor		\b, \b, \c
-	rotri.w		\b, \b, 25
+.macro	OP_4REG	op d0 d1 d2 d3 s0 s1 s2 s3
+	\op	\d0, \d0, \s0
+	\op	\d1, \d1, \s1
+	\op	\d2, \d2, \s2
+	\op	\d3, \d3, \s3
 .endm
 
 /*
@@ -74,6 +62,23 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 /* Reuse i as copy3 */
 #define copy3		i
 
+/* Packs to be used with OP_4REG */
+#define line0		state0, state1, state2, state3
+#define line1		state4, state5, state6, state7
+#define line2		state8, state9, state10, state11
+#define line3		state12, state13, state14, state15
+
+#define	line1_perm	state5, state6, state7, state4
+#define	line2_perm	state10, state11, state8, state9
+#define	line3_perm	state15, state12, state13, state14
+
+#define	copy		copy0, copy1, copy2, copy3
+
+#define _16		16, 16, 16, 16
+#define _20		20, 20, 20, 20
+#define _24		24, 24, 24, 24
+#define _25		25, 25, 25, 25
+
 	/*
 	 * The ABI requires s0-s9 saved, and sp aligned to 16-byte.
 	 * This does not violate the stack-less requirement: no sensitive data
@@ -126,16 +131,38 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	li.w		i, 10
 .Lpermute:
 	/* odd round */
-	QR		state0, state4, state8, state12
-	QR		state1, state5, state9, state13
-	QR		state2, state6, state10, state14
-	QR		state3, state7, state11, state15
+	OP_4REG	add.w	line0, line1
+	OP_4REG	xor	line3, line0
+	OP_4REG	rotri.w	line3, _16
+
+	OP_4REG	add.w	line2, line3
+	OP_4REG	xor	line1, line2
+	OP_4REG	rotri.w	line1, _20
+
+	OP_4REG	add.w	line0, line1
+	OP_4REG	xor	line3, line0
+	OP_4REG	rotri.w	line3, _24
+
+	OP_4REG	add.w	line2, line3
+	OP_4REG	xor	line1, line2
+	OP_4REG	rotri.w	line1, _25
 
 	/* even round */
-	QR		state0, state5, state10, state15
-	QR		state1, state6, state11, state12
-	QR		state2, state7, state8, state13
-	QR		state3, state4, state9, state14
+	OP_4REG	add.w	line0, line1_perm
+	OP_4REG	xor	line3_perm, line0
+	OP_4REG	rotri.w	line3_perm, _16
+
+	OP_4REG	add.w	line2_perm, line3_perm
+	OP_4REG	xor	line1_perm, line2_perm
+	OP_4REG	rotri.w	line1_perm, _20
+
+	OP_4REG	add.w	line0, line1_perm
+	OP_4REG	xor	line3_perm, line0
+	OP_4REG	rotri.w	line3_perm, _24
+
+	OP_4REG	add.w	line2_perm, line3_perm
+	OP_4REG	xor	line1_perm, line2_perm
+	OP_4REG	rotri.w	line1_perm, _25
 
 	addi.w		i, i, -1
 	bnez		i, .Lpermute
@@ -147,10 +174,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	li.w		copy3, 0x6b206574
 
 	/* output[0,1,2,3] = copy[0,1,2,3] + state[0,1,2,3] */
-	add.w		state0, state0, copy0
-	add.w		state1, state1, copy1
-	add.w		state2, state2, copy2
-	add.w		state3, state3, copy3
+	OP_4REG	add.w	line0, copy
 	st.w		state0, output, 0
 	st.w		state1, output, 4
 	st.w		state2, output, 8
@@ -165,10 +189,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	ld.w		state3, key, 12
 
 	/* output[4,5,6,7] = state[0,1,2,3] + state[4,5,6,7] */
-	add.w		state4, state4, state0
-	add.w		state5, state5, state1
-	add.w		state6, state6, state2
-	add.w		state7, state7, state3
+	OP_4REG	add.w	line1, line0
 	st.w		state4, output, 16
 	st.w		state5, output, 20
 	st.w		state6, output, 24
@@ -181,10 +202,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	ld.w		state3, key, 28
 
 	/* output[8,9,10,11] = state[0,1,2,3] + state[8,9,10,11] */
-	add.w		state8, state8, state0
-	add.w		state9, state9, state1
-	add.w		state10, state10, state2
-	add.w		state11, state11, state3
+	OP_4REG	add.w	line2, line0
 	st.w		state8, output, 32
 	st.w		state9, output, 36
 	st.w		state10, output, 40
-- 
2.46.1

