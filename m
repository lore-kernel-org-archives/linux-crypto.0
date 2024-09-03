Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489BB13CF86
	for <linux-crypto@vger.kernel.org>; Tue,  3 Sep 2024 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374041; cv=none; b=H4T6TYEge8sJfXM1C1L543vLUFywMsKsVMNFC1Q2NY7Xp39WYox6zrAVaDJcKl1G4/CTyb8/xPZJX0CxyLPlIl0OxDkHobwuxVH3ft13vpPSJq9OUr2dHXrj+ePssqTkI/C4F4RybR6XIyFZtV8ik5bP08QL/fSyp8rXPK4+G1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374041; c=relaxed/simple;
	bh=1zfNkkzWNpcKmj/fAA7pPUhwVHED5nLzTAiTNqqqBEY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Q8HuZbwRJJcLPsiyK37kIHpNqlayFnCAZMUCjna2kLCGN1pUXb8ZdVF3HCqTxetFuMkafizGlAJe3E31mhhY6WeC/jiobQIs1ywJNfSvOy5oVTdEsi6XVuh46kmFMfw8783y3pqXft63Yh55g0t0J1GmC9KATgkUJ7XvqXIguOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wyp0D5Mzqz20nQF;
	Tue,  3 Sep 2024 22:29:00 +0800 (CST)
Received: from kwepemd500012.china.huawei.com (unknown [7.221.188.25])
	by mail.maildlp.com (Postfix) with ESMTPS id DD63E140136;
	Tue,  3 Sep 2024 22:33:56 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemd500012.china.huawei.com
 (7.221.188.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.34; Tue, 3 Sep
 2024 22:33:56 +0800
From: Li Zetao <lizetao1@huawei.com>
To: <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lucas.segarra.fernandez@intel.com>,
	<damian.muszynski@intel.com>
CC: <lizetao1@huawei.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH -next] crypto: qat - remove redundant null pointer checks in adf_dbgfs_init()
Date: Tue, 3 Sep 2024 22:42:30 +0800
Message-ID: <20240903144230.2005570-1-lizetao1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd500012.china.huawei.com (7.221.188.25)

Since the debugfs_create_dir() never returns a null pointer, checking
the return value for a null pointer is redundant, and using IS_ERR is
safe enough.

Signed-off-by: Li Zetao <lizetao1@huawei.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
index c42f5c25aabd..ec2c712b9006 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -30,7 +30,7 @@ void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
 		 pci_name(accel_dev->accel_pci_dev.pci_dev));
 
 	ret = debugfs_create_dir(name, NULL);
-	if (IS_ERR_OR_NULL(ret))
+	if (IS_ERR(ret))
 		return;
 
 	accel_dev->debugfs_dir = ret;
-- 
2.34.1

