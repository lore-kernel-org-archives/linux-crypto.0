From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] avoid excessive use of socket buffer in skcipher
Date: Mon, 25 Aug 2014 11:48:05 +0200
Message-ID: <1408960085-11583-2-git-send-email-okozina@redhat.com>
References: <1408960085-11583-1-git-send-email-okozina@redhat.com>
Cc: herbert@gondor.apana.org.au, gmazyland@gmail.com
To: okozina@redhat.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaHYJsV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Aug 2014 05:48:21 -0400
In-Reply-To: <1408960085-11583-1-git-send-email-okozina@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On archs with PAGE_SIZE >= 64 KiB the function skcipher_alloc_sgl()
fails with -ENOMEM no matter what user space actually requested.
This is caused by the fact sock_kmalloc call inside the function tried
to allocate more memory than allowed by the default kernel socket buffer
size (kernel param net.core.optmem_max).

Signed-off-by: Ondrej Kozina <okozina@redhat.com>
---
 crypto/algif_skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a19c027..83187f4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
 	struct ablkcipher_request req;
 };
 
-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
 static inline int skcipher_sndbuf(struct sock *sk)
-- 
1.9.3
