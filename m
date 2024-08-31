Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A40214D449;
	Sat, 31 Aug 2024 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725097815; cv=none; b=vAZX9GYU3y2Uv0448RgW5pdSMZCSH7tTueY/4fvn2PPNlSWzg05E/php5qeBKmJWq6pP67/D2koLMJQwJEG1XCBhp6LpCSo7Gbz0oIFIeclMkVsPYJFgPosxrH98URpu5Teuvg+wxSR81F3o0Q37TsCZLZglKNqQj1/RvJeQtBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725097815; c=relaxed/simple;
	bh=64yF2NXKdFnW7YvKhLozImFBdDcYXIY1Twfbm6snMi0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A+K92wdI0Q5CrRvd4vEBlfL1uFZIBgFlPMhZOft7u9OKbXm46pJsLRUNkG1go0wvMHugAFSh0/DeLsimDltsHnpFCPjQ6oshW1mp54kQvLSKZ2vI7GK/z09qPLa5BNaom2d978yU3Xj4AMawxBicJ2MEjBXBhZwULNerFlXQA5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Wwqxc0bsDz1j7vx;
	Sat, 31 Aug 2024 17:49:56 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 09358180043;
	Sat, 31 Aug 2024 17:50:11 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 31 Aug 2024 17:50:10 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH v2 0/3] crypto: hisilicon - fix resource contention and abnormal branch processing issues
Date: Sat, 31 Aug 2024 17:50:06 +0800
Message-ID: <20240831095009.446780-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix the queue resource competition issue in hpre and zip.
2. Fix the abnormal branch processing problem in sgl.
3. Adjust the header file and printing format problems in trng.

---
Changes in v2:
- Rebased on top of the merged spin_lock type for zip_crypto.

---
Chenghai Huang (2):
  crypto: hisilicon - add a lock for the qp send operation
  crypto: hisilicon/trng - modifying the order of header files

Yang Shen (1):
  crypto: hisilicon - fix missed error branch

 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  2 ++
 drivers/crypto/hisilicon/sgl.c              | 14 ++++++++++----
 drivers/crypto/hisilicon/trng/trng.c        |  4 ++--
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  3 +++
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.33.0

