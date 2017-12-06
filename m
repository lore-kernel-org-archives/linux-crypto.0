From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 19/20] crypto: arm64/crct10dif-ce - yield NEON after every block of input
Date: Wed,  6 Dec 2017 19:43:45 +0000
Message-ID: <20171206194346.24393-20-ard.biesheuvel@linaro.org>
References: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-rt-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:42414 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbdLFToz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 14:44:55 -0500
Received: by mail-wm0-f65.google.com with SMTP id l141so9224424wmg.1
        for <linux-crypto@vger.kernel.org>; Wed, 06 Dec 2017 11:44:54 -0800 (PST)
In-Reply-To: <20171206194346.24393-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid excessive scheduling delays under a preemptible kernel by
yielding the NEON after every block of input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 32 +++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index d5b5a8c038c8..111675f7bad5 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -74,13 +74,19 @@
 	.text
 	.cpu		generic+crypto
 
-	arg1_low32	.req	w0
-	arg2		.req	x1
-	arg3		.req	x2
+	arg1_low32	.req	w19
+	arg2		.req	x20
+	arg3		.req	x21
 
 	vzr		.req	v13
 
 ENTRY(crc_t10dif_pmull)
+	frame_push	3, 128
+
+	mov		arg1_low32, w0
+	mov		arg2, x1
+	mov		arg3, x2
+
 	movi		vzr.16b, #0		// init zero register
 
 	// adjust the 16-bit initial_crc value, scale it to 32 bits
@@ -175,8 +181,25 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	subs		arg3, arg3, #128
 
 	// check if there is another 64B in the buffer to be able to fold
-	b.ge		_fold_64_B_loop
+	b.lt		_fold_64_B_end
+
+	if_will_cond_yield_neon
+	stp		q0, q1, [sp, #48]
+	stp		q2, q3, [sp, #80]
+	stp		q4, q5, [sp, #112]
+	stp		q6, q7, [sp, #144]
+	do_cond_yield_neon
+	ldp		q0, q1, [sp, #48]
+	ldp		q2, q3, [sp, #80]
+	ldp		q4, q5, [sp, #112]
+	ldp		q6, q7, [sp, #144]
+	ldr		q10, rk3
+	movi		vzr.16b, #0		// init zero register
+	endif_yield_neon
+
+	b		_fold_64_B_loop
 
+_fold_64_B_end:
 	// at this point, the buffer pointer is pointing at the last y Bytes
 	// of the buffer the 64B of folded data is in 4 of the vector
 	// registers: v0, v1, v2, v3
@@ -304,6 +327,7 @@ _barrett:
 _cleanup:
 	// scale the result back to 16 bits
 	lsr		x0, x0, #16
+	frame_pop	3, 128
 	ret
 
 _less_than_128:
-- 
2.11.0
