Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3536DCE1;
	Mon, 30 Mar 2026 06:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774851939; cv=none; b=rSD0mRkxu4FV9iTWz+jKCxxl37Hls10rdznxtWkL69TIX4H/3kF4jzfZzrWeQ7oZ1NLv4ts1b2OY2ss8h/F8Y5wFC0ufhl+0k/j0ZSTlARS7EyZ1eXNhUYtWx6pJFMaBaGXEkzmDx9/rNAvvz1VNGb49VorcgpKwnL+0CImeiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774851939; c=relaxed/simple;
	bh=7KanPuewHIOLBesG3BaN02X+/HFdP2sq5BsR6u0HqAw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tx9hpR5VFyJJTrelqJ8uUh34EbZKFmVT4DRuzSAfGZWAd+QVI8WPNCpfZFFb8RirvtEJQfC0zBCnwL0FXJyzCJTn8KJ0JOoCFDglk2XP8GWKVEe3gQcdkhkCgcy6dbV9zja2kP8+3GXwo07g3djg3lSna1hDY55RDWGONzNfyhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AkYu1nUf; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AkYu1nUf"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Xlag/lRv/euF55TRCqUD67CXI1xKrYaszh8bt07tpDU=;
	b=AkYu1nUfqP0KdC8/0G2LX8MIPSqczVqtdAkHNs1DiGXfzfCSxINbWYSv+DiaT1wYos0PzViR+
	0oceKzE1JM9TXYG2+6W5H7f4pHvzY2hC5libQ6nVjdgwM20AfWXAtcL1KXtGtBt2tr5jjCVjGR/
	9uFl7AFdN9d4C5s5kwOcwag=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fkh1h3Z6LznV4L;
	Mon, 30 Mar 2026 14:20:08 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 5DD3540561;
	Mon, 30 Mar 2026 14:25:33 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:33 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 14:25:32 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <yinzhushuai@huawei.com>
Subject: [PATCH 0/5] crypto: hisilicon - series of cleanups and format fixes for hisilicon driver
Date: Mon, 30 Mar 2026 14:25:26 +0800
Message-ID: <20260330062531.2976138-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

1.Fixed a format string type mismatch issue identified through static
analysis and code review, which could have caused display errors.
2.A const qualifier addition to improve type safety.
3.Removing unnecessary else statements after a return.
4.Removal of redundant variable initializations that are overwritten
before their first use.
5.A cleanup of unused and non-public APIs to shrink the public interface
and remove dead code.

Chenghai Huang (4):
  crypto: hisilicon/qm - add const qualifier to info_name in struct
    qm_cmd_dump_item
  crypto: hisilicon/qm - remove else after return
  crypto: hisilicon/qm - drop redundant variable initialization
  crypto: hisilicon - remove unused and non-public APIs for qm and sec

Zhushuai Yin (1):
  crypto: hisilicon - fix the format string type error

 drivers/crypto/hisilicon/debugfs.c       | 22 +++++++++++-----------
 drivers/crypto/hisilicon/qm.c            | 16 ++++++++--------
 drivers/crypto/hisilicon/sec2/sec.h      |  2 --
 drivers/crypto/hisilicon/sec2/sec_main.c |  2 +-
 include/linux/hisi_acc_qm.h              |  2 --
 5 files changed, 20 insertions(+), 24 deletions(-)

-- 
2.33.0

