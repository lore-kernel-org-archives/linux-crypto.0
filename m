Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A594C315A4
	for <linux-crypto@vger.kernel.org>; Tue,  7 Nov 2023 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqYltMAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3AAC433CA;
	Tue,  7 Nov 2023 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699372198;
	bh=wtNOXeX7w8zoQ3otGG36EsK0m30/YtgWrswNMVjRl7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqYltMAHnkwuWHfE+JzQVQOSDTY/q7iYxmoh2fl8gpmT+hAFgr8Frt9UT+MiE3Uxy
	 zjTL0N1K/M9TYLAu4YaS0DKU8IN8CBVFBk45Epji21bcHA3Uiqte3Hq9CfB3har+/W
	 Ubpf3Zgm3l4VKGylLAvwYY9MN40UObc80sqkGwuqvsV86z3qnQtXspRG/V1KqxjuCP
	 QK04ZONR5sKx8kp/5N7h3A5Kg5O+2ga5mtcSkRY3Ai0MLcNpBrvh5ajQW2E/s5R4G4
	 MdL21vLPM0We56xruNgF772YesQ8jrEVX95grphdVIxxh0DSaG7NysZj6SpZteujgm
	 J9O1zJzplfgAQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 31/34] crypto: hisilicon/qm - prevent soft lockup in receive loop
Date: Tue,  7 Nov 2023 10:48:11 -0500
Message-ID: <20231107154846.3766119-31-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231107154846.3766119-1-sashal@kernel.org>
References: <20231107154846.3766119-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.10
Content-Transfer-Encoding: 8bit

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit 33fc506d2ac514be1072499a263c3bff8c7c95a0 ]

In the scenario where the accelerator business is fully loaded.
When the workqueue receiving messages and performing callback
processing, there are a large number of messages that need to be
received, and there are continuously messages that have been
processed and need to be received.
This will cause the receive loop here to be locked for a long time.
This scenario will cause watchdog timeout problems on OS with kernel
preemption turned off.

The error logs:
watchdog: BUG: soft lockup - CPU#23 stuck for 23s! [kworker/u262:1:1407]
[ 1461.978428][   C23] Call trace:
[ 1461.981890][   C23]  complete+0x8c/0xf0
[ 1461.986031][   C23]  kcryptd_async_done+0x154/0x1f4 [dm_crypt]
[ 1461.992154][   C23]  sec_skcipher_callback+0x7c/0xf4 [hisi_sec2]
[ 1461.998446][   C23]  sec_req_cb+0x104/0x1f4 [hisi_sec2]
[ 1462.003950][   C23]  qm_poll_req_cb+0xcc/0x150 [hisi_qm]
[ 1462.009531][   C23]  qm_work_process+0x60/0xc0 [hisi_qm]
[ 1462.015101][   C23]  process_one_work+0x1c4/0x470
[ 1462.020052][   C23]  worker_thread+0x150/0x3c4
[ 1462.024735][   C23]  kthread+0x108/0x13c
[ 1462.028889][   C23]  ret_from_fork+0x10/0x18

Therefore, it is necessary to add an actively scheduled operation in the
while loop to prevent this problem.
After adding it, no matter whether the OS turns on or off the kernel
preemption function. Neither will cause watchdog timeout issues.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index edc6fd44e7ca9..3fb1ef2542270 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -847,6 +847,8 @@ static void qm_poll_req_cb(struct hisi_qp *qp)
 		qm_db(qm, qp->qp_id, QM_DOORBELL_CMD_CQ,
 		      qp->qp_status.cq_head, 0);
 		atomic_dec(&qp->qp_status.used);
+
+		cond_resched();
 	}
 
 	/* set c_flag */
-- 
2.42.0

