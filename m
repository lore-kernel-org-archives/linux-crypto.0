Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FDD12B16E;
	Sun, 26 May 2024 09:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716597; cv=none; b=UKFhDjvfqS2seFZYXN4HYUBHWQYDOJG0+DqrS4J4Y7tFZTDZPBIvo/1yWKZGgR0KgpTA5mpxo+odoge55QHUtbsfS5fzXmAc3NGg44mbqwEsaoTSEh/4cljiZBtPAo5pIhBUmDpw20YSQozznLlS8UA8CjBQY0jgwNwcDl+P9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716597; c=relaxed/simple;
	bh=443F2jSE0vrXN8xyNxHoCniKY6aBQ1K2/yfHa/B7lHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naBL3QlZNMWmF28psaKf3uIJSViXDza6wQjijSL1Rc1O7ZQZ9kxZ9nDqUJHnVR56hXVmpVYmMYg/JqEZRo9iXam10sUHZY1cwIR8Ftbb3uX+j53QiA6Gs+1B2RGWeeGBdIcuJl4HcTogdDs2UJAQqzGZAkpzgOxVirz+aWntViI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8qvzetL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8qvzetL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD072C4AF08;
	Sun, 26 May 2024 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716597;
	bh=443F2jSE0vrXN8xyNxHoCniKY6aBQ1K2/yfHa/B7lHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8qvzetLUvBwHdtTnelrx8BXe1Bu8LjQPossBnXQxWjtHgVhoHBb9QOf4sJUUQqbN
	 WVlCXTOJm1+TRAalr8yMolJXIkoR4yagDuRmwMuYLT1XQrZ/trLJ1bncVGJnTq/UqM
	 W5TzZZ+vkvwAVTS/3W/nO/W8v//a+ej+dhxcvtjB8br5ujm8nOC99nRRt63hNhnrX8
	 UmXsJldv48srwqm45euoUpPpUbSK4SNDMItpolMcPJ1um66VLjcRpq3L5ooUYI/puR
	 IXbLoTWFXzt5Kluz/nBQfl6Q3m/GrSU2jyrn9uX3MOgr021JZQGMUIszhtUuE4L5l8
	 Bh3twwj1d3BYg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 3/9] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Sun, 26 May 2024 05:43:04 -0400
Message-ID: <20240526094312.3413460-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094312.3413460-1-sashal@kernel.org>
References: <20240526094312.3413460-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.91
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
index cae7c414bdaf4..09a20307d01e3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -479,8 +479,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
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

