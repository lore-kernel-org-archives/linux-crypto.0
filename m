Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E147010A23;
	Sun, 26 May 2024 09:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716520; cv=none; b=OOJB/Bp1nps5XWbxNQ2VIaG9yfD+vOpMY0WrD/wU/ogOntvBqbjAUEBkHhAwnoUA+MadgFJ6O8hkRqIMXFoqcrc/QBOBAoMPtApoWBbSpK14FdKlylvRQb/VjH28S3nmEdX5qfE+H4Pa0ll9S49GX+sQCUCvlhpkuEys5Q5moYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716520; c=relaxed/simple;
	bh=ZtjOS50WdSyaQkBhwL4AWHQi75qeu4G9PoCiaP63duA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqA7JKKn5ESvN+4v2HLvYazMn0htadrV7CrDGNRtlQ12eCFMfbduT9RpqFUpWuVxZY75ctqsjAHt+we+USKO/VJZ0eHVZqshuoBiOZSWOP8LIw+TlY2XDgKPBpBMe6r6WnaQRFCmfLYwJQbsaeHDPYZwQhh559VGDH0U9XMx2tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjk/gF7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjk/gF7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA26C32782;
	Sun, 26 May 2024 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716519;
	bh=ZtjOS50WdSyaQkBhwL4AWHQi75qeu4G9PoCiaP63duA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjk/gF7aA1oZIZNvUVwdJVXpQ1pS+Q2/FavOls49suVTO4rteioalurQtXGwppMCZ
	 dgSsrwC5ozYqDzA4WKBjN6dvGESATgocnm9CtlfQfrVRGtWqP9QbwMQCLf/1MTv8Br
	 99rCIjj8MQZzdnTio+f0B30v5m1+lAkHmOwNLHMfMTwDOALonUsd9rBUc8U86bP1F/
	 xSP7Jw58ai0SZaI5yuquoJ0oKT9Zte1vJ+ZLYFAe235D5uS0AXkmhPP5Tl8z9Xmv+F
	 GB2mcFOpLxvh/hQ3/3Z+vmDiULP/sJOlcbkHn/ezfo9/n0OWx8kM7hz6/+QAmaEhTa
	 dPeeIJRrV4Tww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.9 04/15] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Sun, 26 May 2024 05:41:36 -0400
Message-ID: <20240526094152.3412316-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094152.3412316-1-sashal@kernel.org>
References: <20240526094152.3412316-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.9.1
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
index 93a972fcbf638..0558f98e221f6 100644
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
 
 static int sec_alloc_qp_ctx_resource(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
-- 
2.43.0

