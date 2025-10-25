Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756CD1E47CA;
	Sat, 25 Oct 2025 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408921; cv=none; b=pAkmmoZ9hc46oRq7GyZtxjW0Wk3oipEoayB+8suFl/3eCjreuFOw7f6EQhv6k7EHJXM7mtKLhPNDJ7GaZYlc7Vr5iqTkAwSGZhpKN4ACGjxHNDIdfgvODNdyHjip8BPfHHDzxyLZHbBhs9CDpitSdrWsCMA+X4djSUZ055qTNQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408921; c=relaxed/simple;
	bh=BXu7kNR7qwFjKDImdYgg7B//tjmVw79YggACZL5lcIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jI//C5p292lZLQ9ub7MZHcClQjqAW6U5SpFULDOKlWNEMXSXiomiM64Et2ks0XDEBR9pXFyzNNgO/O62BnZd+neEUo37/CRBbCcKctLMMkY07wTUdfJEiQVKgOOU/PYrsci5qv8c5f71a8McxjfN3D4NwcO0PyvfBmlqo4tqiqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImOnh18f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImOnh18f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF83C4CEFF;
	Sat, 25 Oct 2025 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408921;
	bh=BXu7kNR7qwFjKDImdYgg7B//tjmVw79YggACZL5lcIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImOnh18fRD88s+c+/Mg0Hn6a/lw4ewrNToZ9L6DkTcGFwvAqPBagmCjLaRfuTeEMd
	 gUedHRL61C+ICrEZ8RIo3moTvoNRXUTn3UHAfOBqg5oX3pO39icO+uOB8DXMLVNAJw
	 enB4hJSgSDDSo+QbRACL9Pd5g6Wa/1tx/F+mZDZ3gxzm7PTM9JnnTC3un6TJUxTY9C
	 Rh0JsmAPxXAX3wcQTxj+gozc93ldK0uUHH0YHjG+VdRTlsjWGCLsFM+hcvGCXZnbb/
	 VvmShKaYLyLYpB/rzO4dLkeRuY2t2GojnR3I56xPKyTwrHtAlkCgPu1tMESwWxfeC1
	 8rat1xTLZ680g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weili Qian <qianweili@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	wangzhou1@hisilicon.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] crypto: hisilicon/qm - clear all VF configurations in the hardware
Date: Sat, 25 Oct 2025 11:56:04 -0400
Message-ID: <20251025160905.3857885-133-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 64b9642fc29a14e1fe67842be9c69c7b90a3bcd6 ]

When disabling SR-IOV, clear the configuration of each VF
in the hardware. Do not exit the configuration clearing process
due to the failure of a single VF. Additionally, Clear the VF
configurations before decrementing the PM counter.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this patch fixes a regression that leaves HiSilicon QM VFs
configured in hardware after SR-IOV disable or an enable failure.

- `drivers/crypto/hisilicon/qm.c:4010` updates `qm->vfs_num` before
  `pci_enable_sriov()`, so if the enable step fails the rollback in
  `qm_clear_vft_config()` actually iterates the programmed VFs; after
  13e21e0ba44f (“adjust the internal processing sequence…”) this value
  stayed 0 and the hardware VFT tables were left stale.
- `drivers/crypto/hisilicon/qm.c:4051` now clears the VF entries while
  the device is still powered instead of zeroing `qm->vfs_num` and
  dropping the runtime-PM ref first, ensuring the SQC/CQC slots reserved
  for VFs are released back to the PF even on disable paths.
- `drivers/crypto/hisilicon/qm.c:3663` clears every VF VFT slot and no
  longer aborts on the first error, avoiding partially-cleared
  configurations that keep some queues orphaned.
- Without this fix, any failed SR-IOV enable attempt or VF disable
  leaves the PF unable to reclaim those queue pairs and can make
  subsequent enables misbehave, so users hit a functional regression;
  the change is small, driver-local, and restores the pre-regression
  clean-up semantics.

Recommendation: backport alongside (or after)
13e21e0ba44f5fad02a3b7b34987ff3845718198 in affected stable trees.

 drivers/crypto/hisilicon/qm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 822202e0f11b6..f9bf102b2b37d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3646,19 +3646,19 @@ static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 	return 0;
 }
 
-static int qm_clear_vft_config(struct hisi_qm *qm)
+static void qm_clear_vft_config(struct hisi_qm *qm)
 {
-	int ret;
 	u32 i;
 
-	for (i = 1; i <= qm->vfs_num; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-	qm->vfs_num = 0;
+	/*
+	 * When disabling SR-IOV, clear the configuration of each VF in the hardware
+	 * sequentially. Failure to clear a single VF should not affect the clearing
+	 * operation of other VFs.
+	 */
+	for (i = 1; i <= qm->vfs_num; i++)
+		(void)hisi_qm_set_vft(qm, i, 0, 0);
 
-	return 0;
+	qm->vfs_num = 0;
 }
 
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
@@ -3993,13 +3993,13 @@ int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
 		goto err_put_sync;
 	}
 
+	qm->vfs_num = num_vfs;
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret) {
 		pci_err(pdev, "Can't enable VF!\n");
 		qm_clear_vft_config(qm);
 		goto err_put_sync;
 	}
-	qm->vfs_num = num_vfs;
 
 	pci_info(pdev, "VF enabled, vfs_num(=%d)!\n", num_vfs);
 
@@ -4034,11 +4034,10 @@ int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 	}
 
 	pci_disable_sriov(pdev);
-
-	qm->vfs_num = 0;
+	qm_clear_vft_config(qm);
 	qm_pm_put_sync(qm);
 
-	return qm_clear_vft_config(qm);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
 
-- 
2.51.0

