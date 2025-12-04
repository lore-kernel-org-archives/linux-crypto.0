Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C0D33F360;
	Thu,  4 Dec 2025 11:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847598; cv=none; b=h2QWyNnxfDMm5IWU6GMVzsj/6KB1hSKesJLrYowrfyTtjn2ubOW5DK8j6h1/huoS19R7Fz6WubQ323i1H0MEOGyzkBpxYnPtfYacz65SK/6+xhlOz8FMn8Hsh8DIStUIxFL96EuGwEzW/f4fJ2j+N/LN/aDpPSUA7YlkWverHBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847598; c=relaxed/simple;
	bh=zpagOuIe519ImsJGw9bDFzmlT1F6HRmFmnUjr8PNBh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYIaHmmVfI6OEMx0HSzCDwQOfMpk+iwS8TkfuOf7MGIxd/tO4wApu4v9KTYKU7sAEYLNCLd/u8goyia3ELV7qRn+mnq1zoXV0aKc+JwkzCGBxNxG1eSPh+R9LhDB1vbcFC/qyOHnDmXLvMHb3Ju8smlnl5SZLF/XtXWTHMVltUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxRNDZbzFpTworAA--.26394S3;
	Thu, 04 Dec 2025 19:26:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJAxVOTWbzFpR2tFAQ--.61421S2;
	Thu, 04 Dec 2025 19:26:14 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] crypto: virtio: Add ecb aes algo support
Date: Thu,  4 Dec 2025 19:26:11 +0800
Message-Id: <20251204112612.2659650-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
References: <20250701030842.1136519-1-maobibo@loongson.cn=20251204112227.2659404-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxVOTWbzFpR2tFAQ--.61421S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

ECB AES also is added here, its ivsize is zero and name is different
compared with CBC AES algo.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 74 +++++++++++++------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index b4b79121c37c..9b4ba6a6b9cf 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -559,31 +559,57 @@ static void virtio_crypto_skcipher_finalize_req(
 					   req, err);
 }
 
-static struct virtio_crypto_algo virtio_crypto_algs[] = { {
-	.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
-	.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
-	.algo.base = {
-		.base.cra_name		= "cbc(aes)",
-		.base.cra_driver_name	= "virtio_crypto_aes_cbc",
-		.base.cra_priority	= 150,
-		.base.cra_flags		= CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-		.base.cra_blocksize	= AES_BLOCK_SIZE,
-		.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
-		.base.cra_module	= THIS_MODULE,
-		.init			= virtio_crypto_skcipher_init,
-		.exit			= virtio_crypto_skcipher_exit,
-		.setkey			= virtio_crypto_skcipher_setkey,
-		.decrypt		= virtio_crypto_skcipher_decrypt,
-		.encrypt		= virtio_crypto_skcipher_encrypt,
-		.min_keysize		= AES_MIN_KEY_SIZE,
-		.max_keysize		= AES_MAX_KEY_SIZE,
-		.ivsize			= AES_BLOCK_SIZE,
+static struct virtio_crypto_algo virtio_crypto_algs[] = {
+	{
+		.algonum = VIRTIO_CRYPTO_CIPHER_AES_CBC,
+		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
+		.algo.base = {
+			.base.cra_name		= "cbc(aes)",
+			.base.cra_driver_name	= "virtio_crypto_aes_cbc",
+			.base.cra_priority	= 150,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
+			.base.cra_module	= THIS_MODULE,
+			.init			= virtio_crypto_skcipher_init,
+			.exit			= virtio_crypto_skcipher_exit,
+			.setkey			= virtio_crypto_skcipher_setkey,
+			.decrypt		= virtio_crypto_skcipher_decrypt,
+			.encrypt		= virtio_crypto_skcipher_encrypt,
+			.min_keysize		= AES_MIN_KEY_SIZE,
+			.max_keysize		= AES_MAX_KEY_SIZE,
+			.ivsize			= AES_BLOCK_SIZE,
+		},
+		.algo.op = {
+			.do_one_request = virtio_crypto_skcipher_crypt_req,
+		},
 	},
-	.algo.op = {
-		.do_one_request = virtio_crypto_skcipher_crypt_req,
-	},
-} };
+	{
+		.algonum = VIRTIO_CRYPTO_CIPHER_AES_ECB,
+		.service = VIRTIO_CRYPTO_SERVICE_CIPHER,
+		.algo.base = {
+			.base.cra_name		= "ecb(aes)",
+			.base.cra_driver_name	= "virtio_crypto_aes_ecb",
+			.base.cra_priority	= 150,
+			.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				CRYPTO_ALG_ALLOCATES_MEMORY,
+			.base.cra_blocksize	= AES_BLOCK_SIZE,
+			.base.cra_ctxsize	= sizeof(struct virtio_crypto_skcipher_ctx),
+			.base.cra_module	= THIS_MODULE,
+			.init			= virtio_crypto_skcipher_init,
+			.exit			= virtio_crypto_skcipher_exit,
+			.setkey			= virtio_crypto_skcipher_setkey,
+			.decrypt		= virtio_crypto_skcipher_decrypt,
+			.encrypt		= virtio_crypto_skcipher_encrypt,
+			.min_keysize		= AES_MIN_KEY_SIZE,
+			.max_keysize		= AES_MAX_KEY_SIZE,
+		},
+		.algo.op = {
+			.do_one_request = virtio_crypto_skcipher_crypt_req,
+		},
+	}
+};
 
 int virtio_crypto_skcipher_algs_register(struct virtio_crypto *vcrypto)
 {
-- 
2.39.3

