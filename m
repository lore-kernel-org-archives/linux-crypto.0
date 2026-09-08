Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52055345751;
	Tue,  8 Sep 2026 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788894977; cv=none; b=JnjtNHDzipUYkI0OZ5F6Z+A1FyoeZQGeoOhny1FKQeMYDD0G2jQim2FA2WzP4SfZ5+oCNoYuXw5EtEoJunErhsuYr+du7s9hLzerw98NQmCcqI+l9/oosTquqcz4uE0Bc+OSlX/8+cQ2FNpu6KBjVVZITQ8VNGab/bKj+WQ35JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788894977; c=relaxed/simple;
	bh=cog+oVLaKQct6BzbWKYJueIWkbLd1K/8HinrtKRYCBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cimNJp3PlDR1FzBEt+Iu+SgtC8DVE7+aOL32XTk+AAC3MTXJ6r7aGTbEJUdyYqIOuSrjgwxn7adku2Mb1cnYFk91D+V2nCmnugmHQJ+7KrnBxmqu0IDIeui11rhUl5QRO1hR58EtQ5hEO6dx/Mh88X8ze76P9fouDkz1PNJhaOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FiBgZpIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FiBgZpIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A40A1F00A3A;
	Tue,  8 Sep 2026 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788894976;
	bh=xMq8l7gT6yB6KuF9QRWCL28yujf4mq6rtubflHZD75Y=;
	h=From:To:Cc:Subject:Date;
	b=FiBgZpILqusTF6OW8Sna+WwhvoBP+hyiz7cfB+tCzf7IZikJNl9TVqmlmUADOv9H+
	 T1eTEIpH4+D6jLMFIMa4/rbzDTWzpAHsKeysoI66xL22ZzeXjl2PnMLmpxUeeJxl13
	 2CVKcw+pP3/2fESs5oli+DKZ7ZxYNF3Q9WaTGe+ruajAAxZY4lE5jEVLcFa99QZGFK
	 AUBzNfq4o+CkEg/Mt8Y8MOEUH9R+hMbMPK7XWWnADjN6vJ2kRhVxjev7cOL5D5C3Ec
	 PHFoZRDXdCpShrMgiv4MQsYMX04DGPTNG5nucTUhG/O/1Id9aCgHoCYKvcoIQN2dvs
	 KYy1tK6f1p4TQ==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
Cc: Thorsten Blum <blum@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: xilinx - clear AES key buffer before freeing it
Date: Tue,  8 Sep 2026 21:16:06 +0200
Message-ID: <20260908191607.405177-2-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1078; i=blum@kernel.org; h=from:subject; bh=cog+oVLaKQct6BzbWKYJueIWkbLd1K/8HinrtKRYCBQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkL4r5vf2fzboLsGc0Djwtd9L6o3bFbkDPLPW3NOqE/B qs3O9bGdpSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEmr8x/BUPu94jsKbVMEv7 p6hSYoLiz/rXIhHJ3/RWcm251rO+6Rcjwy6+/etf/+g+39l7/+HTMjVP1ocCTL3loR6FSpeD72n 5cwMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

In xilinx_aes_aead_exit(), the AES key buffer is freed without being
cleared, which allows key material to remain in memory. Use
kfree_sensitive() to clear the buffer before freeing it.

Fixes: c315cb0005be ("crypto: xilinx - Change coherent DMA to streaming DMA API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index d54c268dfe34..ebee37dddb1f 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -766,7 +766,7 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single(tfm_ctx->dev, tfm_ctx->key_dma_addr, AES_KEYSIZE_256, DMA_TO_DEVICE);
-	kfree(tfm_ctx->key);
+	kfree_sensitive(tfm_ctx->key);
 	if (tfm_ctx->fbk_cipher) {
 		crypto_free_aead(tfm_ctx->fbk_cipher);
 		tfm_ctx->fbk_cipher = NULL;
