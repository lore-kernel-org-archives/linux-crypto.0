Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05539C47256
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5B320757
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588444091;
	bh=e+wnz32L1T+aJDLUEG4h6lQPRmUrnVsjSdSVgx/0vvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h7u6LjqXVNeOXhL3rYlNxedL+4l/93lEE3UieiKj2mt9eL76VrjCWhGwiqe6+Wxou
	 lUAQ2vxeDLTlU2kt3yaSy0ioYQAzkc2mp+Jm+K0/deNMydct8ivrw8hNvqk0pvpWJD
	 ZxOEG88yXdjN12rwboFNB2MLZm1YJShl/AlnJWw4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgEBS2K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 14:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgEBS2K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 14:28:10 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C807B2084D;
        Sat,  2 May 2020 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588444089;
        bh=e+wnz32L1T+aJDLUEG4h6lQPRmUrnVsjSdSVgx/0vvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=salAGzU72/KDFeIWbWO7NLaP2IHe7Wz2cvkTKG56biXWD7DEbJIiypPaKYR26i099
         Col+HieA9gP1SaU2LqEdk6Jw+TzGoHfYCfywVVEVsC7ZAjqOV7KrdrEy5m9VXoy26v
         jFWs9FoJun5msiNbH/WSaT6j4rA+4G4CQR5i5meY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/7] crypto: lib/sha1 - fold linux/cryptohash.h into crypto/sha.h
Date:   Sat,  2 May 2020 11:24:27 -0700
Message-Id: <20200502182427.104383-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
References: <20200502182427.104383-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

<linux/cryptohash.h> sounds very generic and important, like it's the
header to include if you're doing cryptographic hashing in the kernel.
But actually it only includes the library implementation of the SHA-1
compression function (not even the full SHA-1).  This should basically
never be used anymore; SHA-1 is no longer considered secure, and there
are much better ways to do cryptographic hashing in the kernel.

Remove this header and fold it into <crypto/sha.h> which already
contains constants and functions for SHA-1 (along with SHA-2).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/sha1_generic.c      |  1 -
 drivers/char/random.c      |  2 +-
 include/crypto/sha.h       | 10 ++++++++++
 include/linux/cryptohash.h | 18 ------------------
 include/linux/filter.h     |  2 +-
 lib/sha1.c                 |  2 +-
 6 files changed, 13 insertions(+), 22 deletions(-)
 delete mode 100644 include/linux/cryptohash.h

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index a16d9787dcd2c1..1d43472fecbde1 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/cryptohash.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha1_base.h>
diff --git a/drivers/char/random.c b/drivers/char/random.c
index a19a8984741b60..cae02b2a871c32 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -327,7 +327,6 @@
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/percpu.h>
-#include <linux/cryptohash.h>
 #include <linux/fips.h>
 #include <linux/ptrace.h>
 #include <linux/workqueue.h>
@@ -337,6 +336,7 @@
 #include <linux/completion.h>
 #include <linux/uuid.h>
 #include <crypto/chacha.h>
+#include <crypto/sha.h>
 
 #include <asm/processor.h>
 #include <linux/uaccess.h>
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 5c2132c7190095..405dd20419165c 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -113,6 +113,16 @@ extern int crypto_sha512_update(struct shash_desc *desc, const u8 *data,
 extern int crypto_sha512_finup(struct shash_desc *desc, const u8 *data,
 			       unsigned int len, u8 *hash);
 
+/*
+ * An implementation of SHA-1's compression function.  Don't use in new code!
+ * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
+ * the correct way to hash something with SHA-1 (use crypto_shash instead).
+ */
+#define SHA1_DIGEST_WORDS	(SHA1_DIGEST_SIZE / 4)
+#define SHA1_WORKSPACE_WORDS	16
+void sha1_init(__u32 *buf);
+void sha1_transform(__u32 *digest, const char *data, __u32 *W);
+
 /*
  * Stand-alone implementation of the SHA256 algorithm. It is designed to
  * have as little dependencies as possible so it can be used in the
diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
deleted file mode 100644
index c324ffca96e0d5..00000000000000
--- a/include/linux/cryptohash.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __CRYPTOHASH_H
-#define __CRYPTOHASH_H
-
-#include <uapi/linux/types.h>
-
-/*
- * An implementation of SHA-1's compression function.  Don't use in new code!
- * You shouldn't be using SHA-1, and even if you *have* to use SHA-1, this isn't
- * the correct way to hash something with SHA-1 (use crypto_shash instead).
- */
-#define SHA1_DIGEST_WORDS 5
-#define SHA1_BLOCK_SIZE 64
-#define SHA1_WORKSPACE_WORDS 16
-void sha1_init(__u32 *buf);
-void sha1_transform(__u32 *digest, const char *data, __u32 *W);
-
-#endif
diff --git a/include/linux/filter.h b/include/linux/filter.h
index f42662adffe47f..ec45fd7992c957 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -16,11 +16,11 @@
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
-#include <linux/cryptohash.h>
 #include <linux/set_memory.h>
 #include <linux/kallsyms.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <crypto/sha.h>
 
 #include <net/sch_generic.h>
 
diff --git a/lib/sha1.c b/lib/sha1.c
index b381e8cd4fe447..49257a915bb604 100644
--- a/lib/sha1.c
+++ b/lib/sha1.c
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/bitops.h>
-#include <linux/cryptohash.h>
+#include <crypto/sha.h>
 #include <asm/unaligned.h>
 
 /*
-- 
2.26.2

