Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE28A2135A5;
	Wed,  5 Feb 2025 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727795; cv=none; b=j3OR2VTri1/iuXXtDta5G5y/1wqMKtTKG35KTuoNb+9LOFXXflQJ0k5X5FFyPb5AuS6GkTmW4cN15BwU6kxUJZeqwAzaW3g3EEy9kowFdIcLdX6n9t+CuJb6gcrZcyUOXxAe1rBAkQ7s/v8ZbMJeWiSoVY1Rdpv4w9pCOk85H5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727795; c=relaxed/simple;
	bh=VZSNDcJ6gGKPtMe9weeRLAVmTgY8EzAZ0GlYhjah1iU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ct2YuJaZaUduzo5kOmylL5B7V7Jgmy1Q2j/kiuYtzMgyrzuPoB6Luc5l5p4N3ebz7DoqYsSL6eQPDAoYiWy0peOj1atXOpVO1AVQ5imRnKjc6gjkk9Z8/+btthSeih6bj4i7+3mAf+cs8/uRjIPT2si0zEO4chpnhnzSXMlGjK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YnmWw1nqtz11PdG;
	Wed,  5 Feb 2025 11:52:12 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 2293E1402CA;
	Wed,  5 Feb 2025 11:56:30 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Feb 2025 11:56:29 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/3] crypto: hisilicon/sec2 - fix for aead auth key length
Date: Wed, 5 Feb 2025 11:56:26 +0800
Message-ID: <20250205035628.845962-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250205035628.845962-1-huangchenghai2@huawei.com>
References: <20250205035628.845962-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

According to the HMAC RFC, the authentication key
can be 0 bytes, and the hardware can handle this
scenario. Therefore, remove the incorrect validation
for this case.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 66bc07da9..472c5c52b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1090,11 +1090,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 	struct crypto_shash *hash_tfm = ctx->hash_tfm;
 	int blocksize, digestsize, ret;
 
-	if (!keys->authkeylen) {
-		pr_err("hisi_sec2: aead auth key error!\n");
-		return -EINVAL;
-	}
-
 	blocksize = crypto_shash_blocksize(hash_tfm);
 	digestsize = crypto_shash_digestsize(hash_tfm);
 	if (keys->authkeylen > blocksize) {
@@ -1106,7 +1101,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 		}
 		ctx->a_key_len = digestsize;
 	} else {
-		memcpy(ctx->a_key, keys->authkey, keys->authkeylen);
+		if (keys->authkeylen)
+			memcpy(ctx->a_key, keys->authkey, keys->authkeylen);
 		ctx->a_key_len = keys->authkeylen;
 	}
 
-- 
2.33.0

