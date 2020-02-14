Return-Path: <SRS0=Wzqe=4C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F042C3B1A6
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 17:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A81620637
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Feb 2020 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581700229;
	bh=4W0rNhsG2sx8SgGLQkcwZMjhFmbM2VcN2HvkA3XMsbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jzt5eE/manBRchezHftOsyebesmClLE6O5udu2g6nSL3v/ZpApI8LhJQPrV5eWwzZ
	 hNWRTcv4XTCJAPKliox8YtUnj8R2b29qu5+ZsFXp7QY8TUAno4xl5K8PbfieyWA4Wy
	 il41Q1LLUG5Z3vxsilnlbbacnStn0ILKMtxKqOCE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393951AbgBNRKX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390252AbgBNQNj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Feb 2020 11:13:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62C7B246CF;
        Fri, 14 Feb 2020 16:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696819;
        bh=4W0rNhsG2sx8SgGLQkcwZMjhFmbM2VcN2HvkA3XMsbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frIK2L5tAet1wXndq2HEe+haAYOGWurMMuti/SajmQCNxkiiy6gSTLH2+IV8MqLmH
         EdwS+IUMvoNurOzXbClkIk6V6i1gcgV9Y53kGQBnyNe6v4l2gh7IuwTvUU6TWGp8r8
         iaC4T9iuWhjsRFaLebK1ceRjiDg7NjUO1yM2ifEA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 087/252] padata: always acquire cpu_hotplug_lock before pinst->lock
Date:   Fri, 14 Feb 2020 11:09:02 -0500
Message-Id: <20200214161147.15842-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 11c5f9c8779ea..5e8a2a4398565 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -670,8 +670,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	struct cpumask *serial_mask, *parallel_mask;
 	int err = -EINVAL;
 
-	mutex_lock(&pinst->lock);
 	get_online_cpus();
+	mutex_lock(&pinst->lock);
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -689,8 +689,8 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
-	put_online_cpus();
 	mutex_unlock(&pinst->lock);
+	put_online_cpus();
 
 	return err;
 }
-- 
2.20.1

