Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD49B302779;
	Tue,  9 Dec 2025 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765245620; cv=none; b=bgDhS03CF8XhjFrPiZnEjLFdbWcpRXJDR2wieiRwK0+3364mb1CofID9OaOZ2ZHfX22IGV/AtV1DBNVmIuWD2BpEv7Q/Exhy93l8nFuvhBmRvquiqEYV7X++t9wX+fAKp1apqG2VMATs+4UZf9RGMabXJa3DzUnU1fZpEWZ+kqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765245620; c=relaxed/simple;
	bh=ZihkIuUV3vCcA4kHz3C7ogyV5ljaQYRcucxehL1NGig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLlos8Pi1Fp0mtDftcPZQ/Xa82fEg6VOV0vsi3DALsXKuzs/S4bv64tY8urtCyVxGlKLAqA72tUgnoA7iTtDcyp+ZjgOK6tec3170x+vT0sob/k+RrboY+5+APShTMmGcRXLUej58iaPYhJyB79rhmjiOF2Vc7VdLNUDeio48mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx37+vgjdpfYEsAA--.28285S3;
	Tue, 09 Dec 2025 10:00:15 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxXMGpgjdpNkBHAQ--.4873S4;
	Tue, 09 Dec 2025 10:00:13 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/10] crypto: virtio: Add ecb aes algo support
Date: Tue,  9 Dec 2025 09:59:50 +0800
Message-Id: <20251209015951.4174743-11-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251209015951.4174743-1-maobibo@loongson.cn>
References: <20251209015951.4174743-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxXMGpgjdpNkBHAQ--.4873S4
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
index a5e6993da2ef..193042e8e6ac 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -561,31 +561,57 @@ static void virtio_crypto_skcipher_finalize_req(
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

