From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 08/19] crypto: seqiv - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:22 +0100
Message-ID: <1266538943-3344-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/seqiv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 5a013a8..ba79b09 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -116,7 +116,7 @@ static int seqiv_givencrypt(struct skcipher_givcrypt_request *req)
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_ablkcipher_alignmask(geniv) + 1))) {
 		info = kmalloc(ivsize, req->creq.base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 								  GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
@@ -162,7 +162,7 @@ static int seqiv_aead_givencrypt(struct aead_givcrypt_request *req)
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
 		info = kmalloc(ivsize, areq->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
+				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 								  GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
-- 
1.6.6.1
