From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: AF_ALG - fix AEAD AIO handling of zero buffer
Date: Thu, 01 Dec 2016 08:22:37 +0100
Message-ID: <3547426.Fep2bfj8cH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:52012 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754743AbcLAHXJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 02:23:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I split out the bug fix patch from the AD/tag formatting patch as they most likely will come after the next merge window.

---8<---

Handle the case when the caller provided a zero buffer to
sendmsg/sendpage. Such scenario is legal for AEAD ciphers when no
plaintext / ciphertext and no AAD is provided and the caller only
requests the generation of the tag value.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 80a0f1a..6e95137 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -448,12 +448,13 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
 
 	/* take over all tx sgls from ctx */
-	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * sgl->cur,
+	areq->tsgl = sock_kmalloc(sk,
+				  sizeof(*areq->tsgl) * max_t(u32, sgl->cur, 1),
 				  GFP_KERNEL);
 	if (unlikely(!areq->tsgl))
 		goto free;
 
-	sg_init_table(areq->tsgl, sgl->cur);
+	sg_init_table(areq->tsgl, max_t(u32, sgl->cur, 1));
 	for (i = 0; i < sgl->cur; i++)
 		sg_set_page(&areq->tsgl[i], sg_page(&sgl->sg[i]),
 			    sgl->sg[i].length, sgl->sg[i].offset);
-- 
2.9.3
