Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA6C3A1AB;
	Sun, 26 May 2024 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716549; cv=none; b=MeVDyg0tM3WUeoRAcEV6jo99NxQyYaQvqsJf5D/vjJALZL+hW1ymSyPk1WSH6COeqQ58EFIi47lfCa2/pUczbcvLSy2YMTzqKCWvIxMfqxZXEnoJrPIUPgX/JQoYaFy2GrpHVTyN4sfIut+tIkhi9itdGMXXGHhMyg8kuJPgqMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716549; c=relaxed/simple;
	bh=ip+RJKDgvCFKSc27D/Z9mn/UyVFGF2gGb8dmyayQmQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMwX5wlEv1fzhXDejNz27ApM36LAok2Y3eihqpXYRkRUE3Ev6fB4vS+rbyRHf3fkf2WuJYvep1JDzArgrxYzSLWvsmL653M30FPi2ZeGDt2e/9xRgC4DGbANlBpXupkWDR5NxdhI6nQWdW/1y1XV62m6BCshjFeA9pWWHzMbRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rJ6NZUv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rJ6NZUv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9683C32782;
	Sun, 26 May 2024 09:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716549;
	bh=ip+RJKDgvCFKSc27D/Z9mn/UyVFGF2gGb8dmyayQmQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJ6NZUv4cVBFyYcxUmVgYLQ71k1z1hqojPx/HTn5Gz6xGpFy0WIy7fGYQ8kSRMiXW
	 xKvpONIwYzb47BK8Gg0mOIQMq44xVdlafp0Wmzt0dZxVAklfGooDUdHTHinw3jmQZh
	 y2/SfiI+ehQL1pLsjtcZvhhkaHsicyvfjD9Z1BsI4ZhoctmGeO83DmIan8XgpUG8Ew
	 orPUJriB38EI65f4Iz6gj40hr3HKF8wkMHr6sIsj1IZNbT33C10zlMPfTIz5PmV0QF
	 6fMgtN4UgCgk+8GhVvcYN/VerrtJ/Vf6rfafm83a3XOJR3rJL0xFb26VNyDcd+HATk
	 jzVrnLnreh9BA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 03/14] padata: Disable BH when taking works lock on MT path
Date: Sun, 26 May 2024 05:42:08 -0400
Message-ID: <20240526094224.3412675-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094224.3412675-1-sashal@kernel.org>
References: <20240526094224.3412675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.10
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

