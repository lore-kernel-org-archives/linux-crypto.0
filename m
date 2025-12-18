Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59133A6F5;
	Thu, 18 Dec 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065512; cv=none; b=cXYkxvB3lroN6yM4ZrBJWMWkHWTg2S1wRI3rDS3Qss6SR+gU1/AmhtayGeI+CvAq7baNrpbjjL8Xluu5BxWqzzmyiRnD5JHfJ+uVJzpDVumv2e5UhVuTyLE9JMig8muNQoHPn/9YdjgvQszTA6jpz5HrpLe8T1PrxPFpK4VQ3vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065512; c=relaxed/simple;
	bh=DdNQ498LrxaASOGa7RbYn5gp7YxrdSo1Kun3JJjIiXE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UaoIGeUEz3la820sW0SEI52yq8XFrr/bZRp7ZDDtD0FSl90OMgvaJgT1kaxVGE7UnGl2zmGhoyYqu6PJfJ3ivc+EFBB1YhFKLdrIsQKOUnFd13QKJ/H+9d01HK1ZUDr3OAxlmeOGK4HPlIVpWQsbkXgPwiCRGgQtrLyG5S39+J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=fPL8UjhP; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="fPL8UjhP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yU9Ys/NiP5s9lgtFg3DJTLqNFVjv5+rp7igiW3f7IwI=;
	b=fPL8UjhP2gV1V/FLs5xXgAaXZoM6WMI99SrJjnwbOcy8kyo4YCrPZShCkRWM/fe87YXvMCQDZ
	LorzqNhrapLKAPG7fGd3yKoBw0VADaaKqmqLtsPQ5nTF+0a/bUGjxnPXeLY2IOU2bgypGkQYceN
	nKmBFcWCcKkJegtu0FaNzfQ=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfX6HM2zmV69;
	Thu, 18 Dec 2025 21:41:56 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DF2BB1402C4;
	Thu, 18 Dec 2025 21:45:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:53 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:53 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 00/11] crypto: hisilicon - add fallback function for hisilicon accelerater driver
Date: Thu, 18 Dec 2025 21:44:41 +0800
Message-ID: <20251218134452.1125469-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
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
V3: https://lore.kernel.org/all/20251122074916.2793717-1-huangchenghai2@huawei.com/
Updates:
- In patch 7, fix the issue of skipping qp enablement due to incorrect
  reference count judgment.
- In patch 6, Supplement the device power wake-up operation before
  applying for the qp.

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
 drivers/crypto/hisilicon/qm.c               | 206 +++++++---
 drivers/crypto/hisilicon/sec2/sec.h         |   7 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c  | 159 ++++----
 drivers/crypto/hisilicon/sec2/sec_main.c    |  21 +-
 drivers/crypto/hisilicon/zip/zip.h          |   2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 133 ++++---
 drivers/crypto/hisilicon/zip/zip_main.c     |   4 +-
 include/linux/hisi_acc_qm.h                 |  14 +-
 12 files changed, 574 insertions(+), 396 deletions(-)

-- 
2.33.0

