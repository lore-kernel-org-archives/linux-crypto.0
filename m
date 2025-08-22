Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179142F6185;
	Fri, 22 Aug 2025 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755859151; cv=none; b=ojU1K5tFnWDKdM2aeyRxCxyPR3KfEoe+5SrqEZfXD8KnLwy7TVsIKcPbyaZk52AJAVrsSxMNH1CETJBZfT/vCgR/OGPbagpcvafKKQcz1TewnfDI8FguOZwKvzirrwjNSwApWlFjfeswHcPgjRniHhH63JhOOv+ZkYVS35hN1Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755859151; c=relaxed/simple;
	bh=dTmHS+SXwmigGt+qIm+6F1mMEbPr3KsBXmdDhWkQLv8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lHtOCDVDlOotU6JjI1nZbpSVx+FPOhxshyS2i768BLCld/b8F4zo4hXbVE1wLbU85idxTfKTd8RjCRcKi0s6l3Bauz4OMmPoj5fKQRnVQ90b3NpFSbH+0XxzkvacKQU8KRuiZH6Wonb5u+hxxX8yvREy9byW8GuWvniPuxdx4kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c7c4k6LskzPqWq;
	Fri, 22 Aug 2025 18:34:30 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D3534140257;
	Fri, 22 Aug 2025 18:39:06 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:06 +0800
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
Subject: [PATCH 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
Date: Fri, 22 Aug 2025 18:39:03 +0800
Message-ID: <20250822103904.3776304-4-huangchenghai2@huawei.com>
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

From: Yang Shen <shenyang39@huawei.com>

The current uacce_vm_ops does not support the mremap operation of
vm_operations_struct. Implement .mremap to return -EPERM to remind
users

Fixes: 015d239ac014 ("uacce: add uacce driver")
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 6a38809ca819..531a24145ba4 100644
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

