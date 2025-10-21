Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65BD22B8CB;
	Tue, 21 Oct 2025 13:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054613; cv=none; b=kkEbwmUCH/T8Nu0r/lPR0quExqFvNKVmXDYRi1hBWXDr8mr/tvOzGTH3xSoV76RdfQsp2vSlp1iWg9fQuSWeCKW3YAGtwdpsxYI19kUg4rI4WAnbTFjoj6/RTfL3FPMDDzlUZqa2AG+WLgvPWFTbwhYUUro3UaGl+X1GhLfFOnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054613; c=relaxed/simple;
	bh=kpmwgAUt/JX9IN+RW7ZW5CdLSXeY9k7z3Cr+RzWrnbk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/oqxUhnaofCcEDhZpoystJ6+bZ91Gi9uwyl0IARN5KE/9QsXgUxdN5CVY8C/5lmJsKUdrA4HXLWzvaa5PWYuDxFDM50OdVjuKSSPocGLfj8g0Pwb2JQGQMBk8T36fjQexMigT4w6vaaPKpTGJmIcZ6fslMMBWJDqvX2LwXUCjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rfXFWHYO; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rfXFWHYO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JBTdOkRodgvGwfoSt6YtVfH2mVh3oYR8dryGCsqDCzc=;
	b=rfXFWHYOKIFsTT7Nuqjip598RNiZaUQUTMZQgNRpSItF8llY1RBHE/JSZkkImM4A60ZrxgxEN
	egNpotdZUIgNEZQBEcbwnEsEXKeoYnzp3xkyChMQup2pNF7IAqdSY7uozHTXzhCraID3j7BMQIZ
	QyZZ1Btfu3jTG599wg2+TeA=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4crYZF4rrCzKm5G;
	Tue, 21 Oct 2025 21:49:41 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A4F1A140120;
	Tue, 21 Oct 2025 21:50:05 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:50:05 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:50:05 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v3 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
Date: Tue, 21 Oct 2025 21:50:02 +0800
Message-ID: <20251021135003.786588-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251021135003.786588-1-huangchenghai2@huawei.com>
References: <20251021135003.786588-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Yang Shen <shenyang39@huawei.com>

The current uacce_vm_ops does not support the mremap operation of
vm_operations_struct. Implement .mremap to return -EPERM to remind
users.

The reason we need to explicitly disable mremap is that when the
driver does not implement .mremap, it uses the default mremap
method. This could lead to a risk scenario:

An application might first mmap address p1, then mremap to p2,
followed by munmap(p1), and finally munmap(p2). Since the default
mremap copies the original vma's vm_private_data (i.e., q) to the
new vma, both munmap operations would trigger vma_close, causing
q->qfr to be freed twice(qfr will be set to null here, so repeated
release is ok).

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index e3433d95640a..747efb2d36f5 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -214,8 +214,14 @@ static void uacce_vma_close(struct vm_area_struct *vma)
 	}
 }
 
+static int uacce_vma_mremap(struct vm_area_struct *area)
+{
+	return -EPERM;
+}
+
 static const struct vm_operations_struct uacce_vm_ops = {
 	.close = uacce_vma_close,
+	.mremap = uacce_vma_mremap,
 };
 
 static int uacce_fops_mmap(struct file *filep, struct vm_area_struct *vma)
-- 
2.33.0

