Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8890C07E95
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB601613AF
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhGPLHj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:07:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46824 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhGPLHh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 07:07:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4904A205CE;
        Fri, 16 Jul 2021 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626433482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvRAP17pLm/OVFpsyr76Iw1aMi9OCJjvP5bRYY3491M=;
        b=btFKBG9N7WxFjTTymsawxjLFhuMm88rvtiwmp0UXdBdD+bGfo3xqA055SFb5aszNp8Iufk
        U8SDT7RCjcBFQPmJ4eTl7SgWm9oS1zsJS253AKSu9FUZBfy/kcuzfWy4nvRLqUlcHI8kW+
        F/D/UidFpR5uwxRShgXVv+VYmIxWzc4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626433482;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvRAP17pLm/OVFpsyr76Iw1aMi9OCJjvP5bRYY3491M=;
        b=1dMtVHWwZ0UmlObREgiYgPpj25/+ztiaFMC+/QP1ELM/xQ24jKn+HpaJVIXowx1leAHSIo
        egFOR/jhDX2nZQDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B7378A3BB5;
        Fri, 16 Jul 2021 11:04:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 85E5B517160C; Fri, 16 Jul 2021 13:04:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/11] lib/base64: RFC4648-compliant base64 encoding
Date:   Fri, 16 Jul 2021 13:04:21 +0200
Message-Id: <20210716110428.9727-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add RFC4648-compliant base64 encoding and decoding routines.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/base64.h |  16 ++++++
 lib/Makefile           |   2 +-
 lib/base64.c           | 111 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 128 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/base64.h
 create mode 100644 lib/base64.c

diff --git a/include/linux/base64.h b/include/linux/base64.h
new file mode 100644
index 000000000000..660d4cb1ef31
--- /dev/null
+++ b/include/linux/base64.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64 encoding, lifted from fs/crypto/fname.c.
+ */
+
+#ifndef _LINUX_BASE64_H
+#define _LINUX_BASE64_H
+
+#include <linux/types.h>
+
+#define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
+
+int base64_encode(const u8 *src, int len, char *dst);
+int base64_decode(const char *src, int len, u8 *dst);
+
+#endif /* _LINUX_BASE64_H */
diff --git a/lib/Makefile b/lib/Makefile
index 6d765d5fb8ac..92a428aa0e5f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -46,7 +46,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
-	 percpu-refcount.o rhashtable.o \
+	 percpu-refcount.o rhashtable.o base64.o \
 	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
 	 generic-radix-tree.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
diff --git a/lib/base64.c b/lib/base64.c
new file mode 100644
index 000000000000..a8929a3a04fe
--- /dev/null
+++ b/lib/base64.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64.c - RFC4648-compliant base64 encoding
+ *
+ * Copyright (c) 2020 Hannes Reinecke, SUSE
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/base64.h>
+
+static const char lookup_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+/**
+ * base64_encode() - base64-encode some bytes
+ * @src: the bytes to encode
+ * @len: number of bytes to encode
+ * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ *
+ * Encodes the input string using characters from the set [A-Za-z0-9+,].
+ * The encoded string is roughly 4/3 times the size of the input string.
+ *
+ * Return: length of the encoded string
+ */
+int base64_encode(const u8 *src, int len, char *dst)
+{
+	int i, bits = 0;
+	u32 ac = 0;
+	char *cp = dst;
+
+	for (i = 0; i < len; i++) {
+		ac = (ac << 8) | src[i];
+		bits += 8;
+		if (bits < 24)
+			continue;
+		do {
+			bits -= 6;
+			*cp++ = lookup_table[(ac >> bits) & 0x3f];
+		} while (bits);
+		ac = 0;
+	}
+	if (bits) {
+		int more = 0;
+
+		if (bits < 16)
+			more = 2;
+		ac = (ac << (2 + more));
+		bits += (2 + more);
+		do {
+			bits -= 6;
+			*cp++ = lookup_table[(ac >> bits) & 0x3f];
+		} while (bits);
+		*cp++ = '=';
+		if (more)
+			*cp++ = '=';
+	}
+
+	return cp - dst;
+}
+EXPORT_SYMBOL_GPL(base64_encode);
+
+/**
+ * base64_decode() - base64-decode some bytes
+ * @src: the base64-encoded string to decode
+ * @len: number of bytes to decode
+ * @dst: (output) the decoded bytes.
+ *
+ * Decodes the base64-encoded bytes @src according to RFC 4648.
+ *
+ * Return: number of decoded bytes
+ */
+int base64_decode(const char *src, int len, u8 *dst)
+{
+        int i, bits = 0, pad = 0;
+        u32 ac = 0;
+        size_t dst_len = 0;
+
+        for (i = 0; i < len; i++) {
+                int c, p = -1;
+
+                if (src[i] == '=') {
+                        pad++;
+                        if (i + 1 < len && src[i + 1] == '=')
+                                pad++;
+                        break;
+                }
+                for (c = 0; c < strlen(lookup_table); c++) {
+                        if (src[i] == lookup_table[c]) {
+                                p = c;
+                                break;
+                        }
+                }
+                if (p < 0)
+                        break;
+                ac = (ac << 6) | p;
+                bits += 6;
+                if (bits < 24)
+                        continue;
+                while (bits) {
+                        bits -= 8;
+                        dst[dst_len++] = (ac >> bits) & 0xff;
+                }
+                ac = 0;
+        }
+        dst_len -= pad;
+        return dst_len;
+}
+EXPORT_SYMBOL_GPL(base64_decode);
-- 
2.29.2

