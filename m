Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890113;
	b=sAVGsP+732/D6Mdt3VfyfIMQRfsrYP1d2S8U7ikNchP7w2xN6z2yVF9jT10b+nOZqA5L
	 IUU96dvfNrtavKvF+WMp4W/LsfjnFBn2S7ZmMAAZRYBp5Br0rsVVaoOzH2JvNooNar0SP
	 rEoOl/qJu0vk39E+lxxmszVU79jddk0YZ1DNpIaWvOKJrys2W6WxHW/dMIzu8D/YjYU3D
	 lwMz+TKehoUAk+V9Gb8+BFHNvKx9l26zjqZ0X9Ex+xnJVrc8/p4T0HZBa4YQokutpocRC
	 s3iLkx4ogqNEaBapV6UGiPDPw4rWD8fndEkGQ91UGKVr0jpuyCE58o/uSu/P/LS1B+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890113;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Pi0bqedEVPcKpyBR0lAV9z5CffbTAe2VaWnOw6F3Fbw=;
	b=w4gyNe6ZEj7gqNAOMFGFnGTmYRIZK7XiaTHVAH61LXvtNwogeAwyjEqshPdNCPetGAGN
	 lqQ5qRgmo2+jQSFSk86pmAPkjfGFG9W+kNV7u23hIHO/MwTnV0TTncGwIGeLx+JRV7LaS
	 USn9QG3f0HgQKJ+rfpQXWraNL2I6PWMNH+gCEl3rr4dUYx88msOu95HJj0fkANfm/ucqZ
	 1wGJ6k+7OPJ1bdCe4GKMAlk76+M0OMC9CPhK+m/Y8wXnPp77QoQubLIDkcmnaJypztFDG
	 DEpdyCctepRvNisgsHAMXIjyk1IXPLs6hyGN15sjKW2OmAO08Toa5MwgtVowlT9PoWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BbI5CWaf;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EB1606A337
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97EB1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BbI5CWaf
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso2254220a12.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890112; x=1795494912; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pi0bqedEVPcKpyBR0lAV9z5CffbTAe2VaWnOw6F3Fbw=;
        b=BbI5CWafjhn2vCYubqm3R44cGhZpdjaLLO8MKUhexp7+wFfhc+3ulb599MlPaJCl8C
         daSllQwqGCxzQACPU4e3+rejCZL4GcOlFkjwv4bo9Zdtz3HRwL+7yn9FBsTjMlLmiSeR
         3BtSOJUFy6DxhP+ipxsjNmcMs9lkhqgANJ84UU50wZefc4ZW7FfL5/w0Ni1PPopWw+Di
         v9lC58fei6JLOfYPSkTNZ/kiiaien8M7LCj1WmYdiCX58fp++BQjOttgyZ8CL/n9Lbe/
         HndTPQKQWcDsawf5U4mgQUxqFE2C8YZs3eJifzP1+B1fGD6rMQrq6MI5yHTHlNvUYJ+A
         ujbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890112; x=1795494912;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pi0bqedEVPcKpyBR0lAV9z5CffbTAe2VaWnOw6F3Fbw=;
        b=TcEclt8MoQ1soO0k4Av0KQnqoq8dLsUPfj5NmQhQ+HzCBm5yHFVKncYIkwsqtYsWVN
         DQ0iCtaGKLTQQchQcc5f6lzAyR/umhx897qu4N7V8w+pJIk2vfBQPy43OfTupdR9WN6R
         RSd8HDDS3D6dfgP6GGgjvWBZ+8/qj48AwwbHho4PPaWMqOq4XjEPFawjkVP36QZ71rjD
         fnLXdjm4Rc9pdORgkOmCl+bgANBx9xaFd9uckQbbXN97AhzkVrW1/xLBTFT7FutYOGIl
         UvPnJo7S0Qxhxb4m82VIEfZ9iWOkxh70xVrkStpAQ+qfpDTlqAnSsguNo2PbGhJKWGjl
         GDTA==
X-Forwarded-Encrypted: i=1; AL+hErGQ7oe6mJs4RIXWTQsD/vtnRlIucQCFNTtpilfkkZwgi+2kinNWTNOsgKO+C+tb/KYQL4UdUaNiXnfzaeY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+T3uAnQceb+UAt5mP9CoF0gsfcLoCTXHoE2cPWw6Qwx+U22a1d
	NAqgPklj7JWlIAxXMkjjbAzMv0BDZdVQthx72yn3SYPNXRlYOS/Uy9W/OFLJZ/JKXIUVgbI1pPI
	Qp1g72d9LI1Iwu1XxHyUkBltPaQ==
X-Received: from pgbx8-n1.prod.google.com ([2002:a05:6a02:63c8:10b0:cd8:b543:4c4])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6aa0:b0:3f8:78ed:b4fe with SMTP id adf61e73a8af0-3f878edb65bmr7452950637.46.1794890111625;
 Mon, 16 Nov 2026 20:35:11 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:55 +0000
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
Message-ID: <20261117043504.1021063-4-dylanbhatch@google.com>
Subject: [RFC PATCH 03/12] arm64: eh_frame: track CFA and x29/x30 register
 state in CFI parser
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

Extend <asm/eh_frame.h> to decode ULEB128/SLEB128 operands, evaluate
initial CIE opcodes, and track CFA (cfa_reg, cfa_off) and x29/x30
frame-record save rules (fp_rule/fp_off, lr_rule/lr_off) across FDE
instructions, including DW_CFA_remember_state and DW_CFA_restore_state.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/include/asm/eh_frame.h | 273 +++++++++++++++++++++++++++---
 arch/arm64/kernel/pi/patch-scs.c  |   1 +
 2 files changed, 249 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/eh_frame.h b/arch/arm64/include/asm/eh_frame.h
index 6c17fed1860f1..1dcb5b6151bbc 100644
--- a/arch/arm64/include/asm/eh_frame.h
+++ b/arch/arm64/include/asm/eh_frame.h
@@ -2,6 +2,10 @@
 /*
  * Minimal DWARF .eh_frame CFI parser for arm64.
  *
+ * Shared between early boot/module dynamic SCS patching
+ * (arch/arm64/kernel/pi/patch-scs.c) and build-time .lr_unwind generation
+ * (scripts/gen_lr_unwind.c).
+ *
  * This minimal DWARF CFI parser is partially based on the code in
  * arch/arc/kernel/unwind.c, and on the document below:
  * https://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/ehframechpt.html
@@ -19,7 +23,11 @@
 #define U32_MAX				((u32)~0U)
 #endif
 
+#define AARCH64_DWARF_FP		29
 #define AARCH64_DWARF_LR		30
+#define AARCH64_DWARF_SP		31
+
+#define EH_FRAME_STATE_STACK_MAX	8
 
 #define DW_CFA_nop			0x00
 #define DW_CFA_advance_loc1		0x02
@@ -27,14 +35,22 @@
 #define DW_CFA_advance_loc4		0x04
 #define DW_CFA_offset_extended		0x05
 #define DW_CFA_restore_extended		0x06
+#define DW_CFA_undefined		0x07
 #define DW_CFA_same_value		0x08
+#define DW_CFA_register			0x09
 #define DW_CFA_remember_state		0x0a
 #define DW_CFA_restore_state		0x0b
 #define DW_CFA_def_cfa			0x0c
 #define DW_CFA_def_cfa_register		0x0d
 #define DW_CFA_def_cfa_offset		0x0e
+#define DW_CFA_def_cfa_expression	0x0f
+#define DW_CFA_expression		0x10
+#define DW_CFA_offset_extended_sf	0x11
+#define DW_CFA_def_cfa_sf		0x12
 #define DW_CFA_def_cfa_offset_sf	0x13
+#define DW_CFA_val_expression		0x16
 #define DW_CFA_negate_ra_state		0x2d
+#define DW_CFA_GNU_args_size		0x2e
 
 #define DW_EH_PE_sdata4			0x0b
 #define DW_EH_PE_sdata8			0x0c
@@ -47,9 +63,27 @@ enum {
 	EDYNSCS_INVALID_CFA_OPCODE		= 4,
 };
 
+enum eh_frame_reg_rule {
+	EH_REG_UNMODIFIED	= 0,
+	EH_REG_OFFSET		= 1,
+	EH_REG_UNSUPPORTED	= 2,
+};
+
+struct eh_frame_reg_state {
+	s64	cfa_off;
+	s64	fp_off;
+	s64	lr_off;
+	u32	cfa_reg;
+	u8	fp_rule;
+	u8	lr_rule;
+};
+
 struct eh_frame_cfi_state {
-	u64	loc;
-	bool	ra_negated;
+	u64				loc;
+	struct eh_frame_reg_state	reg;
+	struct eh_frame_reg_state	stack[EH_FRAME_STATE_STACK_MAX];
+	unsigned int			stack_depth;
+	bool				ra_negated;
 };
 
 struct eh_frame {
@@ -75,6 +109,7 @@ struct eh_frame {
 			u8	return_address_register;
 			u8	augmentation_data_size;
 			u8	fde_pointer_format;
+			u8	cie_opcodes[];
 		};
 
 		struct { /* FDE (sdata4) */
@@ -92,40 +127,100 @@ struct eh_frame {
 };
 
 struct eh_frame_fde_iter {
-	const u8		*start;
-	const u8		*p;
-	int			size;
-	int			code_align;
-	bool			use_sdata8;
-	const struct eh_frame	*cie;
-	const struct eh_frame	*fde;
+	const u8			*start;
+	const u8			*p;
+	int				size;
+	int				code_align;
+	int				data_align;
+	bool				use_sdata8;
+	struct eh_frame_reg_state	cie_reg;
+	const struct eh_frame		*cie;
+	const struct eh_frame		*fde;
 };
 
 #define EH_FRAME_FDE_ITER_INIT(buf, len) \
-	{ .start = (buf), .p = (buf), .size = (len), .code_align = 1 }
+	{ .start = (buf), .p = (buf), .size = (len), \
+	  .code_align = 1, .data_align = -4, \
+	  .cie_reg = { .cfa_reg = AARCH64_DWARF_SP } }
 
-/*
- * Skip one uleb128/sleb128 encoded quantity from the opcode stream. All bytes
- * except the last one have bit #7 set.
- */
-static __always_inline int skip_xleb128(const u8 **opcode, int *size)
+static __always_inline int eh_frame_read_uleb128(const u8 **opcode, int *size,
+						 u64 *val)
 {
+	unsigned int shift = 0;
+	u64 res = 0;
 	u8 c;
 
 	do {
-		if (*size <= 0)
+		if (*size <= 0 || shift >= 64)
 			return EDYNSCS_INVALID_CFA_OPCODE;
 		c = *(*opcode)++;
 		(*size)--;
+		if (shift == 63 && c > 1)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		res |= (u64)(c & 0x7f) << shift;
+		shift += 7;
 	} while (c & BIT(7));
 
+	*val = res;
+	return 0;
+}
+
+static __always_inline int eh_frame_read_sleb128(const u8 **opcode, int *size,
+						 s64 *val)
+{
+	unsigned int shift = 0;
+	u64 res = 0;
+	u8 c;
+
+	do {
+		if (*size <= 0 || shift >= 64)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		c = *(*opcode)++;
+		(*size)--;
+		if (shift == 63 && c != 0x00 && c != 0x7f)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		res |= (u64)(c & 0x7f) << shift;
+		shift += 7;
+	} while (c & BIT(7));
+
+	if (shift < 64 && (c & BIT(6)))
+		res |= ~0ULL << shift;
+
+	*val = (s64)res;
 	return 0;
 }
 
+static __always_inline void eh_frame_set_reg_rule(struct eh_frame_reg_state *r,
+						  u64 reg, u8 rule, s64 off)
+{
+	if (reg == AARCH64_DWARF_FP) {
+		r->fp_rule = rule;
+		r->fp_off = off;
+	} else if (reg == AARCH64_DWARF_LR) {
+		r->lr_rule = rule;
+		r->lr_off = off;
+	}
+}
+
+static __always_inline void eh_frame_restore_reg(struct eh_frame_reg_state *r,
+						 const struct eh_frame_reg_state *cie,
+						 u64 reg)
+{
+	if (reg == AARCH64_DWARF_FP) {
+		r->fp_rule = cie->fp_rule;
+		r->fp_off = cie->fp_off;
+	} else if (reg == AARCH64_DWARF_LR) {
+		r->lr_rule = cie->lr_rule;
+		r->lr_off = cie->lr_off;
+	}
+}
+
 static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
 						const struct eh_frame_fde_iter *it,
 						struct eh_frame_cfi_state *st)
 {
+	u64 ureg, uoff;
+	s64 soff;
 	u8 op;
 
 	if (*size <= 0)
@@ -137,8 +232,18 @@ static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
 
 	switch (op) {
 	case DW_CFA_nop:
+		break;
+
 	case DW_CFA_remember_state:
+		if (st->stack_depth >= EH_FRAME_STATE_STACK_MAX)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->stack[st->stack_depth++] = st->reg;
+		break;
+
 	case DW_CFA_restore_state:
+		if (!st->stack_depth)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg = st->stack[--st->stack_depth];
 		break;
 
 	case DW_CFA_advance_loc1:
@@ -168,18 +273,106 @@ static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
 		*size -= 4;
 		break;
 
-	case DW_CFA_def_cfa:
 	case DW_CFA_offset_extended:
-		if (skip_xleb128(opcode, size))
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_uleb128(opcode, size, &uoff))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_OFFSET,
+				      (s64)uoff * it->data_align);
+		break;
+
+	case DW_CFA_offset_extended_sf:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_sleb128(opcode, size, &soff))
 			return EDYNSCS_INVALID_CFA_OPCODE;
-		fallthrough;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_OFFSET,
+				      soff * it->data_align);
+		break;
+
+	case DW_CFA_restore_extended:
+		if (eh_frame_read_uleb128(opcode, size, &ureg))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_restore_reg(&st->reg, &it->cie_reg, ureg);
+		break;
+
+	case DW_CFA_same_value:
+		if (eh_frame_read_uleb128(opcode, size, &ureg))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_UNMODIFIED, 0);
+		break;
+
+	case DW_CFA_undefined:
+		if (eh_frame_read_uleb128(opcode, size, &ureg))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_UNSUPPORTED, 0);
+		break;
+
+	case DW_CFA_register:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_uleb128(opcode, size, &uoff))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_UNSUPPORTED, 0);
+		break;
+
+	case DW_CFA_def_cfa:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_uleb128(opcode, size, &uoff) ||
+		    ureg >= U32_MAX)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg.cfa_reg = ureg;
+		st->reg.cfa_off = (s64)uoff;
+		break;
+
+	case DW_CFA_def_cfa_sf:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_sleb128(opcode, size, &soff) ||
+		    ureg >= U32_MAX)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg.cfa_reg = ureg;
+		st->reg.cfa_off = soff * it->data_align;
+		break;
+
+	case DW_CFA_def_cfa_register:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    ureg >= U32_MAX)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg.cfa_reg = ureg;
+		break;
+
 	case DW_CFA_def_cfa_offset:
+		if (eh_frame_read_uleb128(opcode, size, &uoff))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg.cfa_off = (s64)uoff;
+		break;
+
 	case DW_CFA_def_cfa_offset_sf:
-	case DW_CFA_def_cfa_register:
-	case DW_CFA_same_value:
-	case DW_CFA_restore_extended:
-	case 0x80 ... 0xbf: /* DW_CFA_offset */
-		if (skip_xleb128(opcode, size))
+		if (eh_frame_read_sleb128(opcode, size, &soff))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->reg.cfa_off = soff * it->data_align;
+		break;
+
+	case DW_CFA_def_cfa_expression:
+		if (eh_frame_read_uleb128(opcode, size, &uoff) ||
+		    uoff > (u64)*size)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		*opcode += uoff;
+		*size -= uoff;
+		st->reg.cfa_reg = U32_MAX;
+		break;
+
+	case DW_CFA_expression:
+	case DW_CFA_val_expression:
+		if (eh_frame_read_uleb128(opcode, size, &ureg) ||
+		    eh_frame_read_uleb128(opcode, size, &uoff) ||
+		    uoff > (u64)*size)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		*opcode += uoff;
+		*size -= uoff;
+		eh_frame_set_reg_rule(&st->reg, ureg, EH_REG_UNSUPPORTED, 0);
+		break;
+
+	case DW_CFA_GNU_args_size:
+		if (eh_frame_read_uleb128(opcode, size, &uoff))
 			return EDYNSCS_INVALID_CFA_OPCODE;
 		break;
 
@@ -191,7 +384,15 @@ static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
 		st->loc += (op & 0x3f) * it->code_align;
 		break;
 
+	case 0x80 ... 0xbf: /* DW_CFA_offset (reg in low 6 bits) */
+		if (eh_frame_read_uleb128(opcode, size, &uoff))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		eh_frame_set_reg_rule(&st->reg, op & 0x3f, EH_REG_OFFSET,
+				      (s64)uoff * it->data_align);
+		break;
+
 	case 0xc0 ... 0xff: /* DW_CFA_restore (reg in low 6 bits) */
+		eh_frame_restore_reg(&st->reg, &it->cie_reg, op & 0x3f);
 		break;
 
 	default:
@@ -204,7 +405,14 @@ static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
 static __always_inline int eh_frame_parse_cie(const struct eh_frame *frame,
 					      struct eh_frame_fde_iter *it)
 {
-	if (sizeof(frame->size) + frame->size < sizeof(*frame))
+	struct eh_frame_cfi_state cie_st = {
+		.reg = { .cfa_reg = AARCH64_DWARF_SP },
+	};
+	const u8 *opcode;
+	int size, ret;
+
+	if (sizeof(frame->size) + frame->size <
+	    offsetof(struct eh_frame, cie_opcodes))
 		return EDYNSCS_INVALID_CIE_HEADER;
 
 	/*
@@ -225,6 +433,9 @@ static __always_inline int eh_frame_parse_cie(const struct eh_frame *frame,
 		return EDYNSCS_INVALID_CIE_HEADER;
 
 	it->code_align = frame->code_alignment_factor;
+	it->data_align = (frame->data_alignment_factor & BIT(6)) ?
+			 (int)frame->data_alignment_factor - 128 :
+			 frame->data_alignment_factor;
 
 	switch (frame->fde_pointer_format) {
 	case DW_EH_PE_pcrel | DW_EH_PE_sdata4:
@@ -237,6 +448,18 @@ static __always_inline int eh_frame_parse_cie(const struct eh_frame *frame,
 		return EDYNSCS_INVALID_CIE_SDATA_SIZE;
 	}
 
+	it->cie_reg = cie_st.reg;
+	opcode = frame->cie_opcodes;
+	size = (int)(sizeof(frame->size) + frame->size -
+		     offsetof(struct eh_frame, cie_opcodes));
+
+	while (size > 0) {
+		ret = eh_frame_step_opcode(&opcode, &size, it, &cie_st);
+		if (ret)
+			return ret;
+	}
+
+	it->cie_reg = cie_st.reg;
 	it->cie = frame;
 	return 0;
 }
diff --git a/arch/arm64/kernel/pi/patch-scs.c b/arch/arm64/kernel/pi/patch-scs.c
index b240144f7d80e..f4264dda828f7 100644
--- a/arch/arm64/kernel/pi/patch-scs.c
+++ b/arch/arm64/kernel/pi/patch-scs.c
@@ -61,6 +61,7 @@ static int scs_handle_fde_frame(const struct eh_frame_fde_iter *it,
 		.loc = it->use_sdata8 ?
 		       (u64)&frame->initial_loc64 + frame->initial_loc64 :
 		       (u64)offset_to_ptr(&frame->initial_loc),
+		.reg = it->cie_reg,
 	};
 	const u8 *opcode;
 	int size, ret;
-- 
2.56.0.679.gc527c65306-goog

