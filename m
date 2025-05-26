Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E121CD2C;
	Mon, 26 May 2025 02:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748225081; cv=none; b=MC4/ZXrCr6J3W4B/adYsrYiFhAep9hvJGdRNG4EXToR8r0Arg58zUsW1mKdYMLB/PTaFE3G6DSPz2MipD91iIE6FyUt2Vs87/EMyItyZZ4x+KJzvWCjN8fAzqBNgAdcQpc0KhzXpdeueKftHAPmAsBjR2HrwgdSNfX6adgsIYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748225081; c=relaxed/simple;
	bh=4KFRG0JoG2YFzjPvR9NRoAseUIIuSWEwDIujr8L/O8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W63tea/iY3iSKTL2ZN/yc0yhWegnlOJAs3hJrm3z7UC5oWmhoNdX4AO16dcKuddnB0Fn1oiHGMqvx9K81etrz8iNzxygpHWqtvJs1Q+NGttNgi39oDau9PVenaG4f/AaXsg6BQP2S+ZLNjEnvcWOcoQtdYjmUMqK2prNxiMMNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowAAnPVUozDNoORIFAA--.2207S2;
	Mon, 26 May 2025 10:04:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: akhilrajeev@nvidia.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: tegra: Add crypto config in tegra_cmac_do_final()
Date: Mon, 26 May 2025 10:04:02 +0800
Message-ID: <20250526020403.230-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.42.0.windows.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAnPVUozDNoORIFAA--.2207S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF4rXr1kAr4kKF45Zw1UKFg_yoWkurc_ua
	1UurnrX345Krs7uF4DurWxZr4jg343XFykKFyjqr45Ca15Xr1fXas2qF109r1UJa1DJFn3
	W3y7ZFyUGw43ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAcOA2gzuGxdeQAAst

The function tegra_cmac_do_final() calls the function tegra234_aes_cfg(),
but does not call tegra234_aes_crypto_cfg() to have a crypto
configuration. A proper implementation can be found in
tegra_ccm_do_ctr().

Add the tegra234_aes_crypto_cfg() for configuration.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/tegra/tegra-se-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9d130592cc0a..e01653985a31 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -1550,6 +1550,8 @@ static int tegra_cmac_do_final(struct ahash_request *req)
 	rctx->datbuf.size = rctx->residue.size;
 	rctx->total_len += rctx->residue.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
+	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_CMAC, 0) |
+		SE_AES_KEY_INDEX(ctx->key_id);
 
 	/* Prepare command and submit */
 	cmdlen = tegra_cmac_prep_cmd(ctx, rctx);
-- 
2.42.0.windows.2

