Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66DA27EC89;
	Sat,  3 May 2025 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746303709; cv=none; b=V2UekM922Ne4c1iXMaKlACyMDbqEBHNfoPhLosbUOMutgNGoAdeiY7y4j6Hkqjf56/Itye9r4z6YpIxgVAvqUENPUIcF9lrltGOKVhHTnAXR0kmoU+3EINgSYcmzYKbbL1VOX3xIjLW6qIJsYk0w/VC9CG8ndPLDFaUG0ZhuZyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746303709; c=relaxed/simple;
	bh=k4IQP1/of8aKcmJs9ZmrzxkHhlp//Mb+yyhXIBDdxrA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PrAB6CafgHCLFYHobh0zo0duzvunPjjswHnxzBtMMXQsjI7yicAPYVOuXqpsig3HTiu7kmC4Nv77zECGa6YzkcDmN59oDwpIoFUcEF9btLGiTTRDUZXKyIPGr1e4F/N+xdfCm+FWC2/YPNGBkDEtl8+ds77Bw9jBwnoJbbTPyUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=1whEk+Es; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="1whEk+Es"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4ZqfMP6sBDz9snW;
	Sat,  3 May 2025 22:21:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1746303698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BP62rWp5Omj8xStj22ymmHAwI8JTM0+UjiVITZtvlr8=;
	b=1whEk+Es600K435koQp09RYo6oKFJrSEfnrmcqXAeYM7hK38dGZC44CS9MtIqFNHjotdgO
	3uZhhFyy+RjiO/0fU/vzyyg/EuazsEmYgMpC3HrhIJkPEdHf8IKIV83ZMfu2QnEaNUEB0Q
	jg7qHTqhDS2fWDlchcx/zApoKcE4XNFPNYuEyDfP4TgFmPiuZbqwTJWLb50TKwU2e1UODc
	PdGeE0dMb7D1ttPTfBodoTjfASnLeakmg2kIjvlqtMK5UHR5V+nGTT6I5qzAoK0A0fJxgZ
	jGkPXOCn1OIY7ijA1Um8831L0Vv8esFO9eu0Rz56KQSbc/yHHxP/6Idzsj2jRg==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Date: Sat, 03 May 2025 16:21:28 -0400
Subject: [PATCH 2/2] crypto: hisilicon/qm - replace devm_kzalloc with
 devm_kcalloc
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250503-hisilicon_qm-v1-2-d4ebc242bc8a@ethancedwards.com>
References: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
In-Reply-To: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
To: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, 
 Ethan Carter Edwards <ethan@ethancedwards.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=874;
 i=ethan@ethancedwards.com; h=from:subject:message-id;
 bh=k4IQP1/of8aKcmJs9ZmrzxkHhlp//Mb+yyhXIBDdxrA=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0o0bkp2QXk4ekFKWGJEOXFoNThlVGp6e
 GhQcXlVeFpJaFZIZjhjM0Nrd01XMFpyK2hscCtCN1Q5dDRyOFhkCjNXV1Z6eWIvYThtc2FVVXpU
 K3p0S0dWaEVPTmlrQlZUWlBtZm81ejJVSE9Hd3M2L0xrMHdjMWlaUUlZd2NIRUsKd0VSK0dEUDh
 zemtuTzN0aFVvemRlaTFWZzJzOUdWTTZWemRadUV4cXRKb3hUNXZWNG5yc0FrYUcyeXRVbGhVbw
 pKY3J1LzhDNjlIQzVjSEtmaS84SDFndGxaOTVWTC93N1liNC9Qd0E0MjB3dgo9cFpmVgotLS0tL
 UVORCBQR1AgTUVTU0FHRS0tLS0tCg==
X-Developer-Key: i=ethan@ethancedwards.com; a=openpgp;
 fpr=2E51F61839D1FA947A7300C234C04305D581DBFE

Replace devm_kzalloc that has an internal multiplication with
devm_kcalloc to improve code readability and safety from overflows.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 80d57f0dbf26e2902e01103b0a705234009161ee..7c41f9593d039157ad900ee9fcc00e137d2ec169 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5224,7 +5224,7 @@ static int qm_pre_store_caps(struct hisi_qm *qm)
 	size_t i, size;
 
 	size = ARRAY_SIZE(qm_cap_query_info);
-	qm_cap = devm_kzalloc(&pdev->dev, sizeof(*qm_cap) * size, GFP_KERNEL);
+	qm_cap = devm_kcalloc(&pdev->dev, sizeof(*qm_cap), size, GFP_KERNEL);
 	if (!qm_cap)
 		return -ENOMEM;
 

-- 
2.48.1

