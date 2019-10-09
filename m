Return-Path: <SRS0=7GLU=YC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4447EC47404
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 09:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23F1B21721
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 09:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbfJIJND (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:13:03 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:49460 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfJIJND (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Oct 2019 05:13:03 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iI81i-0000Dd-71; Wed, 09 Oct 2019 10:12:58 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iI81h-0003Mo-OI; Wed, 09 Oct 2019 10:12:57 +0100
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@lists.codethink.co.uk,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] crypto: jitter - add header to fix buildwarnings
Date:   Wed,  9 Oct 2019 10:12:56 +0100
Message-Id: <20191009091256.12896-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix the following build warnings by adding a header for
the definitions shared between jitterentropy.c and
jitterentropy-kcapi.c. Fixes the following:

crypto/jitterentropy.c:445:5: warning: symbol 'jent_read_entropy' was not declared. Should it be static?
crypto/jitterentropy.c:475:18: warning: symbol 'jent_entropy_collector_alloc' was not declared. Should it be static?
crypto/jitterentropy.c:509:6: warning: symbol 'jent_entropy_collector_free' was not declared. Should it be static?
crypto/jitterentropy.c:516:5: warning: symbol 'jent_entropy_init' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:59:6: warning: symbol 'jent_zalloc' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:64:6: warning: symbol 'jent_zfree' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:69:5: warning: symbol 'jent_fips_enabled' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:74:6: warning: symbol 'jent_panic' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:79:6: warning: symbol 'jent_memcpy' was not declared. Should it be static?
crypto/jitterentropy-kcapi.c:93:6: warning: symbol 'jent_get_nstime' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 crypto/jitterentropy-kcapi.c |  8 +-------
 crypto/jitterentropy.c       |  7 +------
 crypto/jitterentropy.h       | 17 +++++++++++++++++
 3 files changed, 19 insertions(+), 13 deletions(-)
 create mode 100644 crypto/jitterentropy.h

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 701b8d86ab49..a5ce8f96790f 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -44,13 +44,7 @@
 #include <linux/crypto.h>
 #include <crypto/internal/rng.h>
 
-struct rand_data;
-int jent_read_entropy(struct rand_data *ec, unsigned char *data,
-		      unsigned int len);
-int jent_entropy_init(void);
-struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
-					       unsigned int flags);
-void jent_entropy_collector_free(struct rand_data *entropy_collector);
+#include "jitterentropy.h"
 
 /***************************************************************************
  * Helper function
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 77fa2120fe0c..e342db4084d3 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -103,12 +103,7 @@ struct rand_data {
  * Helper functions
  ***************************************************************************/
 
-void jent_get_nstime(__u64 *out);
-void *jent_zalloc(unsigned int len);
-void jent_zfree(void *ptr);
-int jent_fips_enabled(void);
-void jent_panic(char *s);
-void jent_memcpy(void *dest, const void *src, unsigned int n);
+#include "jitterentropy.h"
 
 /**
  * Update of the loop count used for the next round of
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
new file mode 100644
index 000000000000..c83fff32d130
--- /dev/null
+++ b/crypto/jitterentropy.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+extern void *jent_zalloc(unsigned int len);
+extern void jent_zfree(void *ptr);
+extern int jent_fips_enabled(void);
+extern void jent_panic(char *s);
+extern void jent_memcpy(void *dest, const void *src, unsigned int n);
+extern void jent_get_nstime(__u64 *out);
+
+struct rand_data;
+extern int jent_entropy_init(void);
+extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
+			     unsigned int len);
+
+extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
+						      unsigned int flags);
+extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
-- 
2.23.0

