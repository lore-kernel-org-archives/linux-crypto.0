Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B7D58AB8;
	Sun, 26 May 2024 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716577; cv=none; b=GTNUT0r175+dD9AgO9HtUOdZAVFSASg1zJLkkj3kaJGfhCyLcV5vctxis6XL64ZVX/lZg4vsKewZxSTxku41ZJxBMPJMavHv2NDMCnRhihnrL24FXOH03JfN/7KvlvR94epxio0pt58y2xlLKILKLJ0zJzIJPz5M4aXypxSBm8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716577; c=relaxed/simple;
	bh=ip+RJKDgvCFKSc27D/Z9mn/UyVFGF2gGb8dmyayQmQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPiYNv4xodvOmzWCYK3XLDY1m1A6USWp5hI6MNUqg9vxJMoHIB5b+wbPEbbf1idEint2bMwS7Jpg84iwWu5Y4x/pagjiu5ZoD+Cyd44U+0DeRDS/U1naT11RMfT95VcWXg3vYzxTSpxjC2HWGfvy31ItnQc0wVMqdnonpiL4noM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0c/qof2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0c/qof2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4C6C2BD10;
	Sun, 26 May 2024 09:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716577;
	bh=ip+RJKDgvCFKSc27D/Z9mn/UyVFGF2gGb8dmyayQmQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0c/qof2wkHIoIwhQwlEVDTvgbvr1GUeShJe/3I4vGzXC62f5eM1j2jsRMLiOLPdV
	 0FI+U7PYoYQ+khwK3H6pBNdSJLmiFG0K8lxyiuwarYlBT8xG/Canc/CdFqU+Ani2hn
	 uPfrr+0kP8Dl4IgY19VfMo+t763qXPd+j70faNKPtsaKpZlXaqelaWB9HRbxY0LCPt
	 vwU63KyvmA8MQ7uR+guInXsq0GL1bGMwx4vSY+GI7bufirpgsHIQ6q8S48wOQ94hGD
	 zJc1xp+C1pAhVNufCDNGqtNdFyUEQy+12De3lKfOwRUEyQeGWcOUvAGfKMglDNm2uR
	 UHIColZffBh9Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 03/11] padata: Disable BH when taking works lock on MT path
Date: Sun, 26 May 2024 05:42:41 -0400
Message-ID: <20240526094251.3413178-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094251.3413178-1-sashal@kernel.org>
References: <20240526094251.3413178-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.31
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
index 179fb1518070c..c974568f65f5d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -106,7 +106,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -116,7 +116,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -134,12 +134,12 @@ static void __init padata_works_free(struct list_head *works)
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

