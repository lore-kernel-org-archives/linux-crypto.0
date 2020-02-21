Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FFFC35643
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCD2F24670
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 08:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582273738;
	bh=fjEoFM/ZI/nczcEXkmdnLMMUAcHJBEZV0uX7k/XZlH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AEmf4eFjPCR0VB/fXSKsgex+2FLkT7nzI97rjfwj10FQUXk9ly5pUNAxD5ywYq6QB
	 ScuBBF7IAzGu3hsR/uvbzYYElN/COBOGYdmg4YSfW1wiO7/nwQFJYzTNt/ZM7nrCIu
	 HIULoaXocWt32Yhdm/ZBhzpU3iZU1cLtdDQCTQLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgBUIS7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 03:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387897AbgBUIS7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6CA24689;
        Fri, 21 Feb 2020 08:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273138;
        bh=fjEoFM/ZI/nczcEXkmdnLMMUAcHJBEZV0uX7k/XZlH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALwLw8dyteAdQAbKRiBR1K/AVB2ZS9i8YFDnDxlqxKARNIMg5Kh8KNQOXpmcD1hxu
         BPjcEy/p00Vx7k4racnk71N7+sZhOogsH3+a+XjxSb8YHA1rwRx5Fk/wZysjxfS8cy
         cIt6SWfNAp8hlaoLhqEDSGom/sGwe0aqBVsk45LU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/191] padata: always acquire cpu_hotplug_lock before pinst->lock
Date:   Fri, 21 Feb 2020 08:40:34 +0100
Message-Id: <20200221072258.745173144@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 38228e8848cd7dd86ccb90406af32de0cad24be3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index cfab62923c452..c280cb153915f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -671,8 +671,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	struct cpumask *serial_mask, *parallel_mask;
 	int err = -EINVAL;
 
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -690,8 +690,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }
-- 
2.20.1



