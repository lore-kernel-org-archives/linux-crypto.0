From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 2/3] SHA1 for PPC/SPE - glue
Date: Tue, 24 Feb 2015 20:36:45 +0100
Message-ID: <3ab70d1a-8390-4923-b043-49e789680126@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-89434071-bd15-4180-961a-50b1dadc6dd1"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:19771 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752769AbbBXTgr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 14:36:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-89434071-bd15-4180-961a-50b1dadc6dd1
Content-Type: text/plain

[PATCH v1 2/3] SHA1 for PPC/SPE - glue

Glue code for crypto infrastructure. Call the assembler
code where required. Disable preemption during calculation
and enable SPE instructions in the kernel prior to the 
call. Avoid to disable preemption for too long.

Take a little care about small input data. Kick out early
for input chunks < 64 bytes and replace memset for context
cleanup with simple loop. 

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/sha1_spe_glue.c b/arch/powerpc/sha1_spe_glue.c
new file mode 100644
index 0000000..3e1d222
--- /dev/null
+++ b/arch/powerpc/sha1_spe_glue.c
@@ -0,0 +1,210 @@
+/*
+ * Glue code for SHA-1 implementation for SPE instructions (PPC)
+ *
+ * Based on generic implementation.
+ *
+ * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include <crypto/sha.h>
+#include <asm/byteorder.h>
+#include <asm/switch_to.h>
+#include <linux/hardirq.h>
+
+/*
+ * MAX_BYTES defines the number of bytes that are allowed to be processed
+ * between preempt_disable() and preempt_enable(). SHA1 takes ~1000
+ * operations per 64 bytes. e500 cores can issue two arithmetic instructions
+ * per clock cycle using one 32/64 bit unit (SU1) and one 32 bit unit (SU2).
+ * Thus 2KB of input data will need an estimated maximum of 18,000 cycles.
+ * Headroom for cache misses included. Even with the low end model clocked
+ * at 667 MHz this equals to a critical time window of less than 27us.
+ *
+ */
+#define MAX_BYTES 2048
+
+extern void ppc_spe_sha1_transform(u32 *state, const u8 *src, u32 blocks);
+
+static void spe_begin(void)
+{
+	/* We just start SPE operations and will save SPE registers later. */
+	preempt_disable();
+	enable_kernel_spe();
+}
+
+static void spe_end(void)
+{
+	/* reenable preemption */
+	preempt_enable();
+}
+
+static inline void ppc_sha1_clear_context(struct sha1_state *sctx)
+{
+	int count = sizeof(struct sha1_state) >> 2;
+	u32 *ptr = (u32 *)sctx;
+
+	/* make sure we can clear the fast way */
+	BUILD_BUG_ON(sizeof(struct sha1_state) % 4);
+	do { *ptr++ = 0; } while (--count);
+}
+
+static int ppc_spe_sha1_init(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SHA1_H0;
+	sctx->state[1] = SHA1_H1;
+	sctx->state[2] = SHA1_H2;
+	sctx->state[3] = SHA1_H3;
+	sctx->state[4] = SHA1_H4;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static int ppc_spe_sha1_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	const unsigned int offset = sctx->count & 0x3f;
+	const unsigned int avail = 64 - offset;
+	unsigned int bytes;
+	const u8 *src = data;
+
+	if (avail > len) {
+		sctx->count += len;
+		memcpy((char *)sctx->buffer + offset, src, len);
+		return 0;
+	}
+
+	sctx->count += len;
+
+	if (offset) {
+		memcpy((char *)sctx->buffer + offset, src, avail);
+
+		spe_begin();
+		ppc_spe_sha1_transform(sctx->state, (const u8 *)sctx->buffer, 1);
+		spe_end();
+
+		len -= avail;
+		src += avail;
+	}
+
+	while (len > 63) {
+		bytes = (len > MAX_BYTES) ? MAX_BYTES : len;
+		bytes = bytes & ~0x3f;
+
+		spe_begin();
+		ppc_spe_sha1_transform(sctx->state, src, bytes >> 6);
+		spe_end();
+
+		src += bytes;
+		len -= bytes;
+	};
+
+	memcpy((char *)sctx->buffer, src, len);
+	return 0;
+}
+
+static int ppc_spe_sha1_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	const unsigned int offset = sctx->count & 0x3f;
+	char *p = (char *)sctx->buffer + offset;
+	int padlen;
+	__be64 *pbits = (__be64 *)(((char *)&sctx->buffer) + 56);
+	__be32 *dst = (__be32 *)out;
+
+	padlen = 55 - offset;
+	*p++ = 0x80;
+
+	spe_begin();
+
+	if (padlen < 0) {
+		memset(p, 0x00, padlen + sizeof (u64));
+		ppc_spe_sha1_transform(sctx->state, sctx->buffer, 1);
+		p = (char *)sctx->buffer;
+		padlen = 56;
+	}
+
+	memset(p, 0, padlen);
+	*pbits = cpu_to_be64(sctx->count << 3);
+	ppc_spe_sha1_transform(sctx->state, sctx->buffer, 1);
+
+	spe_end();
+
+	dst[0] = cpu_to_be32(sctx->state[0]);
+	dst[1] = cpu_to_be32(sctx->state[1]);
+	dst[2] = cpu_to_be32(sctx->state[2]);
+	dst[3] = cpu_to_be32(sctx->state[3]);
+	dst[4] = cpu_to_be32(sctx->state[4]);
+
+	ppc_sha1_clear_context(sctx);
+	return 0;
+}
+
+static int ppc_spe_sha1_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int ppc_spe_sha1_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	ppc_spe_sha1_init,
+	.update		=	ppc_spe_sha1_update,
+	.final		=	ppc_spe_sha1_final,
+	.export		=	ppc_spe_sha1_export,
+	.import		=	ppc_spe_sha1_import,
+	.descsize	=	sizeof(struct sha1_state),
+	.statesize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name=	"sha1-ppc-spe",
+		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static int __init ppc_spe_sha1_mod_init(void)
+{
+	return crypto_register_shash(&alg);
+}
+
+static void __exit ppc_spe_sha1_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(ppc_spe_sha1_mod_init);
+module_exit(ppc_spe_sha1_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm, SPE optimized");
+
+MODULE_ALIAS_CRYPTO("sha1");
+MODULE_ALIAS_CRYPTO("sha1-ppc-spe");

------=_NextPartTM-000-89434071-bd15-4180-961a-50b1dadc6dd1
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-89434071-bd15-4180-961a-50b1dadc6dd1--
