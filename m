Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131D41B95B;
	Mon, 11 Nov 2024 01:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731289058; cv=none; b=OCDPwoGbCnpCHpApe5qyNhJCPu46ifzebZdsqb7zBa75zcQnDh/YsZgnrNEA/Yiy3IwyqEtBKTssYzjQnTUoM/Xh1n+8Q4W4V6okc6fneWnPLy/hIw6Muvuxai+mkf/d1vOAraIv7uLbQyhyGWLBzWQ1sAa1WdE+agf5EOo5v7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731289058; c=relaxed/simple;
	bh=HOkgBtHSI6baPmbqaXcaZYAi499ImxQjdx/H/6aJ44s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pwxx0flS/h4gGEudhtaAQnKRPzuiQckl0GLba5HMudM3CHSa7KIunCf27y4LYT37kKZON7PKrjJuqz5wgEJNsfnBF25th69SIT/RLxSXvcyou02takNa16ZRIt2spQ+raZhLCeqhUEsOnKrNwltlXY0arSoX/1I/R8ZLzh4dBBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xmsbr3YDSz4f3nT7;
	Mon, 11 Nov 2024 09:37:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 825CD1A0359;
	Mon, 11 Nov 2024 09:37:31 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgDXAIXRXzFnZ3LFBQ--.3182S2;
	Mon, 11 Nov 2024 09:37:31 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akhilrajeev@nvidia.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: [PATCH v2] crypto: tegra - do not transfer req when tegra init fails
Date: Mon, 11 Nov 2024 01:28:27 +0000
Message-Id: <20241111012827.1788341-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXAIXRXzFnZ3LFBQ--.3182S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1UJF48ur4UtrWDKF4xCrg_yoW8uFyDpF
	48Aayjyrn5XFZ5CF4xJF4rCF15Wasavry7G3yIyas5ZFs7Xry8Cr47CFyUXa15AFZ7try7
	Krs2yw13Jr1YqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

The tegra_cmac_init or tegra_sha_init function may return an error when
memory is exhausted. It should not transfer the request when they return
an error.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c  | 7 +++++--
 drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9d130592cc0a..d734c9a56786 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1750,10 +1750,13 @@ static int tegra_cmac_digest(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
+	int ret;
 
-	tegra_cmac_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	ret = tegra_cmac_init(req);
+	if (ret)
+		return ret;
 
+	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 4d4bd727f498..0b5cdd5676b1 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -615,13 +615,16 @@ static int tegra_sha_digest(struct ahash_request *req)
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ret;
 
 	if (ctx->fallback)
 		return tegra_sha_fallback_digest(req);
 
-	tegra_sha_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	ret = tegra_sha_init(req);
+	if (ret)
+		return ret;
 
+	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
-- 
2.34.1

