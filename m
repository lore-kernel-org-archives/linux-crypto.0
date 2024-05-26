Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E212FF7E;
	Sun, 26 May 2024 09:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716716613; cv=none; b=mWBjQh1812zAJuHJOMJms6oN4XIyyjD/hpejAC4AJhd6U5UdQpZkZC4gqRORZr+iKdIkL1SHAcsUrZ8gFqZpax2viHhWFxZFZOvb7Pu+JGAaoqzUDYVKAQC5Gh9rNDOqT5QyHmfeARSH0jErlWhqllabSpaJjO9nBZaVNKkFSu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716716613; c=relaxed/simple;
	bh=S/Uk1MIsHpVBY9QhFMzIN71MMMG9mkwXuilRviiEQsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRucj3pdr+gUGJ+zXhqa6C+P6toR5Z1nVydNXEreV7QUy/4AAW4RrEusxoJEQIWMe5uz5aUoBnScT0AIZL9R8PMrTdrDs4OeE23Y/hQA8kbLDWgPodCs4WlGaEJZ/gB7OytXJgww0pXIYx1MqUTWk8M+UQkhuMfKBAbmnvfi+Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rN577W/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rN577W/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C46C32781;
	Sun, 26 May 2024 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716716612;
	bh=S/Uk1MIsHpVBY9QhFMzIN71MMMG9mkwXuilRviiEQsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rN577W/HMvT2/+j4cpzWLnHV0VaTPgVGiXdXpo4Sty156otjcfwwSd6orJr42WGTE
	 VY4OsXwIwC6s4aD4vQ3TBYVfCVQGN2WTDTwoOf/k2fY1ICIQKWS7afmPsU54VgMixm
	 xEn8akNmpNPIYQdeY7qo5bL7ZEOBtZ+qSebqqgqWdzldxpttAF6aWSw//vmY8rC2Vg
	 sh1LajvYkofQDSa0KXHGyTW0b8xdZc9IIyS0rp1a8NY4WfJ6wy0ZufQseBENsYWF2n
	 tyJjSNThPQ/gGnnjpheBUUorZsM46/MmzTV05W6QQTcFTym/7QwSDFcxwC+xazGDPB
	 AEObu+Oy3L2FA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	liulongfang@huawei.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/7] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Sun, 26 May 2024 05:43:22 -0400
Message-ID: <20240526094329.3413652-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240526094329.3413652-1-sashal@kernel.org>
References: <20240526094329.3413652-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.159
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
index 0d26eda36a526..28c167e1be426 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -463,8 +463,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
 	if (ctx->pbuf_supported)
 		sec_free_pbuf_resource(dev, qp_ctx->res);
-	if (ctx->alg_type == SEC_AEAD)
+	if (ctx->alg_type == SEC_AEAD) {
 		sec_free_mac_resource(dev, qp_ctx->res);
+		sec_free_aiv_resource(dev, qp_ctx->res);
+	}
 }
 
 static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
-- 
2.43.0

