Return-Path: <SRS0=qmX+=53=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E113C2BBFD
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 12:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 694B621556
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Apr 2020 12:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586607924;
	bh=nBp8M//Wwkue4wWaCuCCtoO0nyJNfejoIKWOMt6EWGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ppFkmgyoH6xxtjcQnCs9iQ2lE8vnibO4En7Qf/dvrfNwaxvF2Mu2D6cDIn/o/bwCU
	 Rkl4Tv4wHPiYjDF0Gqbw+xSqTSNQ2M3ky6UolFnEGR6u/1TXHAMyw6p2qguaf6TEUB
	 Lgf0N3aF40mgl3lM0ExkKcbUu9PNZ0kr1T//KK6g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDKMQp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Apr 2020 08:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgDKMQo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46C2920644;
        Sat, 11 Apr 2020 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607404;
        bh=nBp8M//Wwkue4wWaCuCCtoO0nyJNfejoIKWOMt6EWGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7icK7Ib7lVZSe0+Kqjl0FMOa+zXDYCqx4r4nGd3PAf45c25Fi1uFTLWE53BrWoaq
         N6/TivjyeTzvNPas2IQjP7faREsSVKkcMEysUY0sx9SQUWwzPVoX0ZND/WUYkvRXEK
         P0Mi54RMTWDc/xiQLEtBm78SLf3URRauGGPx4/M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 4.19 24/54] padata: always acquire cpu_hotplug_lock before pinst->lock
Date:   Sat, 11 Apr 2020 14:09:06 +0200
Message-Id: <20200411115510.950406190@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

commit 38228e8848cd7dd86ccb90406af32de0cad24be3 upstream.

lockdep complains when padata's paths to update cpumasks via CPU hotplug
and sysfs are both taken:

  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask

  ======================================================
  WARNING: possible circular locking dependency detected
  5.4.0-rc8-padata-cpuhp-v3+ #1 Not tainted
  ------------------------------------------------------
  bash/205 is trying to acquire lock:
  ffffffff8286bcd0 (cpu_hotplug_lock.rw_sem){++++}, at: padata_set_cpumask+0x2b/0x120

  but task is already holding lock:
  ffff8880001abfa0 (&pinst->lock){+.+.}, at: padata_set_cpumask+0x26/0x120

  which lock already depends on the new lock.

padata doesn't take cpu_hotplug_lock and pinst->lock in a consistent
order.  Which should be first?  CPU hotplug calls into padata with
cpu_hotplug_lock already held, so it should have priority.

Fixes: 6751fb3c0e0c ("padata: Use get_online_cpus/put_online_cpus")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/padata.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -671,8 +671,8 @@ int padata_set_cpumask(struct padata_ins
 	struct cpumask *serial_mask, *parallel_mask;
 	int err = -EINVAL;
 
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -690,8 +690,8 @@ int padata_set_cpumask(struct padata_ins
 	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }


