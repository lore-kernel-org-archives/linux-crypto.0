Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58222C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10CAA21841
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 05:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550727066;
	bh=qIJ4uBZwuoShBSN68gJOIxZ4mZ7uwp0tjjOcS/mqFB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SsskNBwKRDuJ8o+0Zi5wYIB6LNmrcAfrkwoRgNm5dZk4G/43KdidYsXmiNZ+rVWmv
	 mApkXYA61ZXtVDYySM6pWWejAo/kbxUnTXA/oXmVE5iq+cGknH8+S+KaBTADw9jG0S
	 NavqffaVuKZ/G4Sjw2GULBJ4VjC312w9HwqEGIhY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbfBUFbE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:31:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfBUFbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 00:31:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35617214AF;
        Thu, 21 Feb 2019 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550727062;
        bh=qIJ4uBZwuoShBSN68gJOIxZ4mZ7uwp0tjjOcS/mqFB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mI1s4R7nJAMEaaAriksuD5QpRK5s/Ue3cRrY3N8DDaYfHr3W/tpNbnYgCGgHEoTGO
         Jbes02TC534zzLPiyn/VXnq8V5fTNGo+G9B/+0Vsn0rJjbRwXsc/8Mcc4wxG7ew1Sm
         cXDSPwxmeIqT+wRhrrs5wh2o1wVUlXhONRuPN4ok=
From:   Eric Biggers <ebiggers@kernel.org>
To:     ltp@lists.linux.it
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/6] lib: add tst_af_alg lib
Date:   Wed, 20 Feb 2019 21:30:21 -0800
Message-Id: <20190221053026.18489-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221053026.18489-1-ebiggers@kernel.org>
References: <20190221053026.18489-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add helper functions for creating and using AF_ALG sockets.  AF_ALG is
the userspace interface to algorithms in the Linux kernel's crypto API.
See https://www.kernel.org/doc/html/latest/crypto/userspace-if.html for
more information about this interface.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 configure.ac          |   1 +
 include/lapi/if_alg.h |  40 ++++++++++++
 include/tst_af_alg.h  | 136 ++++++++++++++++++++++++++++++++++++++
 lib/tst_af_alg.c      | 147 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 324 insertions(+)
 create mode 100644 include/lapi/if_alg.h
 create mode 100644 include/tst_af_alg.h
 create mode 100644 lib/tst_af_alg.c

diff --git a/configure.ac b/configure.ac
index caea34462f..229815694c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,6 +40,7 @@ AC_CHECK_HEADERS([ \
     linux/cryptouser.h \
     linux/genetlink.h \
     linux/keyctl.h \
+    linux/if_alg.h \
     linux/if_packet.h \
     linux/if_ether.h \
     linux/mempolicy.h \
diff --git a/include/lapi/if_alg.h b/include/lapi/if_alg.h
new file mode 100644
index 0000000000..2fc5e7b5e3
--- /dev/null
+++ b/include/lapi/if_alg.h
@@ -0,0 +1,40 @@
+#ifndef IF_ALG_H__
+#define IF_ALG_H__
+
+#ifdef HAVE_LINUX_IF_ALG_H
+#  include <linux/if_alg.h>
+#else
+#  include <stdint.h>
+
+struct sockaddr_alg {
+	uint16_t	salg_family;
+	uint8_t		salg_type[14];
+	uint32_t	salg_feat;
+	uint32_t	salg_mask;
+	uint8_t		salg_name[64];
+};
+
+struct af_alg_iv {
+	uint32_t	ivlen;
+	uint8_t		iv[0];
+};
+
+/* Socket options */
+#define ALG_SET_KEY		1
+#define ALG_SET_IV		2
+#define ALG_SET_OP		3
+#define ALG_SET_AEAD_ASSOCLEN	4
+#define ALG_SET_AEAD_AUTHSIZE	5
+
+/* Operations */
+#define ALG_OP_DECRYPT		0
+#define ALG_OP_ENCRYPT		1
+
+#endif /* !HAVE_LINUX_IF_ALG_H */
+
+/* This isn't in any UAPI header */
+#ifndef SOL_ALG
+#  define SOL_ALG		279
+#endif
+
+#endif /* IF_ALG_H__ */
diff --git a/include/tst_af_alg.h b/include/tst_af_alg.h
new file mode 100644
index 0000000000..55f080a574
--- /dev/null
+++ b/include/tst_af_alg.h
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+/**
+ * @file tst_af_alg.h
+ *
+ * Library for accessing kernel crypto algorithms via AF_ALG.
+ *
+ * See https://www.kernel.org/doc/html/latest/crypto/userspace-if.html
+ * for more information about AF_ALG.
+ */
+
+#ifndef TST_AF_ALG_H
+#define TST_AF_ALG_H
+
+#include "lapi/if_alg.h"
+#include <stdbool.h>
+
+/**
+ * Create an AF_ALG algorithm socket.
+ *
+ * This creates an AF_ALG algorithm socket that is initially not bound to any
+ * particular algorithm.  On failure, tst_brk() is called with TCONF if the
+ * kernel doesn't support AF_ALG, otherwise TBROK.
+ *
+ * @return a new AF_ALG algorithm socket
+ */
+int tst_alg_create(void);
+
+/**
+ * Bind an AF_ALG algorithm socket to an algorithm.
+ *
+ * @param alg_fd An AF_ALG algorithm socket
+ * @param addr A structure which specifies the algorithm to use
+ *
+ * On failure, tst_brk() is called with TCONF if the kernel doesn't support the
+ * specified algorithm, otherwise TBROK.
+ */
+void tst_alg_bind_addr(int alg_fd, const struct sockaddr_alg *addr);
+
+/**
+ * Bind an AF_ALG algorithm socket to an algorithm.
+ *
+ * @param alg_fd An AF_ALG algorithm socket
+ * @param algtype The type of algorithm, such as "hash" or "skcipher"
+ * @param algname The name of the algorithm, such as "sha256" or "xts(aes)"
+ *
+ * Like tst_alg_bind_addr(), except this just takes in the algorithm type and
+ * name.  The 'feat' and 'mask' fields are left 0.
+ *
+ * On failure, tst_brk() is called with TCONF if the kernel doesn't support the
+ * specified algorithm, otherwise TBROK.
+ */
+void tst_alg_bind(int alg_fd, const char *algtype, const char *algname);
+
+/**
+ * Check for the availability of an algorithm.
+ *
+ * @param algtype The type of algorithm, such as "hash" or "skcipher"
+ * @param algname The name of the algorithm, such as "sha256" or "xts(aes)"
+ *
+ * Return true if the algorithm is available, or false if unavailable.
+ * If another error occurs, tst_brk() is called with TBROK.
+ */
+bool tst_have_alg(const char *algtype, const char *algname);
+
+/**
+ * Require the availability of an algorithm.
+ *
+ * @param algtype The type of algorithm, such as "hash" or "skcipher"
+ * @param algname The name of the algorithm, such as "sha256" or "xts(aes)"
+ *
+ * If the algorithm is unavailable, tst_brk() is called with TCONF.
+ * If another error occurs, tst_brk() is called with TBROK.
+ */
+void tst_require_alg(const char *algtype, const char *algname);
+
+/**
+ * Assign a cryptographic key to an AF_ALG algorithm socket.
+ *
+ * @param alg_fd An AF_ALG algorithm socket
+ * @param key Pointer to the key.  If NULL, a random key is generated.
+ * @param keylen Length of the key in bytes
+ *
+ * On failure, tst_brk() is called with TBROK.
+ */
+void tst_alg_setkey(int alg_fd, const uint8_t *key, unsigned int keylen);
+
+/**
+ * Create an AF_ALG request socket for the given algorithm socket.
+ *
+ * @param alg_fd An AF_ALG algorithm socket
+ *
+ * This creates a request socket for the given algorithm socket, which must be
+ * bound to an algorithm.  The same algorithm socket can have many request
+ * sockets used concurrently to perform independent cryptographic operations,
+ * e.g. hashing or encryption/decryption.  But the key, if any, that has been
+ * assigned to the algorithm is shared by all request sockets.
+ *
+ * On failure, tst_brk() is called with TBROK.
+ *
+ * @return a new AF_ALG request socket
+ */
+int tst_alg_accept(int alg_fd);
+
+/**
+ * Set up an AF_ALG algorithm socket for the given algorithm w/ given key.
+ *
+ * @param algtype The type of algorithm, such as "hash" or "skcipher"
+ * @param algname The name of the algorithm, such as "sha256" or "xts(aes)"
+ * @param key The key to use (optional)
+ * @param keylen The length of the key in bytes (optional)
+ *
+ * This is a helper function which creates an AF_ALG algorithm socket, binds it
+ * to the specified algorithm, and optionally sets a key.  If keylen is 0 then
+ * no key is set; otherwise if key is NULL a key of the given length is randomly
+ * generated and set; otherwise the given key is set.
+ *
+ * @return the AF_ALG algorithm socket that was set up
+ */
+int tst_alg_setup(const char *algtype, const char *algname,
+		  const uint8_t *key, unsigned int keylen);
+
+/**
+ * Set up an AF_ALG request socket for the given algorithm w/ given key.
+ *
+ * This is like tst_alg_setup(), except this returns a request fd instead of the
+ * alg fd.  The alg fd is closed, so it doesn't need to be kept track of.
+ *
+ * @return the AF_ALG request socket that was set up
+ */
+int tst_alg_setup_reqfd(const char *algtype, const char *algname,
+			const uint8_t *key, unsigned int keylen);
+
+#endif /* TST_AF_ALG_H */
diff --git a/lib/tst_af_alg.c b/lib/tst_af_alg.c
new file mode 100644
index 0000000000..8702185d6f
--- /dev/null
+++ b/lib/tst_af_alg.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2019 Google LLC
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+
+#define TST_NO_DEFAULT_MAIN
+#include "tst_test.h"
+#include "tst_af_alg.h"
+
+int tst_alg_create(void)
+{
+	TEST(socket(AF_ALG, SOCK_SEQPACKET, 0));
+	if (TST_RET >= 0)
+		return TST_RET;
+	if (TST_ERR == EPROTONOSUPPORT)
+		tst_brk(TCONF, "kernel doesn't support AF_ALG");
+	tst_brk(TBROK | TTERRNO, "unexpected error creating AF_ALG socket");
+	return -1;
+}
+
+void tst_alg_bind_addr(int algfd, const struct sockaddr_alg *addr)
+{
+	TEST(bind(algfd, (const struct sockaddr *)addr, sizeof(*addr)));
+	if (TST_RET == 0)
+		return;
+	if (TST_ERR == ENOENT) {
+		tst_brk(TCONF, "kernel doesn't support %s algorithm '%s'",
+			addr->salg_type, addr->salg_name);
+	}
+	tst_brk(TBROK | TTERRNO,
+		"unexpected error binding to AF_ALG socket for %s algorithm '%s'",
+		addr->salg_type, addr->salg_name);
+}
+
+static void init_sockaddr_alg(struct sockaddr_alg *addr,
+			      const char *algtype, const char *algname)
+{
+	memset(addr, 0, sizeof(*addr));
+
+	addr->salg_family = AF_ALG;
+
+	strncpy((char *)addr->salg_type, algtype, sizeof(addr->salg_type));
+	if (addr->salg_type[sizeof(addr->salg_type) - 1] != '\0')
+		tst_brk(TBROK, "algorithm type too long: '%s'", algtype);
+
+	strncpy((char *)addr->salg_name, algname, sizeof(addr->salg_name));
+	if (addr->salg_name[sizeof(addr->salg_name) - 1] != '\0')
+		tst_brk(TBROK, "algorithm name too long: '%s'", algname);
+}
+
+void tst_alg_bind(int algfd, const char *algtype, const char *algname)
+{
+	struct sockaddr_alg addr;
+
+	init_sockaddr_alg(&addr, algtype, algname);
+
+	tst_alg_bind_addr(algfd, &addr);
+}
+
+bool tst_have_alg(const char *algtype, const char *algname)
+{
+	int algfd;
+	struct sockaddr_alg addr;
+	bool have_alg = true;
+
+	algfd = tst_alg_create();
+
+	init_sockaddr_alg(&addr, algtype, algname);
+
+	TEST(bind(algfd, (const struct sockaddr *)&addr, sizeof(addr)));
+	if (TST_RET != 0) {
+		if (TST_ERR != ENOENT) {
+			tst_brk(TBROK | TTERRNO,
+				"unexpected error binding to AF_ALG socket for %s algorithm '%s'",
+				algtype, algname);
+		}
+		have_alg = false;
+	}
+
+	close(algfd);
+	return have_alg;
+}
+
+void tst_require_alg(const char *algtype, const char *algname)
+{
+	int algfd = tst_alg_create();
+
+	tst_alg_bind(algfd, algtype, algname);
+
+	close(algfd);
+}
+
+void tst_alg_setkey(int algfd, const uint8_t *key, unsigned int keylen)
+{
+	uint8_t *keybuf = NULL;
+	unsigned int i;
+
+	if (key == NULL) {
+		/* generate a random key */
+		keybuf = SAFE_MALLOC(keylen);
+		for (i = 0; i < keylen; i++)
+			keybuf[i] = rand();
+		key = keybuf;
+	}
+	TEST(setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, keylen));
+	if (TST_RET != 0) {
+		tst_brk(TBROK | TTERRNO,
+			"unexpected error setting key (len=%u)", keylen);
+	}
+	free(keybuf);
+}
+
+int tst_alg_accept(int algfd)
+{
+	TEST(accept(algfd, NULL, NULL));
+	if (TST_RET < 0) {
+		tst_brk(TBROK | TTERRNO,
+			"unexpected error accept()ing AF_ALG request socket");
+	}
+	return TST_RET;
+}
+
+int tst_alg_setup(const char *algtype, const char *algname,
+		  const uint8_t *key, unsigned int keylen)
+{
+	int algfd = tst_alg_create();
+
+	tst_alg_bind(algfd, algtype, algname);
+
+	if (keylen != 0)
+		tst_alg_setkey(algfd, key, keylen);
+
+	return algfd;
+}
+
+int tst_alg_setup_reqfd(const char *algtype, const char *algname,
+			const uint8_t *key, unsigned int keylen)
+{
+	int algfd = tst_alg_setup(algtype, algname, key, keylen);
+	int req_fd = tst_alg_accept(algfd);
+
+	close(algfd);
+	return req_fd;
+}
-- 
2.20.1

