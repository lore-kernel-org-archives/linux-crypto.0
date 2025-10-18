Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF8E1ADC7E;
	Sat, 18 Oct 2025 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760786867; cv=none; b=gUMTX8VuxyoPj2n2gGla3vEMgP8JUgcKHaCkraPgFZxrY0yzDD+BIZ9RY7xOkbXBqd1F7emEL2qQJyzJMIJjoYcwSJF6+qCsM3ZBF5dRTDhpBhgiG3CRH0SuTzKhDwNzcIXgIeTvSjKgYQCf53ZgcbP98uxQBX/jZkG1RLpmw+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760786867; c=relaxed/simple;
	bh=jcOMAGkiUb+fuS17tYJmBIE8jMkbwbWbcDpVYAnxhoM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NSsAQEXPgBulaUDZ3aRroVmurxXSrhRujKadaHACa3ok2sAFPPhWcgQbxpzD6z/k5hm7MIvgiuSex+C16Y5bvUPEQ0N9dPikDUTyTy8bTYAn1jIaep5kfPk2Uphykb/G+2uFfEDeJK9YQYtxM1xR/PD4Hzne4PYdplTDiG+p1Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4BPOaSG2; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4BPOaSG2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xB+eplaRL5bHHA3zfec6b5b4SIuM+3ZPPxwvvx0ulNI=;
	b=4BPOaSG2ULqT62OBPuJSSgyUQEYDTXqDjJJZnn3dg7Kj6rz8AVKtm6j8LGshUqhyZ1mCaWp1s
	vqQUq3K/A5BHY0vafTrIGix8SPvgevHVt/ANNfzxwycAa7e8h2ffa8DVNydZSidyUuF/sFy5ORG
	HOpaKHBcr9+nOMSOkCuk2aI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cpfYL04YWz1prQN;
	Sat, 18 Oct 2025 19:27:18 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CF54180487;
	Sat, 18 Oct 2025 19:27:40 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 19:27:40 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Oct 2025 19:27:39 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - restore original qos values
Date: Sat, 18 Oct 2025 19:27:39 +0800
Message-ID: <20251018112739.3220154-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: nieweiqiang <nieweiqiang@huawei.com>

When the new qos valus setting fails, restore to
the original qos values.

Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a5b96adf2d1e..30e44cfb57ee 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3678,6 +3678,7 @@ static void qm_clear_vft_config(struct hisi_qm *qm)
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 {
 	struct device *dev = &qm->pdev->dev;
+	struct qm_shaper_factor t_factor;
 	u32 ir = qos * QM_QOS_RATE;
 	int ret, total_vfs, i;
 
@@ -3685,6 +3686,7 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 	if (fun_index > total_vfs)
 		return -EINVAL;
 
+	memcpy(&t_factor, &qm->factor[fun_index], sizeof(t_factor));
 	qm->factor[fun_index].func_qos = qos;
 
 	ret = qm_get_shaper_para(ir, &qm->factor[fun_index]);
@@ -3698,11 +3700,21 @@ static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
 		ret = qm_set_vft_common(qm, SHAPER_VFT, fun_index, i, 1);
 		if (ret) {
 			dev_err(dev, "type: %d, failed to set shaper vft!\n", i);
-			return -EINVAL;
+			goto back_func_qos;
 		}
 	}
 
 	return 0;
+
+back_func_qos:
+	memcpy(&qm->factor[fun_index], &t_factor, sizeof(t_factor));
+	for (i--; i >= ALG_TYPE_0; i--) {
+		ret = qm_set_vft_common(qm, SHAPER_VFT, fun_index, i, 1);
+		if (ret)
+			dev_err(dev, "failed to restore shaper vft during rollback!\n");
+	}
+
+	return -EINVAL;
 }
 
 static u32 qm_get_shaper_vft_qos(struct hisi_qm *qm, u32 fun_index)
-- 
2.33.0

