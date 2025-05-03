Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FAD17BED0;
	Sat,  3 May 2025 20:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746304120; cv=none; b=UAkewWWa8BE3VYXtMC8qfa3dyUe/xbqkVjduzDkNG2iTUD/fRTQTvNcWnUvt20N5WyWrByPB9SoKYubfdCZ9ShYJH81xmYqiWTT1cmWvOQ8K8GRiW8x/5NwG4+jFRERaFwCq23i2wOgHTln53U+wniOSokkuxlWav04BrAsw6T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746304120; c=relaxed/simple;
	bh=9sXyHtfy2CGG1rNPSLIBNEw4neQ6gqlqo7AaRVn7gnM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rTTOdqk69dsFAh+dKVgaEOZ5PzAj4ywJq0HpvexQ3VgqkjnpUgpqg8lwMozdZbkpW3YFX4V4QVGZg23V5+Xw5mLEFv0tbxzKJTVHoZGenUvXQnKf+K8fXQm9BYVHEaVmXhXPkAZDlnsQSBmYllV9MwQXCu2BIpu0A1tthgfraqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com; spf=pass smtp.mailfrom=ethancedwards.com; dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b=i+JJPNhi; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ethancedwards.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ethancedwards.com header.i=@ethancedwards.com header.b="i+JJPNhi"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4ZqfMM1F5Xz9sF1;
	Sat,  3 May 2025 22:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1746303695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mhQibUgvi4UXWwBalaujNOuytv932n/6dTzw2/JyC1U=;
	b=i+JJPNhiEFMmRp/Soag9Mv1wTl44Gl2160CiGXDULMDJkAOr3BwU4FEBWFdShW0FxyH0+I
	PqxYSfxQqn5hncWCKOQDz2G6rlyZH3cx29cOabefZfxjxF7GBY9DEKyElCwtabHIFdaLMy
	aqhQh6wbuH59V9bFO88DhAtkAMbdD++a68btBCwrIeup7WgMjqZojvg1KYB5jK9ZJUa9Rd
	LmdObPEkX2wxr9fe+grNGf+9kEzthcbwlmTxtbNicQ7f9tbtYq2FByfyFskwlrov8aY3XC
	p4cvafyijX/rofLAm7Tn7VnS9Q2BM0EXOlvrcNo8TTijLWUnyp1ZIuriJUSoPg==
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Date: Sat, 03 May 2025 16:21:27 -0400
Subject: [PATCH 1/2] crypto: hisilicon/qm - remove sizeof(char)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250503-hisilicon_qm-v1-1-d4ebc242bc8a@ethancedwards.com>
References: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
In-Reply-To: <20250503-hisilicon_qm-v1-0-d4ebc242bc8a@ethancedwards.com>
To: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, 
 Ethan Carter Edwards <ethan@ethancedwards.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=775;
 i=ethan@ethancedwards.com; h=from:subject:message-id;
 bh=9sXyHtfy2CGG1rNPSLIBNEw4neQ6gqlqo7AaRVn7gnM=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgprQTBEQUFvVzJEM0ZOM09UeCtZQnl5WmlBR
 2dXZXNlaDRQenZxM2pFQVExRDhxbXc3Z09QVW1EU3h3QmdEYmNSCkFvemV6ZC9UWW9oMUJBQVdD
 Z0FkRmlFRS8yd2padUVwbUNDNS9VU0MyRDNGTjNPVHgrWUZBbWdXZXNjQUNna1EKMkQzRk4zT1R
 4K1pob2dFQXpyak5CTEFDbnc4Ui9kVTQwWVUrRElsZXVMbDIxU2RlMm5QZ3Z6Q0JSOTBBLzBlUA
 p5ZENSWXRTOWFQcjhkb0lZd3N2bzdWeXB5aFJ3ekZLZ1J6RnpTd2dICj1vS3hBCi0tLS0tRU5EI
 FBHUCBNRVNTQUdFLS0tLS0K
X-Developer-Key: i=ethan@ethancedwards.com; a=openpgp;
 fpr=2E51F61839D1FA947A7300C234C04305D581DBFE
X-Rspamd-Queue-Id: 4ZqfMM1F5Xz9sF1

`sizeof(char)` evaluates to 1. Remove the churn.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index d3f5d108b898bb5fa6ef901070e9e97b02afb29a..80d57f0dbf26e2902e01103b0a705234009161ee 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -862,7 +862,7 @@ int hisi_qm_set_algs(struct hisi_qm *qm, u64 alg_msk, const struct qm_dev_alg *d
 		return -EINVAL;
 	}
 
-	algs = devm_kzalloc(dev, QM_DEV_ALG_MAX_LEN * sizeof(char), GFP_KERNEL);
+	algs = devm_kzalloc(dev, QM_DEV_ALG_MAX_LEN, GFP_KERNEL);
 	if (!algs)
 		return -ENOMEM;
 

-- 
2.48.1

