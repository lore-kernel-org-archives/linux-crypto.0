Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD5312FF61;
	Sun, 26 May 2024 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716611; cv=none; b=J0ciYJi9WUjT6odVnfceF+fVHSmt3w0uHN+51FQZtTPysiFKf1Bh1O46qrFrZZr7bSEYsb4m4ENa+dEmI/NoGCCVc27hWnZthH6CRtXmKGZfgx+RQEmPwAWnsh5VZ8bF1pRtxtm1w3C/fVyednGMQiP32cJ+jsQ/ztlAwPYwiGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716611; c=relaxed/simple;
	bh=c5yfH6H6bPCU9g29WjamsYCZW1ZxsHiZnvNXgWIuJgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Onlr1nHDWAyyxVBZyVCNlNZMTzzapto9vO0tZrBSwyefh2WEpXHAv+uD3qEMTIJnEkr3/hP/3Xle9QIp6c8/+NQ6AY7xktBjMaX8+XowNcHsX9553E9Vdv60A1mde4QtYJpeTBs+TvFnJsn1J9+CuNNEVDqLI3hFKfL0ifCfX2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9HBJTDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9HBJTDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899A5C2BD10;
	Sun, 26 May 2024 09:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716611;
	bh=c5yfH6H6bPCU9g29WjamsYCZW1ZxsHiZnvNXgWIuJgI=;
	h=From:To:Cc:Subject:Date:From;
	b=M9HBJTDGp91xDLRiPG5+OffRKQ257XUkbst1mMKOmZWCH7jFgpSzyeoZ1xKqJX3iH
	 Y4vNtw7viRTgSyjtvAGQeL9KwlWBFsmaEXsuws7rJnoET/tveHJwOGIgZXjAzHg1Sf
	 Du+PmTvSCyWhsYBDY/ISxUssoknPpa4fmu3BrGDwlFeE+x/dnxmonnZKuTjoYQUuB5
	 YTG2wpu8iCNzypkR15Hz3GLMBwbmwvc2Y5N7SkF9gjCDLDa3JydxE5mhj0PFUi/dpK
	 1E5F9qFxbHO4RW+xRa6r9dfQpBqsNwdQ7eHbjvlGQRl0GpkxJSrRcsv9NGPp/omqDF
	 mA09V58iZF41w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 1/7] padata: Disable BH when taking works lock on MT path
Date: Sun, 26 May 2024 05:43:21 -0400
Message-ID: <20240526094329.3413652-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.159
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
index 47f146f061fb1..809978bb249c2 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -98,7 +98,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -108,7 +108,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -126,12 +126,12 @@ static void __init padata_works_free(struct list_head *works)
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

