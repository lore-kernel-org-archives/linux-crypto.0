From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v2] crypto: Add a flag allowing the self-tests to be disabled at runtime.
Date: Fri, 29 Apr 2016 12:03:04 +0100
Message-ID: <1461927784-19114-2-git-send-email-rjones@redhat.com>
References: <1461927784-19114-1-git-send-email-rjones@redhat.com>
Cc: corbet@lwn.net, herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbcD2LDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 07:03:10 -0400
In-Reply-To: <1461927784-19114-1-git-send-email-rjones@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Running self-tests for a short-lived KVM VM takes 28ms on my laptop.
This commit adds a flag 'cryptomgr.notests' which allows them to be
disabled.

Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
---
 Documentation/kernel-parameters.txt | 3 +++
 crypto/testmgr.c                    | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 0b3de80..d4d5fb7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -826,6 +826,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			It will be ignored when crashkernel=X,high is not used
 			or memory reserved is below 4G.
 
+	cryptomgr.notests
+                        [KNL] Disable crypto self-tests
+
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b86883a..5c0664d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -35,6 +35,10 @@
 
 #include "internal.h"
 
+static bool notests;
+module_param(notests, bool, 0644);
+MODULE_PARM_DESC(notests, "disable crypto self-tests");
+
 #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
 
 /* a perfect nop */
@@ -3868,6 +3872,11 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	int j;
 	int rc;
 
+	if (notests) {
+		printk_once(KERN_INFO "alg: self-tests disabled\n");
+		return 0;
+	}
+
 	alg_test_descs_check_order();
 
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
-- 
2.7.4
