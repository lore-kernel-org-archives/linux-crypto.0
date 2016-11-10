From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/3] crypto: AF_ALG - fix AEAD AIO handling of zero buffer
Date: Thu, 10 Nov 2016 04:32:27 +0100
Message-ID: <2337985.xlcote9QFO@positron.chronox.de>
References: <3302668.EORF2jai5r@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50816 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbcKJDdw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 22:33:52 -0500
In-Reply-To: <3302668.EORF2jai5r@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Handle the case when the caller provided a zero buffer to
sendmsg/sendpage. Such scenario is legal for AEAD ciphers when no
plaintext / ciphertext and no AAD is provided and the caller only
requests the generation of the tag value.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 0212cc2..d52e8b2 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -510,12 +510,13 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 				  aead_async_cb, sk);
 
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
2.7.4
