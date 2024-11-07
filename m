Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0917A212183;
	Thu,  7 Nov 2024 13:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984476; cv=none; b=eWtJk/ej78S3LfHhacMSXaN8hxE5Jcsk1EkKFQsqYzEBv2dzLtipqwxAr32qRkfLbGM54KAGCxYDrISQmptbna78ueRMxjX/YwAO0p9ettWzaTS7FaNauNBcXjNkPP3c1/OPDAMRXL4tewVhFQ7TRSzyDrR58W3h4AMjPG5mmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984476; c=relaxed/simple;
	bh=weKFdSv484Nfdma5NXkK5zuGxGcL8QsFDBaRUUD6x8g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=su1vt1GlggD9SFC+/ZX7PbiL7bnHgygMXLjhlDIcUt5k/HU21leWXovCSf+VnyqyTY13bIBopev8cBnNFqosr18TBwEBO3Snha7vyqlQknJwuHT/TxVoaK6dBhrIWjmMLEj3k0u3zO6ox63y5mw5M0dMqtDk5YixFSq3zGuKrYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XkhyW1WKvz4f3jY3;
	Thu,  7 Nov 2024 21:00:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3BA951A0568;
	Thu,  7 Nov 2024 21:01:09 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgC33oIMuixnNNByBA--.55105S2;
	Thu, 07 Nov 2024 21:01:09 +0800 (CST)
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
Subject: [PATCH] crypto: tegra - do not transfer req when tegra_sha_init returns an error
Date: Thu,  7 Nov 2024 12:52:11 +0000
Message-Id: <20241107125211.1679517-1-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC33oIMuixnNNByBA--.55105S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1DXFWfurWkCFWxCr48JFb_yoW8GFy7pF
	WkZayjyr1rXFn3CFn7Aan8CFy5Ja9avry7G3yIyasYyrs7X34kCrW7GFyUXan8AFZ7tr12
	yrs2kw4avr1jq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/

From: Chen Ridong <chenridong@huawei.com>

The tegra_sha_init function may return an error when memory is exhausted.
It should not transfer the request when tegra_sha_init returns an error.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 drivers/crypto/tegra/tegra-se-hash.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 4d4bd727f498..7e888bf5f66a 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -612,6 +612,7 @@ static int tegra_sha_finup(struct ahash_request *req)
 
 static int tegra_sha_digest(struct ahash_request *req)
 {
+	int ret;
 	struct tegra_sha_reqctx *rctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -619,9 +620,11 @@ static int tegra_sha_digest(struct ahash_request *req)
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

