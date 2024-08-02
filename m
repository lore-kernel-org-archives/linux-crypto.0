Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745F1E2890
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 11:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722599754; cv=none; b=ZMgr0OlPstXKnaO/+7L4FfV3+B9Iqe0Pm3dek+A8JwsQrz8PV6fj2ap1VsSzeZdjFwM9OJyKCc99vKYsKxU3zZuOKjAnr59O746AdyQobtuvMESYzooK5rRwhaVpXL2sf8gYs08oMbW3/CqyRosWtg/pRXBDpVfvaY4KPtKjaFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722599754; c=relaxed/simple;
	bh=O6ACiJB0pijeHG+vBDhP6+9/St9ZXMLPw/9iES6OVy4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GYfVEwwYewdwte7vCDRaRQbJb4QIuYGfYN/5SBrPcu1nZ5Jsos8//lf8Nkj5DHtsDHAxBGGKBEalsatPE6EVy3i9YAsbMDNYjeI6Q13P6fu15T1VUEyZBaTVnFhliKuALfT0tDPZVBB+vewjTZDcgKbLWiJrlgaOCdmKRHSYS20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wb41C49J1zQnZV;
	Fri,  2 Aug 2024 19:51:27 +0800 (CST)
Received: from kwepemm600014.china.huawei.com (unknown [7.193.23.54])
	by mail.maildlp.com (Postfix) with ESMTPS id CA1AE180101;
	Fri,  2 Aug 2024 19:55:48 +0800 (CST)
Received: from huawei.com (10.67.174.78) by kwepemm600014.china.huawei.com
 (7.193.23.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 2 Aug
 2024 19:55:48 +0800
From: Yi Yang <yiyang13@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>
CC: <lujialin4@huawei.com>, <linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: testmgr - don't generate WARN for -EAGAIN
Date: Fri, 2 Aug 2024 11:49:47 +0000
Message-ID: <20240802114947.3984577-1-yiyang13@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600014.china.huawei.com (7.193.23.54)

Since commit 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET"),
The encryption and decryption using padata be failed when the CPU goes
online and offline.
We should try to re-encrypt or re-decrypt when -EAGAIN happens rather than
generate WARN. The unnecessary panic will occur when panic_on_warn set 1.

Fixes: 8f4f68e788c3 ("crypto: pcrypt - Fix hungtask for PADATA_RESET")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
---
 crypto/testmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f02cb075bd68..15e0f5e4ba6f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5905,7 +5905,7 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 		}
 		pr_warn("alg: self-tests for %s using %s failed (rc=%d)",
 			alg, driver, rc);
-		WARN(rc != -ENOENT,
+		WARN(rc != -ENOENT && rc != -EAGAIN,
 		     "alg: self-tests for %s using %s failed (rc=%d)",
 		     alg, driver, rc);
 	} else {
-- 
2.25.1

