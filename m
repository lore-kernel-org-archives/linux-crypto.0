Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.243.244.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559680;
	b=Em1RV5ADw+1PgOt7qX9L3Ryq70Dl0oYuxsiO/Jx1clR/L7zznHxjjJwVj3ORYRzs33aO
	 Z+NzrZ2UljOJ+NjvhLxdzQngPQPL06DTFkkCGCqpC7YNUoWQnHFgt5+VmoQOVwZnh75BW
	 qPvKyY+QWAe2xcmt3ksl/nD+u+3o5JeuuQ2h3+lgRgy7Szy3fKguJv4iNVltMeQjOemo3
	 CW0/TqyeCwkyiTSiNw15xP82M8ntLpV5X0Qoh5LkrER73i6lOtYQHIJk/AcsMePURELwB
	 IyNtcwkwyTEhYwq6oj3iba9YSFIdJpLCmVFoMt2XIzdJj6wOXkXZ0nHuZwLIPTtHDZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559680;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=oKU2j8bN1o+Dr7cNQliLRr9DTF+HNjYHfrmyMONRynM=;
	b=r1pImpZKh6Ga1P9gWyvw9ki8ryUoIbcpzmS8IsjSPIEW4tcc5NhVXdJSOIn/G4yJ26Z0
	 rSq7LfI3Knj85JZgbz9dB1bZQfBVTbn/klvpmdWZpR8qzGtJ0U5KN5sUz2s+7mYOrvs76
	 VjLsoi6FrkynbtCZMtkwNvD8J6mW0Mmzow+vKUJDSkfY2OJR8ihkAF3inFE0HFdIZccMY
	 C7U11dbP0q/ZomH6ffoi6twdTEDyh6pFOashXBHGZsnFogHesFf+ePCf8dMgNCXAWK1ad
	 64D8IxoAXLuR/rD+M62zgF+0/WWO4QwkuirI7fV+bvIusb0c/Z8Z4/JTdnJD+Pu95wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=cuF1Ome9;
	arc=none smtp.remote-ip=54.243.244.52
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366B606B363;
	Fri, 13 Nov 2026 08:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1366B606B363
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=cuF1Ome9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794559639;
	bh=oKU2j8bN1o+Dr7cNQliLRr9DTF+HNjYHfrmyMONRynM=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=cuF1Ome9t81fE5dJAWwUZBS0LXZGdGX54pK4EWH/FZLarTlsojx7Y23aHkhjnqdPz
	 flRbLgrHP5WTls9hJ1DRHOg/QEYh3KVm6Hpod12JvuWYiVxuFzFfnZtN7x1L78H+Rp
	 Jq1I555NaJJb00P0q0K3MtG6sDdlmj3SM3/9fy5E=
X-QQ-mid: esmtpgz15t1794559624t5efbcce9
X-QQ-Originating-IP: Do0zNIbIbBLllmWo7Po164zagHd9OJpsc0BMqtAS6xI=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 16:46:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 975368059114725145
EX-QQ-RecipientCnt: 9
From: Jinming Zhao <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 16:46:38 +0800
Subject: [PATCH] crypto: qce - use the mapped scatterlist count for ahash
 requests
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-qce-ahash-dma-count-v1-1-0423b54d75c8@uniontech.com>
X-B4-Tracking: v=1; b=H4sIAG3O9moC/yXMQQ6CQAxA0auQrm1CESF6FcOilOqUhEGnYEwId
 3fU5Vv8v4FrMnW4FBskfZnbHDPoUIAEjndFG7KhKquGiI74FEUO7AGHiVHmNS5Yk9atnM49tQy
 5fCS92ft3vXZ/+9qPKst3Bfv+AQK3qxJ3AAAA
X-Change-ID: 20261113-qce-ahash-dma-count-41e47c59b17a
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Jinming Zhao <zhaojinming@uniontech.com>
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NhUkPfKlCtQwFTwOjOKF1/E/X3z/goMPIr8h3Xdl6xZwpVj8DUDwVgHQ
	9cKHq5M/ttesQck6JfLfqVvM4oN3L6sjpIukwY32RZuIQ5NujbBaG0+zEpZcEa/+mF1Chnv
	XH5SKvxdfKoCeoMMgWTZayIg59uHh6LUuTiEbRCeurGfdbvag6jSObJ0k3brROy8fZ3VnmO
	HX2LqjGT9nsHLa6K89JQ9A49gf2D0DJ327G11TsosMM6nd6txs8rT2nY0+Sz0joFhb7X/aq
	RBgdcwB6ebxt6HQVrHDvSufVl3IIfxvURt2Poh7tchyJuBhjONjBbGUvPDjdbFFILYM/z1Y
	i1AqzqX3ldndS4FO6fWya+LrrETby3j3w1N/4C86wTyr3szQeJ/RRlAKya14bdY/qdaAiG5
	BbAGcOlk4RiMqCd9SCa6rV1RCIH48707ESET4vCX+itbQDiL+zcvWLZ9z9fH3xL2OiVy/7n
	v3ItYbpUYhyIsqzJxrXcbi07nVteUK/k7faf7L6b78nzDTDK0+LRB/5uHUIYYoNoKW80SGI
	p8ofZ/9Wkh+/Jw7ibcViJ7j/3RaZ+iRSZ1fD+ydYGlJ2w4I8GglRjYRbunAyrw6XbPa/I4F
	hIFUvDraXUz5Ei7rzKSro2NWcqmA29PBYbH/fe/DsiPzJv3nE8ZRXP0dthI5xIiwaU0lv0+
	I73wn6wOjFJ7uRi8r+DUlZ/CSYxLBA7pjyg1gBHuij0nUMvJyqGdCDKvQkZ8jZWjmD3gFty
	GMIddM/utSG961eH7KwwyV0NJhwEUs9NwuFBhWiYQEzH8wlywrPit19+SGQ9NNCOy+UBurg
	XrmvI8zm1xIHu2DflrRa0+OTQU7HpvVMeXSeluU4UTtHwpNujPPwQHHFpbZyuYGiSMRvV8L
	/wNuVgl78KLJUTbIKwZBm9DbB51rbDwmuzCfwys2cm9YV/hm9IE6XTZkDoRAMa746rQzK+3
	owOqb6wbzFNNZmx/cLG6EB335eqvgLV3cPJNKVm1TyCD5lk56Eash2uEpI1WxJ/DAxQkyj+
	wnFDPJ8uEy7WY0hPH7fAGOIdJD/vv/tnhkjeBH4D/YtZgnKLkfC5tHQchFpY+qkyNr2aFkC
	A==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

qce_ahash_async_req_handle() maps the source scatterlist with
dma_map_sg(), which returns the number of entries after the DMA mapper
has coalesced them.  The driver keeps that value in ret but immediately
overwrites it with the result of the second dma_map_sg() call for the
result buffer, so qce_dma_prep_sgs() and the later unmaps use
rctx->src_nents, the count from sg_nents_for_len() before mapping.

When the DMA mapper merges entries, the descriptor is prepared with more
entries than were mapped, so the DMA engine may read sg_dma_address and
sg_dma_len from entries that were never populated.  This can lead to
IOMMU faults or memory corruption.  Store the mapped count in
rctx->src_nents so the descriptor and both unmap paths use the count
returned by dma_map_sg().

This issue was found in the Sashiko review of the "crypto: qce - fix CCM
AAD buffer leak and AEAD error-path bugs" series.

Link: https://sashiko.dev/#/patchset/20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com
Fixes: fea40451530fe ("crypto: qce - dma_map_sg can handle chained SG")
Cc: stable@vger.kernel.org
Signed-off-by: Jinming Zhao <zhaojinming@uniontech.com>
---
qce_ahash_async_req_handle() maps the source scatterlist with
dma_map_sg(), which returns the number of entries after the DMA mapper
has coalesced them.  The driver keeps that value in ret but then
overwrites it with the result of the second dma_map_sg() call for the
result buffer, so qce_dma_prep_sgs() and the later unmaps use the
rctx->src_nents value computed before mapping.

When the DMA mapper merges entries, the descriptor is prepared with more
entries than were mapped, so the DMA engine may read sg_dma_address and
sg_dma_len from entries that were never populated, which can lead to
IOMMU faults or memory corruption.  Store the mapped count in
rctx->src_nents so the descriptor and both unmap paths use the count
returned by dma_map_sg().

This issue was found in the Sashiko review of the "crypto: qce - fix CCM
AAD buffer leak and AEAD error-path bugs" series:
https://sashiko.dev/#/patchset/20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0%40uniontech.com
---
 drivers/crypto/qce/sha.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index b67d749db05f..c53d0e53784e 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -97,6 +97,12 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 	if (!ret)
 		return -EIO;
 
+	/*
+	 * dma_map_sg() can coalesce entries, so use the number of mapped
+	 * entries for the descriptor and for the later unmap.
+	 */
+	rctx->src_nents = ret;
+
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
 
 	ret = dma_map_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);

---
base-commit: 7e1392a42ea288d70a266f6553fe06f57f8647ea
change-id: 20261113-qce-ahash-dma-count-41e47c59b17a

Best regards,
--  
Jinming Zhao <zhaojinming@uniontech.com>

