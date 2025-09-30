Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B46218AD1;
	Tue, 30 Sep 2025 10:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759227937; cv=none; b=pmYTR2zFhU+Dguqm9YPyCD04F4lVy44VCdYDjWE4/bpXcQmBCFWqqZ/ZGSomD5l42wZUoD9YQzqcCWw5mxf9/JwGReIlNrVdVnA5JbuyeJQoOteFiFn9JD0r7Oja+vrTi8RMzETfycdQ+5c8oLvXBbWzOWsgIQeBF9/Nx6EtMcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759227937; c=relaxed/simple;
	bh=m8kgpN8y2+dD1fGt/wKhPjGmqbehchW0ol6unVjQYp8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A3hmiMLv6h4aC8MTZWzjx3x+0I6QQQOXCwt3DKGR27cg0yANFoKL3R0roGHne5XdiC9G9NHNH++/0qhMAJjoEmaKGvfYqu+yKhc2VLIe7lSXJucQ0hk8Xj67fWu7kz+CbQeH/xhneTZ/xt7jPDsVVXXVLBUg66kl4vzTa8vPdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MoIqBabH; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MoIqBabH"
Received: from fllvem-sh03.itg.ti.com ([10.64.41.86])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTP id 58UAPNjZ2435439;
	Tue, 30 Sep 2025 05:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1759227923;
	bh=BJDek7EWLI0i+nKCSFQ3tgTixnlCvzxcxxZ3hVY8jMk=;
	h=From:To:CC:Subject:Date;
	b=MoIqBabHq+Rv0CiBC9Ddiebcqvf79Y8gaT4zZVqTo1JscPQTO7OKCfU5oLXnPw47R
	 PEm3uWmhmFj2aeQrsCilTAidXZVLEnYC3jUdwK3nTG4PNBclHCp+6G3isAP9HToug1
	 e5T1LQ7knWgVTeEa6lTipckQxvCS1zTX3DjivC6c=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
	by fllvem-sh03.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 58UAPNrS3043076
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 30 Sep 2025 05:25:23 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Tue, 30
 Sep 2025 05:25:23 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 30 Sep 2025 05:25:23 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 58UAPLAJ3028303;
	Tue, 30 Sep 2025 05:25:22 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Kamlesh Gurudasani <kamlesh@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>,
        Shiva Tripathi <s-tripathi1@ti.com>,
        Kavitha Malarvizhi
	<k-malarvizhi@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ti - Add CRYPTO_ALG_ASYNC flag to DTHEv2 AES algos
Date: Tue, 30 Sep 2025 15:40:26 +0530
Message-ID: <20250930102423.2895282-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add CRYPTO_ALG_ASYNC flag to DTHEv2 AES-ECB and AES-CBC algorithms so as
to properly indicate driver capabilities.

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 0431a36d8c4a4..3547c41fa4ed3 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -367,6 +367,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_driver_name	= "ecb-aes-dthev2",
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
@@ -389,6 +390,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_driver_name	= "cbc-aes-dthev2",
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+						  CRYPTO_ALG_ASYNC |
 						  CRYPTO_ALG_KERN_DRIVER_ONLY,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
-- 
2.43.0

