From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 2/3] crypto: powerpc/md5 - glue
Date: Sun, 1 Mar 2015 19:30:41 +0100
Message-ID: <e51f0b43-7e75-4d33-b2fe-0ba7ef111f54@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-de8a0567-b0e3-48e2-9697-b468d1540729"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:46688 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752173AbbCASan (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 13:30:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-de8a0567-b0e3-48e2-9697-b468d1540729
Content-Type: text/plain

[PATCH v1 2/3] crypto: powerpc/md5 - glue

Glue code for crypto infrastructure. Call the assembler
code where required. Take a little care about small input 
data. Kick out early for input chunks < 64 bytes and replace
memset for context cleanup with simple loop. 

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/md5_glue.c b/arch/powerpc/crypto/md5_glue.c
new file mode 100644
index 0000000..452fb4d
--- /dev/null
+++ b/arch/powerpc/crypto/md5_glue.c
@@ -0,0 +1,165 @@
+/*
+ * Glue code for MD5 implementation for PPC assembler
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
+#include <crypto/md5.h>
+#include <asm/byteorder.h>
+
+extern void ppc_md5_transform(u32 *state, const u8 *src, u32 blocks);
+
+static inline void ppc_md5_clear_context(struct md5_state *sctx)
+{
+	int count = sizeof(struct md5_state) >> 2;
+	u32 *ptr = (u32 *)sctx;
+
+	/* make sure we can clear the fast way */
+	BUILD_BUG_ON(sizeof(struct md5_state) % 4);
+	do { *ptr++ = 0; } while (--count);
+}
+
+static int ppc_md5_init(struct shash_desc *desc)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+
+	sctx->hash[0] = 0x67452301;
+	sctx->hash[1] = 0xefcdab89;
+	sctx->hash[2] = 0x98badcfe;
+	sctx->hash[3] =	0x10325476;
+	sctx->byte_count = 0;
+
+	return 0;
+}
+
+static int ppc_md5_update(struct shash_desc *desc, const u8 *data,
+			unsigned int len)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+	const unsigned int offset = sctx->byte_count & 0x3f;
+	unsigned int avail = 64 - offset;
+	const u8 *src = data;
+
+	sctx->byte_count += len;
+
+	if (avail > len) {
+		memcpy((char *)sctx->block + offset, src, len);
+		return 0;
+	}
+
+	if (offset) {
+		memcpy((char *)sctx->block + offset, src, avail);
+		ppc_md5_transform(sctx->hash, (const u8 *)sctx->block, 1);
+		len -= avail;
+		src += avail;
+	}
+
+	if (len > 63) {
+		ppc_md5_transform(sctx->hash, src, len >> 6);
+		src += len & ~0x3f;
+		len &= 0x3f;
+	}
+
+	memcpy((char *)sctx->block, src, len);
+	return 0;
+}
+
+static int ppc_md5_final(struct shash_desc *desc, u8 *out)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+	const unsigned int offset = sctx->byte_count & 0x3f;
+	const u8 *src = (const u8 *)sctx->block;
+	u8 *p = (u8 *)src + offset;
+	int padlen = 55 - offset;
+	__le64 *pbits = (__le64 *)((char *)sctx->block + 56);
+	__le32 *dst = (__le32 *)out;
+
+	*p++ = 0x80;
+
+	if (padlen < 0) {
+		memset(p, 0x00, padlen + sizeof (u64));
+		ppc_md5_transform(sctx->hash, src, 1);
+		p = (char *)sctx->block;
+		padlen = 56;
+	}
+
+	memset(p, 0, padlen);
+	*pbits = cpu_to_le64(sctx->byte_count << 3);
+	ppc_md5_transform(sctx->hash, src, 1);
+
+	dst[0] = cpu_to_le32(sctx->hash[0]);
+	dst[1] = cpu_to_le32(sctx->hash[1]);
+	dst[2] = cpu_to_le32(sctx->hash[2]);
+	dst[3] = cpu_to_le32(sctx->hash[3]);
+
+	ppc_md5_clear_context(sctx);
+	return 0;
+}
+
+static int ppc_md5_export(struct shash_desc *desc, void *out)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int ppc_md5_import(struct shash_desc *desc, const void *in)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	MD5_DIGEST_SIZE,
+	.init		=	ppc_md5_init,
+	.update		=	ppc_md5_update,
+	.final		=	ppc_md5_final,
+	.export		=	ppc_md5_export,
+	.import		=	ppc_md5_import,
+	.descsize	=	sizeof(struct md5_state),
+	.statesize	=	sizeof(struct md5_state),
+	.base		=	{
+		.cra_name	=	"md5",
+		.cra_driver_name=	"md5-ppc",
+		.cra_priority	=	200,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static int __init ppc_md5_mod_init(void)
+{
+	return crypto_register_shash(&alg);
+}
+
+static void __exit ppc_md5_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(ppc_md5_mod_init);
+module_exit(ppc_md5_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MD5 Secure Hash Algorithm, PPC assembler");
+
+MODULE_ALIAS_CRYPTO("md5");
+MODULE_ALIAS_CRYPTO("md5-ppc");

------=_NextPartTM-000-de8a0567-b0e3-48e2-9697-b468d1540729
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

------=_NextPartTM-000-de8a0567-b0e3-48e2-9697-b468d1540729--
