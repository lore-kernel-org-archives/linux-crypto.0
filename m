Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4D612AAC0;
	Sun, 26 May 2024 09:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716596; cv=none; b=imJVfMR8rDtA9ILN4ShyB8kDgeRSg9v8hRbiUbvSnMpPQL9gJeORbR/2VJU1wKJxP8B/LgD5EdqlG/91BByagVaQBfRcKG6njZ3MLcLWH0sZHrkwLkpc4y2Tw6gbQkAeVS2YYU+1Hq4Xi7wFjypL3kBFVHq7dWSERvY45JT5ZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716596; c=relaxed/simple;
	bh=TPR7es+CZ0E3Rfms9HXS3UyLVh9PuTj3jC2tjEXJq1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGDk26Da0ZbXeuEs/FXuIwOeXH4PXZfuXB8AQ9TxZn2qIumnGx2sDeAre34IggIGvd3Ha5e6mBYjcDD8t5RCVjzYT1ONLhaqNQaM03Y9KbZcud6DHCBMqOyxrJn6KECTiCo7kjWNzcrAgElAIuUYG8IHpeglwsyXn+wODS2H1vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYkNZVGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYkNZVGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523B0C32781;
	Sun, 26 May 2024 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716596;
	bh=TPR7es+CZ0E3Rfms9HXS3UyLVh9PuTj3jC2tjEXJq1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYkNZVGh5MB1Os/+mCy+utLTCjXfu+pnQEpDCjxbLs/fVAxZlcu38BSEA2pcWA6Gs
	 gjwaeSQfqZ7p0jY6djscnkciOlWi98kYJom1+L1BlpgvycbKwSm73a5Pe2LVx+ml18
	 mveBsoXexiykzfrYGsq0+gTh6x6d17EqBtMWauFhRH82zCVlcKqGjzSwW51BMZti5G
	 xOomIqMCfWZV8NfnffzKUXbVvLItJQ93JAeBc6YMq1usPttEhlnn96yLb0s4n9UFZc
	 PETpsgbB+AVgYbE16nLCai031q/M4fQ1pkz5uikidxYV7ec2IWj1IMVVc5y2FlyiwC
	 LJ1Ya4gysrUCQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	steffen.klassert@secunet.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 2/9] padata: Disable BH when taking works lock on MT path
Date: Sun, 26 May 2024 05:43:03 -0400
Message-ID: <20240526094312.3413460-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094312.3413460-1-sashal@kernel.org>
References: <20240526094312.3413460-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.91
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
index 7bef7dae3db54..0261bced7eb6e 100644
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

