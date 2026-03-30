Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC76394490;
	Mon, 30 Mar 2026 06:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774851944; cv=none; b=s1tdVDGlgTzk78mS57cAmX61H+hbCg40XyfxA6a7QHikr+i86G3hANIQjhD85O6K8AwdxaELjT8pp7iHeDXc0lbA9r1aGuNYruZGMlVEQcu8Lgl6Hryaw+NRYBe2VxQKeAcFQuAumEnbpPouiSNUpc3QTYlbrOWQUz+RArkzKsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774851944; c=relaxed/simple;
	bh=9L8e7750CQ7WYuG8PyeOjdLciNxQLopB/tvRvVheT38=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGQXJyXkP+xOfXciz780MVPL7bgPmE0s+d4eGlXPdMfqQVNPPj4pGPER5fycGzL3LcvnhJstk9wUR+AQBf7XuqHseuEU+2Jk5Ah2/oK1Mon+Jwf9Ul3blWkKWjFgSJcRw9Qh+FlmTZbBkACdlxuJGtS/+bhat+MA1/YRqt4xFDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=eDk4zY1z; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="eDk4zY1z"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4Q4/hdG8r7RlOlRpzRWgODwIfL6Nka/KRUBqZxxKjAQ=;
	b=eDk4zY1z2e3jwol7kqwNAZ0iNYtrDfSbM9H6MtxNYXXX5mKVJgSRZrtCkuHoGAQI3qEYZcW60
	WE9FmCiMi168tdVCSOGpQBJgIu4qkoNjKI818O4hK3ATxjApJ+UqFjVT5PDPi2eUelaCu5L2q0L
	1841ywmhfbV6j3FKDjCbGoI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fkh1k1Hqyz12LDF;
	Mon, 30 Mar 2026 14:20:10 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id B558D40569;
	Mon, 30 Mar 2026 14:25:34 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:34 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:33 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <yinzhushuai@huawei.com>
Subject: [PATCH 3/5] crypto: hisilicon/qm - remove else after return
Date: Mon, 30 Mar 2026 14:25:29 +0800
Message-ID: <20260330062531.2976138-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260330062531.2976138-1-huangchenghai2@huawei.com>
References: <20260330062531.2976138-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Else condition is not needed after a return, remove it.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index d1626685ed9f..0588355920dd 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4278,8 +4278,8 @@ int hisi_qm_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	if (num_vfs == 0)
 		return hisi_qm_sriov_disable(pdev, false);
-	else
-		return hisi_qm_sriov_enable(pdev, num_vfs);
+
+	return hisi_qm_sriov_enable(pdev, num_vfs);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_configure);
 
-- 
2.33.0

