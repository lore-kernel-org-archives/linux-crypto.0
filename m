Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E442EA744;
	Sat, 25 Oct 2025 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387192; cv=none; b=dZ60nMyi31oyTRoOHcO4tDu3Y/r6ZTPytcymdkTAj/nflNXgK/Bg9niZMi+cyTu8lh3ZLdWKIUmhN5PhDKc3VRltKCasxBSuplgYEvD7sFDXBWUAY7i7HONufAz6kQVtlQGzExkfQ4IHKcNaRcyivWPnclfT46SspJ64QBhZKEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387192; c=relaxed/simple;
	bh=7qAFrOqHQqL/N9b2GOMeXhE1wZha/G4+phmlaVglsw4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ad30Pyu1jVRtLYkJL282o0oMiv4WTZoGvoT/26MzZVdZhl+59YeCDzoNJvW1PmlwyBHJ1lCtdEaTvvIYxuY4fiGqKdlifgNV49XJlMwNtCl4pSYQ2QyfKJ1WNApmPV2kt1lq8UnjS5QGEFfKZjJwKrI6Z8EEj2Lw+leLJAwTvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2Z+M4ydR; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2Z+M4ydR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dImqEllVv0WBv8WKcE++wx2EPyDK7ZOeok9lsbf3yUo=;
	b=2Z+M4ydRJ+rc8Y7w1vUaHPmwPCtunmxGlBe3lPDAJSyVsQREMiKDcjizvLVENb+R+sM6khCPV
	Fv2StPKu7BbgR6Qaj4HURq8eTxPWHiG8EOjrmM13NdchWpnlABmASg387RI1Qj/C9FfPWpY1m8Y
	faIPc6jwOOdQiCnmkxXk9dE=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4ctwYw1NJDz1K97v;
	Sat, 25 Oct 2025 18:12:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E78041402C4;
	Sat, 25 Oct 2025 18:13:01 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:01 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:01 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - add missing default in switch in qm_vft_data_cfg
Date: Sat, 25 Oct 2025 18:12:58 +0800
Message-ID: <20251025101258.2793179-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251025101258.2793179-1-huangchenghai2@huawei.com>
References: <20251025101258.2793179-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: nieweiqiang <nieweiqiang@huawei.com>

Add default case to avoid warnings and meet code style requirements.

Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c58f67567c12..a016a7d6059c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1286,6 +1286,13 @@ static void qm_vft_data_cfg(struct hisi_qm *qm, enum vft_type type, u32 base,
 				(factor->cbs_s << QM_SHAPER_FACTOR_CBS_S_SHIFT);
 			}
 			break;
+		/*
+		 * Note: The current logic only needs to handle the above three types
+		 * If new types are added, they need to be supplemented here,
+		 * otherwise undefined behavior may occur.
+		 */
+		default:
+			break;
 		}
 	}
 
-- 
2.33.0

