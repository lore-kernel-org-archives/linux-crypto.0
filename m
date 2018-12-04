Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from terminus.zytor.com ([198.137.202.136]:50153 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeLDWhf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 17:37:35 -0500
Date: Tue, 4 Dec 2018 14:37:11 -0800
From: "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-a0076e1778c23de4a42d90fee4ecb4c21dbb5838@git.kernel.org>
Cc: linux-crypto@vger.kernel.org, paulmck@linux.ibm.com,
        herbert@gondor.apana.org.au, hpa@zytor.com, tglx@linutronix.de,
        steffen.klassert@secunet.com, mingo@kernel.org
Reply-To: paulmck@linux.ibm.com, linux-kernel@vger.kernel.org,
          hpa@zytor.com, mingo@kernel.org, linux-crypto@vger.kernel.org,
          herbert@gondor.apana.org.au, tglx@linutronix.de,
          steffen.klassert@secunet.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] crypto/pcrypt: Replace synchronize_rcu_bh() with
 synchronize_rcu()
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit-ID:  a0076e1778c23de4a42d90fee4ecb4c21dbb5838
Gitweb:     https://git.kernel.org/tip/a0076e1778c23de4a42d90fee4ecb4c21dbb5838
Author:     Paul E. McKenney <paulmck@linux.ibm.com>
AuthorDate: Mon, 5 Nov 2018 16:57:40 -0800
Committer:  Paul E. McKenney <paulmck@linux.ibm.com>
CommitDate: Tue, 27 Nov 2018 09:18:59 -0800

crypto/pcrypt: Replace synchronize_rcu_bh() with synchronize_rcu()

Now that synchronize_rcu() waits for bh-disable regions of code as
well as RCU read-side critical sections, the synchronize_rcu_bh() in
pcrypt_cpumask_change_notify() can be replaced by synchronize_rcu().
This commit therefore makes this change.

Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: <linux-crypto@vger.kernel.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/pcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index f8ec3d4ba4a8..8eb3c4c9ff67 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -382,7 +382,7 @@ static int pcrypt_cpumask_change_notify(struct notifier_block *self,
 
 	cpumask_copy(new_mask->mask, cpumask->cbcpu);
 	rcu_assign_pointer(pcrypt->cb_cpumask, new_mask);
-	synchronize_rcu_bh();
+	synchronize_rcu();
 
 	free_cpumask_var(old_mask->mask);
 	kfree(old_mask);
