Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F10394793;
	Mon, 30 Mar 2026 06:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774851945; cv=none; b=E2MZ7ywmsp/tKDjloq9HKSdrz2H2Zx75+6aWpFsHEozqXQyjy2DRo+UqMhqzJXVCUdjIrpIV7oYEZKS5EEnZpkJnsdxttbxCfXTmMR6TW/V4C/fU4XZrxm/yogHF3LaixDMx1184KH42a2YK62n2B86aDznVPr4fzu5wUWjwg+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774851945; c=relaxed/simple;
	bh=Sx0Fc6PZy+pvfWt6qAHAyn6JoAVr3/sQlRxZ2AlorIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UIn1L2+h7XD72Ok7G7qQhSV5gNbqNHFa1hc7UCf6ihLTkH2WD1EuMgo2JNeaM5YN5F0zLCl3CBBsDrE4O6T/CnKfrbr4YGx3ENK+Zkz3qJb10/pLNgcoocJu8zfd6VmY1eQ9u+B+uahuwS3VQFMBbtZ9bpWoGCGGiYVfi1Bn3A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qa7gkjGG; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qa7gkjGG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=O8KXfZ76HdUg1YpieV7WvZyfDkTw293oakpRQ4NFQzI=;
	b=qa7gkjGG/aGB0LJ8MJ+nUWO4ljp2qVVTZFXnWZZMz+hFWcjwwBcXvC4Im4c0QgjZK+otqWxtB
	HvfyqfEWVsHKQM+fi/4ypkFDshDWN78DEDBo9layq/rmf6xaUEps2YSkSE5k8iw7PDCzCWH0ikY
	9FWHRTnh09BW6kyV/rk7FYg=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fkh0t5YQGzRhR7;
	Mon, 30 Mar 2026 14:19:26 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4F91A203A7;
	Mon, 30 Mar 2026 14:25:35 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:34 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:34 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <yinzhushuai@huawei.com>
Subject: [PATCH 4/5] crypto: hisilicon/qm - drop redundant variable initialization
Date: Mon, 30 Mar 2026 14:25:30 +0800
Message-ID: <20260330062531.2976138-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260330062531.2976138-1-huangchenghai2@huawei.com>
References: <20260330062531.2976138-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Variables are assigned before used. Initialization is not required.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 0588355920dd..2bb51d4d88a6 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3381,7 +3381,7 @@ static int __hisi_qm_start(struct hisi_qm *qm)
 int hisi_qm_start(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
-	int ret = 0;
+	int ret;
 
 	down_write(&qm->qps_lock);
 
@@ -3917,8 +3917,8 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 
 static u32 qm_get_shaper_vft_qos(struct hisi_qm *qm, u32 fun_index)
 {
-	u64 cir_u = 0, cir_b = 0, cir_s = 0;
 	u64 shaper_vft, ir_calc, ir;
+	u64 cir_u, cir_b, cir_s;
 	unsigned int val;
 	u32 error_rate;
 	int ret;
-- 
2.33.0

