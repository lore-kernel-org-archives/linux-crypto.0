Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA7E2D0C62;
	Tue, 28 Apr 2026 02:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344429; cv=none; b=gn0TdF70NJPmoatkgTkGVoZGrP1liocU5YXNahKmZYNc//XlP80N8VJ3Wdm8fFx3SB2B0isrvCdKn+EALgwQ3nptuwbewHT2rY52QrSVZWl9vHKrkANwryXvHMeOQk2EhhlKgO+DP/WXpp2Ozpg4EJSlXPfS1ST1vUjTgz+Kg3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344429; c=relaxed/simple;
	bh=ww5wYsgWFnvBdEj/BUCvxSeSCB+Ivy4GWEwlHyl0jSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tk8iWuLeqMEWkgfi3wKr+9vuyZxYdAQN/NDN4szOgX0DSEoq8HBB9C7ZCVjg5QGFNrJBITKcYZPklys8ju0baAsVujdI4HFigTYY4Q4DuWWP5MMbDK7I+gMHn9RqssxKjiMKMganzIW1MrveAqxHHf+vCA+GKNqrQTLwi4hlaKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EEDF3Wh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEDF3Wh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E45C2BCB8;
	Tue, 28 Apr 2026 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777344429;
	bh=ww5wYsgWFnvBdEj/BUCvxSeSCB+Ivy4GWEwlHyl0jSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EEDF3Wh5OaLJR/KQbOsNBZITdF54A7gljyjtaHwM8ofvE2iN8IWOHngZ08G6EmUeW
	 h7BglpS8mVioUJp2ePdSAmxo7+S/6/2KxnytfXzCOkhlyf261Hb6bC4aSLIhS8CAWt
	 DrhiT/03ZAZOLm7P/DwHhNvoZSH3iPwBPNKR5Xi4LNwp1OFFVljLnIQSbzHFZ1LAdN
	 iYsJD2FtZXBI6jHtdZI/ohw5GzM7xdlGSjHI2zGfGuV1Jzio6Hsqvjiw4bk43UjgcY
	 tXrVUEbquejkmHN38190JS1MQQ/cqigeUbnB1fAj+6TgZCs1tIXo0iRINraaq47zZF
	 QLZg/jLUKS+QA==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 1/5] net/rxrpc: Add local FCrypt-PCBC implementation
Date: Mon, 27 Apr 2026 19:43:54 -0700
Message-ID: <20260428024400.123337-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
References: <20260428024400.123337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add a local implementation of FCrypt-PCBC encryption and decryption.
This will be used instead of the crypto API one, allowing the crypto API
one to be removed.  It will also simplify rxkad.c quite a bit.

A KUnit test is included.  The FCrypt-PCBC test vectors are borrowed
from the existing ones in crypto/testmgr.h.  Note that this adds the
first KUnit test for net/rxrpc/, which previously had no KUnit tests.

The FCrypt code is based on crypto/fcrypt.c, but I simplified it a bit.
The PCBC part is straightforward and I just wrote it from scratch.

Tested with:

    kunit.py run --kunitconfig net/rxrpc/

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/rxrpc/.kunitconfig        |   6 +
 net/rxrpc/Kconfig             |   7 +
 net/rxrpc/Makefile            |   3 +-
 net/rxrpc/ar-internal.h       |  14 ++
 net/rxrpc/fcrypt.c            | 351 ++++++++++++++++++++++++++++++++++
 net/rxrpc/tests/Makefile      |   3 +
 net/rxrpc/tests/rxrpc_kunit.c | 109 +++++++++++
 7 files changed, 492 insertions(+), 1 deletion(-)
 create mode 100644 net/rxrpc/.kunitconfig
 create mode 100644 net/rxrpc/fcrypt.c
 create mode 100644 net/rxrpc/tests/Makefile
 create mode 100644 net/rxrpc/tests/rxrpc_kunit.c

diff --git a/net/rxrpc/.kunitconfig b/net/rxrpc/.kunitconfig
new file mode 100644
index 000000000000..44e4a909ff07
--- /dev/null
+++ b/net/rxrpc/.kunitconfig
@@ -0,0 +1,6 @@
+CONFIG_KUNIT=y
+CONFIG_NET=y
+CONFIG_INET=y
+CONFIG_AF_RXRPC=y
+CONFIG_RXKAD=y
+CONFIG_AF_RXRPC_KUNIT_TEST=y
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 43416b3026fb..82cc8cc9427e 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -95,6 +95,13 @@ config RXPERF
 	help
 	  Provide an rxperf service tester.  This listens on UDP port 7009 for
 	  incoming calls from the rxperf program (an example of which can be
 	  found in OpenAFS).
 
+config AF_RXRPC_KUNIT_TEST
+	tristate "RxRPC KUnit test" if !KUNIT_ALL_TESTS
+	depends on KUNIT && RXKAD
+	default KUNIT_ALL_TESTS
+	help
+	  Enable the RxRPC KUnit test suite.
+
 endif
diff --git a/net/rxrpc/Makefile b/net/rxrpc/Makefile
index c0542bae719e..f994f9f30a29 100644
--- a/net/rxrpc/Makefile
+++ b/net/rxrpc/Makefile
@@ -36,13 +36,14 @@ rxrpc-y := \
 	skbuff.o \
 	txbuf.o \
 	utils.o
 
 rxrpc-$(CONFIG_PROC_FS) += proc.o
-rxrpc-$(CONFIG_RXKAD) += rxkad.o
+rxrpc-$(CONFIG_RXKAD) += rxkad.o fcrypt.o
 rxrpc-$(CONFIG_SYSCTL) += sysctl.o
 rxrpc-$(CONFIG_RXGK) += \
 	rxgk.o \
 	rxgk_app.o \
 	rxgk_kdf.o
 
 obj-$(CONFIG_RXPERF) += rxperf.o
+obj-$(CONFIG_KUNIT) += tests/
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 27c2aa2dd023..7efd52f0420d 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -13,18 +13,32 @@
 #include <net/sock.h>
 #include <net/af_rxrpc.h>
 #include <keys/rxrpc-type.h>
 #include "protocol.h"
 
+#define FCRYPT_ROUNDS 16
+
+struct fcrypt_key {
+	__be32 sched[FCRYPT_ROUNDS];
+};
+
 #define FCRYPT_BSIZE 8
 struct rxrpc_crypt {
 	union {
 		u8	x[FCRYPT_BSIZE];
 		__be32	n[2];
 	};
 } __attribute__((aligned(8)));
 
+void fcrypt_preparekey(struct fcrypt_key *key, const u8 raw_key[FCRYPT_BSIZE]);
+void fcrypt_pcbc_encrypt(const struct fcrypt_key *key,
+			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
+			 size_t nblocks);
+void fcrypt_pcbc_decrypt(const struct fcrypt_key *key,
+			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
+			 size_t nblocks);
+
 #define rxrpc_queue_work(WS)	queue_work(rxrpc_workqueue, (WS))
 #define rxrpc_queue_delayed_work(WS,D)	\
 	queue_delayed_work(rxrpc_workqueue, (WS), (D))
 
 struct key_preparsed_payload;
diff --git a/net/rxrpc/fcrypt.c b/net/rxrpc/fcrypt.c
new file mode 100644
index 000000000000..46038a02c0c0
--- /dev/null
+++ b/net/rxrpc/fcrypt.c
@@ -0,0 +1,351 @@
+/* FCrypt encryption algorithm
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * Based on code:
+ *
+ * Copyright (c) 1995 - 2000 Kungliga Tekniska Högskolan
+ * (Royal Institute of Technology, Stockholm, Sweden).
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ *
+ * 3. Neither the name of the Institute nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE.
+ */
+
+#include <asm/byteorder.h>
+#include <kunit/visibility.h>
+#include <linux/export.h>
+#include <linux/unaligned.h>
+#include "ar-internal.h"
+
+/*
+ * Sboxes for Feistel network derived from
+ * /afs/transarc.com/public/afsps/afs.rel31b.export-src/rxkad/sboxes.h
+ */
+#undef Z
+#define Z(x) cpu_to_be32(x << 3)
+static const __be32 sbox0[256] = {
+	Z(0xea), Z(0x7f), Z(0xb2), Z(0x64), Z(0x9d), Z(0xb0), Z(0xd9), Z(0x11),
+	Z(0xcd), Z(0x86), Z(0x86), Z(0x91), Z(0x0a), Z(0xb2), Z(0x93), Z(0x06),
+	Z(0x0e), Z(0x06), Z(0xd2), Z(0x65), Z(0x73), Z(0xc5), Z(0x28), Z(0x60),
+	Z(0xf2), Z(0x20), Z(0xb5), Z(0x38), Z(0x7e), Z(0xda), Z(0x9f), Z(0xe3),
+	Z(0xd2), Z(0xcf), Z(0xc4), Z(0x3c), Z(0x61), Z(0xff), Z(0x4a), Z(0x4a),
+	Z(0x35), Z(0xac), Z(0xaa), Z(0x5f), Z(0x2b), Z(0xbb), Z(0xbc), Z(0x53),
+	Z(0x4e), Z(0x9d), Z(0x78), Z(0xa3), Z(0xdc), Z(0x09), Z(0x32), Z(0x10),
+	Z(0xc6), Z(0x6f), Z(0x66), Z(0xd6), Z(0xab), Z(0xa9), Z(0xaf), Z(0xfd),
+	Z(0x3b), Z(0x95), Z(0xe8), Z(0x34), Z(0x9a), Z(0x81), Z(0x72), Z(0x80),
+	Z(0x9c), Z(0xf3), Z(0xec), Z(0xda), Z(0x9f), Z(0x26), Z(0x76), Z(0x15),
+	Z(0x3e), Z(0x55), Z(0x4d), Z(0xde), Z(0x84), Z(0xee), Z(0xad), Z(0xc7),
+	Z(0xf1), Z(0x6b), Z(0x3d), Z(0xd3), Z(0x04), Z(0x49), Z(0xaa), Z(0x24),
+	Z(0x0b), Z(0x8a), Z(0x83), Z(0xba), Z(0xfa), Z(0x85), Z(0xa0), Z(0xa8),
+	Z(0xb1), Z(0xd4), Z(0x01), Z(0xd8), Z(0x70), Z(0x64), Z(0xf0), Z(0x51),
+	Z(0xd2), Z(0xc3), Z(0xa7), Z(0x75), Z(0x8c), Z(0xa5), Z(0x64), Z(0xef),
+	Z(0x10), Z(0x4e), Z(0xb7), Z(0xc6), Z(0x61), Z(0x03), Z(0xeb), Z(0x44),
+	Z(0x3d), Z(0xe5), Z(0xb3), Z(0x5b), Z(0xae), Z(0xd5), Z(0xad), Z(0x1d),
+	Z(0xfa), Z(0x5a), Z(0x1e), Z(0x33), Z(0xab), Z(0x93), Z(0xa2), Z(0xb7),
+	Z(0xe7), Z(0xa8), Z(0x45), Z(0xa4), Z(0xcd), Z(0x29), Z(0x63), Z(0x44),
+	Z(0xb6), Z(0x69), Z(0x7e), Z(0x2e), Z(0x62), Z(0x03), Z(0xc8), Z(0xe0),
+	Z(0x17), Z(0xbb), Z(0xc7), Z(0xf3), Z(0x3f), Z(0x36), Z(0xba), Z(0x71),
+	Z(0x8e), Z(0x97), Z(0x65), Z(0x60), Z(0x69), Z(0xb6), Z(0xf6), Z(0xe6),
+	Z(0x6e), Z(0xe0), Z(0x81), Z(0x59), Z(0xe8), Z(0xaf), Z(0xdd), Z(0x95),
+	Z(0x22), Z(0x99), Z(0xfd), Z(0x63), Z(0x19), Z(0x74), Z(0x61), Z(0xb1),
+	Z(0xb6), Z(0x5b), Z(0xae), Z(0x54), Z(0xb3), Z(0x70), Z(0xff), Z(0xc6),
+	Z(0x3b), Z(0x3e), Z(0xc1), Z(0xd7), Z(0xe1), Z(0x0e), Z(0x76), Z(0xe5),
+	Z(0x36), Z(0x4f), Z(0x59), Z(0xc7), Z(0x08), Z(0x6e), Z(0x82), Z(0xa6),
+	Z(0x93), Z(0xc4), Z(0xaa), Z(0x26), Z(0x49), Z(0xe0), Z(0x21), Z(0x64),
+	Z(0x07), Z(0x9f), Z(0x64), Z(0x81), Z(0x9c), Z(0xbf), Z(0xf9), Z(0xd1),
+	Z(0x43), Z(0xf8), Z(0xb6), Z(0xb9), Z(0xf1), Z(0x24), Z(0x75), Z(0x03),
+	Z(0xe4), Z(0xb0), Z(0x99), Z(0x46), Z(0x3d), Z(0xf5), Z(0xd1), Z(0x39),
+	Z(0x72), Z(0x12), Z(0xf6), Z(0xba), Z(0x0c), Z(0x0d), Z(0x42), Z(0x2e)
+};
+
+#undef Z
+#define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))
+static const __be32 sbox1[256] = {
+	Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x3e),
+	Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x85),
+	Z(0x6c), Z(0x7b), Z(0x67), Z(0xc6), Z(0x23), Z(0xe3), Z(0xf2), Z(0x89),
+	Z(0x50), Z(0x9c), Z(0x03), Z(0xb7), Z(0x73), Z(0xe6), Z(0xe1), Z(0x39),
+	Z(0x31), Z(0x2c), Z(0x27), Z(0x9f), Z(0xa5), Z(0x69), Z(0x44), Z(0xd6),
+	Z(0x23), Z(0x83), Z(0x98), Z(0x7d), Z(0x3c), Z(0xb4), Z(0x2d), Z(0x99),
+	Z(0x1c), Z(0x1f), Z(0x8c), Z(0x20), Z(0x03), Z(0x7c), Z(0x5f), Z(0xad),
+	Z(0xf4), Z(0xfa), Z(0x95), Z(0xca), Z(0x76), Z(0x44), Z(0xcd), Z(0xb6),
+	Z(0xb8), Z(0xa1), Z(0xa1), Z(0xbe), Z(0x9e), Z(0x54), Z(0x8f), Z(0x0b),
+	Z(0x16), Z(0x74), Z(0x31), Z(0x8a), Z(0x23), Z(0x17), Z(0x04), Z(0xfa),
+	Z(0x79), Z(0x84), Z(0xb1), Z(0xf5), Z(0x13), Z(0xab), Z(0xb5), Z(0x2e),
+	Z(0xaa), Z(0x0c), Z(0x60), Z(0x6b), Z(0x5b), Z(0xc4), Z(0x4b), Z(0xbc),
+	Z(0xe2), Z(0xaf), Z(0x45), Z(0x73), Z(0xfa), Z(0xc9), Z(0x49), Z(0xcd),
+	Z(0x00), Z(0x92), Z(0x7d), Z(0x97), Z(0x7a), Z(0x18), Z(0x60), Z(0x3d),
+	Z(0xcf), Z(0x5b), Z(0xde), Z(0xc6), Z(0xe2), Z(0xe6), Z(0xbb), Z(0x8b),
+	Z(0x06), Z(0xda), Z(0x08), Z(0x15), Z(0x1b), Z(0x88), Z(0x6a), Z(0x17),
+	Z(0x89), Z(0xd0), Z(0xa9), Z(0xc1), Z(0xc9), Z(0x70), Z(0x6b), Z(0xe5),
+	Z(0x43), Z(0xf4), Z(0x68), Z(0xc8), Z(0xd3), Z(0x84), Z(0x28), Z(0x0a),
+	Z(0x52), Z(0x66), Z(0xa3), Z(0xca), Z(0xf2), Z(0xe3), Z(0x7f), Z(0x7a),
+	Z(0x31), Z(0xf7), Z(0x88), Z(0x94), Z(0x5e), Z(0x9c), Z(0x63), Z(0xd5),
+	Z(0x24), Z(0x66), Z(0xfc), Z(0xb3), Z(0x57), Z(0x25), Z(0xbe), Z(0x89),
+	Z(0x44), Z(0xc4), Z(0xe0), Z(0x8f), Z(0x23), Z(0x3c), Z(0x12), Z(0x52),
+	Z(0xf5), Z(0x1e), Z(0xf4), Z(0xcb), Z(0x18), Z(0x33), Z(0x1f), Z(0xf8),
+	Z(0x69), Z(0x10), Z(0x9d), Z(0xd3), Z(0xf7), Z(0x28), Z(0xf8), Z(0x30),
+	Z(0x05), Z(0x5e), Z(0x32), Z(0xc0), Z(0xd5), Z(0x19), Z(0xbd), Z(0x45),
+	Z(0x8b), Z(0x5b), Z(0xfd), Z(0xbc), Z(0xe2), Z(0x5c), Z(0xa9), Z(0x96),
+	Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61), Z(0xad),
+	Z(0x80), Z(0x48), Z(0x81), Z(0xb7), Z(0x1d), Z(0x43), Z(0xd9), Z(0xd7),
+	Z(0x45), Z(0xf0), Z(0xd8), Z(0x8a), Z(0x59), Z(0x7c), Z(0x57), Z(0xc1),
+	Z(0x79), Z(0xc7), Z(0x34), Z(0xd6), Z(0x43), Z(0xdf), Z(0xe4), Z(0x78),
+	Z(0x16), Z(0x06), Z(0xda), Z(0x92), Z(0x76), Z(0x51), Z(0xe1), Z(0xd4),
+	Z(0x70), Z(0x03), Z(0xe0), Z(0x2f), Z(0x96), Z(0x91), Z(0x82), Z(0x80)
+};
+
+#undef Z
+#define Z(x) cpu_to_be32(x << 11)
+static const __be32 sbox2[256] = {
+	Z(0xf0), Z(0x37), Z(0x24), Z(0x53), Z(0x2a), Z(0x03), Z(0x83), Z(0x86),
+	Z(0xd1), Z(0xec), Z(0x50), Z(0xf0), Z(0x42), Z(0x78), Z(0x2f), Z(0x6d),
+	Z(0xbf), Z(0x80), Z(0x87), Z(0x27), Z(0x95), Z(0xe2), Z(0xc5), Z(0x5d),
+	Z(0xf9), Z(0x6f), Z(0xdb), Z(0xb4), Z(0x65), Z(0x6e), Z(0xe7), Z(0x24),
+	Z(0xc8), Z(0x1a), Z(0xbb), Z(0x49), Z(0xb5), Z(0x0a), Z(0x7d), Z(0xb9),
+	Z(0xe8), Z(0xdc), Z(0xb7), Z(0xd9), Z(0x45), Z(0x20), Z(0x1b), Z(0xce),
+	Z(0x59), Z(0x9d), Z(0x6b), Z(0xbd), Z(0x0e), Z(0x8f), Z(0xa3), Z(0xa9),
+	Z(0xbc), Z(0x74), Z(0xa6), Z(0xf6), Z(0x7f), Z(0x5f), Z(0xb1), Z(0x68),
+	Z(0x84), Z(0xbc), Z(0xa9), Z(0xfd), Z(0x55), Z(0x50), Z(0xe9), Z(0xb6),
+	Z(0x13), Z(0x5e), Z(0x07), Z(0xb8), Z(0x95), Z(0x02), Z(0xc0), Z(0xd0),
+	Z(0x6a), Z(0x1a), Z(0x85), Z(0xbd), Z(0xb6), Z(0xfd), Z(0xfe), Z(0x17),
+	Z(0x3f), Z(0x09), Z(0xa3), Z(0x8d), Z(0xfb), Z(0xed), Z(0xda), Z(0x1d),
+	Z(0x6d), Z(0x1c), Z(0x6c), Z(0x01), Z(0x5a), Z(0xe5), Z(0x71), Z(0x3e),
+	Z(0x8b), Z(0x6b), Z(0xbe), Z(0x29), Z(0xeb), Z(0x12), Z(0x19), Z(0x34),
+	Z(0xcd), Z(0xb3), Z(0xbd), Z(0x35), Z(0xea), Z(0x4b), Z(0xd5), Z(0xae),
+	Z(0x2a), Z(0x79), Z(0x5a), Z(0xa5), Z(0x32), Z(0x12), Z(0x7b), Z(0xdc),
+	Z(0x2c), Z(0xd0), Z(0x22), Z(0x4b), Z(0xb1), Z(0x85), Z(0x59), Z(0x80),
+	Z(0xc0), Z(0x30), Z(0x9f), Z(0x73), Z(0xd3), Z(0x14), Z(0x48), Z(0x40),
+	Z(0x07), Z(0x2d), Z(0x8f), Z(0x80), Z(0x0f), Z(0xce), Z(0x0b), Z(0x5e),
+	Z(0xb7), Z(0x5e), Z(0xac), Z(0x24), Z(0x94), Z(0x4a), Z(0x18), Z(0x15),
+	Z(0x05), Z(0xe8), Z(0x02), Z(0x77), Z(0xa9), Z(0xc7), Z(0x40), Z(0x45),
+	Z(0x89), Z(0xd1), Z(0xea), Z(0xde), Z(0x0c), Z(0x79), Z(0x2a), Z(0x99),
+	Z(0x6c), Z(0x3e), Z(0x95), Z(0xdd), Z(0x8c), Z(0x7d), Z(0xad), Z(0x6f),
+	Z(0xdc), Z(0xff), Z(0xfd), Z(0x62), Z(0x47), Z(0xb3), Z(0x21), Z(0x8a),
+	Z(0xec), Z(0x8e), Z(0x19), Z(0x18), Z(0xb4), Z(0x6e), Z(0x3d), Z(0xfd),
+	Z(0x74), Z(0x54), Z(0x1e), Z(0x04), Z(0x85), Z(0xd8), Z(0xbc), Z(0x1f),
+	Z(0x56), Z(0xe7), Z(0x3a), Z(0x56), Z(0x67), Z(0xd6), Z(0xc8), Z(0xa5),
+	Z(0xf3), Z(0x8e), Z(0xde), Z(0xae), Z(0x37), Z(0x49), Z(0xb7), Z(0xfa),
+	Z(0xc8), Z(0xf4), Z(0x1f), Z(0xe0), Z(0x2a), Z(0x9b), Z(0x15), Z(0xd1),
+	Z(0x34), Z(0x0e), Z(0xb5), Z(0xe0), Z(0x44), Z(0x78), Z(0x84), Z(0x59),
+	Z(0x56), Z(0x68), Z(0x77), Z(0xa5), Z(0x14), Z(0x06), Z(0xf5), Z(0x2f),
+	Z(0x8c), Z(0x8a), Z(0x73), Z(0x80), Z(0x76), Z(0xb4), Z(0x10), Z(0x86)
+};
+
+#undef Z
+#define Z(x) cpu_to_be32(x << 19)
+static const __be32 sbox3[256] = {
+	Z(0xa9), Z(0x2a), Z(0x48), Z(0x51), Z(0x84), Z(0x7e), Z(0x49), Z(0xe2),
+	Z(0xb5), Z(0xb7), Z(0x42), Z(0x33), Z(0x7d), Z(0x5d), Z(0xa6), Z(0x12),
+	Z(0x44), Z(0x48), Z(0x6d), Z(0x28), Z(0xaa), Z(0x20), Z(0x6d), Z(0x57),
+	Z(0xd6), Z(0x6b), Z(0x5d), Z(0x72), Z(0xf0), Z(0x92), Z(0x5a), Z(0x1b),
+	Z(0x53), Z(0x80), Z(0x24), Z(0x70), Z(0x9a), Z(0xcc), Z(0xa7), Z(0x66),
+	Z(0xa1), Z(0x01), Z(0xa5), Z(0x41), Z(0x97), Z(0x41), Z(0x31), Z(0x82),
+	Z(0xf1), Z(0x14), Z(0xcf), Z(0x53), Z(0x0d), Z(0xa0), Z(0x10), Z(0xcc),
+	Z(0x2a), Z(0x7d), Z(0xd2), Z(0xbf), Z(0x4b), Z(0x1a), Z(0xdb), Z(0x16),
+	Z(0x47), Z(0xf6), Z(0x51), Z(0x36), Z(0xed), Z(0xf3), Z(0xb9), Z(0x1a),
+	Z(0xa7), Z(0xdf), Z(0x29), Z(0x43), Z(0x01), Z(0x54), Z(0x70), Z(0xa4),
+	Z(0xbf), Z(0xd4), Z(0x0b), Z(0x53), Z(0x44), Z(0x60), Z(0x9e), Z(0x23),
+	Z(0xa1), Z(0x18), Z(0x68), Z(0x4f), Z(0xf0), Z(0x2f), Z(0x82), Z(0xc2),
+	Z(0x2a), Z(0x41), Z(0xb2), Z(0x42), Z(0x0c), Z(0xed), Z(0x0c), Z(0x1d),
+	Z(0x13), Z(0x3a), Z(0x3c), Z(0x6e), Z(0x35), Z(0xdc), Z(0x60), Z(0x65),
+	Z(0x85), Z(0xe9), Z(0x64), Z(0x02), Z(0x9a), Z(0x3f), Z(0x9f), Z(0x87),
+	Z(0x96), Z(0xdf), Z(0xbe), Z(0xf2), Z(0xcb), Z(0xe5), Z(0x6c), Z(0xd4),
+	Z(0x5a), Z(0x83), Z(0xbf), Z(0x92), Z(0x1b), Z(0x94), Z(0x00), Z(0x42),
+	Z(0xcf), Z(0x4b), Z(0x00), Z(0x75), Z(0xba), Z(0x8f), Z(0x76), Z(0x5f),
+	Z(0x5d), Z(0x3a), Z(0x4d), Z(0x09), Z(0x12), Z(0x08), Z(0x38), Z(0x95),
+	Z(0x17), Z(0xe4), Z(0x01), Z(0x1d), Z(0x4c), Z(0xa9), Z(0xcc), Z(0x85),
+	Z(0x82), Z(0x4c), Z(0x9d), Z(0x2f), Z(0x3b), Z(0x66), Z(0xa1), Z(0x34),
+	Z(0x10), Z(0xcd), Z(0x59), Z(0x89), Z(0xa5), Z(0x31), Z(0xcf), Z(0x05),
+	Z(0xc8), Z(0x84), Z(0xfa), Z(0xc7), Z(0xba), Z(0x4e), Z(0x8b), Z(0x1a),
+	Z(0x19), Z(0xf1), Z(0xa1), Z(0x3b), Z(0x18), Z(0x12), Z(0x17), Z(0xb0),
+	Z(0x98), Z(0x8d), Z(0x0b), Z(0x23), Z(0xc3), Z(0x3a), Z(0x2d), Z(0x20),
+	Z(0xdf), Z(0x13), Z(0xa0), Z(0xa8), Z(0x4c), Z(0x0d), Z(0x6c), Z(0x2f),
+	Z(0x47), Z(0x13), Z(0x13), Z(0x52), Z(0x1f), Z(0x2d), Z(0xf5), Z(0x79),
+	Z(0x3d), Z(0xa2), Z(0x54), Z(0xbd), Z(0x69), Z(0xc8), Z(0x6b), Z(0xf3),
+	Z(0x05), Z(0x28), Z(0xf1), Z(0x16), Z(0x46), Z(0x40), Z(0xb0), Z(0x11),
+	Z(0xd3), Z(0xb7), Z(0x95), Z(0x49), Z(0xcf), Z(0xc3), Z(0x1d), Z(0x8f),
+	Z(0xd8), Z(0xe1), Z(0x73), Z(0xdb), Z(0xad), Z(0xc8), Z(0xc9), Z(0xa9),
+	Z(0xa1), Z(0xc2), Z(0xc5), Z(0xe3), Z(0xba), Z(0xfc), Z(0x0e), Z(0x25)
+};
+
+union fcrypt_block {
+	__be64 a;
+	struct {
+		__be32 l, r;
+	};
+};
+
+#define F_ENCRYPT(R, L, sched)                                       \
+	do {                                                         \
+		union lc4 {                                          \
+			__be32 l;                                    \
+			u8 c[4];                                     \
+		} u;                                                 \
+		u.l = sched ^ R;                                     \
+		L ^= sbox0[u.c[0]] ^ sbox1[u.c[1]] ^ sbox2[u.c[2]] ^ \
+		     sbox3[u.c[3]];                                  \
+	} while (0)
+
+/* Encrypt one block using FCrypt. */
+static __be64 fcrypt_encrypt(const struct fcrypt_key *key, __be64 ptext)
+{
+	union fcrypt_block X = { .a = ptext };
+
+	/* This is a 16 round Feistel network with permutation F_ENCRYPT. */
+	F_ENCRYPT(X.r, X.l, key->sched[0x0]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x1]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x2]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x3]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x4]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x5]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x6]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x7]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x8]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x9]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xa]);
+	F_ENCRYPT(X.l, X.r, key->sched[0xb]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xc]);
+	F_ENCRYPT(X.l, X.r, key->sched[0xd]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xe]);
+	F_ENCRYPT(X.l, X.r, key->sched[0xf]);
+	return X.a;
+}
+
+/* Decrypt one block using FCrypt. */
+static __be64 fcrypt_decrypt(const struct fcrypt_key *key, __be64 ctext)
+{
+	union fcrypt_block X = { .a = ctext };
+
+	/* This is a 16 round Feistel network with permutation F_ENCRYPT. */
+	F_ENCRYPT(X.l, X.r, key->sched[0xf]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xe]);
+	F_ENCRYPT(X.l, X.r, key->sched[0xd]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xc]);
+	F_ENCRYPT(X.l, X.r, key->sched[0xb]);
+	F_ENCRYPT(X.r, X.l, key->sched[0xa]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x9]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x8]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x7]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x6]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x5]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x4]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x3]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x2]);
+	F_ENCRYPT(X.l, X.r, key->sched[0x1]);
+	F_ENCRYPT(X.r, X.l, key->sched[0x0]);
+	return X.a;
+}
+
+/**
+ * fcrypt_preparekey - Prepare a key for FCrypt encryption and decryption
+ * @key: (out) The prepared key
+ * @raw_key: The raw key as an 8-byte array
+ *
+ * This computes the FCrypt key schedule.
+ */
+void fcrypt_preparekey(struct fcrypt_key *key, const u8 raw_key[FCRYPT_BSIZE])
+{
+	u64 k = 0;
+
+	/* Load the 56 non-parity bits of the key.  Discard the parity bits. */
+	for (int i = 0; i < 8; i++)
+		k = (k << 7) | (raw_key[i] >> 1);
+
+	/* Generate the key schedule word for each round. */
+	for (int i = 0; i < FCRYPT_ROUNDS; i++) {
+		key->sched[i] = cpu_to_be32(k);
+		/* Rotate the low 56 bits of 'k' right by 11 bits. */
+		k = (k >> 11) | ((k & ((1 << 11) - 1)) << (56 - 11));
+	}
+}
+
+/**
+ * fcrypt_pcbc_encrypt - Encrypt data using FCrypt cipher in PCBC mode
+ * @key: The key
+ * @iv: The 8-byte initialization vector
+ * @src: The source data
+ * @dst: The destination data.  Both in-place and out-of-place are supported.
+ * @nblocks: The number of 8-byte blocks to encrypt
+ *
+ * WARNING: This cipher is insecure.  Not only is the 56-bit key easily
+ * brute-forced, the cipher itself is cryptographically weak and doesn't even
+ * provide the intended 56-bit security level.  It effectively just acts as an
+ * obfuscation algorithm.  It is supported only for backwards compatibility.
+ */
+void fcrypt_pcbc_encrypt(const struct fcrypt_key *key,
+			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
+			 size_t nblocks)
+{
+	__be64 prev = get_unaligned((const __be64 *)iv);
+	const __be64 *src_blocks = src;
+	__be64 *dst_blocks = dst;
+
+	while (nblocks--) {
+		__be64 ptext, ctext;
+
+		ptext = get_unaligned(src_blocks++);
+		ctext = fcrypt_encrypt(key, prev ^ ptext);
+		put_unaligned(ctext, dst_blocks++);
+		prev = ptext ^ ctext;
+	}
+}
+EXPORT_SYMBOL_IF_KUNIT(fcrypt_pcbc_encrypt);
+
+/**
+ * fcrypt_pcbc_decrypt - Decrypt data using FCrypt cipher in PCBC mode
+ * @key: The key
+ * @iv: The 8-byte initialization vector
+ * @src: The source data
+ * @dst: The destination data.  Both in-place and out-of-place are supported.
+ * @nblocks: The number of 8-byte blocks to decrypt
+ */
+void fcrypt_pcbc_decrypt(const struct fcrypt_key *key,
+			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
+			 size_t nblocks)
+{
+	__be64 prev = get_unaligned((const __be64 *)iv);
+	const __be64 *src_blocks = src;
+	__be64 *dst_blocks = dst;
+
+	while (nblocks--) {
+		__be64 ptext, ctext;
+
+		ctext = get_unaligned(src_blocks++);
+		ptext = prev ^ fcrypt_decrypt(key, ctext);
+		put_unaligned(ptext, dst_blocks++);
+		prev = ptext ^ ctext;
+	}
+}
+EXPORT_SYMBOL_IF_KUNIT(fcrypt_pcbc_decrypt);
diff --git a/net/rxrpc/tests/Makefile b/net/rxrpc/tests/Makefile
new file mode 100644
index 000000000000..4f51008800b4
--- /dev/null
+++ b/net/rxrpc/tests/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_AF_RXRPC_KUNIT_TEST) += rxrpc_kunit.o
diff --git a/net/rxrpc/tests/rxrpc_kunit.c b/net/rxrpc/tests/rxrpc_kunit.c
new file mode 100644
index 000000000000..460e3ad61a16
--- /dev/null
+++ b/net/rxrpc/tests/rxrpc_kunit.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Unit tests for RxRPC functions
+ *
+ * Copyright 2026 Google LLC
+ */
+#include "../ar-internal.h"
+#include <kunit/test.h>
+
+struct fcrypt_pcbc_testvec {
+	u8 key[FCRYPT_BSIZE];
+	u8 iv[FCRYPT_BSIZE];
+	const u8 *ptext; /* plaintext */
+	const u8 *ctext; /* ciphertext */
+	size_t nblocks; /* length of ptext and ctext in blocks */
+};
+
+/* FCrypt-PCBC test vectors */
+static const struct fcrypt_pcbc_testvec fcrypt_pcbc_testvecs[] = {
+	{
+		/* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
+		.key = "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.iv = "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext = "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ctext = "\x0E\x09\x00\xC7\x3E\xF7\xED\x41",
+		.nblocks = 1,
+	},
+	{
+		.key = "\x11\x44\x77\xAA\xDD\x00\x33\x66",
+		.iv = "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext = "\x12\x34\x56\x78\x9A\xBC\xDE\xF0",
+		.ctext = "\xD8\xED\x78\x74\x77\xEC\x06\x80",
+		.nblocks = 1,
+	},
+	{
+		/* From Arla */
+		.key = "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
+		.iv = "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.ptext = "The quick brown fox jumps over the lazy dogs.\0\0",
+		.ctext = "\x00\xf0\x0e\x11\x75\xe6\x23\x82"
+			 "\xee\xac\x98\x62\x44\x51\xe4\x84"
+			 "\xc3\x59\xd8\xaa\x64\x60\xae\xf7"
+			 "\xd2\xd9\x13\x79\x72\xa3\x45\x03"
+			 "\x23\xb5\x62\xd7\x0c\xf5\x27\xd1"
+			 "\xf8\x91\x3c\xac\x44\x22\x92\xef",
+		.nblocks = 6,
+	},
+	{
+		.key = "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.iv = "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
+		.ptext = "The quick brown fox jumps over the lazy dogs.\0\0",
+		.ctext = "\xca\x90\xf5\x9d\xcb\xd4\xd2\x3c"
+			 "\x01\x88\x7f\x3e\x31\x6e\x62\x9d"
+			 "\xd8\xe0\x57\xa3\x06\x3a\x42\x58"
+			 "\x2a\x28\xfe\x72\x52\x2f\xdd\xe0"
+			 "\x19\x89\x09\x1c\x2a\x8e\x8c\x94"
+			 "\xfc\xc7\x68\xe4\x88\xaa\xde\x0f",
+		.nblocks = 6,
+	}
+};
+
+static void test_fcrypt_pcbc(struct kunit *test)
+{
+	u8 data[48];
+
+	for (size_t i = 0; i < ARRAY_SIZE(fcrypt_pcbc_testvecs); i++) {
+		const struct fcrypt_pcbc_testvec *tv = &fcrypt_pcbc_testvecs[i];
+		const size_t nblocks = tv->nblocks;
+		const size_t len = nblocks * FCRYPT_BSIZE;
+		struct fcrypt_key key;
+
+		KUNIT_ASSERT_GE(test, sizeof(data), len);
+
+		fcrypt_preparekey(&key, tv->key);
+
+		/* out-of-place encryption */
+		fcrypt_pcbc_encrypt(&key, tv->iv, tv->ptext, data, nblocks);
+		KUNIT_ASSERT_MEMEQ(test, tv->ctext, data, len);
+
+		/* in-place encryption */
+		memcpy(data, tv->ptext, len);
+		fcrypt_pcbc_encrypt(&key, tv->iv, data, data, nblocks);
+		KUNIT_ASSERT_MEMEQ(test, tv->ctext, data, len);
+
+		/* out-of-place decryption */
+		fcrypt_pcbc_decrypt(&key, tv->iv, tv->ctext, data, nblocks);
+		KUNIT_ASSERT_MEMEQ(test, tv->ptext, data, len);
+
+		/* in-place decryption */
+		memcpy(data, tv->ctext, len);
+		fcrypt_pcbc_decrypt(&key, tv->iv, data, data, nblocks);
+		KUNIT_ASSERT_MEMEQ(test, tv->ptext, data, len);
+	}
+}
+
+static struct kunit_case rxrpc_test_cases[] = {
+	KUNIT_CASE(test_fcrypt_pcbc),
+	{},
+};
+
+static struct kunit_suite rxrpc_test_suite = {
+	.name = "rxrpc",
+	.test_cases = rxrpc_test_cases,
+};
+kunit_test_suite(rxrpc_test_suite);
+
+MODULE_DESCRIPTION("Unit tests for RxRPC functions");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_LICENSE("GPL");
-- 
2.54.0

