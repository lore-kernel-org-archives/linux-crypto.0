From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 1/2] asymmetric_keys: make crypto builtin if asymmetric keys
 selected as builtin
Date: Fri, 11 Jul 2014 18:59:44 +0300
Message-ID: <acdd27e3b559b0c1bc57a9393e4e5540a90bab36.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50502 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaGKQBS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 12:01:18 -0400
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1405094060.git.d.kasatkin@samsung.com>
References: <cover.1405094060.git.d.kasatkin@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When ASYMMETRIC_KEYS=y, but depends on CRYPTO=m, selections will be also modules.
In random config case OID_REGISTRY, MPILIB and ASN1 became modules producing build
break. This patch removes asymmetric keys dependency from CRYPTO, but instead
selects CRYPTO and CRYPTO_HASH as they are needed.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/Kconfig                 | 6 +++++-
 crypto/asymmetric_keys/Kconfig | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..96835d6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -10,6 +10,11 @@ config XOR_BLOCKS
 source "crypto/async_tx/Kconfig"
 
 #
+# asymmetric keys
+#
+source crypto/asymmetric_keys/Kconfig
+
+#
 # Cryptographic API Configuration
 #
 menuconfig CRYPTO
@@ -1405,6 +1410,5 @@ config CRYPTO_HASH_INFO
 	bool
 
 source "drivers/crypto/Kconfig"
-source crypto/asymmetric_keys/Kconfig
 
 endif	# if CRYPTO
diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 03a6eb9..a38d2d4 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -30,6 +30,8 @@ config PUBLIC_KEY_ALGO_RSA
 config X509_CERTIFICATE_PARSER
 	tristate "X.509 certificate parser"
 	depends on ASYMMETRIC_PUBLIC_KEY_SUBTYPE
+	select CRYPTO
+	select CRYPTO_HASH
 	select ASN1
 	select OID_REGISTRY
 	help
-- 
1.9.1
