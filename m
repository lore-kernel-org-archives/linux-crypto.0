Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E323B66F;
	Sat,  1 Jun 2024 02:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717210321; cv=none; b=ka+hofhbcuFPLFSvKoRvGz523j+BxkINOvh4JBoXVtwwnoGUlbD8SyJjHvGlhDLK4VjvZJwWq5/whQ8CjqNFpkbwWvA8DUBTmitJMrFo5A6oDT6MMfKR9Vib7jLmlpwbZtlmENrAP7eQgmktdm6cYBTs+/cc/EwtdI+2wr1eT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717210321; c=relaxed/simple;
	bh=Qfgl0Biv0aP0AfSr2hL0ISOr/2WJn7Y3CpP9bolN+HY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Yen7Q+j8lYVebDGc4i4OGotd5PL7yrAJObPMcMM9TsmCq1RsaLeA9hXBlsuCfY7wOcskEaBjk4pkt96QCCq8DZRKlbf/BVZKNbHFU2JBn9Bo4DgMo9ATVq4JAAztH/Qj/68a+M5tKoLId+Nc3sfVm58Z5HxDOwWJyzPTX6L0dwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Vrktm514nz1S4rK;
	Sat,  1 Jun 2024 10:48:00 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 78DD2180AA4;
	Sat,  1 Jun 2024 10:51:51 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 1 Jun 2024 10:51:50 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH V3 0/2] crypto: hisilicon - adjust vf configuration sequence and optimize zip reg offset
Date: Sat, 1 Jun 2024 10:51:48 +0800
Message-ID: <20240601025150.1660826-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

The VF enabling and disabling issues are fixed, and the ZIP address
offset calculation is optimized.

Chenghai Huang (2):
  crypto: hisilicon/qm - adjust the internal processing sequence of the
    vf enable and disable
  crypto: hisilicon/zip - optimize the address offset of the reg query
    function

 drivers/crypto/hisilicon/qm.c           | 11 ++----
 drivers/crypto/hisilicon/zip/zip_main.c | 48 +++++++++++--------------
 2 files changed, 23 insertions(+), 36 deletions(-)

-- 
2.33.0

