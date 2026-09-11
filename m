Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A3542BE93;
	Fri, 11 Sep 2026 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122593; cv=none; b=mghXhG/IA6Dqy/ohKbusrEZY0z8cs5CaZrF/3UopjHj5JW5IQkF+BfQkRYl0PbmbQ/c4XxyB0Z/BuBJGeeVLYnpYfWGBXkAMlOU0VOJKc5eL9jaZwcYmmcKKkpUAeJkscaB5W68+loWbUAQP2UwN2OczPN51CFD2DqH98IHiq3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122593; c=relaxed/simple;
	bh=6+yM8RyY0lple2vyuGGrfcoOL61ZK5XFYhTCEXNR6qk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDiOcB+uiUWxscPjLDvJCLF4fyQDAqBvRJv1wY7PxZFPFu2KfV2BogSG5XlWNT6JO/ZUEWOT3dXRlvFOowOI60S+4Adc9CXXytyQ/9wtO9kKSbD8jdGXNnZdD/yRLBtuB+JxP/CoWCvcSazzVgSIpG12C8g8vEM9Nm6JBMTudS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5jnA4dq9; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5jnA4dq9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1vC1dipBzi5VPWTFrtqb/gr0BglC0lgOI2GhnaEr1Zs=;
	b=5jnA4dq9VaC1/snZXKcsPc//A28fFhigwffGtmTHC4SVVKeORkDhZ24Ar1CghN83oHQ5lXzoT
	VABzjh5VI7i0rxPa6/moKL0cEoXEDJrkkOvSEU8x4sdNWQEPH1dlqWAW5uQxSHTCHCqRctO+PMv
	Tyw5GU+b7OEiDr2dxJl5B+A=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hh9VD52pVz1T4Mc;
	Fri, 11 Sep 2026 18:18:12 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 212C8202E6;
	Fri, 11 Sep 2026 18:29:47 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:29:46 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - fix memory leak in hisi_qm_sort_devices
Date: Fri, 11 Sep 2026 18:29:41 +0800
Message-ID: <20260911102942.387778-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911102942.387778-1-huangchenghai2@huawei.com>
References: <20260911102942.387778-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

From: Wenkai Lin <linwenkai6@hisilicon.com>

hisi_qm_sort_devices() allocates a struct hisi_qm_resource for each
QM device and inserts it into one of two local lists (non_full_list
or full_list).  If kzalloc() fails mid-loop, the function returns
-ENOMEM immediately without freeing the resources already inserted
into the local lists.

Because the splice into the caller's @head list happens only after
the loop completes, the caller's free_list(&head) cannot reclaim
them, so the already-allocated res entries are lost.

Fix by freeing both local lists before returning -ENOMEM.

Fixes: 2a75decec119 ("crypto: hisilicon/qm - optimize device selection priority based on queue ref count and NUMA distance")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e915cacef5c0..0448c68dbde4 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3846,8 +3846,11 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
 			dev_node = 0;
 
 		res = kzalloc_obj(*res);
-		if (!res)
+		if (!res) {
+			free_list(&non_full_list);
+			free_list(&full_list);
 			return -ENOMEM;
+		}
 
 		res->qm = qm;
 		res->distance = node_distance(dev_node, node);
-- 
2.43.0

