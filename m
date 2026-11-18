Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794982798;
	b=o5C+K3yGGxZzTyFMa5CigcaUlIf0GnzbySmEO7+CRibBPeD0Zt8PlOZ0KiCjNZK7uhIB
	 +JuPI1xippqEKjda3s4fycIGTygnbMzXpa/3/MdNftsA1MojTZwLKMmW3rXssndhadBUb
	 /kEVJ/j6Z0W3bFTMyXXjdHG+s3H81mBvOndc/Sg6j4P6LbKAeDOBc1DR8iBbYELW2TmsS
	 QUK57Tqj5WX8L8KDSOE4+bCEnMiSscaUaIj4fMdjnxasS3/et9se2EYCaMD3USWoeA/xb
	 aLjmWouVa/oePTLHxNzydaOdunZ2csozRiWrCPILHd613zAmuajvM26U5tImKU41aBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794982798;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=fBCtu+B/sWo1gZIbTF0XJGnZKSw57JNjaYAfSyLzEs0=;
	b=3yvm4VAPBqTFvHDRS3FNMM5EnOPGMcsNuLoimF5uLRHDcABbRT+LgVMd+hjJtkzJYx5/
	 K7T2qWfMSQ0S6X+IuMFcYzLVcKQGH+gc9KvMbBDdPTWiKTXIZXCOiQ7PzuiFyFLp/n7G/
	 uWGjp1NFvVzfcra9rmEMuOphqUDAxusrGokJiIP2DIq5yIPz+nThSN/LApUTYEVozNx8y
	 souEYCkaQiGZAG4nOhXwn8VyF9Ymdnh6EonYU2G2lIm0ACkWqyQQk8N0BGGyTCbOZQMjA
	 s/9PkbqcwBYBg8t4jy/9v0aRAXA+7GfaJ9C5+nXwf0PQUYHgMyXkFTZtNsayY9+JNOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="BLz+/H+D";
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCE9606A32C;
	Wed, 18 Nov 2026 06:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBCE9606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=BLz+/H+D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fB
	Ctu+B/sWo1gZIbTF0XJGnZKSw57JNjaYAfSyLzEs0=; b=BLz+/H+DSLiqqoe5xB
	uiaLl67amugdkN/kgsOHURn72bLdT6CZauho7f2XgNHZsY2ampUShKOV7dTMfzsy
	HlmzYXdE5rCCYFA1DFyW13cMab5K/j1/VvbKODyyp8Vpx21EzSQJ5SUySSMDbVPT
	e+XVrKnK5e/c0YLC+3sl4XDnE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3fxZnQ_1qoPvHIw--.11338S2;
	Wed, 18 Nov 2026 14:19:20 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	johnpol@2ka.mipt.ru,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH] crypto: hifn_795x - Free walk pages on session setup failure
Date: Wed, 18 Nov 2026 14:19:17 +0800
Message-Id: <20261118061917.2093148-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3fxZnQ_1qoPvHIw--.11338S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJrWfKF18Wr4furWkXFykGrg_yoW8GFyDpF
	4fGrWvk3yUWF12yrW8u3WDZFWkXas3ur4xWrWxK348uanxAFWDWFs3JFyYqFWDGF1xAF4r
	WF4qk34kuF1DuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pir-BtUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7QkFc2r9Q2mAcAAA3f

hifn_setup_session() allocates temporary pages for misaligned destination
buffers. If the scatterlist walk fails or the hardware queue has
insufficient capacity, these pages are not released. Retrying a queued
request reinitializes the walk cache, losing the previous page pointers.
Add a separate cleanup path to release the pages for misaligned requests.

Fixes: f7d0561ea1da ("[CRYPTO] hifn_795x: HIFN 795x driver")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/crypto/hifn_795x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 46bcef044606..73a661085d97 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1539,7 +1539,7 @@ static int hifn_setup_session(struct skcipher_request *req)
 	sg_num = hifn_cipher_walk(req, &rctx->walk);
 	if (sg_num < 0) {
 		err = sg_num;
-		goto err_out_exit;
+		goto err_out_free;
 	}
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -1561,6 +1561,9 @@ static int hifn_setup_session(struct skcipher_request *req)
 
 err_out:
 	spin_unlock_irqrestore(&dev->lock, flags);
+err_out_free:
+	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED)
+		hifn_cipher_walk_exit(&rctx->walk);
 err_out_exit:
 	if (err) {
 		dev_info(&dev->pdev->dev, "iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
-- 
2.25.1

