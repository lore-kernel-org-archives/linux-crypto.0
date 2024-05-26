Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3211311A5;
	Sun, 26 May 2024 09:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716625; cv=none; b=nwq+G9EbJKEVH97957lZIdUlkjsTlNoR3LDsDwKMsL72nqRyWA3lVujiNowNYAIednBsMXD8R5Nsyy4vofP7smmIjycfhGmgh5TB3XBo9hyJSBlJbidMtvdGF4PlmwWcrLLoBixoisH4AblsCTJKHFK8XEPjWSPj8ArjoTBr4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716625; c=relaxed/simple;
	bh=bafW+hAQkLlXTWalx25XHXsPpoYh8vyZ4X/xwceNVjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RNjLXISz3G2Dj+U8ajue/M2xUYi4aG0oaBmc9ndkymJkNX+Oky8rtVj6CAeGtSJjakelKz2QBhTe1vCdWoYE3nrvVM1+ICONYBEe55qvk5+J8ev7p/9F8HfzQLg5KYx8n+6PcPwKyyxM/6bWxQ+agbW6lErFWZPMcd7rok5dSvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cXNAL//u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cXNAL//u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161C4C2BD10;
	Sun, 26 May 2024 09:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716625;
	bh=bafW+hAQkLlXTWalx25XHXsPpoYh8vyZ4X/xwceNVjQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cXNAL//unomYHsDHz2j7K1QwIfX2n0lshwn/oz3B3QSpCW0sNCCSFttVSHSpikAGj
	 c4mK6QGqytaVjQV2VR08YPqNPNhDaYDsWRgwKLVZehSg1oP6FjMdSDS6xfCp4m4Ngf
	 9pn5OZZ4FXf70WBWFufiDfVtTbueuRJRYf9kKvI9UXu+ScOgKoU4wwEQst/zSdRI0V
	 Hkq7DbUaS/syIR2QKz8tBsOH92qpiN9fXumqOB9tYGd8+dYhfPs/Bw1DAKMqf6cNtO
	 UdbqeiRIub2ifugbOPzYACKsU7uW8lo62/65zDTqsowce3pghnExsp8zqcGB7r2Nst
	 XxD8we2MWE/Eg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 1/5] padata: Disable BH when taking works lock on MT path
Date: Sun, 26 May 2024 05:43:37 -0400
Message-ID: <20240526094342.3413841-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.217
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 58329c4312031603bb1786b44265c26d5065fe72 ]

As the old padata code can execute in softirq context, disable
softirqs for the new padata_do_mutithreaded code too as otherwise
lockdep will get antsy.

Reported-by: syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index fdcd78302cd72..471ccbc44541d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -111,7 +111,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -121,7 +121,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -139,12 +139,12 @@ static void __init padata_works_free(struct list_head *works)
 	if (list_empty(works))
 		return;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	list_for_each_entry_safe(cur, next, works, pw_list) {
 		list_del(&cur->pw_list);
 		padata_work_free(cur);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 }
 
 static void padata_parallel_worker(struct work_struct *parallel_work)
-- 
2.43.0

