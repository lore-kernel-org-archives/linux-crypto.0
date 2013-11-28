From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 1/2] crypto: pcrypt - Fix wrong usage of rcu_dereference()
Date: Thu, 28 Nov 2013 19:20:04 +0100
Message-ID: <1385662805-16919-2-git-send-email-minipli@googlemail.com>
References: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33746 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1SUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 13:20:19 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so3947458bkz.14
        for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 10:20:17 -0800 (PST)
In-Reply-To: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A kernel with enabled lockdep complains about the wrong usage of
rcu_dereference() under a rcu_read_lock_bh() protected region.

  ===============================
  [ INFO: suspicious RCU usage. ]
  3.13.0-rc1+ #126 Not tainted
  -------------------------------
  linux/crypto/pcrypt.c:81 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 1, debug_locks = 1
  1 lock held by cryptomgr_test/153:
   #0:  (rcu_read_lock_bh){.+....}, at: [<ffffffff812c8075>] pcrypt_do_parallel.isra.2+0x5/0x200

Fix that by using rcu_dereference_bh() instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 crypto/pcrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index f8c920cafe..309d345ead 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -78,7 +78,7 @@ static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
 	cpu = *cb_cpu;
 
 	rcu_read_lock_bh();
-	cpumask = rcu_dereference(pcrypt->cb_cpumask);
+	cpumask = rcu_dereference_bh(pcrypt->cb_cpumask);
 	if (cpumask_test_cpu(cpu, cpumask->mask))
 			goto out;
 
-- 
1.7.10.4
