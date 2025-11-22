Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164B5295DB8;
	Sat, 22 Nov 2025 07:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797769; cv=none; b=j5QSEAJb5l9OKNsQMdLVD5Ky4ptl464K8O8key1hYXssgRDmrcOImO0W5KqnIdrsYwLFAW+ehKsB5Y4XnWSBogtIGbheH3UNcUmZeHbkQ4TIhi6PvDJDK9eKU3Drfn+YfsuW9FLrQChf7bxYnlxP9zqjNIYYfaDb+vSNGZSSZ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797769; c=relaxed/simple;
	bh=Z4kIeXIGnw7H9/YLtqeMUfkl3wVlAhl4iOc/bmtfhIc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u9/5EEQD5PXm3lv8iBCjtGnlyh76iFdN9d6RtvycMWh6pLe048QYak56WLHUPT6bWkF57m8iKiQGRJ/IGPdrHMS05aN3IWxLM4YObdGmBC7gmE1SMY1DXVYMpBUf5jRjfTkYyyssPNreFxD0Dj82DVHHHG2HzNMe9HqYMNM0pwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ktB8kfl1; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ktB8kfl1"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kGn1mg8TksjCVTTlvI2LDH+0hOt8m8HRDK+RlD2Zz+M=;
	b=ktB8kfl1U9LWU/o2jgSRWGXMb0mGAqJR5D3ZAYtBTPkERSwlSu82Q6S4TZaHxmuBzCiFNjXPL
	4npvkQl0EIFtpR97CJJK/Yy2IaT5BUhsTAexg0OkayGinzYeISOL4SmlbkDocYZXPnRjBvI7SYR
	dQiT5nAIDoSHuVHjidnSpcU=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dD41z5sFzz12LCj;
	Sat, 22 Nov 2025 15:47:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C67FB1402DF;
	Sat, 22 Nov 2025 15:49:17 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:17 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:16 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v3 00/11] crypto: hisilicon - add fallback function for hisilicon accelerater driver
Date: Sat, 22 Nov 2025 15:49:05 +0800
Message-ID: <20251122074916.2793717-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

1.Supports multiple tfms sharing the same device queue to avoid tfm
creation failure.
2.Support fallback for zip/sec2/hpre when queue allocation fails or
when processing unsupported specifications.

When pf_q_num is less than the number of tfms, queues will be
obtained from devices with fewer references and closer NUMA
distances(priority: ref counts -> NUMA distances).

We can test by zswap:
modprobe hisi_zip uacce_mode=1 pf_q_num=2
cat /sys/class/uacce/hisi_zip-?/available_instances
echo hisi-deflate-acomp > /sys/module/zswap/parameters/compressor

---
V2: https://lore.kernel.org/all/20250818065714.1916898-1-huangchenghai2@huawei.com/
Updates:
- According to crypto framework, support shared queues to address
  the hardware resource limitation on tfm.
- Remove the fallback modification for x25519.

V1: https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
Updates:
- Remove unnecessary callback completions.
- Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.

---
Chenghai Huang (8):
  crypto: hisilicon/zip - adjust the way to obtain the req in the
    callback function
  crypto: hisilicon/sec - move backlog management to qp and store sqe in
    qp for callback
  crypto: hisilicon/qm - enhance the configuration of req_type in queue
    attributes
  crypto: hisilicon/qm - centralize the sending locks of each module
    into qm
  crypto: hisilicon - consolidate qp creation and start in
    hisi_qm_alloc_qps_node
  crypto: hisilicon/qm - add reference counting to queues for tfm kernel
    reuse
  crypto: hisilicon/qm - optimize device selection priority based on
    queue ref count and NUMA distance
  crypto: hisilicon/zip - support fallback for zip

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Weili Qian (1):
  crypto: hisilicon/hpre - support the hpre algorithm fallback

lizhi (1):
  crypto: hisilicon/hpre: extend tag field to 64 bits for better
    performance

 drivers/crypto/hisilicon/Kconfig            |   1 +
 drivers/crypto/hisilicon/hpre/hpre.h        |   5 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 416 +++++++++++---------
 drivers/crypto/hisilicon/hpre/hpre_main.c   |   2 +-
 drivers/crypto/hisilicon/qm.c               | 215 +++++++---
 drivers/crypto/hisilicon/sec2/sec.h         |   7 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c  | 159 ++++----
 drivers/crypto/hisilicon/sec2/sec_main.c    |  21 +-
 drivers/crypto/hisilicon/zip/zip.h          |   2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 130 +++---
 drivers/crypto/hisilicon/zip/zip_main.c     |   4 +-
 include/linux/hisi_acc_qm.h                 |  14 +-
 12 files changed, 578 insertions(+), 398 deletions(-)

-- 
2.33.0

