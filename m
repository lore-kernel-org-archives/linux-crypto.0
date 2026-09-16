Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDA63D75C7;
	Wed, 16 Sep 2026 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789550782; cv=none; b=UU7pR8lA14hse6ZIviaDXVwuRA9STDboNUCtzq6LMoC0wGsxWraGs8dq/QmEsFgWuURgbZgW/egzXx5Xo/4GEt6nPzTPR8SlKCTyeNwv4MkL+J2OjOWSNTggc1/QPyyq3NrmaPyxGo9CM2QMKZnif0q4BngZKg7o/LoCaQR2QJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789550782; c=relaxed/simple;
	bh=jIpzuMcqCIYamBi5LXfs6jJ2WngZrWskV0CEuytkRpY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mLlIfK04VvTHTlbLQI3FrCsOM+o6LeY7i2JeUlXH2ntZTwYC9FjLYcmoH9IWLtV+YXA2xA7HJBot/RpOIvlKs6peWRL0E87i6zMarjj+7js9KomV7Fl1csG76B3ytm3ZTm98blfBcH6rLTYSPPxlEgV37CgaNVbQBaLRQpTttR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowABnbDqjYKpqxU3gBw--.41694S2;
	Wed, 16 Sep 2026 17:25:55 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: ayush.sawal@chelsio.com
Cc: davem@davemloft.net,
	harsh@chelsio.com,
	herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chelsio - Fix wrcount leak in chcr_aes_encrypt()
Date: Wed, 16 Sep 2026 09:25:27 +0000
Message-Id: <20260916092527.2002187-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnbDqjYKpqxU3gBw--.41694S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1rCFWDWw47XFWUAF1rCrg_yoW8Xr43pF
	s8CFZ5C3s5Jw43Ga4ktw4rWa43ZwsxZrWSkrW0yw4UAwnxtrWfZ39xXFWjvr1fJF1rJayD
	W3909w15ua4DXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRUMA2qqP4eNbAAAsK

chcr_aes_encrypt() increments the device inflight count with
chcr_inc_wrcount() before building the work request, but when
process_cipher() fails or returns no skb the request is simply
abandoned with the inflight count still elevated. The count is only
dropped on the queue-full error path and by the completion handlers,
so every failed request permanently skews the count and eventually
blocks the device from being detached, with the detach worker warning
"CHCR:request Still Pending".

Jump to the existing error label that calls chcr_dec_wrcount() so the
inflight count is dropped when the request fails.

Fixes: fef4912b66d6 ("crypto: chelsio - Handle PCI shutdown event")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6dec42282768..eece1ac1085a 100644
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
-- 
2.34.1

