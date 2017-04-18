From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 3/8] crypto: AF_ALG - eliminate code duplication
Date: Wed, 19 Apr 2017 01:05:38 +0200
Message-ID: <4484166.pzJ5tnBlJD@positron.chronox.de>
References: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: keyrings@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59002 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758032AbdDRXJy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:09:54 -0400
In-Reply-To: <2715753.J0rCo2lbig@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The handling function for setsockopt contains duplicated code which is
cleaned up with this patch. This patch does not change the functionality.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index a3210bf..f2b2865 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -247,34 +247,23 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_ALG || !type)
 		goto unlock;
 
+	if (sock->state == SS_CONNECTED)
+		goto unlock;
+
 	switch (optname) {
 	case ALG_SET_KEY:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
-
 		err = alg_setkey(sk, optval, optlen, type->setkey);
 		break;
 	case ALG_SET_PUBKEY:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
-
 		err = alg_setkey(sk, optval, optlen, type->setpubkey);
 		break;
 	case ALG_SET_DH_PARAMETERS:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
-
 		err = alg_setkey(sk, optval, optlen, type->dhparams);
 		break;
 	case ALG_SET_ECDH_CURVE:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
-
 		err = alg_setkey(sk, optval, optlen, type->ecdhcurve);
 		break;
 	case ALG_SET_AEAD_AUTHSIZE:
-		if (sock->state == SS_CONNECTED)
-			goto unlock;
 		if (!type->setauthsize)
 			goto unlock;
 		err = type->setauthsize(ask->private, optlen);
-- 
2.9.3
