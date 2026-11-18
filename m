Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794988618;
	b=VD4OAqEKgpUKrW6L46UfzU73iXisTdiGZPHd/Nw4QV47dgjR121Ca+1HmeXGCZne3My8
	 6wWp2kmDmftfkN5TBkvw270ENuyVL4g+yTuZmckfu4FlCcbgz7IE5etInrKy2fyKchqr8
	 xsRD11D+2HBcr+6bdL6zZBiWt0vku4HvzX0k2tRklaPnpe4JGC2T7IZnYTg8AY5RFG5+Q
	 ENZAMgP5rVRWIuaHP17HJiuGA+Y7EkgQUGhan74TtZGp+KiwbIvGu2vbg9mqAnG4SnuI6
	 NT5DFFAlaH4TFgT0COQKUF4OUQaKgrUz7OCcY+wVT+GvdkBFVRjfNPTjQ8DcAzYHEZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794988618;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-Originating-IP:X-CM-SenderInfo;
	bh=rm6FPL/hIEQA9bxW60D0xmRsXN6O2gQIc+olwmiqFTY=;
	b=uEmJEgNrU8gru93tBj4DHfFFU/IZbz2PibdbYLNfJSD4ZvpWqf9UpycVbu6ezJVYHJRj
	 Cw2G3+ReXFgcVnGCJfmpD9dSWYXg7Z6gbu3+1aMJ56i5nnVa1Dqd/Iabpd2oOVGhzmMDR
	 mOWg1fjid1h59L5Ypy2YvCBT0mNnnfU9OOkefmo8owrabpqkwLyseK6+qjhdY0TEh+UqR
	 S7t5gHVWROmXSba3DwFHZQSLZ0N5pSNMoBMTIceb9Yf10LwRLFiMzXgdXSY8yYbs4vbgo
	 9L60NTLtKUQsDBdmsOyKoKQEgLFq8XQUk8DHams2FtRymHQFAnO8wdZij1FpOs5Aa+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VOLOvUZU;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27751606A31C;
	Wed, 18 Nov 2026 07:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27751606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VOLOvUZU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rm
	6FPL/hIEQA9bxW60D0xmRsXN6O2gQIc+olwmiqFTY=; b=VOLOvUZUXAYxImkjXf
	02F06e6y9+Fql1gUFz1GRx057KTuXZQvH/WCYqISUnbdfzXe4ujWe5nOVawqhoWq
	4FBPgcJPSZxFEnry4l2F4f28ihFyUqK5buYoQFU/8/jIUbUpx0YEnpUrUyIRg+WF
	NI5RX2JBBM4/SSX6WvDXxoW/0=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3P6M1Wv1qx8alGg--.56103S3;
	Wed, 18 Nov 2026 15:56:40 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: schalla@marvell.com,
	bbhushan2@marvell.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH 1/3] crypto: marvell/cesa - Fix DMA cache leaks on hash setup errors
Date: Wed, 18 Nov 2026 15:56:34 +0800
Message-Id: <20261118075636.2152451-2-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118075636.2152451-1-haoxiang_li2024@163.com>
References: <20261118075636.2152451-1-haoxiang_li2024@163.com>
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
X-CM-TRANSID:PygvCgD3P6M1Wv1qx8alGg--.56103S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7KrWkXw1DAF4xJF43CFyUZFb_yoW8Gry8pa
	yUAayjkryFva47KrWUXan5XF18Z3s0va43KrWrA345Z3sxuw1IvFZrCFyxZF1UJFWrAa1x
	tanrAw15Xrn8u3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pKYLyiUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbC7hi+LWr9Wji7IQAA3K

The hash DMA initialization error path frees TDMA descriptors and unmaps
the source scatterlist, but leaves the DMA cache allocated.

Use the full DMA cleanup helper on this path. Clear the cache pointer
after freeing it to prevent stale-pointer reuse on subsequent requests.

Fixes: 7850c91b175d ("crypto: marvell/cesa - fix memory leak")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/crypto/marvell/cesa/hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 2f203042d9bd..35f5937b2f8b 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -65,6 +65,7 @@ mv_cesa_ahash_dma_free_cache(struct mv_cesa_ahash_dma_req *req)
 
 	dma_pool_free(cesa_dev->dma->cache_pool, req->cache,
 		      req->cache_dma);
+	req->cache = NULL;
 }
 
 static int mv_cesa_ahash_dma_alloc_padding(struct mv_cesa_ahash_dma_req *req,
@@ -747,8 +748,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	return 0;
 
 err_free_tdma:
-	mv_cesa_dma_cleanup(basereq);
-	dma_unmap_sg(cesa_dev->dev, req->src, creq->src_nents, DMA_TO_DEVICE);
+	mv_cesa_ahash_dma_cleanup(req);
 
 err:
 	mv_cesa_ahash_last_cleanup(req);
-- 
2.25.1

