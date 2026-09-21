Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D83353A73;
	Mon, 21 Sep 2026 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983733; cv=none; b=g6SEWMnWAKZA/yRsVurEHjg9RT8ftZs5gTgtCmwA0YXEtIQMwBJe4d1uh7ICLurjJrqfsra4CF4fDP/HcqPI2XddKD2YPBjEu9e75Ugeh1qrPpy0zP+zEybNdo17PzYCXBoBOlhb4x/xw1uovpn8OWx8FtkPkW5ShE1HxtxpA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983733; c=relaxed/simple;
	bh=ESQNEvFfPzzRUgnfdqnXLHe/3SZO7zRarxf4L4yUZ1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W+WQ6bfnnldOSMneU5N6LGPihQtoOmJ1TH9TTfYwKzbo77ne+f+kU7Xqqs1vRc7eOdo4/cny2A/vKEbJjs7g8tzGEDmlTuf0rt7X7inTwAKakh39q6haPKRX78M+F0+jHxd/hasK+o7P/MIt1yetvi2igGxQFGJZkB7jWhDy7cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=J9WjsNCP; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="J9WjsNCP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3F9Zbl7cldLKP/exScva/1zjnjVySMDwTKk76isZ55U=;
	b=J9WjsNCPCrZ7yuO/apKwYobkKyJlhwFmuy9Uioh5q/FGhjT8D7ip656zcC814T0QNxYNLzr4E
	MUm9FxSi2BvYZW2khVQZ1sE0RdAy5daWAAhI6HXDThkHeTlXukk1+tfe2dDFMOO0BqMqaIG/h9b
	torr1jqarWP4Ksal7NS65CQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hpHyD5xspzpSwY;
	Mon, 21 Sep 2026 17:30:12 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CB4340579;
	Mon, 21 Sep 2026 17:42:07 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 21 Sep 2026 17:42:06 +0800
From: Weili Qian <qianweili@huawei.com>
To: <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>,
	<zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
Subject: [PATCH v2 1/2] uacce: add device usage sysfs interface
Date: Mon, 21 Sep 2026 17:42:04 +0800
Message-ID: <20260921094205.1426618-2-qianweili@huawei.com>
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

Userspace has no way to query the runtime usage of a UACCE
device; it can only be inferred indirectly from queue state, which is
neither accurate nor uniform across drivers.

Add a read-only dev_usage sysfs attribute and a get_dev_usage callback
in struct uacce_ops. A driver implementing the callback writes the
current usage as a percentage (0-100) string into the caller-provided
buffer and returns the number of bytes written; dev_usage_show()
appends the trailing newline. The attribute is hidden via
uacce_dev_is_visible() when the driver does not provide the callback.

The corresponding ABI entry is added to Documentation/ABI/testing/
sysfs-driver-uacce.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 Documentation/ABI/testing/sysfs-driver-uacce |  9 +++++++++
 drivers/misc/uacce/uacce.c                   | 19 +++++++++++++++++++
 include/linux/uacce.h                        |  5 +++++
 3 files changed, 33 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-uacce b/Documentation/ABI/testing/sysfs-driver-uacce
index d3f0b8f3c589..3e4af4c1e5a9 100644
--- a/Documentation/ABI/testing/sysfs-driver-uacce
+++ b/Documentation/ABI/testing/sysfs-driver-uacce
@@ -55,3 +55,12 @@ Date:           Feb 2020
 KernelVersion:  5.7
 Contact:        linux-accelerators@lists.ozlabs.org
 Description:    Size (bytes) of dus region queue file
+
+What:           /sys/class/uacce/<dev_name>/dev_usage
+Date:           Sep 2026
+KernelVersion:  7.3
+Contact:        linux-accelerators@lists.ozlabs.org
+Description:    (R) Current usage of the device, reported as a driver-defined
+                string of up to PAGE_SIZE - 1 bytes. Usage is expressed as a
+                percentage (0-100). The attribute is hidden if the driver does
+                not implement the get_dev_usage callback.
diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 45521d4a56d1..545ba35a590b 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -433,6 +433,20 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
 	return count;
 }
 
+static ssize_t dev_usage_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct uacce_device *uacce = to_uacce_device(dev);
+	int ret;
+
+	ret = uacce->ops->get_dev_usage(uacce, buf, PAGE_SIZE - 1);
+	if (ret < 0)
+		return ret;
+
+	buf[ret++] = '\n';
+
+	return ret;
+}
+
 static DEVICE_ATTR_RO(api);
 static DEVICE_ATTR_RO(flags);
 static DEVICE_ATTR_RO(available_instances);
@@ -441,6 +455,7 @@ static DEVICE_ATTR_RO(region_mmio_size);
 static DEVICE_ATTR_RO(region_dus_size);
 static DEVICE_ATTR_RO(isolate);
 static DEVICE_ATTR_RW(isolate_strategy);
+static DEVICE_ATTR_RO(dev_usage);
 
 static struct attribute *uacce_dev_attrs[] = {
 	&dev_attr_api.attr,
@@ -451,6 +466,7 @@ static struct attribute *uacce_dev_attrs[] = {
 	&dev_attr_region_dus_size.attr,
 	&dev_attr_isolate.attr,
 	&dev_attr_isolate_strategy.attr,
+	&dev_attr_dev_usage.attr,
 	NULL,
 };
 
@@ -474,6 +490,9 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_isolate.attr && !uacce->ops->get_isolate_state)
 		return 0;
 
+	if (attr == &dev_attr_dev_usage.attr && !uacce->ops->get_dev_usage)
+		return 0;
+
 	return attr->mode;
 }
 
diff --git a/include/linux/uacce.h b/include/linux/uacce.h
index e290c0269944..8f0b9765e4b6 100644
--- a/include/linux/uacce.h
+++ b/include/linux/uacce.h
@@ -34,6 +34,10 @@ struct uacce_qfile_region {
  * @get_isolate_state: get the device state after set the isolate strategy
  * @isolate_err_threshold_write: stored the isolate error threshold to the device
  * @isolate_err_threshold_read: read the isolate error threshold value from the device
+ * @get_dev_usage: get the device usage. Write a string describing current
+ *                 usage as a percentage (0-100) into @buf, at most @size
+ *                 bytes, without a trailing newline. Return the number of
+ *                 bytes written on success or a negative errno on failure.
  */
 struct uacce_ops {
 	int (*get_available_instances)(struct uacce_device *uacce);
@@ -50,6 +54,7 @@ struct uacce_ops {
 	enum uacce_dev_state (*get_isolate_state)(struct uacce_device *uacce);
 	int (*isolate_err_threshold_write)(struct uacce_device *uacce, u32 num);
 	u32 (*isolate_err_threshold_read)(struct uacce_device *uacce);
+	int (*get_dev_usage)(struct uacce_device *uacce, char *buf, int size);
 };
 
 /**
-- 
2.43.0

