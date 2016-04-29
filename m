From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH] lib: asn1_decoder - add MODULE_LICENSE("GPL")
Date: Fri, 29 Apr 2016 17:48:08 +0300
Message-ID: <1461941288-10356-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	"Tudor Ambarus" <tudor-dan.ambarus@nxp.com>
To: <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0056.outbound.protection.outlook.com ([157.56.111.56]:59785
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753369AbcD2OsU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 10:48:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A kernel taint results when loading the rsa_generic module:

root@(none):~# modprobe rsa_generic
asn1_decoder: module license 'unspecified' taints kernel.
Disabling lock debugging due to kernel taint

"Tainting" of the kernel is (usually) a way of indicating that
a proprietary module has been inserted, which is not the case here.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 lib/asn1_decoder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/asn1_decoder.c b/lib/asn1_decoder.c
index 2b3f46c..b1ffcab 100644
--- a/lib/asn1_decoder.c
+++ b/lib/asn1_decoder.c
@@ -12,6 +12,7 @@
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/module.h>
 #include <linux/asn1_decoder.h>
 #include <linux/asn1_ber_bytecode.h>
 
@@ -504,3 +505,5 @@ error:
 	return -EBADMSG;
 }
 EXPORT_SYMBOL_GPL(asn1_ber_decoder);
+
+MODULE_LICENSE("GPL");
-- 
1.8.3.1
