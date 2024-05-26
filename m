Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CD83BB35;
	Sun, 26 May 2024 09:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716551; cv=none; b=PhJ5/lOIqw49cNZWZXh5ocPnIwTwtRav4YMEhIMkRQfRpUWlsVqd8JED9RFyzeG4bqe1ASg1LuA6HkgJp6HJYR4DaGoygHwo7VYqVWhGmivvzCnEr3eGpHNmH8UFGUBQjbL1xrmS0N/OdX44FSpV03HKy8HD7Ll/inqP5J0akLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716551; c=relaxed/simple;
	bh=CARH9QD4Shr4QKW/mg1mUaEsiZl0KH/6qP+qV03U+Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATCxIyWPOvcVCcm5WUAxdCwJy40XSYsio85/jKMrwgCRyXx90ikx1tyX9I/QEvaxWjRWDndOj04vRU7RWvytKnksbUohMo3YzTUQ+rTrtmQnBTiBhOhbwKxTJB80CJsMLlJuoXww4pDJTwU+xgtg1uhhh/NZldFMQ6zbOJuuDzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oz5D6o44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oz5D6o44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E7AC2BD10;
	Sun, 26 May 2024 09:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716551;
	bh=CARH9QD4Shr4QKW/mg1mUaEsiZl0KH/6qP+qV03U+Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oz5D6o443DxZzFV20lbZWDNbYIyV9KwSDHLk9qogxyrT/O9+Vaf2kpDhthYwroY3o
	 p072uvBUWVoDdudcE3q1iclsyI3FoU/bts/T/fECVGn63RnYBwmV1z24kPWW68O5Uj
	 FS9180obmLfrfjyVrLlq78C/aY9KwNyPhuO3HWvSA9FfAFTCYUF9efhOepKHnHbIfC
	 mahWoKfEFSZ56Ihfixcv49citu/iKUcH7hRGs0WkokIDneIeWr5pIzjjtIydIdv4Og
	 9msWBmMKNPSy2AIZtIN4Zm4H/uBc2dEjgEONCQHYy7kpfsKJ+0eROS+pQ7xAcAwGhh
	 HtzVWYP/lK29Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 04/14] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Sun, 26 May 2024 05:42:09 -0400
Message-ID: <20240526094224.3412675-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094224.3412675-1-sashal@kernel.org>
References: <20240526094224.3412675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.10
Content-Transfer-Encoding: 8bit

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit bba4250757b4ae1680fea435a358d8093f254094 ]

The AIV is one of the SEC resources. When releasing resources,
it need to release the AIV resources at the same time.
Otherwise, memory leakage occurs.

The aiv resource release is added to the sec resource release
function.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f028dcfd0ead7..fcbeddf22dd2b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -481,8 +481,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
 	if (ctx->pbuf_supported)
 		sec_free_pbuf_resource(dev, qp_ctx->res);
-	if (ctx->alg_type == SEC_AEAD)
+	if (ctx->alg_type == SEC_AEAD) {
 		sec_free_mac_resource(dev, qp_ctx->res);
+		sec_free_aiv_resource(dev, qp_ctx->res);
+	}
 }
 
 static int sec_alloc_qp_ctx_resource(struct hisi_qm *qm, struct sec_ctx *ctx,
-- 
2.43.0

