From: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 09/31] crypto: use kmemdup rather than duplicating its
 implementation
Date: Fri, 07 Aug 2015 09:59:15 +0200
Message-ID: <1438934377-4922-10-git-send-email-a.hajda@samsung.com>
References: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1438934377-4922-1-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The patch was generated using fixed coccinelle semantic patch
scripts/coccinelle/api/memdup.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2014320

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 crypto/echainiv.c | 7 ++-----
 crypto/seqiv.c    | 6 ++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index d3896c7..d8968c0 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -134,13 +134,10 @@ static int echainiv_encrypt(struct aead_request *req)
 
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
+		info = kmemdup(req->iv, ivsize,
+			       req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
-
-		memcpy(info, req->iv, ivsize);
 	}
 
 	aead_request_set_callback(subreq, req->base.flags, compl, data);
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 45d0563..eb83236 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -362,13 +362,11 @@ static int seqiv_aead_encrypt(struct aead_request *req)
 
 	if (unlikely(!IS_ALIGNED((unsigned long)info,
 				 crypto_aead_alignmask(geniv) + 1))) {
-		info = kmalloc(ivsize, req->base.flags &
-				       CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL:
-								  GFP_ATOMIC);
+		info = kmemdup(req->iv, ivsize,
+			       req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC);
 		if (!info)
 			return -ENOMEM;
 
-		memcpy(info, req->iv, ivsize);
 		compl = seqiv_aead_encrypt_complete;
 		data = req;
 	}
-- 
1.9.1
