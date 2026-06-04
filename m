Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71553E16BB;
	Thu,  4 Jun 2026 10:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780568012; cv=none; b=fyuXYrAaVfdbjiw256VuqoZyU1p/inx2KJr7DVcoUlQVuv/Nc6Gw5zGLLeRCB3ZE6Dl2u/w1/qG6+Qj5lN4M2nCIql6d5a0xhHMj8pO8oEkxEAUPn5lLNtJUMtmGL1ls+La5sQhWUGIOMwXKpnvtcPlWtXR15qWInttZj48gMcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780568012; c=relaxed/simple;
	bh=nPNQ2sAPq2ghmqs0jfo3Ocdx95WLwFjostqaD17chIA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hahksfAjkJj9ic/9bZJGohtw5SPhzbLpBjlsN3xxdYujEd1vJLtRTyAfleccYzul+oiykZ5O/tqVJgkCAchzKzdPtOlIeZkm8wCbHBfypjb88P3XaW9s/6XZ9hhGkI594VRNMlZBCS9vv4PJD0p1pk+215P/yaCCeBB2UD06+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAA32tK_TyFqOzyXAA--.11953S2;
	Thu, 04 Jun 2026 18:13:19 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: ayush.sawal@chelsio.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: chelsio: fix refcount leaks in ahash request functions
Date: Thu,  4 Jun 2026 10:13:08 +0000
Message-Id: <20260604101308.3785365-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAA32tK_TyFqOzyXAA--.11953S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF4xAF15AryrWw1DWryDKFg_yoW8Wr15pF
	Z5urWak3s5Jw13KFZ7tws5WFy3A39xur43KrW8t3ykZwnxtrWxA3ykuF1jvF18JFZ5GrW2
	qwsrZa1fC3WUXaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOMKuUU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwkIA2ohQXAwMwAAs8

When chcr_send_wr() fails in chcr_ahash_finup(), chcr_ahash_final(),
chcr_ahash_update(), or chcr_ahash_digest(), the function still returns
-EINPROGRESS to the crypto layer, claiming the request has been
submitted.  No completion callback will be triggered because the work
request was not actually handed over to the hardware, so the
dev->inflight refcount that was incremented by chcr_inc_wrcount() is
never decremented.  This permanently prevents device detach and leads
to a resource leak.

Check the return value of chcr_send_wr() and jump to the error unmap
path on failure so that the refcount is properly undone before
returning an error.

Cc: stable@vger.kernel.org
Fixes: 324429d74127 ("chcr: Support for Chelsio's Crypto Hardware")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/crypto/chelsio/chcr_algo.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 14a708defcd4..142eccaf82fe 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1877,7 +1877,10 @@ static int chcr_ahash_finup(struct ahash_request *req)
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
-- 
2.34.1

