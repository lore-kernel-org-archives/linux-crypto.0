Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A752EBBA8;
	Tue, 11 Nov 2025 09:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762853744; cv=none; b=Bsz2OdZ9UHNqOFBBIGXh/SvIfoHB0/T2x2Bkw8AFUQdAzfp3NQ4p594IMsAZVkGtzP9EIW79dkZ4pEiP58ASLYw/2sGPpqJmYrM2aNfIpiLKyIb+Mk4X94MKT9H8dgwyNhXqMJQ6cTooKLuCmTX3mmYE6guF2uQP6oGYeTd8/do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762853744; c=relaxed/simple;
	bh=E6KJGY2NnOystmBSmxWUXTAFEsWXwwbGyBNkx2M4t88=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nO61yKm83Ovny3gQXFdAPHROg/F5x4aUCsYKteasofFZfKisfhjdVjNfxorsl9gm8fImLNLPF91v4nCTJlbSCAZTEl2son9jf+k+T5T7l65BJDCNg+Naw1KqP1wcSLiB8w5Z+kHdxzJjU0FVzeP8nfVVvJE9yaIa9licGddzQhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Bul3pR2u; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Bul3pR2u"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tkVAbGmNXJDBO8/rAN7phTaaQOlazIRlRDmypJmRr1w=;
	b=Bul3pR2uNBCAvUUgkdJM2H7toFEyEj0zzkYaAcRROPsm94Jde/QfocxAVhyccQflnkVEMjRB9
	liWCbq3dUs7xAK8AuUF+kHM+vvIfPdSdhKeZK+QASAU9K6/OBPr9YTMlSfTn3Ev5wlojZ2WMSSp
	6NUWuo4U/fOgo4ROL9cmmYk=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d5LvX1z6YzmV8L;
	Tue, 11 Nov 2025 17:34:00 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 50D33140158;
	Tue, 11 Nov 2025 17:35:39 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:39 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:38 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v5 3/4] uacce: implement mremap in uacce_vm_ops to return -EPERM
Date: Tue, 11 Nov 2025 17:35:35 +0800
Message-ID: <20251111093536.3729-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251111093536.3729-1-huangchenghai2@huawei.com>
References: <20251111093536.3729-1-huangchenghai2@huawei.com>
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
Acked-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 drivers/misc/uacce/uacce.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 8a0cb38d9a3d..f2296fc9fa4e 100644
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

