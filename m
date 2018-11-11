Return-Path: <SRS0=7Tml=NW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbeKLFdr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 00:33:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wABJi9pl051049
        for <linux-crypto@vger.kernel.org>; Sun, 11 Nov 2018 14:44:20 -0500
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2npdbghdx3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sun, 11 Nov 2018 14:44:20 -0500
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
        Sun, 11 Nov 2018 19:44:19 -0000
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH tip/core/rcu 09/41] crypto/pcrypt: Replace synchronize_rcu_bh() with synchronize_rcu()
Date: Sun, 11 Nov 2018 11:43:38 -0800
In-Reply-To: <20181111194104.GA4787@linux.ibm.com>
References: <20181111194104.GA4787@linux.ibm.com>
Message-Id: <20181111194410.6368-9-paulmck@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that synchronize_rcu() waits for bh-disable regions of code as
well as RCU read-side critical sections, the synchronize_rcu_bh() in
pcrypt_cpumask_change_notify() can be replaced by synchronize_rcu().
This commit therefore makes this change.

Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: <linux-crypto@vger.kernel.org>
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
-- 
2.17.1
