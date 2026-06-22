Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94330244675;
	Mon, 22 Jun 2026 15:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782141564; cv=none; b=IISZMAFZdLt/7UbF68SZANnmo06GUJz4983jdVxpOhJfhkQsmLyVaq7PTbiEWsCzlhdE0qC5jLiGB+U9NnKkueQjs/4shbKqpA2A/g4Rf/8WXNezeRTf6p1q21XvvxSDUI9A5BT5LotN9hjDG+UfOiZJHOMNz5vbf0dckqpBDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782141564; c=relaxed/simple;
	bh=iBwmvKevVolFhLql59YnzV3ie1X7obFkzvuuRhqWefs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I7RpQlK4ZhGCEQjJAGhlDFqF8VBXz4Fl0bMUWViBDv21YGBhev8XnhxG1A6xFuVCf3o0UvkvTytdBjE9vPRdeMWdzIbvr8ALXOAm7LXYUlAEPOYNk3bPU2QnOPGN7mpZqhZYZZ0yrqf0cjMpLRUsFDSJou5T0Cv2GDxliZYtFEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.74.238])
	by APP-01 (Coremail) with SMTP id qwCowACXO9RwUjlqCILBAg--.27065S2;
	Mon, 22 Jun 2026 23:19:14 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] Fix multiple issues in chcr driver:
Date: Mon, 22 Jun 2026 23:19:10 +0800
Message-Id: <20260622151910.49402-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXO9RwUjlqCILBAg--.27065S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1xKFWDJw1rury8Ww15Arb_yoW5uF1rpF
	s8CFZayryrJr17GF92yws5Wa43A3y3uF43CrWFya40vwsYqrykXaykZF1jvF1fGFWrG3yU
	ZwsrXa1fCa4UG37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjJ73PUUUU
	U==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQ4GA2o5I0xylAABsZ

1. In chcr_ahash_final() and chcr_ahash_digest(), chcr_send_wr()
   return value is not checked. If it fails, DMA buffers are not
   unmapped, causing leaks.

2. In chcr_aead_op(), the inflight counter is not decremented when
   assoclen validation fails.

Fix by:
- Adding error handling for chcr_send_wr() with goto unmap
- Adding chcr_dec_wrcount() on the assoclen error path

Fix the following functions with missing decrement on error paths:
- chcr_aes_encrypt()
- chcr_aes_decrypt()
- chcr_aead_op()

For chcr_aes_encrypt() and chcr_aes_decrypt(), use a common error
label to decrement the counter. For chcr_aead_op(), use the existing
chcr_dec_wrcount() helper on the invalid assoclen error path.

Cc: stable@vger.kernel.org
Fixes: b8fd1f4170e7 ("crypto: chcr - Add ctr mode and process large sg entries for cipher")
Fixes: d91a3159e8d9 ("Crypto/chcr: fix gcm-aes and rfc4106-gcm failed tests")
Fixes: 324429d74127 ("chcr: Support for Chelsio's Crypto Hardware")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6dec42282768..e431e8c1fdbd 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1359,7 +1359,7 @@ static int chcr_aes_encrypt(struct skcipher_request *req)
 	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
 			     &skb, CHCR_ENCRYPT_OP);
 	if (err || !skb)
-		return  err;
+		goto error;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
 	chcr_send_wr(skb);
@@ -1402,11 +1402,15 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
 	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
 			     &skb, CHCR_DECRYPT_OP);
 	if (err || !skb)
-		return err;
+		goto error;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
 	chcr_send_wr(skb);
 	return -EINPROGRESS;
+
+error:
+	chcr_dec_wrcount(dev);
+	return err;
 }
 static int chcr_device_init(struct chcr_context *ctx)
 {
@@ -1877,7 +1881,10 @@ static int chcr_ahash_finup(struct ahash_request *req)
 	req_ctx->hctx_wr.processed += params.sg_len;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, req_ctx->txqidx);
-	chcr_send_wr(skb);
+	if (chcr_send_wr(skb)) {
+		error = -EIO;
+		goto unmap;
+	}
 	return -EINPROGRESS;
 unmap:
 	chcr_hash_dma_unmap(&u_ctx->lldi.pdev->dev, req);
@@ -1978,7 +1985,10 @@ static int chcr_ahash_digest(struct ahash_request *req)
 	req_ctx->hctx_wr.processed += params.sg_len;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, req_ctx->txqidx);
-	chcr_send_wr(skb);
+	if (chcr_send_wr(skb)) {
+		error = -EIO;
+		goto unmap;
+	}
 	return -EINPROGRESS;
 unmap:
 	chcr_hash_dma_unmap(&u_ctx->lldi.pdev->dev, req);
@@ -3636,6 +3646,7 @@ static int chcr_aead_op(struct aead_request *req,
 	    crypto_ipsec_check_assoclen(req->assoclen) != 0) {
 		pr_err("RFC4106: Invalid value of assoclen %d\n",
 		       req->assoclen);
+		chcr_dec_wrcount(cdev);
 		return -EINVAL;
 	}
 
-- 
2.39.5 (Apple Git-154)

