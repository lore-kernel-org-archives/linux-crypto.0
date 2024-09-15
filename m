Received: from msa.smtpout.orange.fr (msa-209.smtpout.orange.fr [193.252.23.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540AE198A03
	for <linux-crypto@vger.kernel.org>; Sun, 15 Sep 2024 10:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.252.23.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726395752; cv=none; b=DmLfcwZQDSjWyKwMTvibfE/0XDvkW4m9cwHgb+wMj51+NKVeWI1hmpCuYYohcUjQHXbc7WGG9FkN64iHNF9CC6FEwHJQS5IhuqOMQVVicwlm3WJtRDuN79eq6L4VjM3hyaVWtBhxkzwHqCoaYZiR+Fq3fHqAfSPBKwZ2G+opgqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726395752; c=relaxed/simple;
	bh=OU121EH3o4oNFUMkKEQJk2Axn51rBYd2m3eyMY5uI+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6CJoJiCbT8Jk3+w8TO7kkHjUNCRIqstBBBsYHYvfNKfVbVZopY+bNo2BuPP1ASqTHi+Dj662mps16OACCNz7zy6n476ivUaY5mpCLB/T6bX9bPI4BeWm1pEqHuTzLpls+fEeMorRV2EOskayorvwnzl4Zfg0ldOItb8dFbvAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=bmtKmoke; arc=none smtp.client-ip=193.252.23.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="bmtKmoke"
Received: from fedora.home ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id pmOdsbBSBEyYjpmOds4NCu; Sun, 15 Sep 2024 12:22:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1726395746;
	bh=pf3gB7OINiM24+3hvi+hf8vNJkXkS4txKpVd54g/XEk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=bmtKmokedW7XLT6H76D4hhh4SycDGMbapwut5bWGn8EZ78Pd2vzVs0WtPBqluEgMj
	 qMYDbadJ0Imru+KPx3ascteN4xiMHNpg+TlsybVPM9tbyef5lYU9H5vITEDqCaCUCd
	 5IPQJyHnABNT/yWfyRXgII6W3BAoza05EE7DnStniJ0nHG0km/oSIxcnH1v6nRQAWE
	 Z6Zg2glkYjswINBbeRTzfsPPpWe1pFHQJB1kc/aQIx37ELhsDVV/Lk8YBiwnvmowhQ
	 7O1fKecDUXjZyrUqVbJblBCdO5cVH2RIBql0UWHGa86GDfAUnTWh2Qfv6H5YsmXfd/
	 Q1/kSdUbexPnA==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Sep 2024 12:22:26 +0200
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: caam: Fix the pointer passed to caam_qi_shutdown()
Date: Sun, 15 Sep 2024 12:22:12 +0200
Message-ID: <c76ff86fe3ec40776646f4e5ebd5f0900ca48b37.1726395689.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The type of the last parameter given to devm_add_action_or_reset() is
"struct caam_drv_private *", but in caam_qi_shutdown(), it is casted to
"struct device *".

Pass the correct parameter to devm_add_action_or_reset() so that the
resources are released as expected.

Fixes: f414de2e2fff ("crypto: caam - use devres to de-initialize QI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative review with care.
---
 drivers/crypto/caam/qi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index f6111ee9ed34..8ed2bb01a619 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -794,7 +794,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 
 	caam_debugfs_qi_init(ctrlpriv);
 
-	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
+	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, qidev);
 	if (err)
 		goto fail2;
 
-- 
2.46.0

