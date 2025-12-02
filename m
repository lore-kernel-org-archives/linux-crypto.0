Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A32FF664;
	Tue,  2 Dec 2025 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655985; cv=none; b=PqvhR7Dn9yOGbLXKUpXXFylItbnJvGtbue38lmCyHcofXO3Iq1ECIg2SnyPKpHZCvEB1fVQGjCTGhnjCPdQATTr0QFVyM+DBDlX1aLcWooQEqxdP+OSeRv/GUCh6Sh0T/GoCyC02oZUSkMMRQGpjy7J8VO2iLEiwCLHKNeP1AWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655985; c=relaxed/simple;
	bh=gnrhT/h0A8AV79o6VCRZ1fL2+CeNshbrYlrotkJIksI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZkV00QaPJABLoNYQWf+jjRDNSgScDJ/83XeYLCTrhiNlkLY6F8aHW1OuiEXy0VQ9EMLOGQuRdxtDjbzaX1mugO1Pml1m21HABh80uoSbZmrA9gL5w4Jf53laCkSXtTWqg6lVGPizqQ27SBZtvVFhRserpxiGyOttx0xRx1n+QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=IMapymeC; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="IMapymeC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1Dm9bT+p9g52NqnB8W1+F9hfCBHyPZRbf4WhOd2TC04=;
	b=IMapymeCniJqdB6LlgTw/Xyky4elwfmYgSbJpl0YYVLjKZAoH6rCMPS8Fa2pja319hIz5bxXI
	6vf6ZP6GFoSxKDyFc0jejYrYqOyCmGN/BMwC9ExSxZMDfBBZr79aaDlqSolw2a4KpwoS0dlZ3TZ
	MkyVWG9movvDrNIw3KfEZlM=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dL9Pl2ljXzmV7L;
	Tue,  2 Dec 2025 14:11:07 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 08A22140143;
	Tue,  2 Dec 2025 14:12:59 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 14:12:58 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 14:12:58 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v6 2/4] uacce: fix isolate sysfs check condition
Date: Tue, 2 Dec 2025 14:12:54 +0800
Message-ID: <20251202061256.4158641-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251202061256.4158641-1-huangchenghai2@huawei.com>
References: <20251202061256.4158641-1-huangchenghai2@huawei.com>
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

uacce supports the device isolation feature. If the driver
implements the isolate_err_threshold_read and
isolate_err_threshold_write callback functions, uacce will create
sysfs files now. Users can read and configure the isolation policy
through sysfs. Currently, sysfs files are created as long as either
isolate_err_threshold_read or isolate_err_threshold_write callback
functions are present.

However, accessing a non-existent callback function may cause the
system to crash. Therefore, intercept the creation of sysfs if
neither read nor write exists; create sysfs if either is supported,
but intercept unsupported operations at the call site.

Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/misc/uacce/uacce.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 43d215fb8c73..b0b3c1562d52 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -382,6 +382,9 @@ static ssize_t isolate_strategy_show(struct device *dev, struct device_attribute
 	struct uacce_device *uacce = to_uacce_device(dev);
 	u32 val;
 
+	if (!uacce->ops->isolate_err_threshold_read)
+		return -ENOENT;
+
 	val = uacce->ops->isolate_err_threshold_read(uacce);
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -394,6 +397,9 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
 	unsigned long val;
 	int ret;
 
+	if (!uacce->ops->isolate_err_threshold_write)
+		return -ENOENT;
+
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
-- 
2.33.0

