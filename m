From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: algif_aead - fix comment regarding memory layout
Date: Wed, 09 Aug 2017 16:20:00 +0200
Message-ID: <1863751.KMZUYKXSmc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58404 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbdHIOUC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 10:20:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 48d46e74ed0d..516b38c3a169 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -201,11 +201,11 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		 * Encryption operation - The in-place cipher operation is
 		 * achieved by the following operation:
 		 *
-		 * TX SGL: AAD || PT || Tag
+		 * TX SGL: AAD || PT
 		 *	    |	   |
 		 *	    | copy |
 		 *	    v	   v
-		 * RX SGL: AAD || PT
+		 * RX SGL: AAD || PT || Tag
 		 */
 		err = crypto_aead_copy_sgl(null_tfm, tsgl->sg,
 					   areq->first_rsgl.sgl.sg, processed);
-- 
2.13.4
