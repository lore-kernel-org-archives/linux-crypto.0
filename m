From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/2] padata: Fix wrong usage of rcu_dereference()
Date: Thu, 28 Nov 2013 19:20:05 +0100
Message-ID: <1385662805-16919-3-git-send-email-minipli@googlemail.com>
References: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58804 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3K1SUT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 13:20:19 -0500
Received: by mail-bk0-f49.google.com with SMTP id my13so3922660bkb.36
        for <linux-crypto@vger.kernel.org>; Thu, 28 Nov 2013 10:20:18 -0800 (PST)
In-Reply-To: <1385662805-16919-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A kernel with enabled lockdep complains about the wrong usage of
rcu_dereference() under a rcu_read_lock_bh() protected region.

  ===============================
  [ INFO: suspicious RCU usage. ]
  3.13.0-rc1+ #126 Not tainted
  -------------------------------
  linux/kernel/padata.c:115 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 1, debug_locks = 1
  1 lock held by cryptomgr_test/153:
   #0:  (rcu_read_lock_bh){.+....}, at: [<ffffffff8115c235>] padata_do_parallel+0x5/0x270

Fix that by using rcu_dereference_bh() instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 2abd25d79c..161402f0b5 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -112,7 +112,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 
 	rcu_read_lock_bh();
 
-	pd = rcu_dereference(pinst->pd);
+	pd = rcu_dereference_bh(pinst->pd);
 
 	err = -EINVAL;
 	if (!(pinst->flags & PADATA_INIT) || pinst->flags & PADATA_INVALID)
-- 
1.7.10.4
