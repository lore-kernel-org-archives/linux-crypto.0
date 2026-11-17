Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794890111;
	b=ou+ehIJKrYhjsJkbHFNeymLDQ7PbC498RB6SCxleQ43NaUw5gTinIFFDc/elL3ydeTpN
	 v1Qvv/DGtsockKCVS2qiryQrpSd08cJgQditEsRSZiPiaPUfSnJRGuXohmm836NRPIx+r
	 YsmT5eEUo0wkGCIOtFvEPwyYHWkynLDZl9fCkmIDpa2+jPOY0FnXkhu/eT3uwZyOtj0Rr
	 w3keZNwCJzAEMvkU4hIQTDqYJscDZtZx8z/7cXEuwUHAnC8dedzjQgeMOgl2+jIs0aufX
	 +zNzWRJYwqrpmeKJ0aIYZNjPWhHY0PsLQ24ozCecdfj3k3nZfFtVd0MHS5vnic83khw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794890111;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=BoRzsqu7GOPq4Dqk3y3lgS/gv/EkkCJiKVH2/gGcSE0=;
	b=CyD7Lm5k+rRBvf6VEMFQSSm+/j7B7iEZddpNxRT4GLSW+TljcIn77YQ1nB494S9C6imC
	 1ZNbcdjpYj6qz8h7v9f4ubEATUnm64JfrYLye7WLn/68XvCm1cdF3zEfn0FoJHpFVYBT0
	 iayorofI02AcwLOEKdV6GnfzYIu7SXVDDlCLOdn7yWJ4M3FkNMcq93juMDptInY9Atjpq
	 8UnyzJI7QN7lc1wC9lOUIHWg7OmJ0LeK6k/WH8Xt7Z667d0x/C6FsN5cVIVk0siJVSFkX
	 1wv9ipNIrL1qvz391mBfWEjvrHOFiT0rykU7R42EtehXmVMaWsT6i87GcsghuPK3kXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AvvIIf8i;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5E3606A89F
	for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 04:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C5E3606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AvvIIf8i
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2eaf8ea208bso32373535ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 20:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794890110; x=1795494910; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BoRzsqu7GOPq4Dqk3y3lgS/gv/EkkCJiKVH2/gGcSE0=;
        b=AvvIIf8ie/N5F6rUMuhw7VTEX3usoCq53IIh+x9t7tjlNtHjBlrsjVNzY+Sg3MtDKa
         kyQulqMdSrgECcFKLMQt8JlWmwDs3DmioNO2P7nvUZ4eMdq0ytL4o2ed6hj8wHDO3UTu
         ohRM2HPI6H0rC/y+4L87QkRh8c7xWaCOjOCM8hlGDdQquE0AaRzrQkzYBnjvYjLG3hXj
         40WkWXHO00qLCs9z5FPOXAtDpqWjtVVS+8KYqJp/WNeK1B4C2sQUDuLm0eBcwn4iJkqj
         pgTcLLk97mpQX3EeWheM3kCkvjky2Irh8Fs6pYTNxYm28j/HPkUxfa41isOKjf0ax3SL
         ZA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794890110; x=1795494910;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BoRzsqu7GOPq4Dqk3y3lgS/gv/EkkCJiKVH2/gGcSE0=;
        b=MOHeRz/1AcMrbyvzEv2g+YtS2k92fBUrqsPHZHhtaaeIFta4jAEyt7ryK/54KUuoh+
         GdcsH6BCeJFZNzapbNccWLy0WYHfTM3p6QAN5lguIxYoLHDDCMVr5eE/CyrLkQ+FdYJU
         P4PqAawkQm1bOC3v68FbEFeNdyiFEqFfVQDfpyDEJWMT5RYdnn9TUvfAgceg94NarO3b
         vyKQFQNzJR56M04n3qibuPnLRtcdmNmXg4KA2xU6FtvAcx/jeuLU5hYIbcWQ/PdhbhCz
         I5fiGwCRKwnH4aai87Yw1VfjToreceX5ELIZcUf2KhAgQXdwOYCVTZiKyAe4LuvZXF+9
         Y6Sw==
X-Forwarded-Encrypted: i=1; AL+hErFz+SkPvzYC+4ooyY45k28yJ/+eIr6S86QLiItuo/E3+0li7C74J9xOobzW+ortCyusw4OsU426xWTwu1c=@vger.kernel.org
X-Gm-Message-State: APuU4Z+zMxdtvNsi8r7tXBY/tM/jV2Iytb38Mn19Zl7m56oyCuzGiNVX
	zuRLwySvecmZ9mbsMVgUpYhWlkGjCgfhLWEE7+9evLbuotrlufHk1d7NmBG15o3q+lCPIiaJXqU
	nh8i4C33my6oX++Y0CjYYntTUiQ==
X-Received: from pltk11.prod.google.com ([2002:a17:902:694b:b0:2eb:50b1:b505])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a83:b0:2ed:fd0:e736 with SMTP id d9443c01a7336-2ee0d66293dmr128863165ad.6.1794890110271;
 Mon, 16 Nov 2026 20:35:10 -0800 (PST)
Date: Tue, 17 Nov 2026 04:34:54 +0000
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
Message-ID: <20261117043504.1021063-3-dylanbhatch@google.com>
Subject: [RFC PATCH 02/12] arm64: factor .eh_frame parser out of patch-scs.c
 into <asm/eh_frame.h>
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

Move the DWARF .eh_frame CIE/FDE iterator and opcode stepper out of
arch/arm64/kernel/pi/patch-scs.c into a shared <asm/eh_frame.h> header
so it can be reused by build-time unwind table generation.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 arch/arm64/include/asm/eh_frame.h | 329 ++++++++++++++++++++++++++++++
 arch/arm64/include/asm/scs.h      |   7 -
 arch/arm64/kernel/pi/patch-scs.c  | 258 +++--------------------
 3 files changed, 358 insertions(+), 236 deletions(-)
 create mode 100644 arch/arm64/include/asm/eh_frame.h

diff --git a/arch/arm64/include/asm/eh_frame.h b/arch/arm64/include/asm/eh_frame.h
new file mode 100644
index 0000000000000..6c17fed1860f1
--- /dev/null
+++ b/arch/arm64/include/asm/eh_frame.h
@@ -0,0 +1,329 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Minimal DWARF .eh_frame CFI parser for arm64.
+ *
+ * This minimal DWARF CFI parser is partially based on the code in
+ * arch/arc/kernel/unwind.c, and on the document below:
+ * https://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/ehframechpt.html
+ */
+#ifndef __ASM_EH_FRAME_H
+#define __ASM_EH_FRAME_H
+
+#include <linux/bits.h>
+#include <linux/compiler.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#ifndef U32_MAX
+#define U32_MAX				((u32)~0U)
+#endif
+
+#define AARCH64_DWARF_LR		30
+
+#define DW_CFA_nop			0x00
+#define DW_CFA_advance_loc1		0x02
+#define DW_CFA_advance_loc2		0x03
+#define DW_CFA_advance_loc4		0x04
+#define DW_CFA_offset_extended		0x05
+#define DW_CFA_restore_extended		0x06
+#define DW_CFA_same_value		0x08
+#define DW_CFA_remember_state		0x0a
+#define DW_CFA_restore_state		0x0b
+#define DW_CFA_def_cfa			0x0c
+#define DW_CFA_def_cfa_register		0x0d
+#define DW_CFA_def_cfa_offset		0x0e
+#define DW_CFA_def_cfa_offset_sf	0x13
+#define DW_CFA_negate_ra_state		0x2d
+
+#define DW_EH_PE_sdata4			0x0b
+#define DW_EH_PE_sdata8			0x0c
+#define DW_EH_PE_pcrel			0x10
+
+enum {
+	EDYNSCS_INVALID_CIE_HEADER		= 1,
+	EDYNSCS_INVALID_CIE_SDATA_SIZE		= 2,
+	EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE	= 3,
+	EDYNSCS_INVALID_CFA_OPCODE		= 4,
+};
+
+struct eh_frame_cfi_state {
+	u64	loc;
+	bool	ra_negated;
+};
+
+struct eh_frame {
+	/*
+	 * The size of this frame if 0 < size < U32_MAX, 0 terminates the list.
+	 */
+	u32	size;
+
+	/*
+	 * The first frame is a Common Information Entry (CIE) frame, followed
+	 * by one or more Frame Description Entry (FDE) frames. In the former
+	 * case, this field is 0, otherwise it is the negated offset relative
+	 * to the associated CIE frame.
+	 */
+	u32	cie_id_or_pointer;
+
+	union {
+		struct { /* CIE */
+			u8	version;
+			char	augmentation_string[3];
+			u8	code_alignment_factor;
+			u8	data_alignment_factor;
+			u8	return_address_register;
+			u8	augmentation_data_size;
+			u8	fde_pointer_format;
+		};
+
+		struct { /* FDE (sdata4) */
+			s32	initial_loc;
+			s32	range;
+			u8	opcodes[];
+		};
+
+		struct { /* FDE (sdata8) */
+			s64	initial_loc64;
+			s64	range64;
+			u8	opcodes64[];
+		};
+	};
+};
+
+struct eh_frame_fde_iter {
+	const u8		*start;
+	const u8		*p;
+	int			size;
+	int			code_align;
+	bool			use_sdata8;
+	const struct eh_frame	*cie;
+	const struct eh_frame	*fde;
+};
+
+#define EH_FRAME_FDE_ITER_INIT(buf, len) \
+	{ .start = (buf), .p = (buf), .size = (len), .code_align = 1 }
+
+/*
+ * Skip one uleb128/sleb128 encoded quantity from the opcode stream. All bytes
+ * except the last one have bit #7 set.
+ */
+static __always_inline int skip_xleb128(const u8 **opcode, int *size)
+{
+	u8 c;
+
+	do {
+		if (*size <= 0)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		c = *(*opcode)++;
+		(*size)--;
+	} while (c & BIT(7));
+
+	return 0;
+}
+
+static __always_inline int eh_frame_step_opcode(const u8 **opcode, int *size,
+						const struct eh_frame_fde_iter *it,
+						struct eh_frame_cfi_state *st)
+{
+	u8 op;
+
+	if (*size <= 0)
+		return EDYNSCS_INVALID_CFA_OPCODE;
+
+	op = *(*opcode)++;
+	(*size)--;
+	st->ra_negated = false;
+
+	switch (op) {
+	case DW_CFA_nop:
+	case DW_CFA_remember_state:
+	case DW_CFA_restore_state:
+		break;
+
+	case DW_CFA_advance_loc1:
+		if (*size < 1)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->loc += *(*opcode)++ * it->code_align;
+		(*size)--;
+		break;
+
+	case DW_CFA_advance_loc2:
+		if (*size < 2)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->loc += ((*opcode)[0] | ((*opcode)[1] << 8)) *
+			   it->code_align;
+		*opcode += 2;
+		*size -= 2;
+		break;
+
+	case DW_CFA_advance_loc4:
+		if (*size < 4)
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		st->loc += (u64)((*opcode)[0] | ((*opcode)[1] << 8) |
+				 ((*opcode)[2] << 16) |
+				 ((u32)(*opcode)[3] << 24)) *
+			   it->code_align;
+		*opcode += 4;
+		*size -= 4;
+		break;
+
+	case DW_CFA_def_cfa:
+	case DW_CFA_offset_extended:
+		if (skip_xleb128(opcode, size))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		fallthrough;
+	case DW_CFA_def_cfa_offset:
+	case DW_CFA_def_cfa_offset_sf:
+	case DW_CFA_def_cfa_register:
+	case DW_CFA_same_value:
+	case DW_CFA_restore_extended:
+	case 0x80 ... 0xbf: /* DW_CFA_offset */
+		if (skip_xleb128(opcode, size))
+			return EDYNSCS_INVALID_CFA_OPCODE;
+		break;
+
+	case DW_CFA_negate_ra_state:
+		st->ra_negated = true;
+		break;
+
+	case 0x40 ... 0x7f: /* DW_CFA_advance_loc (delta in low 6 bits) */
+		st->loc += (op & 0x3f) * it->code_align;
+		break;
+
+	case 0xc0 ... 0xff: /* DW_CFA_restore (reg in low 6 bits) */
+		break;
+
+	default:
+		return EDYNSCS_INVALID_CFA_OPCODE;
+	}
+
+	return 0;
+}
+
+static __always_inline int eh_frame_parse_cie(const struct eh_frame *frame,
+					      struct eh_frame_fde_iter *it)
+{
+	if (sizeof(frame->size) + frame->size < sizeof(*frame))
+		return EDYNSCS_INVALID_CIE_HEADER;
+
+	/*
+	 * Require presence of augmentation data (z) with a specifier for the
+	 * size of the FDE initial_loc and range fields (R), and nothing else.
+	 */
+	if (memcmp(frame->augmentation_string, "zR", 3))
+		return EDYNSCS_INVALID_CIE_HEADER;
+
+	/*
+	 * Require single-byte uleb128/sleb128 alignment factors, LR as the
+	 * return address register, and a 1-byte augmentation payload.
+	 */
+	if ((frame->code_alignment_factor & BIT(7)) ||
+	    (frame->data_alignment_factor & BIT(7)) ||
+	    frame->return_address_register != AARCH64_DWARF_LR ||
+	    frame->augmentation_data_size != 1)
+		return EDYNSCS_INVALID_CIE_HEADER;
+
+	it->code_align = frame->code_alignment_factor;
+
+	switch (frame->fde_pointer_format) {
+	case DW_EH_PE_pcrel | DW_EH_PE_sdata4:
+		it->use_sdata8 = false;
+		break;
+	case DW_EH_PE_pcrel | DW_EH_PE_sdata8:
+		it->use_sdata8 = true;
+		break;
+	default:
+		return EDYNSCS_INVALID_CIE_SDATA_SIZE;
+	}
+
+	it->cie = frame;
+	return 0;
+}
+
+static __always_inline int eh_frame_next_fde(struct eh_frame_fde_iter *it)
+{
+	while (it->size > 4) {
+		const struct eh_frame *frame = (const void *)it->p;
+		const struct eh_frame *cie;
+		const u8 *cie_ptr;
+		size_t min_size;
+		int step, ret;
+
+		if (frame->size == 0 || frame->size == U32_MAX ||
+		    frame->size > (u32)(it->size - sizeof(frame->size)))
+			break;
+
+		if (frame->size < sizeof(frame->cie_id_or_pointer))
+			return EDYNSCS_INVALID_CIE_HEADER;
+
+		step = sizeof(frame->size) + frame->size;
+		it->p += step;
+		it->size -= step;
+
+		if (frame->cie_id_or_pointer == 0) {
+			ret = eh_frame_parse_cie(frame, it);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		cie_ptr = (const u8 *)&frame->cie_id_or_pointer;
+		if (frame->cie_id_or_pointer > (u32)(cie_ptr - it->start))
+			return EDYNSCS_INVALID_CIE_HEADER;
+
+		cie = (const void *)(cie_ptr - frame->cie_id_or_pointer);
+		if (cie != it->cie) {
+			if (cie->cie_id_or_pointer != 0 ||
+			    cie->size == 0 || cie->size == U32_MAX ||
+			    cie->size > (u32)(cie_ptr - (const u8 *)cie -
+					      sizeof(cie->size)))
+				return EDYNSCS_INVALID_CIE_HEADER;
+			ret = eh_frame_parse_cie(cie, it);
+			if (ret)
+				return ret;
+		}
+
+		min_size = it->use_sdata8 ?
+			   offsetof(struct eh_frame, opcodes64) :
+			   offsetof(struct eh_frame, opcodes);
+		if ((size_t)step < min_size)
+			return EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE;
+
+		it->fde = frame;
+		return 0;
+	}
+
+	it->fde = NULL;
+	return 0;
+}
+
+static __always_inline int eh_frame_fde_opcodes(const struct eh_frame *frame,
+						bool use_sdata8,
+						const u8 **opcode_out,
+						int *size_out)
+{
+	size_t hdr_size = use_sdata8 ?
+			  offsetof(struct eh_frame, opcodes64) :
+			  offsetof(struct eh_frame, opcodes);
+	size_t total = sizeof(frame->size) + frame->size;
+	const u8 *opcode = use_sdata8 ? frame->opcodes64 : frame->opcodes;
+	int size, l;
+
+	if (total < hdr_size + 1 || (*opcode & BIT(7)))
+		return EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE;
+
+	size = (int)(total - hdr_size);
+	l = *opcode++;
+	if (l > size - 1)
+		return EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE;
+
+	opcode += l;
+	size -= l + 1;
+
+	*opcode_out = opcode;
+	*size_out = size;
+	return 0;
+}
+
+#endif /* __ASM_EH_FRAME_H */
diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
index a15a2968e7b66..f49fc27a8a9b2 100644
--- a/arch/arm64/include/asm/scs.h
+++ b/arch/arm64/include/asm/scs.h
@@ -54,13 +54,6 @@ static inline void dynamic_scs_init(void)
 static inline void dynamic_scs_init(void) {}
 #endif
 
-enum {
-	EDYNSCS_INVALID_CIE_HEADER		= 1,
-	EDYNSCS_INVALID_CIE_SDATA_SIZE		= 2,
-	EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE	= 3,
-	EDYNSCS_INVALID_CFA_OPCODE		= 4,
-};
-
 int __pi_scs_patch(const u8 eh_frame[], int size, bool skip_dry_run);
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/arm64/kernel/pi/patch-scs.c b/arch/arm64/kernel/pi/patch-scs.c
index 3944ad899021c..b240144f7d80e 100644
--- a/arch/arm64/kernel/pi/patch-scs.c
+++ b/arch/arm64/kernel/pi/patch-scs.c
@@ -9,51 +9,13 @@
 #include <linux/linkage.h>
 #include <linux/types.h>
 
+#include <asm/eh_frame.h>
 #include <asm/scs.h>
 
 #include "pi.h"
 
 bool dynamic_scs_is_enabled;
 
-//
-// This minimal DWARF CFI parser is partially based on the code in
-// arch/arc/kernel/unwind.c, and on the document below:
-// https://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/ehframechpt.html
-//
-
-#define DW_CFA_nop                          0x00
-#define DW_CFA_set_loc                      0x01
-#define DW_CFA_advance_loc1                 0x02
-#define DW_CFA_advance_loc2                 0x03
-#define DW_CFA_advance_loc4                 0x04
-#define DW_CFA_offset_extended              0x05
-#define DW_CFA_restore_extended             0x06
-#define DW_CFA_undefined                    0x07
-#define DW_CFA_same_value                   0x08
-#define DW_CFA_register                     0x09
-#define DW_CFA_remember_state               0x0a
-#define DW_CFA_restore_state                0x0b
-#define DW_CFA_def_cfa                      0x0c
-#define DW_CFA_def_cfa_register             0x0d
-#define DW_CFA_def_cfa_offset               0x0e
-#define DW_CFA_def_cfa_expression           0x0f
-#define DW_CFA_expression                   0x10
-#define DW_CFA_offset_extended_sf           0x11
-#define DW_CFA_def_cfa_sf                   0x12
-#define DW_CFA_def_cfa_offset_sf            0x13
-#define DW_CFA_val_offset                   0x14
-#define DW_CFA_val_offset_sf                0x15
-#define DW_CFA_val_expression               0x16
-#define DW_CFA_lo_user                      0x1c
-#define DW_CFA_negate_ra_state              0x2d
-#define DW_CFA_GNU_args_size                0x2e
-#define DW_CFA_GNU_negative_offset_extended 0x2f
-#define DW_CFA_hi_user                      0x3f
-
-#define DW_EH_PE_sdata4                     0x0b
-#define DW_EH_PE_sdata8                     0x0c
-#define DW_EH_PE_pcrel                      0x10
-
 enum {
 	PACIASP		= 0xd503233f,
 	AUTIASP		= 0xd50323bf,
@@ -61,7 +23,7 @@ enum {
 	SCS_POP		= 0xf85f8e5e,
 };
 
-static void __always_inline scs_patch_loc(u64 loc)
+static __always_inline void scs_patch_loc(u64 loc)
 {
 	u32 insn = le32_to_cpup((void *)loc);
 
@@ -91,211 +53,49 @@ static void __always_inline scs_patch_loc(u64 loc)
 		    :: "r"(loc));
 }
 
-/*
- * Skip one uleb128/sleb128 encoded quantity from the opcode stream. All bytes
- * except the last one have bit #7 set.
- */
-static int __always_inline skip_xleb128(const u8 **opcode, int size)
-{
-	u8 c;
-
-	do {
-		c = *(*opcode)++;
-		size--;
-	} while (c & BIT(7));
-
-	return size;
-}
-
-struct eh_frame {
-	/*
-	 * The size of this frame if 0 < size < U32_MAX, 0 terminates the list.
-	 */
-	u32	size;
-
-	/*
-	 * The first frame is a Common Information Entry (CIE) frame, followed
-	 * by one or more Frame Description Entry (FDE) frames. In the former
-	 * case, this field is 0, otherwise it is the negated offset relative
-	 * to the associated CIE frame.
-	 */
-	u32	cie_id_or_pointer;
-
-	union {
-		struct { // CIE
-			u8	version;
-			u8	augmentation_string[3];
-			u8	code_alignment_factor;
-			u8	data_alignment_factor;
-			u8	return_address_register;
-			u8	augmentation_data_size;
-			u8	fde_pointer_format;
-		};
-
-		struct { // FDE
-			s32	initial_loc;
-			s32	range;
-			u8	opcodes[];
-		};
-
-		struct { // FDE
-			s64	initial_loc64;
-			s64	range64;
-			u8	opcodes64[];
-		};
-	};
-};
-
-static int scs_handle_fde_frame(const struct eh_frame *frame,
-				int code_alignment_factor,
-				bool use_sdata8,
+static int scs_handle_fde_frame(const struct eh_frame_fde_iter *it,
 				bool dry_run)
 {
-	int size = frame->size - offsetof(struct eh_frame, opcodes) + 4;
-	u64 loc = (u64)offset_to_ptr(&frame->initial_loc);
-	const u8 *opcode = frame->opcodes;
-	int l;
-
-	if (use_sdata8) {
-		loc = (u64)&frame->initial_loc64 + frame->initial_loc64;
-		opcode = frame->opcodes64;
-		size -= 8;
-	}
-
-	// assume single byte uleb128_t for augmentation data size
-	if (*opcode & BIT(7))
-		return EDYNSCS_INVALID_FDE_AUGM_DATA_SIZE;
+	const struct eh_frame *frame = it->fde;
+	struct eh_frame_cfi_state st = {
+		.loc = it->use_sdata8 ?
+		       (u64)&frame->initial_loc64 + frame->initial_loc64 :
+		       (u64)offset_to_ptr(&frame->initial_loc),
+	};
+	const u8 *opcode;
+	int size, ret;
 
-	l = *opcode++;
-	opcode += l;
-	size -= l + 1;
+	ret = eh_frame_fde_opcodes(frame, it->use_sdata8, &opcode, &size);
+	if (ret)
+		return ret;
 
 	/*
 	 * Starting from 'loc', apply the CFA opcodes that advance the location
 	 * pointer, and identify the locations of the PAC instructions.
 	 */
-	while (size-- > 0) {
-		switch (*opcode++) {
-		case DW_CFA_nop:
-		case DW_CFA_remember_state:
-		case DW_CFA_restore_state:
-			break;
-
-		case DW_CFA_advance_loc1:
-			loc += *opcode++ * code_alignment_factor;
-			size--;
-			break;
-
-		case DW_CFA_advance_loc2:
-			loc += *opcode++ * code_alignment_factor;
-			loc += (*opcode++ << 8) * code_alignment_factor;
-			size -= 2;
-			break;
-
-		case DW_CFA_advance_loc4:
-			loc += *opcode++ * code_alignment_factor;
-			loc += (*opcode++ << 8) * code_alignment_factor;
-			loc += (*opcode++ << 16) * code_alignment_factor;
-			loc += ((u64)*opcode++ << 24) * code_alignment_factor;
-			size -= 4;
-			break;
-
-		case DW_CFA_def_cfa:
-		case DW_CFA_offset_extended:
-			size = skip_xleb128(&opcode, size);
-			fallthrough;
-		case DW_CFA_def_cfa_offset:
-		case DW_CFA_def_cfa_offset_sf:
-		case DW_CFA_def_cfa_register:
-		case DW_CFA_same_value:
-		case DW_CFA_restore_extended:
-		case 0x80 ... 0xbf:
-			size = skip_xleb128(&opcode, size);
-			break;
-
-		case DW_CFA_negate_ra_state:
-			if (!dry_run)
-				scs_patch_loc(loc - 4);
-			break;
+	while (size > 0) {
+		ret = eh_frame_step_opcode(&opcode, &size, it, &st);
+		if (ret)
+			return ret;
 
-		case 0x40 ... 0x7f:
-			// advance loc
-			loc += (opcode[-1] & 0x3f) * code_alignment_factor;
-			break;
-
-		case 0xc0 ... 0xff:
-			break;
-
-		default:
-			return EDYNSCS_INVALID_CFA_OPCODE;
-		}
+		if (st.ra_negated && !dry_run)
+			scs_patch_loc(st.loc - 4);
 	}
 	return 0;
 }
 
 int scs_patch(const u8 eh_frame[], int size, bool skip_dry_run)
 {
-	int code_alignment_factor = 1;
-	bool fde_use_sdata8 = false;
-	const u8 *p = eh_frame;
-
-	while (size > 4) {
-		const struct eh_frame *frame = (const void *)p;
-		int ret;
-
-		if (frame->size == 0 ||
-		    frame->size == U32_MAX ||
-		    frame->size > size)
-			break;
-
-		if (frame->cie_id_or_pointer == 0) {
-			/*
-			 * Require presence of augmentation data (z) with a
-			 * specifier for the size of the FDE initial_loc and
-			 * range fields (R), and nothing else.
-			 */
-			if (strcmp(frame->augmentation_string, "zR"))
-				return EDYNSCS_INVALID_CIE_HEADER;
+	struct eh_frame_fde_iter it = EH_FRAME_FDE_ITER_INIT(eh_frame, size);
+	int ret;
 
-			/*
-			 * The code alignment factor is a uleb128 encoded field
-			 * but given that the only sensible values are 1 or 4,
-			 * there is no point in decoding the whole thing.  Also
-			 * sanity check the size of the data alignment factor
-			 * field, and the values of the return address register
-			 * and augmentation data size fields.
-			 */
-			if ((frame->code_alignment_factor & BIT(7)) ||
-			    (frame->data_alignment_factor & BIT(7)) ||
-			    frame->return_address_register != 30 ||
-			    frame->augmentation_data_size != 1)
-				return EDYNSCS_INVALID_CIE_HEADER;
+	while (!(ret = eh_frame_next_fde(&it)) && it.fde) {
+		ret = scs_handle_fde_frame(&it, !skip_dry_run);
+		if (ret)
+			return ret;
 
-			code_alignment_factor = frame->code_alignment_factor;
-
-			switch (frame->fde_pointer_format) {
-			case DW_EH_PE_pcrel | DW_EH_PE_sdata4:
-				fde_use_sdata8 = false;
-				break;
-			case DW_EH_PE_pcrel | DW_EH_PE_sdata8:
-				fde_use_sdata8 = true;
-				break;
-			default:
-				return EDYNSCS_INVALID_CIE_SDATA_SIZE;
-			}
-		} else {
-			ret = scs_handle_fde_frame(frame, code_alignment_factor,
-						   fde_use_sdata8, !skip_dry_run);
-			if (ret)
-				return ret;
-
-			if (!skip_dry_run)
-				scs_handle_fde_frame(frame, code_alignment_factor,
-						     fde_use_sdata8, false);
-		}
-
-		p += sizeof(frame->size) + frame->size;
-		size -= sizeof(frame->size) + frame->size;
+		if (!skip_dry_run)
+			scs_handle_fde_frame(&it, false);
 	}
-	return 0;
+	return ret;
 }
-- 
2.56.0.679.gc527c65306-goog

