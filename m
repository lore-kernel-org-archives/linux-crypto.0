Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B831C2EA46F;
	Sat, 25 Oct 2025 10:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387185; cv=none; b=bySY/pSNpCpRFh5gT8c3nv06dLrOCbWs6wiVseowmHn2oxtokNQoa0nfeDYNylKXHb2zNcOndRpie5AAgfpNRu/bCCLaX2voD330VMIyU1W1B0RMThP6A2HaH84yZoE48Zc3xdfhmxwKgwR7Z9Px22qEGy2lojNb1nOuWGsR5dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387185; c=relaxed/simple;
	bh=LiRJO0uqrTqoomhsftTGBDGSwayh7lHgVXGED2QgW/o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EtyPnQdmFPD/0jJhBHwXz00uUuBiS6wdPkEkM7tM4oGndkQCU6Sln81YAxRK9inAa68zEalaFQX8d41XaGYVzP7jqsndDF1f/u5ZAWQmP+md8jX937SJRZmQDyiXs7rQZux0eMg0DIUtQ2JmqfRKIVL4bAwnL9K6wgdGxOfEEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cMEAVVAf; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cMEAVVAf"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ICUYgriAX66Ic6nFV4wDFOSrOFuC1F2rghUO8grP7d0=;
	b=cMEAVVAfShUlEhAxrzruzN6ToUQAFQVcmd08dnyQIA3X8e3DphMITQiRp3JXazC4BQVIXJSAK
	gBLyLe9KYVjQAzy17+62yWalwrZj9ltwtF5teHNyopmDmec3+0MrQZHfDfqb7Tm5pPRPipvK1xf
	E2zQ1vkdHJ54+HAkGw6hciI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4ctwYs1jzgz1prLt;
	Sat, 25 Oct 2025 18:12:33 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 17C9C180488;
	Sat, 25 Oct 2025 18:13:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:12:59 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:12:59 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH 0/4] crypto: hisilicon - various cleanup for QM and SGL
Date: Sat, 25 Oct 2025 18:12:54 +0800
Message-ID: <20251025101258.2793179-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This patch series addresses several issues in the hisilicon crypto
driver:
Patch 1: ensures proper synchronization when reading eqe/aeqe
values by saving the complete 4-byte values atomically. This
guarantees the valid bit and queue number are read as a consistent
pair that was written by the device.
Patch 2: adds concurrency protection for the err_threshold variable
to prevent race conditions between sysfs operations and hardware
error handling functions.
Patch 3: removes redundant error checks for curr_hw_sgl since
acc_get_sgl() cannot fail after mem_block creation, simplifying the
code.
Patch 4: adds a default case to a switch statement in
qm_vft_data_cfg to comply with coding style and prevent compiler
warnings.

nieweiqiang (4):
  crypto: hisilicon/qm - add concurrency protection for variable
    err_threshold
  crypto: hisilicon/qm - add missing default in switch in
    qm_vft_data_cfg
  crypto: hisilicon/qm - add the save operation of eqe and aeqe
  crypto: hisilicon/sgl - remove unnecessary checks for curr_hw_sgl
    error

 drivers/crypto/hisilicon/qm.c  | 41 ++++++++++++++++++++++------------
 drivers/crypto/hisilicon/sgl.c |  5 -----
 2 files changed, 27 insertions(+), 19 deletions(-)

-- 
2.33.0

