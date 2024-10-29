Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E05118DF60;
	Tue, 29 Oct 2024 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730214372; cv=none; b=Y4WlD1bpCBygGb7ZTPo1/Z719VcUgoXM5M/SM0RyIK8kKEoGdkyedkPp6LmidCBlPOEMplSRczsf2IQqbGNQQ2VEpXOScF73xiwiUA9zq34e0qSXDrOqLyj4hZNzFjBowCb4tDgJ8D1UTaeMDhqc/CA254G+uJc+vlSKWTKvgOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730214372; c=relaxed/simple;
	bh=C/R1pSYsTwmzSuMq7B2veX8My0kFlPqurD41bbFvGZk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uk+ETd8Xa7aUBn9vHVH5htqtoTkp+1chKbLk1p3A0bH1eqaEN/QgeSF4sAvCvm73YmJL3sUR2h9FofnGI5EUeRqBSWXqaiVVu5+M80e9n4HugLUQRAP9tddl8o3uwFKQ8cIHk6v99K6WaoSzhf8S/uzMlcRXOZlWM+1ar/1asTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XdD6f1HVmz1T9Lj;
	Tue, 29 Oct 2024 23:03:54 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (unknown [7.193.23.3])
	by mail.maildlp.com (Postfix) with ESMTPS id E4683140157;
	Tue, 29 Oct 2024 23:06:03 +0800 (CST)
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 29 Oct
 2024 23:06:02 +0800
From: Wang Hai <wanghai38@huawei.com>
To: <giovanni.cabiddu@intel.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ahsan.atta@intel.com>, <mun.chun.yep@intel.com>,
	<markas.rapoportas@intel.com>, <damian.muszynski@intel.com>,
	<furong.zhou@intel.com>, <adam.guerin@intel.com>, <zhangxiaoxu5@huawei.com>
CC: <qat-linux@intel.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH v2] crypto: qat - Fix missing destroy_workqueue in adf_init_aer()
Date: Tue, 29 Oct 2024 23:05:23 +0800
Message-ID: <20241029150523.52435-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600001.china.huawei.com (7.193.23.3)

The adf_init_aer() won't destroy device_reset_wq when alloc_workqueue()
for device_sriov_wq failed. Add destroy_workqueue for device_reset_wq to
fix this issue.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2: add 'device_reset_wq = NULL'
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index ec7913ab00a2..4cb8bd83f570 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -281,8 +281,11 @@ int adf_init_aer(void)
 		return -EFAULT;
 
 	device_sriov_wq = alloc_workqueue("qat_device_sriov_wq", 0, 0);
-	if (!device_sriov_wq)
+	if (!device_sriov_wq) {
+		destroy_workqueue(device_reset_wq);
+		device_reset_wq = NULL;
 		return -EFAULT;
+	}
 
 	return 0;
 }
-- 
2.17.1

