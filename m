Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890122;
	b=QgJqKcSrcY2PIMHMz+yUJCa0dFdQ7XrM9XCHjdf6CwnK7nbYIFWljLeHqlhBJ6pYdq9Q
	 Pcc/KNg85ALuGbO4tAKa1zlSJLPzXNYaQX7L0QPzsK7x+h2B9Q6gBiuAfyg6Dk4yIa+9c
	 GHOM2wkLROh93hxedCOamVLH8IbYIr86p9Fkk2g/n9cAOexwVnFl+jzSCifCHzECJtO/+
	 Svnt7/KOC8dGsBrftQJW6JFHiuDNBsL8vDVvUucgvgYOqBpeBHHeN0PvOM1goAMIA+i2p
	 nriuG/L3Pya9pyFhCoNtxcDQzPmB2ftWDEk6V/0lm5hIzKYGUEyWSnShc4jU5+2+lKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890122;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vDuDdRL8iZneo/phC8IWAHFDoAthrBkjX6kaJXJOz94=;
	b=k7xiKeGmfMI5lxBafw32XWkyTX7Ie+G4xN2F3KmNiukM+o+6jTTcvu0Z5HbvD1zVFEtO
	 KYPvZOYwHouzFjzvp2PnnRgYs2rOqbcDL4liU7oD1hKXSFVrwGJAz2DaR2DST/bkvU6pZ
	 9WH22Qi7hY+aRkl5LodviaCITANCmO/pEZi+hMOSdeip300tMkt1vgv1S4sP2LHqRI9VZ
	 xUqdrLXu/7M7m3VvomjSzBXZZMWuD1JpjvsqleFL0jS8mJ3YXwOF87Re8gpsymgMneYAj
	 2sYTM02X2eSnXRHp2JfT79aHLdMso3tDgR5kuCB62l8x1ElTWvM8MCJ7EZykiYMwAEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SP+W2Lfk;
	arc=none smtp.remote-ip=209.85.214.198
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5EA60A381C
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C5EA60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SP+W2Lfk
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e9501034c4so61655105ad.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890122; x=1795494922; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vDuDdRL8iZneo/phC8IWAHFDoAthrBkjX6kaJXJOz94=;
        b=SP+W2LfkrNnx1jjN1YNt85F6BWfWujzUbmezApdaGbnymMtHckzkHgEeMcGL6xU8h1
         nD6R3fyN/x1rYwdbf4MAqKbtXEEaEmvXvDpWHPEGH3/bk+OX6xV8DF2LigTbmgUbUPb0
         r1dE0YwMPw7w1SKCVJ727fHAREoHGUBOGBZWsVnjYzEPGQ31Nn61uqXpHcoAhbLg9WUE
         KzEwoZTL9etEHuGkwJzVXhuF4ls/afNviCViuQngeDFWeKRszizOxBwX9oN1ngT37jyK
         R4RVV0MG/lW9MQYke19cs3iDXlRvJtstT9NhsOAhnCWYYYvYtdLp4kTN72OdXE61KzQk
         uvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890122; x=1795494922;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vDuDdRL8iZneo/phC8IWAHFDoAthrBkjX6kaJXJOz94=;
        b=g2NAN+P19FA7HA28zcQXdEJ0JiPkGXk5oHnYt1zjZ1a3DU9yU2uhQ9psq0ZnucciML
         sjORyvoo6q3KsjsHg9V5DmM+i8fFCUad/C4F/mSsXT7nLopiJccWov4fynPdMVpNGZYP
         IM/R6GMkvSHOLtsvA3whmSwiHa9hWY04VGVBAtH/L1LYYADwtiJACs8dI8DfnE6G5nGy
         d/N5AirO6Xejwo1oBO7dPieFBbT1zCMeqwQNtD56u7Q/4oAieWv3SS7AF69X1EadS70j
         r0LIF6Ri6JlYaMU4YCv+DoptPk4IOq8z0U0sc6wb/r9OdEvgaOGSmXPuEyJ8Rp97qzzp
         puFw==
X-Forwarded-Encrypted: i=1; AL+hErEf5KlNJueAVKUoA00E7+lXarRwzaFVhzQQAB4ifnAj1Va+r8/3n4nw0GEjqmjnVfmYkwbCV7cvl4RLV8o=@vger.kernel.org
X-Gm-Message-State: APuU4Z9edT94jQNdxvCwf2nhZpuAZYdwaVIADLKO4yDzx7GGb0f/H6YD
	vTFR2KNfQdQ1uMMDDft+/di/Zj3NO6dQzDE2cEOxZx0zF/nfiJVntHnrfS7EKdFZC6gd6NM4Yt4
	IKiFsbah7akxzMpg8iCWSG/pX3w==
X-Received: from plgn9.prod.google.com ([2002:a17:902:f609:b0:2df:4aa4:16d0])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:f8d:b0:2e9:5507:b52c with SMTP id d9443c01a7336-2ee0de03f7dmr125521225ad.34.1794890121819;
 Mon, 16 Nov 2026 20:35:21 -0800 (PST)
Date: Tue, 17 Nov 2026 04:35:02 +0000
In-Reply-To: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261117043504.1021063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261117043504.1021063-11-dylanbhatch@google.com>
Subject: [RFC PATCH 10/12] arm64: entry: add unwind info for call_on_irq_stack()
From: Dylan Hatch <dylanbhatch@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Weinan Liu <wnliu@google.com>, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Indu Bhagat <ibhagatgnu@gmail.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, live-patching@vger.kernel.org, 
	Dylan Hatch <dylanbhatch@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Weinan Liu <wnliu@google.com>

DWARF CFI (Call Frame Information) specifies how to recover the return
address and callee-saved registers at each PC in a given function.
Compilers are able to generate the CFI annotations when they compile
the code to assembly language. For handcrafted assembly, we need to
annotate them by hand.

Frame pointers alone are usually sufficient to recover stack frames
(without CFI), except at the exception boundary, where more information
is needed to determine if the LR is live.

Since an exception can be taken from call_on_irq_stack(), annotate it
with CFI. The actual entry assembly functions are left untouched, since
they are not expected to take exceptions themselves.

Signed-off-by: Weinan Liu <wnliu@google.com>
Suggested-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/kernel/entry.S | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 8d17f61d1b5b2..aae27ccc0f2c1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,13 @@
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
 
+#ifndef CONFIG_UNWIND_TABLES
+/*
+ * Do not generate .eh_frame unless CONFIG_UNWIND_TABLES is enabled.
+ */
+	.cfi_sections .debug_frame
+#endif
+
 	.macro	clear_gp_regs
 	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
 	mov	x\n, xzr
@@ -880,8 +887,11 @@ NOKPROBE(ret_from_fork)
  * 		          void (*func)(struct pt_regs *));
  *
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
+ * Open-code SYM_FUNC_START() so .cfi_startproc precedes the BTI landing pad.
  */
-SYM_FUNC_START(call_on_irq_stack)
+SYM_START(call_on_irq_stack, SYM_L_GLOBAL, SYM_A_ALIGN)
+	.cfi_startproc
+	bti	c
 	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
@@ -892,6 +902,9 @@ SYM_FUNC_START(call_on_irq_stack)
 	/* Create a frame record to save our LR and SP (implicit in FP) */
 	stp	x29, x30, [sp, #-16]!
 	mov	x29, sp
+	.cfi_def_cfa 29, 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
 
 	ldr_this_cpu x16, irq_stack_ptr, x17
 
@@ -907,9 +920,13 @@ SYM_FUNC_START(call_on_irq_stack)
 	 */
 	mov	sp, x29
 	ldp	x29, x30, [sp], #16
+	.cfi_restore 29
+	.cfi_restore 30
+	.cfi_def_cfa 31, 0
 	scs_load_current
 	restore_irq x9
 	ret
+	.cfi_endproc
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)
 
-- 
2.56.0.679.gc527c65306-goog

