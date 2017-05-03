From: Tudor-Dan Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: kpp, (ec)dh - fix typos
Date: Wed, 3 May 2017 12:35:26 +0300
Message-ID: <1493804126-28143-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62465 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdECJfc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 05:35:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Tudor-Dan Ambarus <tudor.ambarus@microchip.com>
---
 crypto/dh.c           | 4 ++--
 crypto/dh_helper.c    | 4 ++--
 crypto/ecdh.c         | 4 ++--
 crypto/ecdh_helper.c  | 4 ++--
 include/crypto/dh.h   | 4 ++--
 include/crypto/ecdh.h | 4 ++--
 include/crypto/kpp.h  | 4 ++--
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 87e3542..7cec0498 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -4,9 +4,9 @@
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
+ * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * 2 of the License, or (at your option) any later version.
  */
 
 #include <linux/module.h>
diff --git a/crypto/dh_helper.c b/crypto/dh_helper.c
index 02db76b..8ba8a3f 100644
--- a/crypto/dh_helper.c
+++ b/crypto/dh_helper.c
@@ -3,9 +3,9 @@
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
+ * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * 2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 63ca337..3623307 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -4,9 +4,9 @@
  * Authors: Salvator Benedetto <salvatore.benedetto@intel.com>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
+ * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * 2 of the License, or (at your option) any later version.
  */
 
 #include <linux/module.h>
diff --git a/crypto/ecdh_helper.c b/crypto/ecdh_helper.c
index 3cd8a24..f05bea5 100644
--- a/crypto/ecdh_helper.c
+++ b/crypto/ecdh_helper.c
@@ -3,9 +3,9 @@
  * Authors: Salvatore Benedetto <salvatore.benedetto@intel.com>
  *
  * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
+ * modify it under the terms of the GNU General Public License
  * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
+ * 2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
diff --git a/include/crypto/dh.h b/include/crypto/dh.h
index 6b424ad..f638998 100644
--- a/include/crypto/dh.h
+++ b/include/crypto/dh.h
@@ -73,9 +73,9 @@ int crypto_dh_encode_key(char *buf, unsigned int len, const struct dh *params);
 /**
  * crypto_dh_decode_key() - decode a private key
  * @buf:	Buffer holding a packet key that should be decoded
- * @len:	Lenth of the packet private key buffer
+ * @len:	Length of the packet private key buffer
  * @params:	Buffer allocated by the caller that is filled with the
- *		unpacket DH private key.
+ *		unpacked DH private key.
  *
  * The unpacking obtains the private key by pointing @p to the correct location
  * in @buf. Thus, both pointers refer to the same memory.
diff --git a/include/crypto/ecdh.h b/include/crypto/ecdh.h
index 03a64f6..1aff2a8 100644
--- a/include/crypto/ecdh.h
+++ b/include/crypto/ecdh.h
@@ -74,9 +74,9 @@ int crypto_ecdh_encode_key(char *buf, unsigned int len, const struct ecdh *p);
 /**
  * crypto_ecdh_decode_key() - decode a private key
  * @buf:	Buffer holding a packet key that should be decoded
- * @len:	Lenth of the packet private key buffer
+ * @len:	Length of the packet private key buffer
  * @p:		Buffer allocated by the caller that is filled with the
- *		unpacket ECDH private key.
+ *		unpacked ECDH private key.
  *
  * The unpacking obtains the private key by pointing @p to the correct location
  * in @buf. Thus, both pointers refer to the same memory.
diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h
index ce8e1f7..c190825 100644
--- a/include/crypto/kpp.h
+++ b/include/crypto/kpp.h
@@ -53,7 +53,7 @@ struct crypto_kpp {
  *
  * @set_secret:		Function invokes the protocol specific function to
  *			store the secret private key along with parameters.
- *			The implementation knows how to decode thie buffer
+ *			The implementation knows how to decode the buffer
  * @generate_public_key: Function generate the public key to be sent to the
  *			counterpart. In case of error, where output is not big
  *			enough req->dst_len will be updated to the size
@@ -102,7 +102,7 @@ struct kpp_alg {
  * @mask: specifies the mask for the algorithm
  *
  * Allocate a handle for kpp algorithm. The returned struct crypto_kpp
- * is requeried for any following API invocation
+ * is required for any following API invocation
  *
  * Return: allocated handle in case of success; IS_ERR() is true in case of
  *	   an error, PTR_ERR() returns the error code.
-- 
2.7.4
