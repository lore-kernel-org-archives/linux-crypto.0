Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B0A1662E7;
	Mon, 17 Nov 2025 02:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763346716; cv=none; b=fb62Xnek1qI740/YejV0RynBR84Mc/twN00X0IHRE7OWK5VGSQNzy9S2B566wVnr3uECu5cVKEXGX5sDXuIaVTmzpj5hkekqSHMZqxXsJ9+UAwxE86viPi++sCW3MJs2O1ppoAwnBEE3v1oZDqttHXEX7OV57n64smLyDD9RjHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763346716; c=relaxed/simple;
	bh=chPqVcsnaUx+x9hnWGl0nv1eLH9BD6X3SmcAzYqmB0E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cFwfT2YapuuMrCSpIJcbFWUdW+NKIRvjWC1NcoD8rGUUdC1J4wtyaSTY400vpWllaXUrNL3EgvsYyoBRcUXDL+lYeJD0Z+CAuAqmlvmClCGbc5MUKOFss8AHWTHaidGrPbYIKrR5pcYOV/V/PS1flTjuKkhhUc/Fftom2LYtAl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-03 (Coremail) with SMTP id rQCowAAXptgHiRppZXgGAQ--.26690S2;
	Mon, 17 Nov 2025 10:31:36 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH v2] crypto: sa2ul: Add error handling for DMA metadata retrieval
Date: Mon, 17 Nov 2025 10:31:17 +0800
Message-ID: <20251117023117.90-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAAXptgHiRppZXgGAQ--.26690S2
X-Coremail-Antispam: 1UD129KBjvJXoWxurW7Jw4UCF47XF18Gr4rZrb_yoW5AF48pa
	yrWay2y398JFZ7JrW3Xa43Ar45ur93ua43u397GF1xuw15WF18KF4UCa4rXF1jyas5ta45
	J39rWa43uw1DtFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUehL0UU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRAJA2kag78WcQAAs7

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
Changes in v2:
  -fix the misuse of skcipher_request_complete().
---
 drivers/crypto/sa2ul.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index fdc0b2486069..93afe7c6a3e1 100644
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
+		ahash_request_complete(req, PTR_ERR(mdptr));
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
+		aead_request_complete(req, PTR_ERR(mdptr));
+		return;
+	}
 	for (i = 0; i < (authsize / 4); i++)
 		mdptr[i + 4] = swab32(mdptr[i + 4]);
 
-- 
2.50.1.windows.1

