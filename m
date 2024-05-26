Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB2413AEE;
	Sun, 26 May 2024 09:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716521; cv=none; b=QmTHdsVL3ER4lR9IipgNxFoezNpaT/nK2PzsmtL44xA4PewnmGNeLFulflbAmZLdRNLQ/Y5oyU7k1xupk/0KWsUq8fXZ+bQMzCTpSdC/0D2a7K2WFQ5dD37YjWbRa0840yFxO/WdUpHahpjiQ35d2YGgVEaPJzR32V9nVF0jhFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716521; c=relaxed/simple;
	bh=UIVnESVODy4iD6n7pWSxqNXIFCQSqUEh5UJQkxwMHds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEDzuT9imM+GUEWfeU2Nrx5W5x7qFjUfD3NxW+azDC9yH0P7yWyHC/DNESHQFQ5ykc/DW0JMvIAo3c5gKmsy637XTNqcgy/htR35TbKaN7/wfsiDLZnv+7mROUzQrRlid8BD/z5dIIg/kYfI0F4GhstCLUgk9ndRPHuMZG8HuiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rfr0WjxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rfr0WjxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25BAC32789;
	Sun, 26 May 2024 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716520;
	bh=UIVnESVODy4iD6n7pWSxqNXIFCQSqUEh5UJQkxwMHds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfr0WjxXiuhH+NMM+fhoGkhg7VKqw7DlQR9O8/hD/y9bwbV18a4AyqVLKFcxTbhyG
	 xF1b659ASTatBO63PJG2ap8RHU4TMc71PDELX12N9j/YbCx/GpQooHKSpulmBCEgLu
	 gKecECcbWbJ7lYkEf5DKDiHqJPLsnoaaslvbOYnY4can7aGb65AX3Ci1EqqzMS8FCL
	 h9R0veQNboZprbNCApSwUuodPmSXPvRYfUUwsmfJhfpa+49zOvPGLx7YQS2trE2o8F
	 JJNJGT0+A2zkimKSQt4B3G4p5pNFEGRpu3gAGZuX6y4UZdOitEtILE4SCPLH+Hs13U
	 02lFtjIoGxouQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 05/15] crypto: hisilicon/qm - Add the err memory release process to qm uninit
Date: Sun, 26 May 2024 05:41:37 -0400
Message-ID: <20240526094152.3412316-5-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094152.3412316-1-sashal@kernel.org>
References: <20240526094152.3412316-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.1
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit c9ccfd5e0ff0dd929ce86d1b5f3c6a414110947a ]

When the qm uninit command is executed, the err data needs to
be released to prevent memory leakage. The error information
release operation and uacce_remove are integrated in
qm_remove_uacce.

So add the qm_remove_uacce to qm uninit to avoid err memory
leakage.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 92f0a1d9b4a6b..13e413533f082 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2893,12 +2893,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 	hisi_qm_set_state(qm, QM_NOT_READY);
 	up_write(&qm->qps_lock);
 
+	qm_remove_uacce(qm);
 	qm_irqs_unregister(qm);
 	hisi_qm_pci_uninit(qm);
-	if (qm->use_sva) {
-		uacce_remove(qm->uacce);
-		qm->uacce = NULL;
-	}
 }
 EXPORT_SYMBOL_GPL(hisi_qm_uninit);
 
-- 
2.43.0

