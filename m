Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CA132E72B;
	Thu, 13 Nov 2025 07:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763020278; cv=none; b=OQP4dZ1KX+SP6ACg8dnU6+7AiL8ATbjb51UDqLVfssZvy3KJo2CL/tbmfCyMxbNfUHQiq5S19mBtIw+L2FX8HVd6TVBhee1fcvR8Yxr71k3EE8YfhNTsho8DPB1BGwFXH5sZomQNxE5WVUnU48i2mTUdufuTf1Xzn4aEYypLcS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763020278; c=relaxed/simple;
	bh=H1qOcA6eFMFqHCEyCVcEkZ+J9Tlx0VvtvRNodVjvXIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RxGYmu62Tm9fNpjLD4YLv/AotJG/YKyOfEw9yVqJesQsVjKr9Xd5BucDIcs6E8TYahauiLTRLACwyTDBZgXDQddgaGvSw2aBDRCwAwx0QN3pR8SL/tcDgw2/yNg3sRri2bAcQTssqmsXnKeldnTcLEGPwgmm5a+CUefpJ8Zw3Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-05 (Coremail) with SMTP id zQCowADnr3DvjRVp8daWAA--.40885S2;
	Thu, 13 Nov 2025 15:51:12 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: sa2ul: Add error handling for DMA metadata retrieval
Date: Thu, 13 Nov 2025 15:51:04 +0800
Message-ID: <20251113075104.1396-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnr3DvjRVp8daWAA--.40885S2
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7Jw4UCF47XF1Uur18AFb_yoW5Ar1Upa
	yrWay2y398JFZ7JrW3J3W3Ar45ur93Wa43C39rGF1xuw15WF18KF4UC34rXF1jyas5ta43
	JrZrWa43uwn8tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUSNtxUUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBg0FA2kVJ-uQ-wABsD

The SA2UL driver calls dmaengine_desc_get_metadata_ptr() in AES, SHA and
AEAD DMA paths without checking for error pointers. If the metadata
retrieval fails, these functions may dereference an ERR_PTR value,
leading to kernel crashes or undefined behavior.

Add proper IS_ERR() checks after each dmaengine_desc_get_metadata_ptr()
call, log the failure, clean up the DMA state, and complete the crypto
request with an error.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: 2dc53d004745 ("crypto: sa2ul - add sha1/sha256/sha512 support")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/crypto/sa2ul.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index fdc0b2486069..eaec284b5e4b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1051,6 +1051,13 @@ static void sa_aes_dma_in_callback(void *data)
 	if (req->iv) {
 		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
 							       &ml);
+		if (IS_ERR(mdptr)) {
+			dev_err(rxd->ddev, "Failed to get AES RX metadata pointer: %ld\n",
+				PTR_ERR(mdptr));
+			sa_free_sa_rx_data(rxd);
+			skcipher_request_complete(req, PTR_ERR(mdptr));
+			return;
+		}
 		result = (u32 *)req->iv;
 
 		for (i = 0; i < (rxd->enc_iv_size / 4); i++)
@@ -1272,6 +1279,12 @@ static int sa_run(struct sa_req *req)
 	 * crypto algorithm to be used, data sizes, different keys etc.
 	 */
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
+	if (IS_ERR(mdptr)) {
+		dev_err(pdata->dev, "Failed to get TX metadata pointer: %ld\n",
+			PTR_ERR(mdptr));
+		ret = PTR_ERR(mdptr);
+		goto err_cleanup;
+	}
 
 	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
 				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
@@ -1367,6 +1380,14 @@ static void sa_sha_dma_in_callback(void *data)
 	authsize = crypto_ahash_digestsize(tfm);
 
 	mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl, &ml);
+	if (IS_ERR(mdptr)) {
+		dev_err(rxd->ddev, "Failed to get SHA RX metadata pointer: %ld\n",
+			PTR_ERR(mdptr));
+		sa_free_sa_rx_data(rxd);
+		skcipher_request_complete(req, PTR_ERR(mdptr));
+		return;
+	}
+
 	result = (u32 *)req->result;
 
 	for (i = 0; i < (authsize / 4); i++)
@@ -1677,6 +1698,13 @@ static void sa_aead_dma_in_callback(void *data)
 	authsize = crypto_aead_authsize(tfm);
 
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl, &ml);
+	if (IS_ERR(mdptr)) {
+		dev_err(rxd->ddev, "Failed to get AEAD RX metadata pointer: %ld\n",
+			PTR_ERR(mdptr));
+		sa_free_sa_rx_data(rxd);
+		skcipher_request_complete(req, PTR_ERR(mdptr));
+		return;
+	}
 	for (i = 0; i < (authsize / 4); i++)
 		mdptr[i + 4] = swab32(mdptr[i + 4]);
 
-- 
2.50.1.windows.1

