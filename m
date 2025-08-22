Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AF2F5483;
	Fri, 22 Aug 2025 10:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755859152; cv=none; b=bXyNZmB6FE2KGlsffi8OCljXCyTLV5JciOOHV43mNJ7axP5COP6/ShzU0hmADuQJssIB2PmZiHms3dUPEVCx3MJ2JxXWlh0sKURlfHBEBf8VQ3NJtg3k1ybhXq3UpSobxGlVF7FCW4YIGucJsCVi4SOHy8/84Kqa5x4V/uW5dWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755859152; c=relaxed/simple;
	bh=5OW9O5RwyETlN8vXUqm94SQB4JN1rvICtu20k9gCrQM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KcIQZnYGOvXwEcClnZmLPHy6rjItgIhXFv8gaI7nF5puC+gIDn2yw83M8eV/KsDxHQ2XE9BPxb7KuidS2UxNQZFObkOhhsWvfMqTHM8CEGDSjMQ7NRzcnlIt00VKbMALhjEZbZYtjsFfONTFZcmAxlGs+jiLZDeg9P9FfSX1DFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7c6j3dN8z1R8yS;
	Fri, 22 Aug 2025 18:36:13 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 816F6140258;
	Fri, 22 Aug 2025 18:39:07 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:07 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:06 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<liulongfang@huawei.com>
Subject: [PATCH 4/4] uacce: ensure safe queue release with state management
Date: Fri, 22 Aug 2025 18:39:04 +0800
Message-ID: <20250822103904.3776304-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250822103904.3776304-1-huangchenghai2@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Directly calling `put_queue` carries risks since it cannot
guarantee that resources of `uacce_queue` have been fully released
beforehand. So adding a `stop_queue` operation for the
UACCE_CMD_PUT_Q command and leaving the `put_queue` operation to
the final resource release ensures safety.

Queue states are defined as follows:
- UACCE_Q_ZOMBIE: Initial state
- UACCE_Q_INIT: After opening `uacce`
- UACCE_Q_STARTED: After `start` is issued via `ioctl`

When executing `poweroff -f` in virt while accelerator are still
working, `uacce_fops_release` and `uacce_remove` may execute
concurrently. This can cause `uacce_put_queue` within
`uacce_fops_release` to access a NULL `ops` pointer. Therefore, add
state checks to prevent accessing freed pointers.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/misc/uacce/uacce.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 531a24145ba4..8a78edb545a1 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -40,20 +40,34 @@ static int uacce_start_queue(struct uacce_queue *q)
 	return 0;
 }
 
-static int uacce_put_queue(struct uacce_queue *q)
+static int uacce_stop_queue(struct uacce_queue *q)
 {
 	struct uacce_device *uacce = q->uacce;
 
-	if ((q->state == UACCE_Q_STARTED) && uacce->ops->stop_queue)
+	if (q->state != UACCE_Q_STARTED)
+		return 0;
+
+	if (uacce->ops->stop_queue)
 		uacce->ops->stop_queue(q);
 
-	if ((q->state == UACCE_Q_INIT || q->state == UACCE_Q_STARTED) &&
-	     uacce->ops->put_queue)
+	q->state = UACCE_Q_INIT;
+
+	return 0;
+}
+
+static void uacce_put_queue(struct uacce_queue *q)
+{
+	struct uacce_device *uacce = q->uacce;
+
+	uacce_stop_queue(q);
+
+	if (q->state != UACCE_Q_INIT)
+		return;
+
+	if (uacce->ops->put_queue)
 		uacce->ops->put_queue(q);
 
 	q->state = UACCE_Q_ZOMBIE;
-
-	return 0;
 }
 
 static long uacce_fops_unl_ioctl(struct file *filep,
@@ -80,7 +94,7 @@ static long uacce_fops_unl_ioctl(struct file *filep,
 		ret = uacce_start_queue(q);
 		break;
 	case UACCE_CMD_PUT_Q:
-		ret = uacce_put_queue(q);
+		ret = uacce_stop_queue(q);
 		break;
 	default:
 		if (uacce->ops->ioctl)
-- 
2.33.0

