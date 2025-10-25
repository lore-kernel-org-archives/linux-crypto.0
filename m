Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5033A2EA735;
	Sat, 25 Oct 2025 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387185; cv=none; b=uETStwoevUHTo5ZTWxY10CGcF+RZHEP3a0+52kdse+CNIz1DObkRe5UjL3sOtYe3huHUOT8BNUcaYf/dugfSotw23kz0K7mEwqneWdnZ8bGxa/DZnB/fNO/a9W678JD6jJMEx9EN2QK/jRdoGGjyvfNHU6JODNdqzljJeFudfhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387185; c=relaxed/simple;
	bh=/sNgSAdf8Cd5KPAOTHV6fHNexKiZAdfuzHqQLFaO2hI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2191UMEF+HCAeN4qo298ytJTwjhgj9zv6x7Kp/jl5iOjA6YGtkyiDV968DEaUJeV9u+I4fNksigZsUokl/yQQbLTUaKi9J5j/8YsnwgYwyvZ95LMG05RM19cYBF53t1aFW0Yo1N9Ag5kRSrOqgoZ3ozVCO5z4wg8kMxxAOU/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1tIssE9y; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1tIssE9y"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+vvg9scQ6IncnhGrN5fA/hR1Wev2paxZFanOz8GdgIM=;
	b=1tIssE9ys9J8aF3aJlKmwGv4VBqXsYO/ylNHmQ9W5WgCM/Oh//QYxztO/nmQGJQ2LPP7oXjv3
	E0Sw5w3CUbkRXxqEu3aNTGnqInK672tTC04MUgyUoCjL6pir9Sn55LFtnT+1sntgKRb7ieOFfu+
	Ju4nuo8Stj/mcYEm9RYIGIY=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ctwYd4CTKznTW3;
	Sat, 25 Oct 2025 18:12:21 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 09E341800CE;
	Sat, 25 Oct 2025 18:13:01 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:00 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:00 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - add concurrency protection for variable err_threshold
Date: Sat, 25 Oct 2025 18:12:56 +0800
Message-ID: <20251025101258.2793179-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251025101258.2793179-1-huangchenghai2@huawei.com>
References: <20251025101258.2793179-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: nieweiqiang <nieweiqiang@huawei.com>

The isolate_strategy_store function is not protected
by a lock. If sysfs operations and functions that depend
on the err_threshold variable,such as qm_hw_err_isolate(),
execute concurrently, the outcome will be unpredictable.
Therefore, concurrency protection should be added for
the err_threshold variable.

Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8274da8b37ca..c58f67567c12 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2655,10 +2655,10 @@ static int qm_hw_err_isolate(struct hisi_qm *qm)
 		}
 	}
 	list_add(&hw_err->list, &isolate->qm_hw_errs);
-	mutex_unlock(&isolate->isolate_lock);
 
 	if (count >= isolate->err_threshold)
 		isolate->is_isolate = true;
+	mutex_unlock(&isolate->isolate_lock);
 
 	return 0;
 }
@@ -2667,12 +2667,10 @@ static void qm_hw_err_destroy(struct hisi_qm *qm)
 {
 	struct qm_hw_err *err, *tmp;
 
-	mutex_lock(&qm->isolate_data.isolate_lock);
 	list_for_each_entry_safe(err, tmp, &qm->isolate_data.qm_hw_errs, list) {
 		list_del(&err->list);
 		kfree(err);
 	}
-	mutex_unlock(&qm->isolate_data.isolate_lock);
 }
 
 static enum uacce_dev_state hisi_qm_get_isolate_state(struct uacce_device *uacce)
@@ -2700,10 +2698,12 @@ static int hisi_qm_isolate_threshold_write(struct uacce_device *uacce, u32 num)
 	if (qm->isolate_data.is_isolate)
 		return -EPERM;
 
+	mutex_lock(&qm->isolate_data.isolate_lock);
 	qm->isolate_data.err_threshold = num;
 
 	/* After the policy is updated, need to reset the hardware err list */
 	qm_hw_err_destroy(qm);
+	mutex_unlock(&qm->isolate_data.isolate_lock);
 
 	return 0;
 }
@@ -2740,7 +2740,10 @@ static void qm_remove_uacce(struct hisi_qm *qm)
 	struct uacce_device *uacce = qm->uacce;
 
 	if (qm->use_sva) {
+		mutex_lock(&qm->isolate_data.isolate_lock);
 		qm_hw_err_destroy(qm);
+		mutex_unlock(&qm->isolate_data.isolate_lock);
+
 		uacce_remove(uacce);
 		qm->uacce = NULL;
 	}
-- 
2.33.0

