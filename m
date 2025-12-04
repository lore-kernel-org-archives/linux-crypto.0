Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 926AA33DECD;
	Thu,  4 Dec 2025 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847395; cv=none; b=iqds2D064XvQ9IGu9/u/85nf3u8kDy8QwK/Ap5OyY0rbj3LtE7k+6xdqoxpE+7HvPy77mwfh6aJBonb1/so15hQ9PtaU562foDNgJg9mN9MEQGvm8zqYevRwWLUaff9jHK/BxHw4UBwKbmeK/liiYdrERh1yndCKSAtbUox+/9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847395; c=relaxed/simple;
	bh=fY0SZ7IA2VqnaoJFfIVHEkajs1Dg4mydpYpQrDdHrrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h2NZKMWt/HqoO5CKWpGKZ4fk4Jq9SJZpnAKrkU76Oimwe/GIWbG8L8Oeg8WJCGlVNc5yGvf1maFrtq5/06CNbElXNWQFhmgls3EHi0wfxVT1yp0UYupHepRdgS9jnZCf7sCggP/wEJh30Dy9BUePX/N6S1e0uEyp0ObvHPjs74Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxP_D7bjFpCgorAA--.26652S3;
	Thu, 04 Dec 2025 19:22:35 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxG8HzbjFp1mpFAQ--.17590S6;
	Thu, 04 Dec 2025 19:22:34 +0800 (CST)
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
Subject: [PATCH v2 4/9] crypto: virtio: Use generic API aes_check_keylen()
Date: Thu,  4 Dec 2025 19:22:21 +0800
Message-Id: <20251204112227.2659404-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20251204112227.2659404-1-maobibo@loongson.cn>
References: <20251204112227.2659404-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxG8HzbjFp1mpFAQ--.17590S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

With AES algo, generic API aes_check_keylen() is used to check length
of key.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index d42c7a77cdbb..314ecda46311 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -94,18 +94,16 @@ static u64 virtio_crypto_alg_sg_nents_length(struct scatterlist *sg)
 }
 
 static int
-virtio_crypto_alg_validate_key(int key_len, uint32_t *alg)
+virtio_crypto_alg_validate_key(int key_len, uint32_t alg)
 {
-	switch (key_len) {
-	case AES_KEYSIZE_128:
-	case AES_KEYSIZE_192:
-	case AES_KEYSIZE_256:
-		*alg = VIRTIO_CRYPTO_CIPHER_AES_CBC;
-		break;
+	switch (alg) {
+	case VIRTIO_CRYPTO_CIPHER_AES_ECB:
+	case VIRTIO_CRYPTO_CIPHER_AES_CBC:
+	case VIRTIO_CRYPTO_CIPHER_AES_CTR:
+		return aes_check_keylen(key_len);
 	default:
 		return -EINVAL;
 	}
-	return 0;
 }
 
 static int virtio_crypto_alg_skcipher_init_session(
@@ -248,7 +246,6 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		struct virtio_crypto_skcipher_ctx *ctx,
 		const uint8_t *key, unsigned int keylen)
 {
-	uint32_t alg;
 	int ret;
 	struct virtio_crypto *vcrypto = ctx->vcrypto;
 
@@ -257,7 +254,7 @@ static int virtio_crypto_alg_skcipher_init_sessions(
 		return -EINVAL;
 	}
 
-	if (virtio_crypto_alg_validate_key(keylen, &alg))
+	if (virtio_crypto_alg_validate_key(keylen, ctx->alg->algonum))
 		return -EINVAL;
 
 	/* Create encryption session */
@@ -279,10 +276,9 @@ static int virtio_crypto_skcipher_setkey(struct crypto_skcipher *tfm,
 					 unsigned int keylen)
 {
 	struct virtio_crypto_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
-	uint32_t alg;
 	int ret;
 
-	ret = virtio_crypto_alg_validate_key(keylen, &alg);
+	ret = virtio_crypto_alg_validate_key(keylen, ctx->alg->algonum);
 	if (ret)
 		return ret;
 
-- 
2.39.3

