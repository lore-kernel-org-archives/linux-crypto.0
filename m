Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034E63D962;
	Sun, 26 May 2024 09:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716553; cv=none; b=M7wKzZte3X0KyFbK1p8fws6LiUl8YtM2iiXuKqxuTKsxqsySAdkCSweIG7hLu/OycrhtyiHbAu1iKCo1GQnN/FEj6a68jwICbFGNs7onisfsZAfoMG3Jir+oZ4JXHy0SuxStuFnMDwY4XZuCgvu+kBZinSq3EWctTGtoVCHf5MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716553; c=relaxed/simple;
	bh=IciGUaZjLC7WvPU/EMDll8bQQZvHzbbXZp5v08cVN2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il98NND0a8K7xDEl63E36pZ6K0jXpkZmW0Z45NRXhwJopy0tVXm1QMppUgutniRNNubt5dYn2lAVy4UKMkYAnEWF/wepsBU+Pwfv95zuR5kyMh7bXqD+Ijbv/kHrksnLXLk72awFAtvaTFUDGamsXifguozPMv/hfLmE1VD5VUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfLxaZn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfLxaZn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE42C2BD10;
	Sun, 26 May 2024 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716552;
	bh=IciGUaZjLC7WvPU/EMDll8bQQZvHzbbXZp5v08cVN2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfLxaZn7Qmo8kmbqOHzryNSf23VbUj5yAGG82/QAsEaDt9ja2G1TGuDzw7L62xiNC
	 v04G3kYjkvBVYTkqTxKIcZtppQhwOEMtxmmHnslTlEzacnDQHg8zL07sxg6zkaib28
	 P/pW7A2cOOY73l8Lc1FY5wEsnGJPL+qvhE0LPheyho1dd+rNd6XVL/YtW2ix+mmroZ
	 C6vEhPm5/I6m/+bjkghOD5Au9yySJDtODDiNWm9r3rwM7B7YV95oWtuGXOvRyO40JI
	 0Nk8bTpscxCoJEPyfBILoeHzilmlqaZTeDVbTGVyaBzZppxbdRGP7Kax745i8ecOp6
	 RIa5TIHuIOQLQ==
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
Subject: [PATCH AUTOSEL 6.8 05/14] crypto: hisilicon/qm - Add the err memory release process to qm uninit
Date: Sun, 26 May 2024 05:42:10 -0400
Message-ID: <20240526094224.3412675-5-sashal@kernel.org>
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
index 4b20b94e6371a..5f3f2f1dd71ef 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2833,12 +2833,9 @@ void hisi_qm_uninit(struct hisi_qm *qm)
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

