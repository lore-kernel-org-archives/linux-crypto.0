Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024325;
	b=abK8MduZ7UiDo5Q2dhyM6/I6gMKEEMjE7E8ryep+jiZIygM5XECKG1gEmKVR0CMMzH33
	 fr9/Wj1nAWswJD0pnnJHFOvSDjQsDaJzgX8Ei9GLvBOwVorLQOqDnC3vf/kliDcHL70cy
	 4DRSQkwsWOup6v6mqyS4UlLa8kmUe4J9iWvlhntsbNaLDJ6gwmfNs7iNxIiR+ki7UL20I
	 6TB0zbJt7lGme6yTKMckugaSFSHkprjJ1wYuZrv3EOrY5xC1l1MrtVF4z7wq3vtsJ1QFn
	 1sbZPvpZt4oobBqAqhunNfl18GvK76zLWMB5e7/CubL3v4OG4SKFsvPZekmc8uZjKIg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024325;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kiASrWI0uoJRMk9S73U2RxVLSDv/VMJzAWczcwrDMt4=;
	b=iQhKeI/4WkWESOM7n9KIfjs7/2YbNOJzPCBI2Au+4gtGb4/jDEHqsuag9qGlDP9ySyZL
	 kJRHUNrFmsZT+posrv2S8BnmG907AFcbNjy3BqNpppl3mS8jNV5bhfctGhJFQmrGVZGuw
	 WNEO+1hHWo1antEk9NW/6mO2QGrDPjiJVf09Bavy0CuR8e2GRmDarowx0+FvoBdXNpcTR
	 gz8Tv+T/rcdQtDt6jzNUySXQWZ6H7qbvJS4ptluEnSjozxIXTal6992xx/NqJN2g3mXdr
	 EhHffzQMWbZUPY+Ui+U8uyWSivXsbaFyV93+Tx+upVwegA4FvM0/pS/H4pZA3g5vIWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPPYBZV0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F0560A2629;
	Wed, 18 Nov 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kPPYBZV0
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795024325;
	b=yloBw1YmyLCJeYpflyPl6r2lP8q5yNpwcaQ4KnrKcPov7aGqUagEgCrvC1SLi/YVl45k
	 +qJezSN1Ua3R5miWW8WHRG89d1j7B01kmizFN3F6KFc5BjmgP4GJnyY/UZeAkyzK82yXj
	 xnyhWaZplmiXO4mJuDHchJMKXvO2UgD/aT9Qa1nuxwA1w1ev46ZfN5l2T/9T01BJagSt/
	 vxIQ2UB6onoikqOdp7rjOAMqf3a0yT1b8HTycuhwekVFFN+IaMG5csyppuUuFFZieFl2p
	 zhEQ8aDsKBccuh8NctPCeq7cDhGtWGhYXqKvlsT2goInpH7BwcDDg1H+y5BvVaAvxxw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795024325;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kiASrWI0uoJRMk9S73U2RxVLSDv/VMJzAWczcwrDMt4=;
	b=trQWiMC38hLTSN/6xZkqp/dBJwfGnBFYObWbodsYWPsreUfq9IL73y5+ysSn//coV5OT
	 Tr7luX1Y5Aa3yq6B9QGlH6zhd/PR1ObVPmOy1wI72JDb244FHIT/Ltv2tE8Y0oslnp1IJ
	 JmUWcI+k80XEXIOhEs3cMUSGogAqiE6b4JupR3os1OXlFnu1pwbQmNgfb0XmGh7k8GRRt
	 f6BhJayG+dc11PM8QR2p4ulSnYWSiCj7K+yHDKTdUijdPj235lal8gT5O3HFQAzRRgZ9u
	 KVEFfWJicV5cRVrAGd/iP0HkJdGlaSey+YC+nqJFqvhfEbipX+HprSAtp5BpG0aLcsg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5992A1F000C5;
	Wed, 18 Nov 2026 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024325;
	bh=kiASrWI0uoJRMk9S73U2RxVLSDv/VMJzAWczcwrDMt4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kPPYBZV0QK+/21wSFiTvFbJGbKfrYewXZOdKUy1ltlIKLIhQQWrM3IU2aH43oWyIB
	 pwulFOwau+01r5LKxn1ztEfPB/5IFtMFMOJzEFcqamVohfyr0yRGn1vCgU/+9/chFE
	 0/S/7M5yibgh20rr3FThkkyhpwKeSN/LxGIVfWs18EQ1IDZTlKPO3Sn2KSCSmtYSyp
	 idAw52rMpPZPK4kFF15+0gGfP/HOi+JUfE8txfUQDef6rtmEY1TD7f07oVQy+gK+30
	 gfAB0NTbMfXarkAWSD0RSLZE+RwEIzH00mj+Q9+ErPIN4d0vJvO7vYfqPzbbqa8fP1
	 6PNNehAPJY8Pw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D59024AF11;
	Wed, 18 Nov 2026 17:52:01 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Wed, 18 Nov 2026 09:51:47 -0800
Subject: [PATCH v9 3/5] crypto: cmh - add key/datastore infrastructure
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
Message-Id: <20261118-cmh-b4-a-v9-v9-3-70385613fd50@rambus.com>
References: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
In-Reply-To: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795024320; l=14234;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=aBs+nocUJdIRphtZyCEZOKdyqMdDMfSvXq4qG7B1gPw=;
 b=a1No3NnVnBMDd06qhfTqfV7KCcp7ZIy3wmnNsC7EY9L2dALRmoprvgFXhgqVQTdCPOECMwiRw
 kUsni1kVHBACjdF5rKctL9m7If5kjEVZiVRKGViF2jNTNzjKQSAdWXs
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
 drivers/crypto/cmh/cmh_key.c         | 152 +++++++++++++++++++++++++++++++++++
 drivers/crypto/cmh/cmh_sys.c         |  58 +++++++++++++
 drivers/crypto/cmh/include/cmh_key.h |  76 ++++++++++++++++++
 drivers/crypto/cmh/include/cmh_sys.h |  23 ++++++
 5 files changed, 312 insertions(+), 1 deletion(-)

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
index 000000000000..0990e25f4dad
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_key.c
@@ -0,0 +1,152 @@
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
+ * - SYS_REF_TEMP lifetime:  a temporary object lives in a per-mailbox
+ *   area until a command consumes it or the area is reset (a SYS flush
+ *   or MBX_COMMAND_FLUSH); it is not tied to a VCQ.  The driver packs
+ *   SYS_CMD_WRITE into every VCQ to re-provision the raw key for each
+ *   operation.
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
+ * march toward exhaustion (SYS_CMD_WRITE to SYS_REF_TEMP then fails) and
+ * could shadow a live object.  Never carry SYS_REF_TEMP across VCQs
+ * here.  A VCQ that fails between the write and the key-load leaves its
+ * object behind: RESTART does not reclaim it.
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
+ * If the device may still be reading memory (cmh_tm_dma_quiescent() is
+ * false: a retired mailbox, or an abandoned synchronous command still on
+ * the device), the key buffer is zeroed and quarantined instead of freed,
+ * since such a VCQ may still reference it.
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
+			/*
+			 * The device may still read this mapping, so it is not
+			 * freed.  Wiping it first is a CPU write to a buffer
+			 * the device may still own, contrary to the DMA API
+			 * ownership rule, and deliberate: a late device read
+			 * then sees zeros or the old key, and its result lands
+			 * in quarantined memory, while without the wipe the key
+			 * would stay in memory if the quarantine is never
+			 * released.  A SWIOTLB bounce copy is not wiped.
+			 */
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
index 000000000000..eb8fe44b1cd9
--- /dev/null
+++ b/drivers/crypto/cmh/cmh_sys.c
@@ -0,0 +1,58 @@
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
+ *   SYS_REF_TEMP   -- Temporary objects in a small per-mailbox area.
+ *                      Held until a command consumes them or a SYS
+ *                      flush or mailbox FLUSH resets the area, so they
+ *                      can outlive the VCQ that created them (see
+ *                      cmh_key.c).  Used for raw-key provisioning.
+ *
+ *   SYS_REF_PERSIST -- Persistent objects.  Survive across slots;
+ *                      a grant with no access wipes one, but its space
+ *                      is reclaimed only by a device reset.  Identified
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


