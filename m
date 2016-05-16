From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: user - no parsing of CRYPTO_MSG_GETALG
Date: Mon, 16 May 2016 02:53:36 +0200
Message-ID: <2794859.sgsFI1z3Ep@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39426 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbcEPCau (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 May 2016 22:30:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CRYPTO_MSG_GETALG netlink message type provides a buffer to the
kernel to retrieve information from the kernel. The data buffer will not
provide any input and will not be read. Hence the nlmsg_parse is not
applicable to this netlink message type.

This patch fixes the following kernel log message when using this
netlink interface:

netlink: 208 bytes leftover after parsing attributes in process `XXX'.

Patch successfully tested with libkcapi from [1] which uses
CRYPTO_MSG_GETALG to obtain cipher-specific information from the kernel.

[1] http://www.chronox.de/libkcapi.html

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/crypto_user.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 43fe85f..f71960d 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -516,10 +516,12 @@ static int crypto_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		return err;
 	}
 
-	err = nlmsg_parse(nlh, crypto_msg_min[type], attrs, CRYPTOCFGA_MAX,
-			  crypto_policy);
-	if (err < 0)
-		return err;
+	if (type != (CRYPTO_MSG_GETALG - CRYPTO_MSG_BASE)) {
+		err = nlmsg_parse(nlh, crypto_msg_min[type], attrs,
+				  CRYPTOCFGA_MAX, crypto_policy);
+		if (err < 0)
+			return err;
+	}
 
 	if (link->doit == NULL)
 		return -EINVAL;
-- 
2.5.5
