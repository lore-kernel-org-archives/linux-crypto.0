Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E982F2A;
	Thu, 24 Oct 2024 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778496; cv=none; b=PIbvlYELpiVWg/z1LY/M/RvwMie8Q4PpSN3EyZGOY+AaWJHoAxIxdHkl0qaj+aB6Z4N0r5rLJz8dmtKtAFHOMEeZkRu14QrB8AOPWpTgj0ilnKyAzoUV0rJCultosWHmWJmAI8ACG3FFlMaJpEuqjUWl9a50Yf+D95qmDu2+jhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778496; c=relaxed/simple;
	bh=EYyETycH3az/VAkNMGSuo6bnoJz7qk/tLQlADD4QzMA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m8WZrmtq7ZmpjkiTqkarYDOFz4o9kYiurFgmyupDq4D2JTIOHW27LCHNxR7ZN49VDVDoPnp+UdpJ+sCmklobQQwaU3jb/FuPP+Ar7JBoXwHW+RrAT/lkEmUEuGNPgtL1zMkSrC6D+1hKJ1MM80PBI6y0nO8BZrIAy8QsFetMyD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XZ6wZ02kCz10Nc6;
	Thu, 24 Oct 2024 21:59:26 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (unknown [7.193.23.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C6DA18010F;
	Thu, 24 Oct 2024 22:01:29 +0800 (CST)
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 24 Oct
 2024 22:01:28 +0800
From: Wang Hai <wanghai38@huawei.com>
To: <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ahsan.atta@intel.com>, <mun.chun.yep@intel.com>,
	<markas.rapoportas@intel.com>, <damian.muszynski@intel.com>,
	<furong.zhou@intel.com>, <adam.guerin@intel.com>, <zhangxiaoxu5@huawei.com>
CC: <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH] crypto: qat - Fix missing destroy_workqueue in adf_init_aer()
Date: Thu, 24 Oct 2024 22:00:57 +0800
Message-ID: <20241024140057.18548-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600001.china.huawei.com (7.193.23.3)

The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
fix this issue.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index ec7913ab00a2..907144ec7e65 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -281,8 +281,10 @@ int adf_init_aer(void)
 		return -EFAULT;
 
 	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
-	if (!device_sriov_wq)
+	if (!device_sriov_wq) {
+		destroy_workqueue(device_reset_wq);
 		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.17.1

