Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D46357CE0;
	Mon, 21 Sep 2026 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983735; cv=none; b=cbAVhgnx2HfYO464EUSJQqhWGcPkN62dSzzvBH2G5Hnsmxlu+1UhbxGv5wfZI23BVaxThFrCBfvTdapwixUj34BxNCoKs0jQQ0kltmAz1qf0UzUht5emcpC4RmkHURzaODNYtS6rM5YJxNTF6P8/xGz0zPWqdIT0sbK5BUxQras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983735; c=relaxed/simple;
	bh=PERZFNfWWVwdp6nW1zIQ4EfMbSMRxyBP2xLhkIyzWzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jCoW0tmIuYyQexqhzJIlf0Y20n87fWar0MoK721VqJ43jIkmFdkL1Y6hFs7ACmofDdD1mq4gN2koMj+oGs2oZ+HaOykjf3g94Hjx4n6tJZ38g4yb6StGyiiobRETmpGrdZFJMb81+MVK2suWi0zdzWOLx6V05HrgsksLKGHELFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=fPtsDyPQ; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="fPtsDyPQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aONeRWuaRi4rsRwD0bkekWfCW1x65EloHht9llpQ4JM=;
	b=fPtsDyPQ14ZPRO81Y+QGcriCN3dD0NQHbnB7siN11M9zVFxhdN+t3pkY5AzAozUHIcPRQAB8X
	aVAMRQyFcm/Dm83X6BJWDW/fQPhN8mIr+KhuMyWvaji4rVvBSJyh3qByj4S7waWZuDDtdfYV65t
	Gnt1HoKzXTnTKORqsh5wXYY=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hpHzF2XWVznTVd;
	Mon, 21 Sep 2026 17:31:05 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 8944C40572;
	Mon, 21 Sep 2026 17:42:07 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 21 Sep 2026 17:42:07 +0800
From: Weili Qian <qianweili@huawei.com>
To: <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>,
	<zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
Subject: [PATCH v2 2/2] crypto: hisilicon/qm - implement uacce get_dev_usage callback
Date: Mon, 21 Sep 2026 17:42:05 +0800
Message-ID: <20260921094205.1426618-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921094205.1426618-1-qianweili@huawei.com>
References: <20260921094205.1426618-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

The HiSilicon QM driver does not implement the get_dev_usage callback,
so the dev_usage sysfs attribute is hidden on its UACCE devices.

Implement hisi_qm_get_dev_usage and register it in uacce_qm_ops.  For
each channel the callback reads the channel-usage register and derives
the usage via the existing qm_usage_percent() helper, moved to qm.c
with a shared declaration in qm_common.h.

The callback uses hisi_qm_get_dfx_access() so that a sysfs read does
not wake a runtime-suspended device; 0 is reported per channel when
suspended.

The channel-usage registers exist only on QM_HW_V5 and later, so the
callback returns -ENODEV on older revisions.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/debugfs.c   | 17 -------
 drivers/crypto/hisilicon/qm.c        | 66 ++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm_common.h |  1 +
 3 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 3ee6de16e3f1..83dfbe74e704 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -1040,23 +1040,6 @@ void hisi_qm_show_last_dfx_regs(struct hisi_qm *qm)
 	}
 }
 
-static int qm_usage_percent(struct hisi_qm *qm, int chan_num)
-{
-	u32 val, used_bw, total_bw;
-
-	val = readl(qm->io_base + QM_CHANNEL_USAGE_OFFSET +
-				chan_num * QM_CHANNEL_ADDR_INTRVL);
-	used_bw = lower_16_bits(val);
-	total_bw = upper_16_bits(val);
-	if (!total_bw)
-		return -EIO;
-
-	if (total_bw <= used_bw)
-		return QM_MAX_DEV_USAGE;
-
-	return (used_bw * QM_DEV_USAGE_RATE) / total_bw;
-}
-
 static int qm_usage_show(struct seq_file *s, void *unused)
 {
 	struct hisi_qm *qm = s->private;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c01966a4a33f..7dd7cf617570 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2884,6 +2884,71 @@ static u32 hisi_qm_isolate_threshold_read(struct uacce_device *uacce)
 	return qm->isolate_data.err_threshold;
 }
 
+int qm_usage_percent(struct hisi_qm *qm, int chan_idx)
+{
+	u32 val, used_bw, max_bw;
+
+	/*
+	 * Channel-usage register: lower 16 bits = current used bandwidth,
+	 * upper 16 bits = per-channel maximum bandwidth (static capability,
+	 * non-zero once the device is initialized).
+	 */
+	val = readl(qm->io_base + QM_CHANNEL_USAGE_OFFSET +
+		    chan_idx * QM_CHANNEL_ADDR_INTRVL);
+	used_bw = lower_16_bits(val);
+	max_bw = upper_16_bits(val);
+	if (!max_bw)
+		return -EIO;
+
+	if (max_bw <= used_bw)
+		return QM_MAX_DEV_USAGE;
+
+	return (used_bw * QM_DEV_USAGE_RATE) / max_bw;
+}
+
+static int hisi_qm_get_dev_usage(struct uacce_device *uacce, char *buf, int size)
+{
+	struct hisi_qm *qm = uacce->priv;
+	struct qm_channel *channel_data = &qm->channel_data;
+	bool dev_is_active = true;
+	const char *sep = "";
+	int ret, i, len = 0;
+
+	if (qm->ver < QM_HW_V5)
+		return -ENODEV;
+
+	/* If runtime-suspended, skip register reads and report 0. */
+	ret = hisi_qm_get_dfx_access(qm);
+	if (ret == -EAGAIN) {
+		dev_is_active = false;
+		ret = 0;
+	} else if (ret) {
+		return ret;
+	}
+
+	for (i = 0; i < channel_data->channel_num; i++) {
+		if (dev_is_active) {
+			ret = qm_usage_percent(qm, i);
+			if (ret < 0)
+				goto out;
+		}
+
+		if (len >= size)
+			break;
+
+		len += scnprintf(buf + len, size - len, "%s%s: %d",
+				 sep, channel_data->channel_name[i], ret);
+		sep = "\n";
+	}
+
+	ret = len;
+out:
+	if (dev_is_active)
+		hisi_qm_put_dfx_access(qm);
+
+	return ret;
+}
+
 static const struct uacce_ops uacce_qm_ops = {
 	.get_available_instances = hisi_qm_get_available_instances,
 	.get_queue = hisi_qm_uacce_get_queue,
@@ -2896,6 +2961,7 @@ static const struct uacce_ops uacce_qm_ops = {
 	.get_isolate_state = hisi_qm_get_isolate_state,
 	.isolate_err_threshold_write = hisi_qm_isolate_threshold_write,
 	.isolate_err_threshold_read = hisi_qm_isolate_threshold_read,
+	.get_dev_usage = hisi_qm_get_dev_usage,
 };
 
 static void qm_remove_uacce(struct hisi_qm *qm)
diff --git a/drivers/crypto/hisilicon/qm_common.h b/drivers/crypto/hisilicon/qm_common.h
index 0760bf55f13e..78bcf40bd851 100644
--- a/drivers/crypto/hisilicon/qm_common.h
+++ b/drivers/crypto/hisilicon/qm_common.h
@@ -75,5 +75,6 @@ struct qm_aeqc {
 int qm_set_and_get_xqc(struct hisi_qm *qm, u8 cmd, void *xqc, u32 qp_id, bool op);
 void hisi_qm_show_last_dfx_regs(struct hisi_qm *qm);
 void hisi_qm_set_algqos_init(struct hisi_qm *qm);
+int qm_usage_percent(struct hisi_qm *qm, int chan_idx);
 
 #endif
-- 
2.43.0

