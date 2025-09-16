Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F8194A73;
	Tue, 16 Sep 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034101; cv=none; b=PWvPXsIs7l1axw1qHwRKf3oi9n2mfH/tqkvIuRlYc8joh4av30UMnwUtIZJF4SkfqVOOfnImzhR3Ru/S98/RBfVpHTuf4aeIi/u0l1e2Mpb01HGhQ2EpSnLqn6x1l0ZhdIuXmf46yj1fTw4XDjlYsb/YyE+IA6VlaHuJJP5XNuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034101; c=relaxed/simple;
	bh=oyU8qiw51dSJYMBKtoP/7t+jedY7k8+d7PdF3tyLLVs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZJnkLvq0DlGPAmXBVgMm2EU4ZQDD2iBHC1CqHMsWQzIkTebDldfX777tIkT1q1Mykj45w/LSVnO7VkwNRfAuBKpxQuSO1mCxwKpla9rzhlKyOm37EdlwdBnckPeMJC0e6hdso5sknjieH3l9kHJCxTZk14aKCvJt3AsUUZIpdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cR4Qd12XgzTgqY;
	Tue, 16 Sep 2025 22:43:37 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 89EC41402E9;
	Tue, 16 Sep 2025 22:48:14 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:14 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:13 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH v2 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
Date: Tue, 16 Sep 2025 22:48:10 +0800
Message-ID: <20250916144811.1799687-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250916144811.1799687-1-huangchenghai2@huawei.com>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
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
index 770a931ef68d..dda71492874d 100644
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

