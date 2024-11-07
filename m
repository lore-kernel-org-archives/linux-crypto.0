Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFA0DF78;
	Thu,  7 Nov 2024 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730943191; cv=none; b=RV0Xml5AHQ6A0nYlXJteJqBTOMX6zrtAzGkoBS6guS764XlHHTej0lnrZmO3lrNFzcj3vRZuLlrZ4LaW2mGSD9JgwC4Sa7AcplpbsBpTK2ktDv+SLc/TzzWIB+yxP1N+eMdwqNvVh1D8pa7v12vWV2XZDpYUtGe8hs39RX8RDNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730943191; c=relaxed/simple;
	bh=4nxCp5Sjd0mMPkyeUlSN8LSaCjjPFoaYLgo0iH8mfYw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZQiKQmUZydUbDntGKeW7z7ACDU60tM0THUnGZ4HGVXZ15KxLBn2PZqySITnxGWSGkqh75PR92xNuT2SjVym/WqVJuOdwB0c8ev2x93SFeS9VlyTCB5nILE6tKqJYhFlGgEAN72w8yEWQwLpPnjuj5DUqymKvDEom36PBSaYVHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XkPhZ3grJz4f3jXs;
	Thu,  7 Nov 2024 09:32:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 813C31A06DA;
	Thu,  7 Nov 2024 09:33:04 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgAXP4PGGCxnWNREBA--.27917S2;
	Thu, 07 Nov 2024 09:33:04 +0800 (CST)
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
Subject: [PATCH] crypto: tegra - do not transfer req when tegra_cmac_init returns an error
Date: Thu,  7 Nov 2024 01:24:07 +0000
Message-Id: <20241107012407.1669481-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXP4PGGCxnWNREBA--.27917S2
X-Coremail-Antispam: 1UD129KBjvJXoWrKr1DJrW8Xw15tF4kuFyDWrg_yoW8JF4UpF
	4DZayjvrn5XrZ5CFWxJa15uF15Ga95Zry7Kw4IyasYvFs7J348CrW2ka4UXa15AFZ7try2
	krs2yw13tr12vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

The tegra_cmac_init function may return an error when memory is exhausted.
It should not transfer the request when tegra_cmac_init returns an error.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9d130592cc0a..10cd19427530 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1747,13 +1747,16 @@ static int tegra_cmac_finup(struct ahash_request *req)
 
 static int tegra_cmac_digest(struct ahash_request *req)
 {
+	int ret;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct tegra_cmac_reqctx *rctx = ahash_request_ctx(req);
 
-	tegra_cmac_init(req);
-	rctx->task |= SHA_UPDATE | SHA_FINAL;
+	ret = tegra_cmac_init(req);
+	if (ret)
+		return ret;
 
+	rctx->task |= SHA_UPDATE | SHA_FINAL;
 	return crypto_transfer_hash_request_to_engine(ctx->se->engine, req);
 }
 
-- 
2.34.1

