Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329562;
	b=HJuC88VH6H9Wp5J5APXFrf2XOJUHD1pVVJyEPUS5mNLC3gc5iRUf5o2ue6VTM8iXFk/y
	 vz0O/P7/at0T62qkSPqU9+sEkYSvVUTIfBMHpV0GK3XYZtb3pwKM9NdY/lK/ZS38J4irQ
	 EVEOlG6fUY0+f5ro+mjyyhjxwvzR8+YhmaY3ahYyMlsJI9BbP5Aun3l/zMoEIH9kEINRB
	 GQRygG3723h+CWhXKNl+VY8ra9xex7+viF2mDck+c2FEg1K4ODcfZm6RHrrXOBfCakQkJ
	 ptVh6mR+mF2lM503z3KthHsccjem8pugqtxmpeTYuRLBepnbjWSUE0gUAkPjTp1cImg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329562;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gnt07gPHg3Xvth1LKoJnvhhg4qt6TeG76NcoQbxMJZE=;
	b=S3ArF0SkUv2UZehrw8frrIvCjUcfMEvnJm8IdbTqKkn2EajfLEtttiCKQlbwSdj4H+qW
	 UyMfEQQ+dmWlRwL7NRll8bXuDJTLAVF7vhpt+I/RHRqhlih94ploRldn37S3DI35P4aNA
	 CaQwJXXLIS2GEPZ8GRwl9YPSZtg0YyS7sWc6Yj2H8Vw/54SY3ZfYGjrtmydYWde79/KJj
	 cQnRIS5o38YSfr3rIGyzLqFxRJmHDQyPOtyXnz8TKdljpRkaCS0Z5cRJtb67G4wJ3pRix
	 M+eY0XZMoiYWL8fksahSy7WksJlV2hdCUzmDtwmM35aYZViHKGvWo25sCQDakS6wu7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mb0aCIeC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279E60A260D;
	Tue, 10 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mb0aCIeC
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794329561;
	b=CzVVAP0UA0bSaDYUzGZFOGiKS8MKHgtFpQbGHp6qxtdsh6NFWrC3nR48aYy56C2WTHE5
	 JfV9+c5wFQieUCnDvmKcutD88E2iP3UyPpHd6X60qD3wOv2h9O1sBOtY3wMUAKutWOJT5
	 le9dR+remZ6q8I9rLZOSThBN7zzdhTib3oZR6cHAg3nc9QKvGrmI640n/JYLMrIQ4VTRV
	 FTeybp87DnHwtczxFCOExtjOQ7bdAXYhGT2aHuTZlWwZDG5pTVCaaP9Rt85U67MzCjbTs
	 KAi5EsvacnKy+tYpw7wwKTv5X5bRs02fi/5Z+qX8BEmyoizUvJfY+1QGhu0XeT/sqTw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794329561;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gnt07gPHg3Xvth1LKoJnvhhg4qt6TeG76NcoQbxMJZE=;
	b=tDlgulEuWkiCzE12U8ArVWmd0Bp2lzYmciP8pQgV0oP935edfoMq9hhmJwX/hpMfsGfR
	 avHIWQrTxa4O3ca2aXq3HkTb+qQM4OWi7/Z/1xHQYcpK6Uy1im3Tn/fL3xhXDvvhvgME6
	 YePrvPzxMBdg8oXdrhLQBJ5rBzqnTRj29FjusE0l7OSwz15Nogpav2dFirEaPqhXdFYSq
	 0gbUrbLY29z9q/HVJgrItZMUxLYldJXoY3p8fvClMas6CPoyMUgnXy185jyIIlKXs7hKx
	 +PAkIwq+XA7rzyh15tJIo7z+tiiBIBTyLRDIkiPHf1iDwAZxlCm+mbYu0AdbYn4ZIUg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DE38F1F008A4;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329561;
	bh=gnt07gPHg3Xvth1LKoJnvhhg4qt6TeG76NcoQbxMJZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Mb0aCIeCycxtH4aAHfVkLeUeRCV/avGZzaieUwRzr1wtrcGMqUyRNrvrZFWamVQ8B
	 xd/GhgkSJweK97Gdmw2SgTeuoz76D4eBXnDMIsnHJ+5EDibPeWt1Fp2bBNWwNXgGzP
	 t88qEQGx65w1PN1LA4pOr51bgd3tUX7xD4SnvnpusE5hn8eh8Lo+i6rl5KQbsT1CAH
	 CYc4NaSoaPrH2P6Z78Y6Vmm+nGLGxD8Zfe1wZt8kC+k849K/6Cu5Tjbk7cwmucPpVa
	 MKto5G/bM0ihc8VSnz9Pnb1Wh99gF63YivTIs3EfcbdMs6BA22rP9htWt1zfKJcxQW
	 /bp8XjXvl0knQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 63FD548C16;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Tue, 10 Nov 2026 08:52:29 -0800
Subject: [PATCH v8 3/5] crypto: cmh - add key/datastore infrastructure
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261110-cmh-b4-a-v8-v8-3-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
In-Reply-To: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>, 
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Alex Ousherovitch <aousherovitch@rambus.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794329557; l=13348;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=NxFHYhB45wpdpCnZMVEI2Jkh27Zyd+QBeiq28XOoiWo=;
 b=gIEDozxFh4p3gFEYXtLX3P6JOtKgVVvH3CiaGM1Kfg3BhWmxsIHyslEB9UdxLibogG/3YD5UK
 JraNAxLGnm1DYOpzpAjdnnT/95BEFRtWSCG2rGNuzNr0MMfdCvT3hAM
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com
Content-Transfer-Encoding: 7bit

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add the CMH key and datastore (system object) layer shared by the
algorithm drivers.  cmh_key.c stages a raw key into a per-transform
context and DMA-maps it for the lifetime of the transform; cmh_sys.c
builds the SYS_WRITE datastore command that loads such a key into the
per-mailbox temporary datastore slot (SYS_REF_TEMP) of a request's VCQ.

The AES driver that follows is the first user.  Builders for the other
SYS datastore commands are added together with the drivers that use
them.  No crypto API algorithm is registered by this patch.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
---
 drivers/crypto/cmh/Makefile          |   4 +-
 drivers/crypto/cmh/cmh_key.c         | 138 +++++++++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_sys.c         |  56 ++++++++++++++
 drivers/crypto/cmh/include/cmh_key.h |  76 +++++++++++++++++++
 drivers/crypto/cmh/include/cmh_sys.h |  23 ++++++
 5 files changed, 296 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cmh/Makefile b/drivers/crypto/cmh/Makefile
index 742e65e3917e..485247405cb2 100644
--- a/drivers/crypto/cmh/Makefile
+++ b/drivers/crypto/cmh/Makefile
@@ -12,7 +12,9 @@ cmh-y := \
 	cmh_txn.o \
 	cmh_rh.o \
 	cmh_dma.o \
-	cmh_sysfs.o
+	cmh_sysfs.o \
+	cmh_sys.o \
+	cmh_key.o
 
 ccflags-y += -I$(src)/include
 
diff --git a/drivers/crypto/cmh/cmh_key.c b/drivers/crypto/cmh/cmh_key.c
new file mode 100644
index 000000000000..b9a8e571e856
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_key.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Raw key context
+ *
+ * Keys come from the crypto API .setkey() as raw key bytes:
+ *
+ * Raw key:  key bytes -> stored in tfm context ->
+ *   SYS_CMD_WRITE(SYS_REF_TEMP) packed into every crypto VCQ.
+ *   The raw key buffer is DMA-mapped once at setkey time and remains
+ *   mapped for the lifetime of the transform (unmapped in destroy).
+ *
+ * Raw key DMA lifetime rationale
+ * ------------------------------
+ * Raw keys are DMA-mapped at setkey time and the mapping persists
+ * until the transform is destroyed (cmh_key_destroy).  This is a
+ * deliberate design choice, consistent with upstream HW crypto
+ * drivers (CAAM, ccree, CCP) that also map keys at setkey for
+ * transform-lifetime reuse:
+ *
+ *   - The Linux crypto framework expects setkey to prepare the
+ *     transform for repeated encrypt/decrypt calls.  Remapping the
+ *     same key on every request would add DMA API overhead per crypto
+ *     operation with no security benefit.
+ *   - On destroy, kfree_sensitive() scrubs the key buffer and the
+ *     DMA mapping is released.
+ *   - No key material is ever logged; dev_dbg() messages only show
+ *     CIDs (content identifiers), not key bytes.
+ *
+ * Hardware-required behaviors (not driver policy)
+ * ------------------------------------------------
+ * - SYS_REF_TEMP lifetime:  the eSW firmware reclaims temporary
+ *   datastore objects when the mailbox slot is reused.  This is a
+ *   hardware constraint; the driver packs SYS_CMD_WRITE into every
+ *   VCQ to re-provision the raw key for each operation.
+ * - Mailbox flush (SYS_CMD_FLUSH):  reclaims temp-stack space on the
+ *   target MBX.  Required by HW to prevent temp-stack exhaustion
+ *   across multi-VCQ operations.
+ *
+ * Net-zero temp invariant (driver policy that MUST hold)
+ * ------------------------------------------------------
+ * Each crypto VCQ stages its raw key with SYS_CMD_WRITE(SYS_REF_TEMP) and
+ * consumes it in the SAME VCQ (the core key-load drops it on use), leaving
+ * the mailbox temporary memory unchanged.  A mailbox can also carry
+ * commands that keep temporary objects across VCQs; that memory is a
+ * per-mailbox stack that persists until it is freed (by a SYS flush or
+ * MBX_COMMAND_FLUSH), so an op that left a temp object behind would
+ * march toward -ENOMEM and could shadow a live object.  Never carry
+ * SYS_REF_TEMP across VCQs here.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "cmh_key.h"
+#include "cmh_sys.h"
+#include "cmh_txn.h"
+#include "cmh_dma.h"
+#include "cmh_sys_abi.h"
+
+/**
+ * cmh_key_setkey_raw() - Store a raw key in the key context
+ * @ctx: Key context to populate
+ * @key: Pointer to the raw key bytes
+ * @keylen: Length of @key in bytes
+ * @core_id: Logical core ID for SYS_TYPE tagging
+ *
+ * Duplicates the raw key, DMA-maps the copy for the lifetime of the
+ * transform, and stores the mapping in @ctx.  Any previously held key
+ * is destroyed first.
+ *
+ * The DMA mapping persists until cmh_key_destroy() is called (typically
+ * from the algorithm .exit_tfm callback).  This avoids per-request DMA
+ * mapping overhead and matches the setkey-to-destroy lifetime model used
+ * by other upstream HW crypto drivers (CAAM, ccree, CCP).  The key
+ * buffer is freed via kfree_sensitive() on destroy.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int cmh_key_setkey_raw(struct cmh_key_ctx *ctx, const u8 *key,
+		       u32 keylen, u32 core_id)
+{
+	dma_addr_t dma;
+	u8 *copy;
+
+	if (!keylen || !key)
+		return -EINVAL;
+
+	copy = kmemdup(key, keylen, GFP_KERNEL);
+	if (!copy)
+		return -ENOMEM;
+
+	/* Pre-map for the lifetime of the transform */
+	dma = cmh_dma_map_single(copy, keylen, DMA_TO_DEVICE);
+	if (cmh_dma_map_error(dma)) {
+		kfree_sensitive(copy);
+		return -ENOMEM;
+	}
+
+	/* Clean up any previous key */
+	cmh_key_destroy(ctx);
+
+	ctx->mode = CMH_KEY_RAW;
+	ctx->raw.data = copy;
+	ctx->raw.len = keylen;
+	ctx->raw.dma = dma;
+	ctx->raw.sys_type = SYS_TYPE_SET(SYS_TYPE_FLAG_PT, core_id);
+
+	return 0;
+}
+
+/**
+ * cmh_key_destroy() - Destroy and zero-fill a key context
+ * @ctx: Key context to destroy
+ *
+ * For raw keys, unmaps the DMA buffer and securely frees the key material.
+ * If a mailbox was retired while the device may still have been reading
+ * from memory (see cmh_tm_dma_quiescent()), the key buffer is zeroed and
+ * quarantined instead of freed, since a stuck VCQ may still reference it.
+ * Resets the key mode to CMH_KEY_NONE.
+ */
+void cmh_key_destroy(struct cmh_key_ctx *ctx)
+{
+	if (ctx->mode == CMH_KEY_RAW && ctx->raw.data) {
+		if (cmh_tm_dma_quiescent()) {
+			cmh_dma_unmap_single(ctx->raw.dma, ctx->raw.len,
+					     DMA_TO_DEVICE);
+			kfree_sensitive(ctx->raw.data);
+		} else {
+			memzero_explicit(ctx->raw.data, ctx->raw.len);
+			cmh_tm_dma_quarantine_buf(ctx->raw.data, ctx->raw.dma,
+						  ctx->raw.len, DMA_TO_DEVICE);
+		}
+		memzero_explicit(&ctx->raw, sizeof(ctx->raw));
+	}
+	ctx->mode = CMH_KEY_NONE;
+}
diff --git a/drivers/crypto/cmh/cmh_sys.c b/drivers/crypto/cmh/cmh_sys.c
new file mode 100644
index 000000000000..8facf47ca0bb
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_sys.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SYS Core VCQ Builders
+ *
+ * VCQ builder functions for SYS core datastore commands and the other
+ * shared core commands.  Each function populates a single vcq_cmd slot.
+ * Callers assemble complete VCQs by combining header + command(s) +
+ * flush, then submit them through the transaction manager.
+ *
+ * Hardware-required datastore semantics
+ * --------------------------------------
+ * The SYS builders are direct mappings of the eSW firmware SYS core
+ * command set.  The eSW maintains per-mailbox datastore namespaces
+ * with two object classes:
+ *
+ *   SYS_REF_TEMP   -- Temporary objects.  Lifetime is scoped to the
+ *                      current mailbox slot; reclaimed automatically
+ *                      when the slot is reused or on explicit FLUSH.
+ *                      Used for raw-key provisioning on every VCQ.
+ *
+ *   SYS_REF_PERSIST -- Persistent objects.  Survive across slots;
+ *                      require explicit DELETE to reclaim.  Identified
+ *                      by a 64-bit Content ID (CID) and resolved to
+ *                      a per-MBX ref via SYS_CMD_FIND.
+ *
+ * These semantics are hardware requirements, not driver policy.
+ * The per-MBX temp-stack and per-MBX ref namespace are eSW firmware
+ * design constraints that cannot be changed by the kernel driver.
+ */
+
+#include <linux/string.h>
+
+#include "cmh_sys.h"
+
+/**
+ * vcq_add_sys_write() - Build a SYS_WRITE VCQ command
+ * @slot: VCQ command slot to populate
+ * @ref: Datastore object reference handle
+ * @src_dma: DMA address of source data buffer
+ * @wrap_key: Wrapping key reference (0 if none)
+ * @len: Length of data to write in bytes
+ * @sys_type: Datastore object type identifier
+ */
+void vcq_add_sys_write(struct vcq_cmd *slot, u64 ref, u64 src_dma,
+		       u64 wrap_key, u32 len, u32 sys_type)
+{
+	memset(slot, 0, sizeof(*slot));
+	slot->magic = VCQ_CMD_MAGIC;
+	slot->id = VCQ_CMD_ID(CORE_ID_SYS, 0, 1, SYS_CMD_WRITE);
+	slot->hwc.sys.cmd_write.ref = ref;
+	slot->hwc.sys.cmd_write.src = src_dma;
+	slot->hwc.sys.cmd_write.key = wrap_key;
+	slot->hwc.sys.cmd_write.len = len;
+	slot->hwc.sys.cmd_write.type = sys_type;
+}
diff --git a/drivers/crypto/cmh/include/cmh_key.h b/drivers/crypto/cmh/include/cmh_key.h
new file mode 100644
index 000000000000..5df18ff7bfee
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_key.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- Per-transform key context
+ *
+ * Per-transform key context used by the keyed crypto algorithms.  Stores
+ * raw key bytes supplied via the crypto API .setkey() callback: the key
+ * is DMA-mapped once at setkey time and written to SYS_REF_TEMP in every
+ * VCQ.
+ *
+ * Each keyed algorithm driver embeds a struct cmh_key_ctx in its
+ * per-transform context and calls cmh_key_setkey_raw() from its
+ * .setkey() callback.
+ *
+ * Raw-key atomicity (SYS_REF_TEMP)
+ * ---------------------------------
+ * SYS_CMD_WRITE to SYS_REF_TEMP is packed into the same VCQ as the
+ * algorithm command that uses it (e.g. AES_CMD_INIT).  SYS_REF_TEMP
+ * is per-MBX -- the CMH eSW allocates it in the tail of each mailbox's
+ * own VCQ buffer (mbx_alloc_temp), so concurrent raw-key requests on
+ * different MBXes do not interfere.
+ */
+
+#ifndef CMH_KEY_H
+#define CMH_KEY_H
+
+#include <linux/types.h>
+#include "cmh_config.h"
+#include "cmh_vcq.h"
+
+/* Key context mode */
+enum cmh_key_mode {
+	CMH_KEY_NONE = 0,	/* no key set yet */
+	CMH_KEY_RAW,		/* raw key bytes in memory */
+};
+
+/* Per-transform key context */
+struct cmh_key_ctx {
+	enum cmh_key_mode mode;
+	struct {
+		u8 *data;	/* kmemdup'd raw key bytes */
+		u32 len;	/* key length in bytes */
+		u32 sys_type;	/* SYS_TYPE_SET(flags, core_id) */
+		dma_addr_t dma;	/* pre-mapped DMA addr (DMA_TO_DEVICE) */
+	} raw;
+};
+
+/**
+ * cmh_key_setkey_raw() - Store raw key bytes in the transform context
+ * @ctx: Per-transform key context
+ * @key: Raw key bytes
+ * @keylen: Key length in bytes
+ * @core_id: Target algorithm core (e.g. CORE_ID_AES)
+ *
+ * The key is host-supplied plaintext, so it is tagged SYS_TYPE_FLAG_PT
+ * (readable as plaintext), as the eSW tags its own raw-key writes to
+ * SYS_REF_TEMP; the object is consumed in the VCQ that writes it.  The
+ * actual SYS_CMD_WRITE
+ * to SYS_REF_TEMP is deferred to each encrypt/decrypt VCQ, where it
+ * is packed inline for atomicity.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
+int cmh_key_setkey_raw(struct cmh_key_ctx *ctx, const u8 *key,
+		       u32 keylen, u32 core_id);
+
+/**
+ * cmh_key_destroy() - Free key resources
+ * @ctx: Per-transform key context
+ *
+ * Zeroises and frees the raw key buffer, or zeroises and quarantines it
+ * if the device may still be reading memory (see cmh_tm_dma_quiescent()).
+ */
+void cmh_key_destroy(struct cmh_key_ctx *ctx);
+
+#endif /* CMH_KEY_H */
diff --git a/drivers/crypto/cmh/include/cmh_sys.h b/drivers/crypto/cmh/include/cmh_sys.h
new file mode 100644
index 000000000000..4f74dbbfadf3
--- /dev/null
+++ b/drivers/crypto/cmh/include/cmh_sys.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026 Cryptography Research, Inc. (CRI).
+ * CMH LKM -- SYS Core VCQ Builders
+ *
+ * VCQ builder functions for the SYS (datastore) core and the other
+ * cores whose commands are issued by more than one driver.  Each builder
+ * populates one vcq_cmd slot with the appropriate magic, command ID, and
+ * payload.
+ *
+ * Callers combine these with vcq_set_header() + vcq_add_flush()
+ * and submit via cmh_tm_submit_sync().
+ */
+
+#ifndef CMH_SYS_H
+#define CMH_SYS_H
+
+#include "cmh_vcq.h"
+
+void vcq_add_sys_write(struct vcq_cmd *slot, u64 ref, u64 src_dma,
+		       u64 wrap_key, u32 len, u32 sys_type);
+
+#endif /* CMH_SYS_H */

-- 
2.43.7


