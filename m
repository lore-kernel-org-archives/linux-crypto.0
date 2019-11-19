Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBA7C432C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5488422449
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 22:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKSWc4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:32:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49572 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfKSWc4 (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Tue, 19 Nov 2019 17:32:56 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iXC3K-0000no-Jm; Wed, 20 Nov 2019 06:32:54 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iXC3G-0000Dg-3h; Wed, 20 Nov 2019 06:32:50 +0800
Date:   Wed, 20 Nov 2019 06:32:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] padata: Remove unused padata_remove_cpu
Message-ID: <20191119223250.jaefneeatsa52nhh@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function padata_remove_cpu was supposed to have been removed
along with padata_add_cpu but somehow it remained behind.  Let's
kill it now as it doesn't even have a prototype anymore.

Fixes: 815613da6a67 ("kernel/padata.c: removed unused code")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/kernel/padata.c b/kernel/padata.c
index da56a235a255..fc00f7e64133 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -718,41 +718,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	return 0;
 }
 
- /**
- * padata_remove_cpu - remove a cpu from the one or both(serial and parallel)
- *                     padata cpumasks.
- *
- * @pinst: padata instance
- * @cpu: cpu to remove
- * @mask: bitmask specifying from which cpumask @cpu should be removed
- *        The @mask may be any combination of the following flags:
- *          PADATA_CPU_SERIAL   - serial cpumask
- *          PADATA_CPU_PARALLEL - parallel cpumask
- */
-int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
-{
-	int err;
-
-	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
-		return -EINVAL;
-
-	mutex_lock(&pinst->lock);
-
-	get_online_cpus();
-	if (mask & PADATA_CPU_SERIAL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
-	if (mask & PADATA_CPU_PARALLEL)
-		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
-
-	err = __padata_remove_cpu(pinst, cpu);
-	put_online_cpus();
-
-	mutex_unlock(&pinst->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(padata_remove_cpu);
-
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
 {
 	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
