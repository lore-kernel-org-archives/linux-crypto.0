Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32626F2E2
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 17:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722966453; cv=none; b=qHr/ewA5JCam0rvl3ep/DQqdoqgvXbe+KDE3lokPPuMAhyqO6ouUBk1voIHFnb+w6HJkqhBP1+H8/0tO9kdZIS0pw7xPLCBvyxhOF8NbtSHQP3ceFTWTKPlL1GuAYR7qm183N2R85l7NyHolX62tA9J0WtqmDVSnR3dpVx/njzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722966453; c=relaxed/simple;
	bh=m8zP/G2Caope01Y5hp+XNPX61CFNQXC42ATl15aCd2U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h+mxxN/BuXLEuIkTVsB1cMkGR7e01sMzK+dCp5EyxwtWhnVTtkCf6moHMVpFM6SHjfww0un/iaH1oRDaF9vLG0Op09wD4kv3yqbdAyST+OJB8Dg1XoiSQj/DW5fDPRTdefjpvNi/tyFv8JMT8DMfhOfTB/xHlCBKWpyyieMA/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQEdXKtg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQEdXKtg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722966450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Dx3lp9LD5waJbHKy20MWljw9mO6ZuZv40UA8MNp3kCs=;
	b=IQEdXKtgSsqcf9gwZth3qnVHa1muaJ8mhm6T/hyqeM8GNnJEepfL+peBFCvAvj68ge4jco
	1COVOlU4Ndxa06K0x8QS8km/ObpljjYG+OP1e75DvPzbdABvlIcgp5KsC/s6sYAmFjlgHE
	LRENkmX8fP73LkzTCRQgl1vu6nT7304=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-rCRjMDKNMH2L5EfFmof1eA-1; Tue,
 06 Aug 2024 13:47:29 -0400
X-MC-Unique: rCRjMDKNMH2L5EfFmof1eA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBACE19560A2;
	Tue,  6 Aug 2024 17:47:27 +0000 (UTC)
Received: from llong.com (unknown [10.2.16.146])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 226F8300019B;
	Tue,  6 Aug 2024 17:47:25 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] padata: Fix possible divide-by-0 panic in padata_mt_helper()
Date: Tue,  6 Aug 2024 13:46:47 -0400
Message-ID: <20240806174647.1050398-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We are hit with a not easily reproducible divide-by-0 panic in padata.c
at bootup time.

  [   10.017908] Oops: divide error: 0000 1 PREEMPT SMP NOPTI
  [   10.017908] CPU: 26 PID: 2627 Comm: kworker/u1666:1 Not tainted 6.10.0-15.el10.x86_64 #1
  [   10.017908] Hardware name: Lenovo ThinkSystem SR950 [7X12CTO1WW]/[7X12CTO1WW], BIOS [PSE140J-2.30] 07/20/2021
  [   10.017908] Workqueue: events_unbound padata_mt_helper
  [   10.017908] RIP: 0010:padata_mt_helper+0x39/0xb0
    :
  [   10.017963] Call Trace:
  [   10.017968]  <TASK>
  [   10.018004]  ? padata_mt_helper+0x39/0xb0
  [   10.018084]  process_one_work+0x174/0x330
  [   10.018093]  worker_thread+0x266/0x3a0
  [   10.018111]  kthread+0xcf/0x100
  [   10.018124]  ret_from_fork+0x31/0x50
  [   10.018138]  ret_from_fork_asm+0x1a/0x30
  [   10.018147]  </TASK>

Looking at the padata_mt_helper() function, the only way a divide-by-0
panic can happen is when ps->chunk_size is 0. The way that chunk_size is
initialized in padata_do_multithreaded(), chunk_size can be 0 when the
min_chunk in the passed-in padata_mt_job structure is 0.

Fix this divide-by-0 panic by making sure that chunk_size will be at
least 1 no matter what the input parameters are.

Fixes: 004ed42638f4 ("padata: add basic support for multithreaded jobs")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/padata.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/padata.c b/kernel/padata.c
index 53f4bc912712..0fa6c2895460 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -517,6 +517,13 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 	ps.chunk_size = max(ps.chunk_size, job->min_chunk);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
+	/*
+	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
+	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
+	 */
+	if (!ps.chunk_size)
+		ps.chunk_size = 1U;
+
 	list_for_each_entry(pw, &works, pw_list)
 		if (job->numa_aware) {
 			int old_node = atomic_read(&last_used_nid);
-- 
2.43.5

