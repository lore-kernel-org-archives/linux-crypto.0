Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDCD3BD643;
	Wed, 16 Sep 2026 09:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789550682; cv=none; b=nYSYKbjbtx7s8umUJv/9GtJzjJUbxGEBKNX6CR3PkHbpnEPvqhngzxU+qRAdV5hNnTtSkQMA0JJeFs5ZV2tRNAhP0wy4q3LpfBuvTOiR3jprUl+jweLhRx3Xh98DaEOpgAigHeVzad0PmS/akj1V4UtPPAF7CSFutM6SXZR6o8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789550682; c=relaxed/simple;
	bh=gmaeNHOa3Ufzwu9kVF1ULpfDmFBmcFRQa4tda3rqkJA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JuvsBrC3iWcv2BMgW97Jc2qAnLB+yClccUuVhFxJ58Xu/P6goNjhsMYUGsy6N+tfPaYD4K+t+0fDvS/9HTZHc7XSNu94nbG9CbfLkeej6/vMGpK9S7bZ+2vfxsW0kaOh/MbeHnqYiJ2mX+iu5wLjC6zisUGVOnOFhTYmOiKP33U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowACXoT9LYKpqOUngBw--.16269S2;
	Wed, 16 Sep 2026 17:24:27 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: ayush.sawal@chelsio.com
Cc: davem@davemloft.net,
	harsh@chelsio.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chelsio - Fix wrcount leak in chcr_aes_decrypt()
Date: Wed, 16 Sep 2026 09:23:59 +0000
Message-Id: <20260916092359.2001753-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACXoT9LYKpqOUngBw--.16269S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1rCFyrJFWUuw18JFW3Awb_yoW8CFy5pF
	s8CFZayr95Jr1xGF95tw4kWa43C39rCFWSkr4rtw1UZrs8trWfJ3y2vFyYvF1rJF4kJ34U
	WrWqka45u3WDXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
	JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUb
	khL5UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgAMA2qqPpSSvwAAsO

chcr_aes_decrypt() increments the device inflight count with
chcr_inc_wrcount() before building the work request, but it returns
early without dropping the count when the tx queue is full or when
process_cipher() fails and returns no skb. The count is only dropped
by the completion handlers, so every failed request permanently skews
the count and eventually blocks the device from being detached, with
the detach worker warning "CHCR:request Still Pending".

Add an error label that calls chcr_dec_wrcount(), mirroring
chcr_aes_encrypt(), and jump to it on the failure paths.

Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index eece1ac1085a..6fd25c54aa1e 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1396,17 +1396,22 @@ static int chcr_aes_decrypt(struct skcipher_request *req)
 		return -ENXIO;
 
 	if (unlikely(cxgb4_is_crypto_q_full(u_ctx->lldi.ports[0],
-						reqctx->txqidx) &&
-		(!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))))
-			return -ENOSPC;
+					    reqctx->txqidx) &&
+	    (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
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

