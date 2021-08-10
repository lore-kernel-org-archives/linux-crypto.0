Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D87BC4320A
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ECDB604DC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240725AbhHJMnR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:43:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43650 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240684AbhHJMnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 08:43:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 187C9200AC;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628599372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBz1euu/Em73FsBrJkOYPpUWzZMW08ZHnj+jOApWQ20=;
        b=daG147EI93GuflJ21eDXm7tEVZ0kzV1RBKSXywqdhNPwfvaF9ibSB9nPtvKDGthaRdVvSQ
        W3Ld7QOwgTX6nXUVW0d60YNGlZX4DvpToQ1cT7Aqtpuw9Y5jyftcdAe0QpxlLJuwmuwK0E
        INfNNUTq/AfVBNZ2iqDsAzqdllnKrI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628599372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBz1euu/Em73FsBrJkOYPpUWzZMW08ZHnj+jOApWQ20=;
        b=/mlxHgXt/f/jdc68S0rtT6z4OBGbp3taASbwQy4uHq0lFPwtFKhJtkcYO6kjvNjTG7xLJo
        aRO1dSXEhLxyaYBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 97A16A3B8A;
        Tue, 10 Aug 2021 12:42:50 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6408D518C548; Tue, 10 Aug 2021 14:42:50 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/13] lib/base64: RFC4648-compliant base64 encoding
Date:   Tue, 10 Aug 2021 14:42:21 +0200
Message-Id: <20210810124230.12161-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210810124230.12161-1-hare@suse.de>
References: <20210810124230.12161-1-hare@suse.de>
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
 lib/base64.c           | 115 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
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
index 000000000000..ef120cecceba
--- /dev/null
+++ b/lib/base64.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64.c - RFC4648-compliant base64 encoding
+ *
+ * Copyright (c) 2020 Hannes Reinecke, SUSE
+ *
+ * Based on the (slightly non-standard) base64 routines
+ * from fs/crypto/fname.c, but using the RFC-mandated
+ * coding table.
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

