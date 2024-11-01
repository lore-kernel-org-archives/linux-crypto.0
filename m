Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBC9156220;
	Fri,  1 Nov 2024 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453064; cv=none; b=JQ0Q+7wKPjIPWQpPWX1S33v5li2clVTL2vfsx1Tii4AoZLkC9KdH1FO6ABOQbbiGjPPsAkV8Y8zMKHhac6ImClU8bOKHAb7xurdOx0kfAZIDP2tE0kuK+/8Ks6SJB8vfvA1BSgpkWJUPwWNY0vjE9w7HET5PdQW4uHfTRQgLxlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453064; c=relaxed/simple;
	bh=K3E6YEr3RR0Q6c4selF6BZXkct6KzT9uVfxbZtkf+ro=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qTqM4XEJ2oB3MwkDQRGmJcHPpFtYICKYp/aXVS80uGXpQfQzxuEilz0pMaJJKLzaqLQbJxCI9YcLRh7D0x1wxTzlaYc/OIwxLzGxHxX3dKM4VwT12P4MfQOwnJP4LWsxaE1FmNcTBuwk2knHHUay2B5f39e8+3Rd8c58RzwRspc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XfwNS48j5zdkWX;
	Fri,  1 Nov 2024 17:21:44 +0800 (CST)
Received: from kwepemd200012.china.huawei.com (unknown [7.221.188.145])
	by mail.maildlp.com (Postfix) with ESMTPS id 19CB518005F;
	Fri,  1 Nov 2024 17:24:19 +0800 (CST)
Received: from huawei.com (10.67.175.84) by kwepemd200012.china.huawei.com
 (7.221.188.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Fri, 1 Nov
 2024 17:24:18 +0800
From: Zicheng Qu <quzicheng@huawei.com>
To: <steffen.klassert@secunet.com>, <daniel.m.jordan@oracle.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tanghui20@huawei.com>, <zhangqiao22@huawei.com>,
	<judy.chenhui@huawei.com>, <quzicheng@huawei.com>
Subject: [PATCH] padata: Clean up in padata_do_multithreaded()
Date: Fri, 1 Nov 2024 09:13:24 +0000
Message-ID: <20241101091324.2372626-1-quzicheng@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200012.china.huawei.com (7.221.188.145)

In commit 24cc57d8faaa ("padata: Honor the caller's alignment in case of
chunk_size 0"), the line 'ps.chunk_size = max(ps.chunk_size, 1ul)' was
added, making 'ps.chunk_size = 1U' redundant and never executed.

Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
---
 kernel/padata.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index d899f34558af..d51bbc76b227 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -521,13 +521,6 @@ void __init padata_do_multithreaded(struct padata_mt_job *job)
 	ps.chunk_size = max(ps.chunk_size, 1ul);
 	ps.chunk_size = roundup(ps.chunk_size, job->align);
 
-	/*
-	 * chunk_size can be 0 if the caller sets min_chunk to 0. So force it
-	 * to at least 1 to prevent divide-by-0 panic in padata_mt_helper().`
-	 */
-	if (!ps.chunk_size)
-		ps.chunk_size = 1U;
-
 	list_for_each_entry(pw, &works, pw_list)
 		if (job->numa_aware) {
 			int old_node = atomic_read(&last_used_nid);
-- 
2.34.1

