Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B212FFF99;
	Mon, 18 May 2026 14:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114693; cv=none; b=mhZDum5ymIjA23M444mBEeNyvfHlHYyFcCGJT4Bk4q7d2u4Boz94P3rlCbNfU8rwrrVvVx9GzCprSTHiXJ7uYGYFaNJ1ilmPL5yhKIqE0x2/FOWHrI5/ZX6uXu7yl3iTElC3WqU31L/HVrRHpEa/GIBTV6wXBZdBA5Lgr8btMuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114693; c=relaxed/simple;
	bh=6zRLbEGja04YfEmsW+p0HxJ9Xzfe3NaD6Yc8rl9HLRs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZvMST66vVCPkb32aYTYFjB6mTJlPLPzRlC7Q6xMOXsEmZYb1j+rTt3lTwJ+/EjukjTCQdXPXjkKAodlnRyX909AeUIL9HZ333WhqadfJw5mLCxtu8jbEnm05GVF+fYDuePQ936eR1Mt0k5sAnlsU8fFtFPgt11wPxH0cNKQLXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0NCq3aI2; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0NCq3aI2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+8XT8O6CaNYjbH7mg1oZghNgUEHo6uC588vWWamN3tk=;
	b=0NCq3aI2aP4BoyoXRFdlHhcAgsqW/rSaDv41aRCYNXZYZ4HcNb0U6aEBa2xq4aTAv9hiPJiJP
	+4sjRBhlGzweUEjkrAASOEPDls8B23yvG3C3BUt0KgdKnBzdwLE6u2/OEnhYe+VrgHQHsW2bnYi
	pnXAhGevYk3wRK1eHikMV2E=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gK0R16yn0z1cyPh;
	Mon, 18 May 2026 22:23:41 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 0821440565;
	Mon, 18 May 2026 22:31:21 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:20 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 0/6] crypto: hisilicon/qm - support function reset and VF isolation
Date: Mon, 18 May 2026 22:29:50 +0800
Message-ID: <20260518142956.3593934-1-wuzongyu1@huawei.com>
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
 kwepemr100008.china.huawei.com (7.202.195.119)

This patch set adds function reset and function isolation capabilities,
and fixes issues related to reset operations.

1.Currently, the device only supports global reset when an error occurs.
However, some errors only affect a single function's operation without
affecting other functions. Therefore, the PF can notify the VF driver
to perform a reset, rather than using a global reset that affects all
task.
2.When device reset fails or the reset frequency exceeds the
user-configured threshold, the device on the physical machine will
be isolated. Add functionality for devices in virtual machines to
obtain the isolation status of the PF.
3.Support for doorbell enable control, which disables doorbell before
reset and enables doorbell after device initialization.

Weili Qian (2):
  crypto: hisilicon/qm - disable error report before flr
  crypto: hisilicon - mask all error type when removing driver

Zhushuai Yin (3):
  crypto: hisilicon/qm - allow VF devices to query hardware isolation
    status
  crypto: hisilicon/qm - place the interrupt status interface after the
    PM usage counter
  crypto: hisilicon/qm - support function-level error reset

Zongyu Wu (1):
  crypto: hisilicon/qm - support doorbell enable control

 drivers/crypto/hisilicon/hpre/hpre_main.c |  19 +-
 drivers/crypto/hisilicon/qm.c             | 334 ++++++++++++++++++----
 drivers/crypto/hisilicon/sec2/sec_main.c  |  13 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  20 +-
 include/linux/hisi_acc_qm.h               |  15 +-
 5 files changed, 308 insertions(+), 93 deletions(-)

-- 
2.33.0

