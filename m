From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - return error code when no data was processed
Date: Sun, 30 Jul 2017 14:31:18 +0200
Message-ID: <3015646.VmS85RP8pt@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60838 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754188AbdG3RmQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2017 13:42:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If no data has been processed during recvmsg, return the error code.
This covers all errors received during non-AIO operations.

If any error occurs during a synchronous operation in addition to
-EIOCBQUEUED or -EBADMSG (like -ENOMEM), it should be relayed to the
caller.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 4 +++-
 crypto/algif_skcipher.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 9755aac0fe26..2de056c3139c 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -791,9 +791,11 @@ static int aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 * only handle one AIO request. If the caller wants to have
 		 * multiple AIO requests in parallel, he must make multiple
 		 * separate AIO calls.
+		 *
+		 * Also return the error if no data has been processed so far.
 		 */
 		if (err <= 0) {
-			if (err == -EIOCBQUEUED || err == -EBADMSG)
+			if (err == -EIOCBQUEUED || err == -EBADMSG || !ret)
 				ret = err;
 			goto out;
 		}
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 968d094f0bcc..ce3b5fba2279 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -714,9 +714,11 @@ static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		 * only handle one AIO request. If the caller wants to have
 		 * multiple AIO requests in parallel, he must make multiple
 		 * separate AIO calls.
+		 *
+		 * Also return the error if no data has been processed so far.
 		 */
 		if (err <= 0) {
-			if (err == -EIOCBQUEUED)
+			if (err == -EIOCBQUEUED || !ret)
 				ret = err;
 			goto out;
 		}
-- 
2.13.3
