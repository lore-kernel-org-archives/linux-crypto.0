Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B3DECE58C
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3848421D7B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ERGBHDwN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfJBOSA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:18:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38528 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfJBOR7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id w12so19884751wro.5
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Th4AOk+yOVbWHxmbQ0+LoirsQcTHiG+xSQnyDNaRzdU=;
        b=ERGBHDwNFYQ2/+SXwex99/iOhUtnmJMzmhaBDdyS320tWkXaYRx/JiYm4mHziSIze8
         xDcLQnLsHS54ZQGvKPNijD69nI6J5huwen++1e4M39wReDUTBwK3gDO38PtGr1O0HOGA
         LrtuS/UKGf7DMzn7g7jFjZnUzznpGlL5Gdewa43qcr3BJaV+VEx1fPfBBTyebKlQrmKl
         yXnbEJOH4ee9vQfEsLty8Q69CJENdkGwtPGEzRkAEinN6QO8X6VNBIeH9T/8yOodl6yY
         IEE15Hns6z240w2HSWFKEn+u0tRrBJeFaxATzRSWwNpDWWeKr7/STxFyw7gXUmAZeKyJ
         C0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Th4AOk+yOVbWHxmbQ0+LoirsQcTHiG+xSQnyDNaRzdU=;
        b=dtkQqjdp9AZC5s4gZ1UpKxwdqTcC17+6ceG+h9WJgm8y7NnvU9wVPXvpz2y3JjHhfQ
         McPnQ0N+t2EURlNDbH6IHjGwwet5ojMZVenvmSFvZbXPslkmkzsuA7VoabbaGZzJMnGc
         NvFULQNPmhrJ35S4m/UB23XX8UcYrl9vktiiq29xDhzAbXNwvo/UOd/BF21pG/caNUnm
         euDZuXMJ2A6Qa9CEYctFsZZva3gLyudzLmwLGi3m/y04sEuUAaMtrV9CRz7pue6DtY1R
         qhBKtSnqJBFx73bQtJzP4PYAcdmE3A9E+K31vEWPbPA+AOGBoHzYucigcWJxMmuPI/cJ
         dVZw==
X-Gm-Message-State: APjAAAUWP+g9ngR9s4+lPFgplt1CTUFQwaXMP2epjVnZdunfhK2iA8ZV
        3pfxntvPiwnJ0k5JWv/K/hPDjwNbzZnoZHry
X-Google-Smtp-Source: APXvYqwymBNqFICvAwnAB3mT341ppVVGb54mGmmexqRAOfCiUm8635jf5ingX4wklnRlSlW+86ZEAw==
X-Received: by 2002:a5d:5352:: with SMTP id t18mr3070529wrv.72.1570025875144;
        Wed, 02 Oct 2019 07:17:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Subject: [PATCH v2 10/20] crypto: mips/poly1305 - import accelerated 32r2 code from Zinc
Date:   Wed,  2 Oct 2019 16:17:03 +0200
Message-Id: <20191002141713.31189-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This integrates the accelerated MIPS 32r2 implementation of ChaCha
into both the API and library interfaces of the kernel crypto stack.

The significance of this is that, in addition to becoming available
as an accelerated library implementation, it can also be used by
existing crypto API code such as IPsec, using chacha20poly1305.

Co-developed-by: René van Dorst <opensource@vdorst.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/mips/crypto/Makefile        |   3 +
 arch/mips/crypto/poly1305-core.S | 407 ++++++++++++++++++++
 arch/mips/crypto/poly1305-glue.c | 203 ++++++++++
 crypto/Kconfig                   |   6 +
 4 files changed, 619 insertions(+)

diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
index 7f7ea0020cc2..849173749626 100644
--- a/arch/mips/crypto/Makefile
+++ b/arch/mips/crypto/Makefile
@@ -7,3 +7,6 @@ obj-$(CONFIG_CRYPTO_CRC32_MIPS) += crc32-mips.o
 
 obj-$(CONFIG_CRYPTO_CHACHA_MIPS) += chacha-mips.o
 chacha-mips-y := chacha-core.o chacha-glue.o
+
+obj-$(CONFIG_CRYPTO_POLY1305_MIPS) += poly1305-mips.o
+poly1305-mips-y := poly1305-core.o poly1305-glue.o
diff --git a/arch/mips/crypto/poly1305-core.S b/arch/mips/crypto/poly1305-core.S
new file mode 100644
index 000000000000..4291c156815b
--- /dev/null
+++ b/arch/mips/crypto/poly1305-core.S
@@ -0,0 +1,407 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright (C) 2016-2018 René van Dorst <opensource@vdorst.com> All Rights Reserved.
+ * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define MSB 0
+#define LSB 3
+#else
+#define MSB 3
+#define LSB 0
+#endif
+
+#define POLY1305_BLOCK_SIZE 16
+.text
+#define H0 $t0
+#define H1 $t1
+#define H2 $t2
+#define H3 $t3
+#define H4 $t4
+
+#define R0 $t5
+#define R1 $t6
+#define R2 $t7
+#define R3 $t8
+
+#define O0 $s0
+#define O1 $s4
+#define O2 $v1
+#define O3 $t9
+#define O4 $s5
+
+#define S1 $s1
+#define S2 $s2
+#define S3 $s3
+
+#define SC $at
+#define CA $v0
+
+/* Input arguments */
+#define poly	$a0
+#define src	$a1
+#define srclen	$a2
+#define hibit	$a3
+
+/* Location in the opaque buffer
+ * R[0..3], CA, H[0..4]
+ */
+#define PTR_POLY1305_R(n) ( 0 + (n*4)) ## ($a0)
+#define PTR_POLY1305_CA   (16        ) ## ($a0)
+#define PTR_POLY1305_H(n) (20 + (n*4)) ## ($a0)
+
+#define POLY1305_BLOCK_SIZE 16
+#define POLY1305_STACK_SIZE 32
+
+.set	noat
+.align	4
+.globl	poly1305_blocks_mips
+.ent	poly1305_blocks_mips
+poly1305_blocks_mips:
+	.frame	$sp, POLY1305_STACK_SIZE, $ra
+	/* srclen &= 0xFFFFFFF0 */
+	ins	srclen, $zero, 0, 4
+
+	addiu	$sp, -(POLY1305_STACK_SIZE)
+
+	/* check srclen >= 16 bytes */
+	beqz	srclen, .Lpoly1305_blocks_mips_end
+
+	/* Calculate last round based on src address pointer.
+	 * last round src ptr (srclen) = src + (srclen & 0xFFFFFFF0)
+	 */
+	addu	srclen, src
+
+	lw	R0, PTR_POLY1305_R(0)
+	lw	R1, PTR_POLY1305_R(1)
+	lw	R2, PTR_POLY1305_R(2)
+	lw	R3, PTR_POLY1305_R(3)
+
+	/* store the used save registers. */
+	sw	$s0, 0($sp)
+	sw	$s1, 4($sp)
+	sw	$s2, 8($sp)
+	sw	$s3, 12($sp)
+	sw	$s4, 16($sp)
+	sw	$s5, 20($sp)
+
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Sx = Rx + (Rx >> 2) */
+	srl	S1, R1, 2
+	srl	S2, R2, 2
+	srl	S3, R3, 2
+	addu	S1, R1
+	addu	S2, R2
+	addu	S3, R3
+
+	addiu	SC, $zero, 1
+
+.Lpoly1305_loop:
+	lwl	O0, 0+MSB(src)
+	lwl	O1, 4+MSB(src)
+	lwl	O2, 8+MSB(src)
+	lwl	O3,12+MSB(src)
+	lwr	O0, 0+LSB(src)
+	lwr	O1, 4+LSB(src)
+	lwr	O2, 8+LSB(src)
+	lwr	O3,12+LSB(src)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	O0
+	wsbh	O1
+	wsbh	O2
+	wsbh	O3
+	rotr	O0, 16
+	rotr	O1, 16
+	rotr	O2, 16
+	rotr	O3, 16
+#endif
+
+	/* h0 = (u32)(d0 = (u64)h0 + inp[0] + c 'Carry_previous cycle'); */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	O0, H0
+	sltu	H0, O0, H0
+	addu	CA, H0
+
+	/* h1 = (u32)(d1 = (u64)h1 + (d0 >> 32) + inp[4]); */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	O1, H1
+	sltu	H1, O1, H1
+	addu	CA, H1
+
+	/* h2 = (u32)(d2 = (u64)h2 + (d1 >> 32) + inp[8]); */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	O2, H2
+	sltu	H2, O2, H2
+	addu	CA, H2
+
+	/* h3 = (u32)(d3 = (u64)h3 + (d2 >> 32) + inp[12]); */
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	O3, H3
+	sltu	H3, O3, H3
+	addu	CA, H3
+
+	/* h4 += (u32)(d3 >> 32) + padbit; */
+	addu	H4, hibit
+	addu	O4, H4, CA
+
+	/* D0 */
+	multu	O0, R0
+	maddu	O1, S3
+	maddu	O2, S2
+	maddu	O3, S1
+	mfhi	CA
+	mflo	H0
+
+	/* D1 */
+	multu	O0, R1
+	maddu	O1, R0
+	maddu	O2, S3
+	maddu	O3, S2
+	maddu	O4, S1
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H1
+
+	/* D2 */
+	multu	O0, R2
+	maddu	O1, R1
+	maddu	O2, R0
+	maddu	O3, S3
+	maddu	O4, S2
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H2
+
+	/* D4 */
+	mul	H4, O4, R0
+
+	/* D3 */
+	multu	O0, R3
+	maddu	O1, R2
+	maddu	O2, R1
+	maddu	O3, R0
+	maddu	O4, S3
+	maddu	CA, SC
+	mfhi	CA
+	mflo	H3
+
+	addiu	src, POLY1305_BLOCK_SIZE
+
+	/* h4 += (u32)(d3 >> 32); */
+	addu	O4, H4, CA
+	/* h4 &= 3 */
+	andi	H4, O4, 3
+	/* c = (h4 >> 2) + (h4 & ~3U); */
+	srl	CA, O4, 2
+	ins	O4, $zero, 0, 2
+
+	addu	CA, O4
+
+	/* able to do a 16 byte block. */
+	bne	src, srclen, .Lpoly1305_loop
+
+	/* restore the used save registers. */
+	lw	$s0, 0($sp)
+	lw	$s1, 4($sp)
+	lw	$s2, 8($sp)
+	lw	$s3, 12($sp)
+	lw	$s4, 16($sp)
+	lw	$s5, 20($sp)
+
+	/* store Hx and Carry */
+	sw	CA, PTR_POLY1305_CA
+	sw	H0, PTR_POLY1305_H(0)
+	sw	H1, PTR_POLY1305_H(1)
+	sw	H2, PTR_POLY1305_H(2)
+	sw	H3, PTR_POLY1305_H(3)
+	sw	H4, PTR_POLY1305_H(4)
+
+.Lpoly1305_blocks_mips_end:
+	addiu	$sp, POLY1305_STACK_SIZE
+
+	/* Jump Back */
+	jr	$ra
+.end poly1305_blocks_mips
+.set at
+
+/* Input arguments CTX=$a0, MAC=$a1, NONCE=$a2 */
+#define MAC	$a1
+#define NONCE	$a2
+
+#define G0	$t5
+#define G1	$t6
+#define G2	$t7
+#define G3	$t8
+#define G4	$t9
+
+.set	noat
+.align	4
+.globl	poly1305_emit_mips
+.ent	poly1305_emit_mips
+poly1305_emit_mips:
+	/* load Hx and Carry */
+	lw	CA, PTR_POLY1305_CA
+	lw	H0, PTR_POLY1305_H(0)
+	lw	H1, PTR_POLY1305_H(1)
+	lw	H2, PTR_POLY1305_H(2)
+	lw	H3, PTR_POLY1305_H(3)
+	lw	H4, PTR_POLY1305_H(4)
+
+	/* Add left over carry */
+	addu	H0, CA
+	sltu	CA, H0, CA
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H3, CA
+	sltu	CA, H3, CA
+	addu	H4, CA
+
+	/* compare to modulus by computing h + -p */
+	addiu	G0, H0, 5
+	sltu	CA, G0, H0
+	addu	G1, H1, CA
+	sltu	CA, G1, H1
+	addu	G2, H2, CA
+	sltu	CA, G2, H2
+	addu	G3, H3, CA
+	sltu	CA, G3, H3
+	addu	G4, H4, CA
+
+	srl	SC, G4, 2
+
+	/* if there was carry into 131st bit, h3:h0 = g3:g0 */
+	movn	H0, G0, SC
+	movn	H1, G1, SC
+	movn	H2, G2, SC
+	movn	H3, G3, SC
+
+	lwl	G0, 0+MSB(NONCE)
+	lwl	G1, 4+MSB(NONCE)
+	lwl	G2, 8+MSB(NONCE)
+	lwl	G3,12+MSB(NONCE)
+	lwr	G0, 0+LSB(NONCE)
+	lwr	G1, 4+LSB(NONCE)
+	lwr	G2, 8+LSB(NONCE)
+	lwr	G3,12+LSB(NONCE)
+
+	/* mac = (h + nonce) % (2^128) */
+	addu	H0, G0
+	sltu	CA, H0, G0
+
+	/* H1 */
+	addu	H1, CA
+	sltu	CA, H1, CA
+	addu	H1, G1
+	sltu	G1, H1, G1
+	addu	CA, G1
+
+	/* H2 */
+	addu	H2, CA
+	sltu	CA, H2, CA
+	addu	H2, G2
+	sltu	G2, H2, G2
+	addu	CA, G2
+
+	/* H3 */
+	addu	H3, CA
+	addu	H3, G3
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	H0
+	wsbh	H1
+	wsbh	H2
+	wsbh	H3
+	rotr	H0, 16
+	rotr	H1, 16
+	rotr	H2, 16
+	rotr	H3, 16
+#endif
+
+	/* store MAC */
+	swl	H0, 0+MSB(MAC)
+	swl	H1, 4+MSB(MAC)
+	swl	H2, 8+MSB(MAC)
+	swl	H3,12+MSB(MAC)
+	swr	H0, 0+LSB(MAC)
+	swr	H1, 4+LSB(MAC)
+	swr	H2, 8+LSB(MAC)
+	swr	H3,12+LSB(MAC)
+
+	jr	$ra
+.end poly1305_emit_mips
+
+#define PR0 $t0
+#define PR1 $t1
+#define PR2 $t2
+#define PR3 $t3
+#define PT0 $t4
+
+/* Input arguments CTX=$a0, KEY=$a1 */
+
+.align	4
+.globl	poly1305_init_mips
+.ent	poly1305_init_mips
+poly1305_init_mips:
+	lwl	PR0, 0+MSB($a1)
+	lwl	PR1, 4+MSB($a1)
+	lwl	PR2, 8+MSB($a1)
+	lwl	PR3,12+MSB($a1)
+	lwr	PR0, 0+LSB($a1)
+	lwr	PR1, 4+LSB($a1)
+	lwr	PR2, 8+LSB($a1)
+	lwr	PR3,12+LSB($a1)
+
+	/* store Hx and Carry */
+	sw	$zero, PTR_POLY1305_CA
+	sw	$zero, PTR_POLY1305_H(0)
+	sw	$zero, PTR_POLY1305_H(1)
+	sw	$zero, PTR_POLY1305_H(2)
+	sw	$zero, PTR_POLY1305_H(3)
+	sw	$zero, PTR_POLY1305_H(4)
+
+#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+	wsbh	PR0
+	wsbh	PR1
+	wsbh	PR2
+	wsbh	PR3
+	rotr	PR0, 16
+	rotr	PR1, 16
+	rotr	PR2, 16
+	rotr	PR3, 16
+#endif
+
+	lui	PT0, 0x0FFF
+	ori	PT0, 0xFFFC
+
+	/* AND 0x0fffffff; */
+	ext	PR0, PR0, 0, (32-4)
+
+	/* AND 0x0ffffffc; */
+	and	PR1, PT0
+	and	PR2, PT0
+	and	PR3, PT0
+
+	/* store Rx */
+	sw	PR0, PTR_POLY1305_R(0)
+	sw	PR1, PTR_POLY1305_R(1)
+	sw	PR2, PTR_POLY1305_R(2)
+	sw	PR3, PTR_POLY1305_R(3)
+
+	/* Jump Back  */
+	jr	$ra
+.end poly1305_init_mips
diff --git a/arch/mips/crypto/poly1305-glue.c b/arch/mips/crypto/poly1305-glue.c
new file mode 100644
index 000000000000..56ef1469ae6b
--- /dev/null
+++ b/arch/mips/crypto/poly1305-glue.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * OpenSSL/Cryptogams accelerated Poly1305 transform for ARM
+ *
+ * Copyright (C) 2019 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/poly1305.h>
+#include <linux/cpufeature.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+
+asmlinkage void poly1305_init_mips(void *state, const u8 *key);
+asmlinkage void poly1305_blocks_mips(void *state, const u8 *src, u32 len, u32 hibit);
+asmlinkage void poly1305_emit_mips(void *state, __le32 *digest, const u32 *nonce);
+
+void poly1305_init(struct poly1305_desc_ctx *dctx, const u8 *key)
+{
+	poly1305_init_mips(&dctx->h, key);
+	dctx->s[0] = get_unaligned_le32(key + 16);
+	dctx->s[1] = get_unaligned_le32(key + 20);
+	dctx->s[2] = get_unaligned_le32(key + 24);
+	dctx->s[3] = get_unaligned_le32(key + 28);
+	dctx->buflen = 0;
+}
+EXPORT_SYMBOL(poly1305_init);
+
+static int mips_poly1305_init(struct shash_desc *desc)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	dctx->buflen = 0;
+	dctx->rset = 0;
+	dctx->sset = false;
+
+	return 0;
+}
+
+static void mips_poly1305_blocks(struct poly1305_desc_ctx *dctx, const u8 *src,
+				 u32 len, u32 hibit)
+{
+	if (unlikely(!dctx->sset)) {
+		if (!dctx->rset) {
+			poly1305_init_mips(&dctx->h, src);
+			src += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			dctx->rset = 1;
+		}
+		if (len >= POLY1305_BLOCK_SIZE) {
+			dctx->s[0] = get_unaligned_le32(src +  0);
+			dctx->s[1] = get_unaligned_le32(src +  4);
+			dctx->s[2] = get_unaligned_le32(src +  8);
+			dctx->s[3] = get_unaligned_le32(src + 12);
+			src += POLY1305_BLOCK_SIZE;
+			len -= POLY1305_BLOCK_SIZE;
+			dctx->sset = true;
+		}
+		if (len < POLY1305_BLOCK_SIZE)
+			return;
+	}
+
+	len &= ~(POLY1305_BLOCK_SIZE - 1);
+
+	poly1305_blocks_mips(&dctx->h, src, len, hibit);
+}
+
+static int mips_poly1305_update(struct shash_desc *desc, const u8 *src,
+				unsigned int len)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	if (unlikely(dctx->buflen)) {
+		u32 bytes = min(len, POLY1305_BLOCK_SIZE - dctx->buflen);
+
+		memcpy(dctx->buf + dctx->buflen, src, bytes);
+		src += bytes;
+		len -= bytes;
+		dctx->buflen += bytes;
+
+		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
+			mips_poly1305_blocks(dctx, dctx->buf, POLY1305_BLOCK_SIZE, 1);
+			dctx->buflen = 0;
+		}
+	}
+
+	if (likely(len >= POLY1305_BLOCK_SIZE)) {
+		mips_poly1305_blocks(dctx, src, len, 1);
+		src += round_down(len, POLY1305_BLOCK_SIZE);
+		len %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(len)) {
+		dctx->buflen = len;
+		memcpy(dctx->buf, src, len);
+	}
+	return 0;
+}
+
+void poly1305_update(struct poly1305_desc_ctx *dctx, const u8 *src,
+		     unsigned int nbytes)
+{
+	if (unlikely(dctx->buflen)) {
+		u32 bytes = min(nbytes, POLY1305_BLOCK_SIZE - dctx->buflen);
+
+		memcpy(dctx->buf + dctx->buflen, src, bytes);
+		src += bytes;
+		nbytes -= bytes;
+		dctx->buflen += bytes;
+
+		if (dctx->buflen == POLY1305_BLOCK_SIZE) {
+			poly1305_blocks_mips(&dctx->h, dctx->buf,
+					     POLY1305_BLOCK_SIZE, 1);
+			dctx->buflen = 0;
+		}
+	}
+
+	if (likely(nbytes >= POLY1305_BLOCK_SIZE)) {
+		unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
+
+		poly1305_blocks_mips(&dctx->h, src, len, 1);
+		src += len;
+		nbytes %= POLY1305_BLOCK_SIZE;
+	}
+
+	if (unlikely(nbytes)) {
+		dctx->buflen = nbytes;
+		memcpy(dctx->buf, src, nbytes);
+	}
+}
+EXPORT_SYMBOL(poly1305_update);
+
+void poly1305_final(struct poly1305_desc_ctx *dctx, u8 *dst)
+{
+	__le32 digest[4];
+	u64 f = 0;
+
+	if (unlikely(dctx->buflen)) {
+		dctx->buf[dctx->buflen++] = 1;
+		memset(dctx->buf + dctx->buflen, 0,
+		       POLY1305_BLOCK_SIZE - dctx->buflen);
+		poly1305_blocks_mips(&dctx->h, dctx->buf, POLY1305_BLOCK_SIZE, 0);
+	}
+
+	poly1305_emit_mips(&dctx->h, digest, dctx->s);
+
+	/* mac = (h + s) % (2^128) */
+	f = (f >> 32) + le32_to_cpu(digest[0]);
+	put_unaligned_le32(f, dst);
+	f = (f >> 32) + le32_to_cpu(digest[1]);
+	put_unaligned_le32(f, dst + 4);
+	f = (f >> 32) + le32_to_cpu(digest[2]);
+	put_unaligned_le32(f, dst + 8);
+	f = (f >> 32) + le32_to_cpu(digest[3]);
+	put_unaligned_le32(f, dst + 12);
+
+	*dctx = (struct poly1305_desc_ctx){};
+}
+EXPORT_SYMBOL(poly1305_final);
+
+static int mips_poly1305_final(struct shash_desc *desc, u8 *dst)
+{
+	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	if (unlikely(!dctx->sset))
+		return -ENOKEY;
+
+	poly1305_final(dctx, dst);
+	return 0;
+}
+
+static struct shash_alg mips_poly1305_alg = {
+	.init			= mips_poly1305_init,
+	.update			= mips_poly1305_update,
+	.final			= mips_poly1305_final,
+	.digestsize		= POLY1305_DIGEST_SIZE,
+	.descsize		= sizeof(struct poly1305_desc_ctx),
+
+	.base.cra_name		= "poly1305",
+	.base.cra_driver_name	= "poly1305-mips",
+	.base.cra_priority	= 200,
+	.base.cra_blocksize	= POLY1305_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+};
+
+static int __init mips_poly1305_mod_init(void)
+{
+	return crypto_register_shash(&mips_poly1305_alg);
+}
+
+static void __exit mips_poly1305_mod_exit(void)
+{
+	crypto_unregister_shash(&mips_poly1305_alg);
+}
+
+module_init(mips_poly1305_mod_init);
+module_exit(mips_poly1305_mod_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("poly1305");
+MODULE_ALIAS_CRYPTO("poly1305-mips");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4a8aafeca8ad..9cc3716de11d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -718,6 +718,12 @@ config CRYPTO_POLY1305_X86_64
 	  in IETF protocols. This is the x86_64 assembler implementation using SIMD
 	  instructions.
 
+config CRYPTO_POLY1305_MIPS
+	tristate "Poly1305 authenticator algorithm (MIPS 32r2 optimized)"
+	depends on CPU_MIPS32_R2
+	select CRYPTO_POLY1305
+	select CRYPTO_ARCH_HAVE_LIB_POLY1305
+
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
 	select CRYPTO_HASH
-- 
2.20.1

