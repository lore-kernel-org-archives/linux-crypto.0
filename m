Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9B1714C6;
	Wed, 25 Sep 2024 11:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264393; cv=none; b=arjQzZX/4bURLR26lTB1ss9P3a0c8Wxtvip2Z5VayeQabJZ315DnF6EuBmqVWyqEHjLT9XNH064kKNUAFzYvTdxXR5ETdCn1gCAaNnelHS6xUkk9lFc0rZN84ORHVENDPuMwtWQlWKRGlmH+Gd29bQ5ZTBXXYx0eiaYpqWPPxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264393; c=relaxed/simple;
	bh=3RUwOFnAWaH6vstr8Lg2RwM5nPpr+9uWilbMvttHpS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYSohwf9drwHqjVvIMn6founHnDmm/RYt2i5nCKrcxcSIwK1y7WDj6/4/BOKsSuU900xDiac0oytpNOWBmHeZ9YOVfG+JvS9UpHn1hvsexYL6W0HtwS/5xN/uOWFVRcre+76YRyKpRAlSl/AEPr/BOqtN89pSCATITRxEOYoPKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clpYPKRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clpYPKRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40CCC4CEC3;
	Wed, 25 Sep 2024 11:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264393;
	bh=3RUwOFnAWaH6vstr8Lg2RwM5nPpr+9uWilbMvttHpS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clpYPKRXu/9OE/ciZh4NdSrX1WYhtkNVjTdtYaxg4nkaq2zlGnXHlggwg6AGHQ6rv
	 r/hRz7kUQ2DaVihoTSisQeAb7QUqUUHF5ItshB+G87YJmli0it5vpVL6ENCa1Ao+jo
	 9yO9A717p9OCR7ukOU80D++bTV8tTcKjRUhfDvWwDBbyVzfRPWjQdr6oX4A93TX4H0
	 LENGUBYB9QiH14UgEjv5wZMKzstLm6368mS/Okw7m5IW4lvS9nljP0R/pgTKl5mxqQ
	 XD8MicjcJeSxpI2RkFMPWwnLZyTEMQL6/gTmnonVkl2oeraiJUR3C1FN4KZLxB0j2c
	 rtDw17kjbAebQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Yang Shen <shenyang39@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	qianweili@huawei.com,
	wangzhou1@hisilicon.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 080/244] crypto: hisilicon - fix missed error branch
Date: Wed, 25 Sep 2024 07:25:01 -0400
Message-ID: <20240925113641.1297102-80-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Yang Shen <shenyang39@huawei.com>

[ Upstream commit f386dc64e1a5d3dcb84579119ec350ab026fea88 ]

If an error occurs in the process after the SGL is mapped
successfully, it need to unmap the SGL.

Otherwise, memory problems may occur.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sgl.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 568acd0aee3fa..c974f95cd126f 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -225,7 +225,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	dma_addr_t curr_sgl_dma = 0;
 	struct acc_hw_sge *curr_hw_sge;
 	struct scatterlist *sg;
-	int sg_n;
+	int sg_n, ret;
 
 	if (!dev || !sgl || !pool || !hw_sgl_dma || index >= pool->count)
 		return ERR_PTR(-EINVAL);
@@ -240,14 +240,15 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 
 	if (sg_n_mapped > pool->sge_nr) {
 		dev_err(dev, "the number of entries in input scatterlist is bigger than SGL pool setting.\n");
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto err_unmap;
 	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
 	if (IS_ERR(curr_hw_sgl)) {
 		dev_err(dev, "Get SGL error!\n");
-		dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err_unmap;
 	}
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
@@ -262,6 +263,11 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	*hw_sgl_dma = curr_sgl_dma;
 
 	return curr_hw_sgl;
+
+err_unmap:
+	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_sg_buf_map_to_hw_sgl);
 
-- 
2.43.0

