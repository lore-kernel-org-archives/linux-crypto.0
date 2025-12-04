Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEB733EB19;
	Thu,  4 Dec 2025 11:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764847549; cv=none; b=l9gtbYOz9dF7ChdL7WgBRrGmr93gDmxC3abdPlBzBiS8c1l216TONC1lh9qtp1gbWzxrdetS+9DRpwKYGn0iVAnhskme4kERh63DWL7vILdc3bKGGcBaFsKenmmphibCkHpNjw1mdyNMuCDC5uROXfJyMQOAalDMZlBGlnNhG0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764847549; c=relaxed/simple;
	bh=1Wg9Gngx3yec8fG4euvLrWZ7vNnJpHijt0KPLPRj1tw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mv8SCX4Vddri295eQW31eb1N/lVrEWgOvQGPp4PPT5BA+MoFpq8UtGTCTzlQw8y5sF5gS5pvSlPrHAJGvNG7cT8TaQof/vQDp+0SSKN0eYWO3P0xAAfU0qRwfhSWHXnHM6tPYwKpTC0wIE+tmD9B+S2s/vZDRYTrzsYKACIktQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8CxJ9G0bzFpPgorAA--.26570S3;
	Thu, 04 Dec 2025 19:25:40 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxaMCzbzFpO2tFAQ--.29989S2;
	Thu, 04 Dec 2025 19:25:39 +0800 (CST)
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
Subject: [PATCH v2 8/9] crypto: virtio: Add skcipher support without IV
Date: Thu,  4 Dec 2025 19:25:36 +0800
Message-Id: <20251204112537.2659601-1-maobibo@loongson.cn>
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
X-CM-TRANSID:qMiowJDxaMCzbzFpO2tFAQ--.29989S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Some skcipher algo has no IV buffer such as ecb(aes) also, here add
checking with ivsize.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 .../virtio/virtio_crypto_skcipher_algs.c      | 36 +++++++++++--------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index c911b7ba8f13..b4b79121c37c 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -345,7 +345,9 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 			src_nents, dst_nents);
 
 	/* Why 3?  outhdr + iv + inhdr */
-	sg_total = src_nents + dst_nents + 3;
+	sg_total = src_nents + dst_nents + 2;
+	if (ivsize)
+		sg_total += 1;
 	sgs = kcalloc_node(sg_total, sizeof(*sgs), GFP_KERNEL,
 				dev_to_node(&vcrypto->vdev->dev));
 	if (!sgs)
@@ -402,15 +404,17 @@ __virtio_crypto_skcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	 * Avoid to do DMA from the stack, switch to using
 	 * dynamically-allocated for the IV
 	 */
-	iv = vc_sym_req->iv;
-	memcpy(iv, req->iv, ivsize);
-	if (!vc_sym_req->encrypt)
-		scatterwalk_map_and_copy(req->iv, req->src,
-					 req->cryptlen - ivsize,
-					 ivsize, 0);
-
-	sg_init_one(&iv_sg, iv, ivsize);
-	sgs[num_out++] = &iv_sg;
+	if (ivsize) {
+		iv = vc_sym_req->iv;
+		memcpy(iv, req->iv, ivsize);
+		if (!vc_sym_req->encrypt)
+			scatterwalk_map_and_copy(req->iv, req->src,
+					req->cryptlen - ivsize,
+					ivsize, 0);
+
+		sg_init_one(&iv_sg, iv, ivsize);
+		sgs[num_out++] = &iv_sg;
+	}
 
 	/* Source data */
 	for (sg = req->src; src_nents; sg = sg_next(sg), src_nents--)
@@ -542,11 +546,13 @@ static void virtio_crypto_skcipher_finalize_req(
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 
-	if (vc_sym_req->encrypt)
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 req->cryptlen - ivsize,
-					 ivsize, 0);
-	memzero_explicit(vc_sym_req->iv, ivsize);
+	if (ivsize) {
+		if (vc_sym_req->encrypt)
+			scatterwalk_map_and_copy(req->iv, req->dst,
+					req->cryptlen - ivsize,
+					ivsize, 0);
+		memzero_explicit(vc_sym_req->iv, ivsize);
+	}
 	virtcrypto_clear_request(&vc_sym_req->base);
 
 	crypto_finalize_skcipher_request(vc_sym_req->base.dataq->engine,
-- 
2.39.3

