Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FE5C433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B0222CBB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 16:50:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbhAEQuS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 11:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729101AbhAEQuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 11:50:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD41E22D0B;
        Tue,  5 Jan 2021 16:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609865355;
        bh=72pNXIvTF5kr80p1Ma+KdL1NJUURfcgv1MnWkT7SZW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkJiohJ2DmfSuoQOzh9LTlaFys7ynhaxeHrPb3Z7/uw6AIFcSil1404tN8/rdQRDr
         5KNNUPL88y8BU50HCzQ3bxTFwxZxgSKwnqQNzcH0+w3r1zR7jGIdS3//rQYacQyWQV
         7vrFe7tTuCynm8BGKAxxjfk+y8M5o72Zyq56ofssSv25DNwBDKt9lKVXM61fhfJsoH
         IxWBN9wKGWreRBlRc6fXNw2O5/8QPQWYQcT+P94K74mo6xaifHCzpNtnZ3jlHrnaJ3
         IEa+o9sO1saNCSmsTFZoJGg9bTdSQOfw9r8L8AIzIQM/LEOYWscheVbCDXCcOqkaxN
         z4TMf1nBtCt1A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 14/21] crypto: x86 - add some helper macros for ECB and CBC modes
Date:   Tue,  5 Jan 2021 17:48:02 +0100
Message-Id: <20210105164809.8594-15-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105164809.8594-1-ardb@kernel.org>
References: <20210105164809.8594-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The x86 glue helper module is starting to show its age:
- It relies heavily on function pointers to invoke asm helper functions that
  operate on fixed input sizes that are relatively small. This means the
  performance is severely impacted by retpolines.
- It goes to great lengths to amortize the cost of kernel_fpu_begin()/end()
  over as much work as possible, which is no longer necessary now that FPU
  save/restore is done lazily, and doing so may cause unbounded scheduling
  blackouts due to the fact that enabling the FPU in kernel mode disables
  preemption.
- The CBC mode decryption helper makes backward strides through the input, in
  order to avoid a single block size memcpy() between chunks. Consuming the
  input in this manner is highly likely to defeat any hardware prefetchers,
  so it is better to go through the data linearly, and perform the extra
  memcpy() where needed (which is turned into direct loads and stores by the
  compiler anyway). Note that benchmarks won't show this effect, given that
  the memory they use is always cache hot.
- It implements blockwise XOR in terms of le128 pointers, which imply an
  alignment that is not guaranteed by the API, violating the C standard.

GCC does not seem to be smart enough to elide the indirect calls when the
function pointers are passed as arguments to static inline helper routines
modeled after the existing ones. So instead, let's create some CPP macros
that encapsulate the core of the ECB and CBC processing, so we can wire
them up for existing users of the glue helper module, i.e., Camellia,
Serpent, Twofish and CAST6.

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/ecb_cbc_helpers.h | 76 ++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/x86/crypto/ecb_cbc_helpers.h b/arch/x86/crypto/ecb_cbc_helpers.h
new file mode 100644
index 000000000000..eaa15c7b29d6
--- /dev/null
+++ b/arch/x86/crypto/ecb_cbc_helpers.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _CRYPTO_ECB_CBC_HELPER_H
+#define _CRYPTO_ECB_CBC_HELPER_H
+
+#include <crypto/internal/skcipher.h>
+#include <asm/fpu/api.h>
+
+/*
+ * Mode helpers to instantiate parameterized skcipher ECB/CBC modes without
+ * having to rely on indirect calls and retpolines.
+ */
+
+#define ECB_WALK_START(req, bsize, fpu_blocks) do {			\
+	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));	\
+	const int __bsize = (bsize);					\
+	struct skcipher_walk walk;					\
+	int err = skcipher_walk_virt(&walk, (req), false);		\
+	while (walk.nbytes > 0) {					\
+		unsigned int nbytes = walk.nbytes;			\
+		bool do_fpu = (fpu_blocks) != -1 &&			\
+			      nbytes >= (fpu_blocks) * __bsize;		\
+		const u8 *src = walk.src.virt.addr;			\
+		u8 *dst = walk.dst.virt.addr;				\
+		u8 __maybe_unused buf[(bsize)];				\
+		if (do_fpu) kernel_fpu_begin()
+
+#define CBC_WALK_START(req, bsize, fpu_blocks)				\
+	ECB_WALK_START(req, bsize, fpu_blocks)
+
+#define ECB_WALK_ADVANCE(blocks) do {					\
+	dst += (blocks) * __bsize;					\
+	src += (blocks) * __bsize;					\
+	nbytes -= (blocks) * __bsize;					\
+} while (0)
+
+#define ECB_BLOCK(blocks, func) do {					\
+	while (nbytes >= (blocks) * __bsize) {				\
+		(func)(ctx, dst, src);					\
+		ECB_WALK_ADVANCE(blocks);				\
+	}								\
+} while (0)
+
+#define CBC_ENC_BLOCK(func) do {					\
+	const u8 *__iv = walk.iv;					\
+	while (nbytes >= __bsize) {					\
+		crypto_xor_cpy(dst, src, __iv, __bsize);		\
+		(func)(ctx, dst, dst);					\
+		__iv = dst;						\
+		ECB_WALK_ADVANCE(1);					\
+	}								\
+	memcpy(walk.iv, __iv, __bsize);					\
+} while (0)
+
+#define CBC_DEC_BLOCK(blocks, func) do {				\
+	while (nbytes >= (blocks) * __bsize) {				\
+		const u8 *__iv = src + ((blocks) - 1) * __bsize;	\
+		if (dst == src)						\
+			__iv = memcpy(buf, __iv, __bsize);		\
+		(func)(ctx, dst, src);					\
+		crypto_xor(dst, walk.iv, __bsize);			\
+		memcpy(walk.iv, __iv, __bsize);				\
+		ECB_WALK_ADVANCE(blocks);				\
+	}								\
+} while (0)
+
+#define ECB_WALK_END()							\
+		if (do_fpu) kernel_fpu_end();				\
+		err = skcipher_walk_done(&walk, nbytes);		\
+	}								\
+	return err;							\
+} while (0)
+
+#define CBC_WALK_END() ECB_WALK_END()
+
+#endif
-- 
2.17.1

