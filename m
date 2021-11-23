Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274E1C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 12:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhKWMlX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 07:41:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59642 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbhKWMlW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 07:41:22 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 28741218D9;
        Tue, 23 Nov 2021 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637671094; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxUHWPSHHKIQkH/xCp19F5dtYwbHfZfyFaAz+qxGBdI=;
        b=UlXno2KG8DltpmspYGeJrvYmvg+6BmjH7QphQCsHqh3T5BfdXoLE1GLX1B6vmP7wjF3Sgp
        zT6wNC8L9y5bwLJiRjB3z6b5QzQhRcXCV47hWzxaRMWjPP+oxPR0YCuEUesAZioA+YIkUv
        VtpTSIebTTbEorqZ1qPxysx1QkVY+68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637671094;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxUHWPSHHKIQkH/xCp19F5dtYwbHfZfyFaAz+qxGBdI=;
        b=y97crLcjP9hl/sAn3DhLD8gJZxosD3zfCO2vLurLM25BOLZ/lHugJ5avXduySUOnYCSEEa
        GQEgMDyy0ulXsHDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D1B4EA3B8B;
        Tue, 23 Nov 2021 12:38:12 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A25F651918C2; Tue, 23 Nov 2021 13:38:12 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.org>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH 04/12] lib/base64: RFC4648-compliant base64 encoding
Date:   Tue, 23 Nov 2021 13:37:53 +0100
Message-Id: <20211123123801.73197-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211123123801.73197-1-hare@suse.de>
References: <20211123123801.73197-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add RFC4648-compliant base64 encoding and decoding routines, based on
the base64url encoding in fs/crypto/fname.c.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 include/linux/base64.h |  16 +++++++
 lib/Makefile           |   2 +-
 lib/base64.c           | 103 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 1 deletion(-)
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
index 364c23f15578..ddc5cb4c6eb8 100644
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
index 000000000000..60d46157da85
--- /dev/null
+++ b/lib/base64.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64.c - RFC4648-compliant base64 encoding
+ *
+ * Copyright (c) 2020 Hannes Reinecke, SUSE
+ *
+ * Based on the base64url routines from fs/crypto/fname.c
+ * (which are using the URL-safe base64 encoding),
+ * modified to use the standard coding table from RFC4648 section 4.
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/base64.h>
+
+static const char base64_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+/**
+ * base64_encode() - base64-encode some binary data
+ * @src: the binary data to encode
+ * @srclen: the length of @src in bytes
+ * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ *
+ * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
+ * by RFC 4648, including the  '='-padding.
+ *
+ * Return: the length of the resulting base64url-encoded string in bytes.
+ */
+int base64_encode(const u8 *src, int srclen, char *dst)
+{
+	u32 ac = 0;
+	int bits = 0;
+	int i;
+	char *cp = dst;
+
+	for (i = 0; i < srclen; i++) {
+		ac = (ac << 8) | src[i];
+		bits += 8;
+		do {
+			bits -= 6;
+			*cp++ = base64_table[(ac >> bits) & 0x3f];
+		} while (bits >= 6);
+	}
+	if (bits) {
+		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
+		bits -= 6;
+	}
+	while (bits < 0) {
+		*cp++ = '=';
+		bits += 2;
+	}
+	return cp - dst;
+}
+EXPORT_SYMBOL_GPL(base64_encode);
+
+/**
+ * base64_decode() - base64-decode a string
+ * @src: the string to decode.  Doesn't need to be NUL-terminated.
+ * @srclen: the length of @src in bytes
+ * @dst: (output) the decoded binary data
+ *
+ * Decodes a string using base64url encoding, i.e. the "Base 64 Encoding"
+ * specified by RFC 4648, including the  '='-padding.
+ *
+ * This implementation hasn't been optimized for performance.
+ *
+ * Return: the length of the resulting decoded binary data in bytes,
+ *	   or -1 if the string isn't a valid base64 string.
+ */
+int base64_decode(const char *src, int srclen, u8 *dst)
+{
+	u32 ac = 0;
+	int bits = 0;
+	int i;
+	u8 *bp = dst;
+
+	for (i = 0; i < srclen; i++) {
+		const char *p = strchr(base64_table, src[i]);
+
+		if (src[i] == '=') {
+			ac = (ac << 6);
+			bits += 6;
+			if (bits >= 8)
+				bits -= 8;
+			continue;
+		}
+		if (p == NULL || src[i] == 0)
+			return -1;
+		ac = (ac << 6) | (p - base64_table);
+		bits += 6;
+		if (bits >= 8) {
+			bits -= 8;
+			*bp++ = (u8)(ac >> bits);
+		}
+	}
+	if (ac & ((1 << bits) - 1))
+		return -1;
+	return bp - dst;
+}
+EXPORT_SYMBOL_GPL(base64_decode);
-- 
2.29.2

