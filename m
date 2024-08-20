Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DDC1B813;
	Tue, 20 Aug 2024 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142532; cv=none; b=MAKbFcPHGRaWPQ79Y39vshXQ7MPXt+MTDlBCYk0DXtxQy4lt9O+dPtFhhqFS8GKlS+aFCszUfV0Pdaea4bd05HhSRLOtDH1FKB2yA4DY74Gao1j2rTCRPjgn2W431X/aGP7fgefmSta4lT33/jowQHeqg4HTpUjTx/W4aMSHEtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142532; c=relaxed/simple;
	bh=n4IfhXr5tYdlIii6U0C1w0sEx3eqEp8dJxWyAab0yGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X9zSGSypru47zKbAHhfsPHDhu0P8IusNmvCymw3RcxyAJiRW4EDD4ndHw0b2YmjdGRbwSHTTvpjv/b6FAeURbLnor/OLzp5uzYXZYK6w57Qpcc9SZPWyleZtpPJzHs5tOnCjeN4IuRQv3jqOrTO2HUhznEhkw0ESkwb93jRlU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wp2YJ36jLz1S8Lm;
	Tue, 20 Aug 2024 16:23:48 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DE7C1402CF;
	Tue, 20 Aug 2024 16:28:48 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:47 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 3/6] crypto: octeontx - Remove unused declaration otx_cpt_callback()
Date: Tue, 20 Aug 2024 16:25:22 +0800
Message-ID: <20240820082525.259337-4-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820082525.259337-1-yuehaibing@huawei.com>
References: <20240820082525.259337-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

This function is never implemented and used since introduction in
commit 10b4f09491bf ("crypto: marvell - add the Virtual Function
driver for CPT")

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
index 4181b5c5c356..a50b5e2f8d00 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.h
@@ -185,6 +185,5 @@ int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
 			int num_queues, int num_devices);
 void otx_cpt_crypto_exit(struct pci_dev *pdev, struct module *mod,
 			 enum otx_cptvf_type engine_type);
-void otx_cpt_callback(int status, void *arg, void *req);
 
 #endif /* __OTX_CPT_ALGS_H */
-- 
2.34.1

