From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] crypto: fix build failure in mv_cesa.c (missing of header)
Date: Fri,  9 Mar 2012 14:58:25 -0500
Message-ID: <1331323105-21034-1-git-send-email-paul.gortmaker@windriver.com>
Cc: linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: michael@walle.cc, jason@lakedaemon.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:47281 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030655Ab2CIT6h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Mar 2012 14:58:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 737b75872487f560397ba34846a19823b1addf88 (linux-next)

    "ARM: kirkwood: mv_cesa devicetree bindings"

fails to compile as follows:

 CC      drivers/crypto/mv_cesa.o
 drivers/crypto/mv_cesa.c:1139: error: implicit declaration of function 'of_match_ptr'
 drivers/crypto/mv_cesa.c:1139: error: 'mv_cesa_dt_ids' undeclared here (not in a function)
 drivers/crypto/mv_cesa.c:1139: error: initializer element is not constant
 drivers/crypto/mv_cesa.c:1139: error: (near initialization for 'marvell_crypto.driver.of_match_table')

because it is missing the linux/of.h header file.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index b7a3d48..093e214 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -10,6 +10,7 @@
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 #include <linux/io.h>
 #include <linux/kthread.h>
 #include <linux/platform_device.h>
-- 
1.7.9.1
