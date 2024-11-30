Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F861C6A3;
	Sat, 30 Nov 2024 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732953703; cv=none; b=UeCzod22+XS9jjHOU/9BoN1KZ0iWEYjW3kG4IpTSGCatTYmyMQ+pfnsOUiVk2RupngKl6BIgV5uR41VdGRhgr1tUhQmRMKX3CRDHtyiZEreI0TwVGbHjRqWHOqv22WKmN9ojIT+5MkpZTUeWVkz5UwWXA8sXM/zDXmZTZaVYa2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732953703; c=relaxed/simple;
	bh=WDRIO5B62V/XAvaiuOU/9/QRjdq0+4qwe+kGMGXbQFE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VpQf5F9vhBQl2w1Q61ABlx8luhZQ1xuj7fJw6Z/xqMlNQnkM3H6sdbahoXXfMMkej8OYmFj3abfFnK/+NPDtHa7Jtt54GFA0Owd1+oaTR9EGQUluZNy05J+aJ0/9zVQfQE3K07xAzr4Lvu7D5nYO4TAH3RAzAMLWekzTrKIEEZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y0jDT4Rbvz1JDJc;
	Sat, 30 Nov 2024 16:01:29 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id B31911402DA;
	Sat, 30 Nov 2024 16:01:32 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Nov 2024 16:01:32 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/debugfs - fix the struct pointer incorrectly offset problem
Date: Sat, 30 Nov 2024 16:01:31 +0800
Message-ID: <20241130080131.906598-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200024.china.huawei.com (7.221.188.85)

Offset based on (id * size) is wrong for sqc and cqc.
(*sqc/*cqc + 1) can already offset sizeof(struct(Xqc)) length.

Fixes: 15f112f9cef5 ("crypto: hisilicon/debugfs - mask the unnecessary info from the dump")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 1b9b7bccdeff..45e130b901eb 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -192,7 +192,7 @@ static int qm_sqc_dump(struct hisi_qm *qm, char *s, char *name)
 
 	down_read(&qm->qps_lock);
 	if (qm->sqc) {
-		memcpy(&sqc, qm->sqc + qp_id * sizeof(struct qm_sqc), sizeof(struct qm_sqc));
+		memcpy(&sqc, qm->sqc + qp_id, sizeof(struct qm_sqc));
 		sqc.base_h = cpu_to_le32(QM_XQC_ADDR_MASK);
 		sqc.base_l = cpu_to_le32(QM_XQC_ADDR_MASK);
 		dump_show(qm, &sqc, sizeof(struct qm_sqc), "SOFT SQC");
@@ -229,7 +229,7 @@ static int qm_cqc_dump(struct hisi_qm *qm, char *s, char *name)
 
 	down_read(&qm->qps_lock);
 	if (qm->cqc) {
-		memcpy(&cqc, qm->cqc + qp_id * sizeof(struct qm_cqc), sizeof(struct qm_cqc));
+		memcpy(&cqc, qm->cqc + qp_id, sizeof(struct qm_cqc));
 		cqc.base_h = cpu_to_le32(QM_XQC_ADDR_MASK);
 		cqc.base_l = cpu_to_le32(QM_XQC_ADDR_MASK);
 		dump_show(qm, &cqc, sizeof(struct qm_cqc), "SOFT CQC");
-- 
2.33.0

