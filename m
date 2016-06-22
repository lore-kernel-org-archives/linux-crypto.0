From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: user - re-add size check for CRYPTO_MSG_GETALG
Date: Wed, 22 Jun 2016 20:29:37 +0200
Message-ID: <1466620177-10998-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35900 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbcFVSaN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 14:30:13 -0400
Received: by mail-wm0-f68.google.com with SMTP id c82so3821132wme.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2016 11:30:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
accidentally removed the minimum size check for CRYPTO_MSG_GETALG
netlink messages. This allows userland to send a truncated
CRYPTO_MSG_GETALG message as short as a netlink header only making
crypto_report() operate on uninitialized memory by accessing data
beyond the end of the netlink message.

Fix this be re-adding the minimum required size of CRYPTO_MSG_GETALG
messages to the crypto_msg_min[] array.

Fixes: 9aa867e46565 ("crypto: user - Add CRYPTO_MSG_DELRNG")
Cc: stable@vger.kernel.org	# v4.2
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
This should go on top of crypto-2.6/master.

 crypto/crypto_user.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index 43fe85f20d57..7097a3395b25 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -455,6 +455,7 @@ static const int crypto_msg_min[CRYPTO_NR_MSGTYPES] = {
 	[CRYPTO_MSG_NEWALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_DELALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_UPDATEALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
+	[CRYPTO_MSG_GETALG	- CRYPTO_MSG_BASE] = MSGSIZE(crypto_user_alg),
 	[CRYPTO_MSG_DELRNG	- CRYPTO_MSG_BASE] = 0,
 };
 
-- 
1.7.10.4
