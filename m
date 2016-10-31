From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] crypto: cryptd - Remove unused but set variable 'tfm'
Date: Mon, 31 Oct 2016 15:42:43 +0100
Message-ID: <20161031144243.18152-1-tklauser@distanz.ch>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:51168 "EHLO mail.zhinst.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943488AbcJaOs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 10:48:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the unused but set variable tfm in cryptd_enqueue_request to fix
the following warning when building with 'W=1':

crypto/cryptd.c:125:21: warning: variable 'tfm' set but not used [-Wunused-but-set-variable]

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 crypto/cryptd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 0c654e59f215..3fd2a20a8145 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -122,7 +122,6 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 {
 	int cpu, err;
 	struct cryptd_cpu_queue *cpu_queue;
-	struct crypto_tfm *tfm;
 	atomic_t *refcnt;
 	bool may_backlog;
 
@@ -141,7 +140,6 @@ static int cryptd_enqueue_request(struct cryptd_queue *queue,
 	if (!atomic_read(refcnt))
 		goto out_put_cpu;
 
-	tfm = request->tfm;
 	atomic_inc(refcnt);
 
 out_put_cpu:
-- 
2.9.0
