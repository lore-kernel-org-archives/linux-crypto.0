From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] net - Add AF_ALG macros
Date: Mon, 15 Nov 2010 19:53:15 +0800
Message-ID: <E1PHxcZ-00010l-Jt@gondolin.me.apana.org.au>
References: <20101115115120.GA3797@gondor.apana.org.au>
To: Martin Willi <martin@strongswan.org>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47831 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0KOLxR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 06:53:17 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

net - Add AF_ALG macros

This patch adds the socket family/level macros for the yet-to-be-born
AF_ALG family.  The AF_ALG family provides the user-space interface
for the kernel crypto API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: David S. Miller <davem@davemloft.net>
---

 include/linux/socket.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 5146b50..ebc081b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -193,7 +193,8 @@ struct ucred {
 #define AF_PHONET	35	/* Phonet sockets		*/
 #define AF_IEEE802154	36	/* IEEE802154 sockets		*/
 #define AF_CAIF		37	/* CAIF sockets			*/
-#define AF_MAX		38	/* For now.. */
+#define AF_ALG		38	/* Algorithm sockets		*/
+#define AF_MAX		39	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -234,6 +235,7 @@ struct ucred {
 #define PF_PHONET	AF_PHONET
 #define PF_IEEE802154	AF_IEEE802154
 #define PF_CAIF		AF_CAIF
+#define PF_ALG		AF_ALG
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
@@ -307,6 +309,7 @@ struct ucred {
 #define SOL_RDS		276
 #define SOL_IUCV	277
 #define SOL_CAIF	278
+#define SOL_ALG		279
 
 /* IPX options */
 #define IPX_TYPE	1
