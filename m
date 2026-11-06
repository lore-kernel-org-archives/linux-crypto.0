Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950696;
	b=ufxvK/j6AEx84ukFQ4WgClEGPLo648hFh0IkR7rVWTPa+PyX/G2wPX+xqb1igUp1IBey
	 L3z3ZP1tsS9kt/RpWriDsMg8TTd0CXHz52nubLL6dUtJOm/BF7JECj9xadKrOl9TmorZQ
	 gCdNhMx6B07ZlKQ0lJt4eyjdnV5DQn8yFQOZ17v5oqN/K42IQOH5qo80s/bZkTj3kHGln
	 NFdd3JUME8IH9vvkc20bJeyjD4G03azLR7+tmBDfok29YUXRAYGz4o2TaKw3urcoxqvcs
	 scx4cWK4N9EIFMryQ56j2/gn/8Qmtr5fdnSSIzLF2HkRulnrLt0/zx+DZAlpWOubL+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950696;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=nup/d5xUjvEo1vx4q2sZoM+/UF0zitralJNNC5zemuA=;
	b=Urc1ZzL/tjdEiY7poPDNea+LFPPkzD/eGYaCIYpQaxgTGyW0cDUVFvGLWngwvHtu8IDR
	 yTOaZPTMwZWWxgTb9XMHh1TSedSK1gryQaswXBbLlcAAE1Gn6Ql8del9rUVEHq4Fz8q7D
	 /kJINvtXMVROzBSapRWYe9eiy/vycPpI2H7WjVxNmGxoQSFzeonWTKIwvLgOsZKR2zDcP
	 S6tTCoWl8Wq/tLM4tgriSVeGqAUdAu3vFaCPv9t3lY31EZUnTENl0ML8UqK/SJyfo/lKt
	 i7MNTSfLH5tNadbbWPiLXM+cTE7sXDK7t1WLojiENlrL1LcfWh5j+aYc0rthX04YKfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59953606A326;
	Fri,  6 Nov 2026 07:38:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59953606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn9Zbdg+1qc_JpAA--.4027S2;
	Fri, 06 Nov 2026 15:38:05 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: ayush.sawal@chelsio.com,
	harsh@chelsio.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH v2] crypto: chelsio - Fix wrcount leak in AES encrypt and decrypt
Date: Fri, 06 Nov 2026 07:38:14 -0000
Message-Id: <179395069486.2116632.4190811765560584696@iscas.ac.cn>
In-Reply-To: <arNk6ujyrvTsFBfS@gondor.apana.org.au>
References: <20260916092359.2001753-1-vulab@iscas.ac.cn>
	<arNk6ujyrvTsFBfS@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowADn9Zbdg+1qc_JpAA--.4027S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWxXFy5Ww1xtryxJrykGrg_yoW5Xw13pF
	s8CFZayr95Jry7GF97Jw4rWFy3uw43Cr13Kr4rt3W8uws8t3yxJ39rZF1YvF1UJF4kJ34U
	X3yq9a4rZa4DZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvS1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVWxJr0_GcWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
	wIxGrwCF04k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI
	8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
	xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
	8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280
	aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43
	ZEXa7VU1pnQUUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAADA2rtTzW++AAAs3

chcr_aes_encrypt() and chcr_aes_decrypt() increment the device inflight
count with chcr_inc_wrcount() before building the work request, but both
can return early without dropping the count.

chcr_aes_encrypt() leaks the count when process_cipher() fails or
returns no skb. chcr_aes_decrypt() leaks it when the tx queue is full or
when process_cipher() fails and returns no skb. No completion can
balance those increments, so every failed request permanently skews the
count and eventually blocks the device from being detached, with the
detach worker warning "CHCR:request Still Pending".

chcr_aes_encrypt() already has an error label that calls
chcr_dec_wrcount(), so jump to it on the remaining failure path. Add the
same label to chcr_aes_decrypt() and jump to it from both of its failure
paths, mirroring the encrypt side.

Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
Changes in v2:
- Fix chcr_aes_encrypt() and chcr_aes_decrypt() in a single patch, as
  requested. Sorry for the late reply.
- Link to v1: https://lore.kernel.org/all/20260916092527.2002187-1-vulab@iscas.ac.cn/
  https://lore.kernel.org/all/20260916092359.2001753-1-vulab@iscas.ac.cn/
---
 drivers/crypto/chelsio/chcr_algo.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e2f2b2a6200e..9ce9eefef777 100644
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
@@ -1397,16 +1397,21 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
 
 	if (unlikely(cxgb4_is_crypto_q_full(u_ctx->lldi.ports[0],
 						reqctx->txqidx) &&
-		(!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))))
-			return -ENOSPC;
+		(!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
+		err = -ENOSPC;
+		goto error;
+	}
 	err = process_cipher(req, u_ctx->lldi.rxq_ids[reqctx->rxqidx],
 			     &skb, CHCR_DECRYPT_OP);
 	if (err || !skb)
-		return err;
+		goto error;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, reqctx->txqidx);
 	chcr_send_wr(skb);
 	return -EINPROGRESS;
+error:
+	chcr_dec_wrcount(dev);
+	return err;
 }
 static int chcr_device_init(struct chcr_context *ctx)
 {
-- 
2.34.1

