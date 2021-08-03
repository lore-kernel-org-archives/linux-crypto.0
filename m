Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C067C4320A
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 14:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 357F36054F
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 14:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhHCORl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Aug 2021 10:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbhHCOR2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Aug 2021 10:17:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31BC06179E;
        Tue,  3 Aug 2021 07:17:14 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BIWpi0J5GKgm++CC4pz/dS7QJOqOdYQfXdusIGoqZtU=;
        b=fbxorotkjX+w9iOuY5fTl6mXiRrH2STnzhtXgQvRtfYnyoTaLlVLRGNkIhx01UbFNg5/Xf
        EIJfblnVYXSN3VApYpI20NeBoKobofjuVNgZ9JiBWQMPZxFQXCmJzKdqwwtbopPEnAHktQ
        g6YZ33G+hRYMp/ew63Zy+b2umvD1ZoSqxLIFt2c5QufnDv4//zpx9piHkB5SquMoqxPSQ6
        UZUWsbAiuNc3Bs4n9ENSIwmPn6GMdFHfi55EoIch+YddG6c38pBeJiaOT0rNcuRPl/+VgR
        iBM/RQWicizTZatysPB6Q2UGZRcJDPzGrqb50NIPk1XFNTjQp2NEQhZVhEKJgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BIWpi0J5GKgm++CC4pz/dS7QJOqOdYQfXdusIGoqZtU=;
        b=C4y5/A858fS5TBmqcro9QQblLa4w8CPAL90ixhf1v288yA6l/ODjX87mip3hRWm7TciyXt
        7vHG/P/k1pxIpODQ==
To:     linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 27/38] padata: Replace deprecated CPU-hotplug functions.
Date:   Tue,  3 Aug 2021 16:16:10 +0200
Message-Id: <20210803141621.780504-28-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-1-bigeasy@linutronix.de>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/padata.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d4d3ba6e1728a..0b0b6e8917d10 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -733,7 +733,7 @@ int padata_set_cpumask(struct padata_instance *pinst, i=
nt cpumask_type,
 	struct cpumask *serial_mask, *parallel_mask;
 	int err =3D -EINVAL;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&pinst->lock);
=20
 	switch (cpumask_type) {
@@ -753,7 +753,7 @@ int padata_set_cpumask(struct padata_instance *pinst, i=
nt cpumask_type,
=20
 out:
 	mutex_unlock(&pinst->lock);
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	return err;
 }
@@ -992,7 +992,7 @@ struct padata_instance *padata_alloc(const char *name)
 	if (!pinst->parallel_wq)
 		goto err_free_inst;
=20
-	get_online_cpus();
+	cpus_read_lock();
=20
 	pinst->serial_wq =3D alloc_workqueue("%s_serial", WQ_MEM_RECLAIM |
 					   WQ_CPU_INTENSIVE, 1, name);
@@ -1026,7 +1026,7 @@ struct padata_instance *padata_alloc(const char *name)
 						    &pinst->cpu_dead_node);
 #endif
=20
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	return pinst;
=20
@@ -1036,7 +1036,7 @@ struct padata_instance *padata_alloc(const char *name)
 err_free_serial_wq:
 	destroy_workqueue(pinst->serial_wq);
 err_put_cpus:
-	put_online_cpus();
+	cpus_read_unlock();
 	destroy_workqueue(pinst->parallel_wq);
 err_free_inst:
 	kfree(pinst);
@@ -1074,9 +1074,9 @@ struct padata_shell *padata_alloc_shell(struct padata=
_instance *pinst)
=20
 	ps->pinst =3D pinst;
=20
-	get_online_cpus();
+	cpus_read_lock();
 	pd =3D padata_alloc_pd(ps);
-	put_online_cpus();
+	cpus_read_unlock();
=20
 	if (!pd)
 		goto out_free_ps;
--=20
2.32.0

