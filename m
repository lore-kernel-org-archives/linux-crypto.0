From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/2] digsig: make crypto builtin if digsig selected as builtin
Date: Fri, 11 Jul 2014 18:59:45 +0300
Message-ID: <7afa0a5a9343ddb354478536bd9dc670057fbebe.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40507 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaGKQBT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:19 -0400
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When SIGNATURE=y but depends on CRYPTO=m, it selects MPILIB as module
producing build break. This patch makes digsig to select crypto for
correcting dependency.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 lib/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 334f772..a8a775730 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -451,7 +451,8 @@ config MPILIB
 
 config SIGNATURE
 	tristate
-	depends on KEYS && CRYPTO
+	depends on KEYS
+	select CRYPTO
 	select CRYPTO_SHA1
 	select MPILIB
 	help
-- 
1.9.1
