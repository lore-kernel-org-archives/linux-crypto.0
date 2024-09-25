Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9621D6DC6;
	Wed, 25 Sep 2024 12:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727265665; cv=none; b=TOqnIgqcTj8RbaxiBAb1A5rdEqqm9WFoU9dh8YYRmyRrb1mQkHKiwjQHQ7PN+Rwow9nRXakQ5OCm8t9MgAGU0LzyJgQxKa9SbdvqsLodVHUIB2BLHdN4Lw667kt+fK2vbA0ADFkD8O0RerqYll7QYYzK2+Hh8OEtMUdYH4n9eYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727265665; c=relaxed/simple;
	bh=3RUwOFnAWaH6vstr8Lg2RwM5nPpr+9uWilbMvttHpS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJnJABXnjQm5hEd5Wc6tD4l3glWqfdOVdsTneVEBjyoX4g4YCM5WYbQWQBM10ZDeNgphx6ej4agJGw2n3KSn8G08uLH7eAM5gfCAClJnNIYloel16AiTvH7RmdRz0ISycAYETQtKQITpITYMzevCjuD4c2osbEvgvKULC2cTusI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVCl5ssO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVCl5ssO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970A3C4CEC3;
	Wed, 25 Sep 2024 12:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727265664;
	bh=3RUwOFnAWaH6vstr8Lg2RwM5nPpr+9uWilbMvttHpS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVCl5ssO61WP0DNWfKAUJ3B7fGdrsP3Uk8xOXJLjsLOitWtc3k5T5rR5BML6PeZG9
	 BYMpc1pAFt3tlihzqbRE1MS4MlMywPwK5+33zfgUg5yuxE2gxbLRBqJq/8MEwzNXW7
	 N2hsmd2JGL9UCInEqZS0XNFOj/M/DI/eZSZqzcu8h5W6jypZb6E+7MTyvXYAwpYg4r
	 stATNxOjIAbYFNav9j+i0TTF7C/yuJJjEtwpB5INN+GJ1aGq4+591CMDFhOUaY5oT4
	 R1CO6yVF4HoQXnnTIEzmFjuh1wdhqkSA0v7As28pNCxrKRHV6N+t4rebSy5hCjICLP
	 z7OjatlMAFx8g==
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
Subject: [PATCH AUTOSEL 6.10 065/197] crypto: hisilicon - fix missed error branch
Date: Wed, 25 Sep 2024 07:51:24 -0400
Message-ID: <20240925115823.1303019-65-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925115823.1303019-1-sashal@kernel.org>
References: <20240925115823.1303019-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.11
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

