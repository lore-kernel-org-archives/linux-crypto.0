From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] crypt: ablkcipher: remove redundant NULL check
Date: Tue, 25 Jan 2011 13:27:45 -0300
Message-ID: <1295972865.1998.9.camel@offworld>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 crypto/ablkcipher.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index a854df2..fdc67d3 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -141,8 +141,7 @@ err:
 
 	if (walk->iv != req->info)
 		memcpy(req->info, walk->iv, tfm->crt_ablkcipher.ivsize);
-	if (walk->iv_buffer)
-		kfree(walk->iv_buffer);
+	kfree(walk->iv_buffer);
 
 	return err;
 }
-- 
1.7.1
