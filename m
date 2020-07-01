Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CCBC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 17:20:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E462A2078A
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 17:20:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dq1pa/K3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGARUw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 13:20:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42646 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726432AbgGARUv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 13:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593624049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=jwLHgKRr0xCpf9rk2C/KLIQVKmaCEwU7VXYHf/GlC48=;
        b=Dq1pa/K3/t6EUJ9mofNQEnbjOP7DDgHikH7xwKElcOiP/+2s38mKZ5q+fB9Cwf+jgDe0Ct
        vER7rm3qYyQ/C8TcSKA8XyvlfRHf4QPr8/RwwJ1QVEgMJxd5MeNTLgcvvsWAO/USpoPdGl
        KVv5mBTE+BptMkZrsen96OZpUkfgjxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-8w-8z3phOLOsMhUMAseRcg-1; Wed, 01 Jul 2020 13:20:46 -0400
X-MC-Unique: 8w-8z3phOLOsMhUMAseRcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93EDA80183C;
        Wed,  1 Jul 2020 17:20:44 +0000 (UTC)
Received: from npache.remote.csb (ovpn-113-77.rdu2.redhat.com [10.10.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A67CF100238C;
        Wed,  1 Jul 2020 17:20:43 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        daniel.m.jordan@oracle.com, npache@redhat.com
Subject: [PATCH] Remove __init from padata_do_multithreaded and padata_mt_helper
Date:   Wed,  1 Jul 2020 13:20:26 -0400
Message-Id: <20200701172026.14426-1-npache@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow padata_do_multithreaded function to be called after bootstrap.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/padata.h | 2 +-
 kernel/padata.c        | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 7302efff5..2e7d92e80 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -201,7 +201,7 @@ extern void padata_free_shell(struct padata_shell *ps);
 extern int padata_do_parallel(struct padata_shell *ps,
 			      struct padata_priv *padata, int *cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern void __init padata_do_multithreaded(struct padata_mt_job *job);
+extern void padata_do_multithreaded(struct padata_mt_job *job);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 extern int padata_start(struct padata_instance *pinst);
diff --git a/kernel/padata.c b/kernel/padata.c
index 4373f7ada..2c0efab81 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -58,7 +58,7 @@ struct padata_mt_job_state {
 };
 
 static void padata_free_pd(struct parallel_data *pd);
-static void __init padata_mt_helper(struct work_struct *work);
+static void padata_mt_helper(struct work_struct *work);
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
@@ -463,7 +463,7 @@ static int pd_setup_cpumasks(struct parallel_data *pd,
 	return err;
 }
 
-static void __init padata_mt_helper(struct work_struct *w)
+static void padata_mt_helper(struct work_struct *w)
 {
 	struct padata_work *pw = container_of(w, struct padata_work, pw_work);
 	struct padata_mt_job_state *ps = pw->pw_data;
@@ -503,7 +503,7 @@ static void __init padata_mt_helper(struct work_struct *w)
  *
  * See the definition of struct padata_mt_job for more details.
  */
-void __init padata_do_multithreaded(struct padata_mt_job *job)
+void padata_do_multithreaded(struct padata_mt_job *job)
 {
 	/* In case threads finish at different times. */
 	static const unsigned long load_balance_factor = 4;
-- 
2.18.1

