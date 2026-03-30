Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF25339478F;
	Mon, 30 Mar 2026 06:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774851952; cv=none; b=TZGHBJMmL2bdrJMrsYFISbYGvQP4e0JJTKrIlHIPnC/+o4BAR99w84aczTkR/x4XbgV9xQFd8mZsMhyAeMB//wE5ljLJlg6PgspaXmzV+1EA5abpyJ7Jo0i3n+rUzOJGu7az/r6Rj2jKK4x7ibcMLJ/NT4n8TzMmPxzFHhAk5b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774851952; c=relaxed/simple;
	bh=NVgqMp+ej9gXxrCJL59iSZwkkaMmXobCyidAXEEqekA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tx3dncD7n3KgOaW3e+Sp2orX2KvCcz2LWVJQMdICSDyosvDzshtYzK2VDuL4MjTDyUmGgLdQtsnKnrhXPN9NOOnWF7l8A6bVN6DpK+ZdrJZIQI7dSNVLJgIYy0gGVYQ3EijXc4rOXMpse0kWYqyUq4Z+C4dONSHVaHfPFiqihBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UcQ0oYsR; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UcQ0oYsR; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UcQ0oYsR";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UcQ0oYsR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NtHldOAKLME86m23DlCEDtsS98a/InDXmypmupVIqpM=;
	b=UcQ0oYsRoInmeaO/LBx3bkZQ7dzUlhsU+iOXdj2cGOeMBrzaE/gRg+VTH4A7xTsHzyrbPyNP4
	Gmj3Rnf+oxMrjFJjI5EFxZPD6q6/mVoq+m2o8X/nAA81t9fAKi7/qzWfRIP3VbJbHdTv5YdzpZT
	iO0fU8b7/tBIo/qAGfJwpBM=
Received: from canpmsgout08.his.huawei.com (unknown [172.19.92.156])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fkh7r2b0mz1BGDX;
	Mon, 30 Mar 2026 14:25:28 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NtHldOAKLME86m23DlCEDtsS98a/InDXmypmupVIqpM=;
	b=UcQ0oYsRoInmeaO/LBx3bkZQ7dzUlhsU+iOXdj2cGOeMBrzaE/gRg+VTH4A7xTsHzyrbPyNP4
	Gmj3Rnf+oxMrjFJjI5EFxZPD6q6/mVoq+m2o8X/nAA81t9fAKi7/qzWfRIP3VbJbHdTv5YdzpZT
	iO0fU8b7/tBIo/qAGfJwpBM=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4fkh0r1JBXzmVW3;
	Mon, 30 Mar 2026 14:19:24 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B9C440562;
	Mon, 30 Mar 2026 14:25:34 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:33 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:33 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <yinzhushuai@huawei.com>
Subject: [PATCH 2/5] crypto: hisilicon/qm - add const qualifier to info_name in struct qm_cmd_dump_item
Date: Mon, 30 Mar 2026 14:25:28 +0800
Message-ID: <20260330062531.2976138-3-huangchenghai2@huawei.com>
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

The "info_name" is never changed in struct qm_cmd_dump_item,
make it const.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/debugfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index e5878558dc64..3ee6de16e3f1 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -45,8 +45,8 @@ struct qm_dfx_item {
 
 struct qm_cmd_dump_item {
 	const char *cmd;
-	char *info_name;
-	int (*dump_fn)(struct hisi_qm *qm, char *cmd, char *info_name);
+	const char *info_name;
+	int (*dump_fn)(struct hisi_qm *qm, char *cmd, const char *info_name);
 };
 
 static struct qm_dfx_item qm_dfx_files[] = {
@@ -151,7 +151,7 @@ static ssize_t qm_cmd_read(struct file *filp, char __user *buffer,
 }
 
 static void dump_show(struct hisi_qm *qm, void *info,
-		     unsigned int info_size, char *info_name)
+		     unsigned int info_size, const char *info_name)
 {
 	struct device *dev = &qm->pdev->dev;
 	u8 *info_curr = info;
@@ -165,7 +165,7 @@ static void dump_show(struct hisi_qm *qm, void *info,
 	}
 }
 
-static int qm_sqc_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_sqc_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct qm_sqc sqc;
@@ -202,7 +202,7 @@ static int qm_sqc_dump(struct hisi_qm *qm, char *s, char *name)
 	return 0;
 }
 
-static int qm_cqc_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_cqc_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct qm_cqc cqc;
@@ -239,7 +239,7 @@ static int qm_cqc_dump(struct hisi_qm *qm, char *s, char *name)
 	return 0;
 }
 
-static int qm_eqc_aeqc_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_eqc_aeqc_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct qm_aeqc aeqc;
@@ -317,7 +317,7 @@ static int q_dump_param_parse(struct hisi_qm *qm, char *s,
 	return 0;
 }
 
-static int qm_sq_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_sq_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	u16 sq_depth = qm->qp_array->sq_depth;
 	struct hisi_qp *qp;
@@ -345,7 +345,7 @@ static int qm_sq_dump(struct hisi_qm *qm, char *s, char *name)
 	return 0;
 }
 
-static int qm_cq_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_cq_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	struct qm_cqe *cqe_curr;
 	struct hisi_qp *qp;
@@ -363,7 +363,7 @@ static int qm_cq_dump(struct hisi_qm *qm, char *s, char *name)
 	return 0;
 }
 
-static int qm_eq_aeq_dump(struct hisi_qm *qm, char *s, char *name)
+static int qm_eq_aeq_dump(struct hisi_qm *qm, char *s, const char *name)
 {
 	struct device *dev = &qm->pdev->dev;
 	u16 xeq_depth;
-- 
2.33.0

