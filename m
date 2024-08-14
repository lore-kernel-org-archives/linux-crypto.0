Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2598111A1;
	Wed, 14 Aug 2024 02:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723603922; cv=none; b=MIivCtURC8K54VCgQ2lsZ0pDSwdS9jqf218bGd26iUM9fXQHaCNWUL4Mgzwb0O9au3S+s+LYvwBNRGI81H16sb5oLtkoKbFKY2RXoB8mWa1bVYYh2MsfjLldULs1WgNP99FQv6g+f4DmdNpyNTgjYyyfEBKdXCkP4nwh4YliRIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723603922; c=relaxed/simple;
	bh=rwQiDf7rbiUQg2QFABVP9J4Gp7MHJdRwYvWrQKsNtdo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fOsThjhvlPGZab4Z7YXVZoTS1ows64Q2WXBKiOFtLOAqcfQpPRjnJHEKDgooFZear+yDhWnBHKMwZ6PcSNHZ4W7FrIPVT9uvWJ3dc5JwlLx/i9DnNX8p5WENAr1lcYWLmUPXoD/q9gFkYABYrA1YGYvxzU1RUuLj84xCycq5yvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WkCSs2qCfzcdLr;
	Wed, 14 Aug 2024 10:51:41 +0800 (CST)
Received: from dggpemm500020.china.huawei.com (unknown [7.185.36.49])
	by mail.maildlp.com (Postfix) with ESMTPS id F276718006C;
	Wed, 14 Aug 2024 10:51:55 +0800 (CST)
Received: from huawei.com (10.67.174.77) by dggpemm500020.china.huawei.com
 (7.185.36.49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 14 Aug
 2024 10:51:55 +0800
From: Liao Chen <liaochen4@huawei.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <declan.murphy@intel.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
Subject: [PATCH -next] crypto: keembay - fix module autoloading
Date: Wed, 14 Aug 2024 02:44:06 +0000
Message-ID: <20240814024406.3875287-1-liaochen4@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500020.china.huawei.com (7.185.36.49)

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
---
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
index c2dfca73fe4e..e54c79890d44 100644
--- a/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c
@@ -1150,6 +1150,7 @@ static const struct of_device_id kmb_ocs_hcu_of_match[] = {
 	},
 	{}
 };
+MODULE_DEVICE_TABLE(of, kmb_ocs_hcu_of_match);
 
 static void kmb_ocs_hcu_remove(struct platform_device *pdev)
 {
-- 
2.34.1

