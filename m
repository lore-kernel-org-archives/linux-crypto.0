Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA634DCE0;
	Mon, 18 May 2026 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114700; cv=none; b=Miwz6swz7CxA1oeEnNIWalixLT88H8hzOX8ZBPBIl/ryVg8NN6YShAlvf02GSs/+UPstFZb2w33c8/oHHpW6W3r21YPl20NGMNiNEGcyvCxtYhF/Oqw163fybWtJQ1GrN1KQo7QHsg/jWcXTnI0rKGl7Y7qz9m2/pfgSC3Rn80U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114700; c=relaxed/simple;
	bh=Dny62flpyxSIaHOIPzJwEjSbXvjdT2/chld/2RBl/A8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JtcxiSZGoif6Fe99yspfVidWwoo6KUgAmx7r0ddSnvTT5+0xjcSr9/MYLAjb5dHmw30EsJIAYCgrbUKZ144ZgEdVnW72qZHTkgY1l3nx8dNIqPvTTeW5CIkG2h8MZoBmALYMK0bl94MZnhzlpg6LimHXWvQ2wTmngq0+yTYA9Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pb9n04I3; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pb9n04I3"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ULEOw3on9FfRcUp7ebO5U4gWY+T/kPQ2BQKR5dnyFlg=;
	b=pb9n04I3ApvVdDP6dgWIAZc+JE5ME5t13lOfRZiUrde1GfNi0zkZjlFi+SCyR6tnzSUVA7uLT
	XCgEyoStI51tPcztZ6x9E2ONwr1PUqOA4MTgHX4GY+qwMCLZkz0GvESG+wXoxIoKPfUU2X0xjiP
	BEiXk8tigVT0vQWA+5qcpWA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gK0Rp3xv8znTV5;
	Mon, 18 May 2026 22:24:22 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E7BB40572;
	Mon, 18 May 2026 22:31:22 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:21 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 4/6] crypto: hisilicon/qm - disable error report before flr
Date: Mon, 18 May 2026 22:29:54 +0800
Message-ID: <20260518142956.3593934-5-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260518142956.3593934-1-wuzongyu1@huawei.com>
References: <20260518142956.3593934-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Weili Qian <qianweili@huawei.com>

Before function level reset, driver first disable device error report
and then waits for the device reset to complete. However, when the
error is recovered, the error bits will be enabled again, resulting in
invalid disable. It is modified to detect that there is no error
before disable error report, and then do FLR.

Fixes: 7ce396fa12a9 ("crypto: hisilicon - add FLR support")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2b3132595e42..90b447b934c6 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5004,8 +5004,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -5022,6 +5020,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.33.0

