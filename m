Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590ABC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jan 2022 10:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbiARKcn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:32:43 -0500
Received: from smtpout4.mo529.mail-out.ovh.net ([217.182.185.173]:49797 "EHLO
        smtpout4.mo529.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237443AbiARKcn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jan 2022 05:32:43 -0500
Received: from mxplan1.mail.ovh.net (unknown [10.109.156.48])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 5BB21D86FA3B;
        Tue, 18 Jan 2022 11:24:03 +0100 (CET)
Received: from bracey.fi (37.59.142.101) by DAG4EX1.mxp1.local (172.16.2.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 18 Jan
 2022 11:24:02 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-101G0049ec73664-5e08-45a5-a937-b75d1194a294,
                    D2C519BAB91300E05C7E54B340BF794D215B5709) smtp.auth=kevin@bracey.fi
X-OVh-ClientIp: 82.181.225.135
From:   Kevin Bracey <kevin@bracey.fi>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kevin Bracey <kevin@bracey.fi>
Subject: [PATCH v3 4/4] arm64: accelerate crc32_be
Date:   Tue, 18 Jan 2022 12:23:51 +0200
Message-ID: <20220118102351.3356105-5-kevin@bracey.fi>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118102351.3356105-1-kevin@bracey.fi>
References: <20220118102351.3356105-1-kevin@bracey.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG8EX2.mxp1.local (172.16.2.16) To DAG4EX1.mxp1.local
 (172.16.2.7)
X-Ovh-Tracer-GUID: 0cc6860a-4815-45c3-989e-d261c4950712
X-Ovh-Tracer-Id: 10755440337342599273
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgddugecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepmfgvvhhinhcuuehrrggtvgihuceokhgvvhhinhessghrrggtvgihrdhfiheqnecuggftrfgrthhtvghrnhepjedujeevgeekhfdvlefhvdetueeuudehteejgfeiheehgfeikeeludefleetjeeunecuffhomhgrihhnpegtrhgtfedvrdhssgenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnuddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehkvghvihhnsegsrhgrtggvhidrfhhipdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhgvvhhinhessghrrggtvgihrdhfih
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It makes no sense to leave crc32_be using the generic code while we
only accelerate the little-endian ops.

Even though the big-endian form doesn't fit as smoothly into the arm64,
we can speed it up and avoid hitting the D cache.

Tested on Cortex-A53. Without acceleration:

    crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
    crc32: self tests passed, processed 225944 bytes in 192240 nsec
    crc32c: CRC_LE_BITS = 64
    crc32c: self tests passed, processed 112972 bytes in 21360 nsec

With acceleration:

    crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
    crc32: self tests passed, processed 225944 bytes in 53480 nsec
    crc32c: CRC_LE_BITS = 64
    crc32c: self tests passed, processed 112972 bytes in 21480 nsec

Signed-off-by: Kevin Bracey <kevin@bracey.fi>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/lib/crc32.S | 87 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 73 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
index 0f9e10ecda23..8340dccff46f 100644
--- a/arch/arm64/lib/crc32.S
+++ b/arch/arm64/lib/crc32.S
@@ -11,7 +11,44 @@
 
 	.arch		armv8-a+crc
 
-	.macro		__crc32, c
+	.macro		byteorder, reg, be
+	.if		\be
+CPU_LE( rev		\reg, \reg	)
+	.else
+CPU_BE( rev		\reg, \reg	)
+	.endif
+	.endm
+
+	.macro		byteorder16, reg, be
+	.if		\be
+CPU_LE( rev16		\reg, \reg	)
+	.else
+CPU_BE( rev16		\reg, \reg	)
+	.endif
+	.endm
+
+	.macro		bitorder, reg, be
+	.if		\be
+	rbit		\reg, \reg
+	.endif
+	.endm
+
+	.macro		bitorder16, reg, be
+	.if		\be
+	rbit		\reg, \reg
+	lsr		\reg, \reg, #16
+	.endif
+	.endm
+
+	.macro		bitorder8, reg, be
+	.if		\be
+	rbit		\reg, \reg
+	lsr		\reg, \reg, #24
+	.endif
+	.endm
+
+	.macro		__crc32, c, be=0
+	bitorder	w0, \be
 	cmp		x2, #16
 	b.lt		8f			// less than 16 bytes
 
@@ -24,10 +61,14 @@
 	add		x8, x8, x1
 	add		x1, x1, x7
 	ldp		x5, x6, [x8]
-CPU_BE(	rev		x3, x3		)
-CPU_BE(	rev		x4, x4		)
-CPU_BE(	rev		x5, x5		)
-CPU_BE(	rev		x6, x6		)
+	byteorder	x3, \be
+	byteorder	x4, \be
+	byteorder	x5, \be
+	byteorder	x6, \be
+	bitorder	x3, \be
+	bitorder	x4, \be
+	bitorder	x5, \be
+	bitorder	x6, \be
 
 	tst		x7, #8
 	crc32\c\()x	w8, w0, x3
@@ -55,33 +96,43 @@ CPU_BE(	rev		x6, x6		)
 32:	ldp		x3, x4, [x1], #32
 	sub		x2, x2, #32
 	ldp		x5, x6, [x1, #-16]
-CPU_BE(	rev		x3, x3		)
-CPU_BE(	rev		x4, x4		)
-CPU_BE(	rev		x5, x5		)
-CPU_BE(	rev		x6, x6		)
+	byteorder	x3, \be
+	byteorder	x4, \be
+	byteorder	x5, \be
+	byteorder	x6, \be
+	bitorder	x3, \be
+	bitorder	x4, \be
+	bitorder	x5, \be
+	bitorder	x6, \be
 	crc32\c\()x	w0, w0, x3
 	crc32\c\()x	w0, w0, x4
 	crc32\c\()x	w0, w0, x5
 	crc32\c\()x	w0, w0, x6
 	cbnz		x2, 32b
-0:	ret
+0:	bitorder	w0, \be
+	ret
 
 8:	tbz		x2, #3, 4f
 	ldr		x3, [x1], #8
-CPU_BE(	rev		x3, x3		)
+	byteorder	x3, \be
+	bitorder	x3, \be
 	crc32\c\()x	w0, w0, x3
 4:	tbz		x2, #2, 2f
 	ldr		w3, [x1], #4
-CPU_BE(	rev		w3, w3		)
+	byteorder	w3, \be
+	bitorder	w3, \be
 	crc32\c\()w	w0, w0, w3
 2:	tbz		x2, #1, 1f
 	ldrh		w3, [x1], #2
-CPU_BE(	rev16		w3, w3		)
+	byteorder16	w3, \be
+	bitorder16	w3, \be
 	crc32\c\()h	w0, w0, w3
 1:	tbz		x2, #0, 0f
 	ldrb		w3, [x1]
+	bitorder8	w3, \be
 	crc32\c\()b	w0, w0, w3
-0:	ret
+0:	bitorder	w0, \be
+	ret
 	.endm
 
 	.align		5
@@ -99,3 +150,11 @@ alternative_if_not ARM64_HAS_CRC32
 alternative_else_nop_endif
 	__crc32		c
 SYM_FUNC_END(__crc32c_le)
+
+	.align		5
+SYM_FUNC_START(crc32_be)
+alternative_if_not ARM64_HAS_CRC32
+	b		crc32_be_base
+alternative_else_nop_endif
+	__crc32		be=1
+SYM_FUNC_END(crc32_be)
-- 
2.25.1

