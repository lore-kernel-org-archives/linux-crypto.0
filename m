Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F976143879;
	Mon,  6 May 2024 11:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996800; cv=none; b=MlqGnVJynYix6T4K3o0UvvqpiBxGiLrdhcJ9xUpory+6zZkp/0qKbEf1NKx5WAb9bU1DWx2eFKLHPgzEQSPTxB1dbnnV+wBGSt55oOfQWb3U+2klr73Or55nRLBOjfaRzQaAh6qvUg84C+smXU9hGXn6+MVm81MQRCJTn7ljKZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996800; c=relaxed/simple;
	bh=Qfgl0Biv0aP0AfSr2hL0ISOr/2WJn7Y3CpP9bolN+HY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NRKte3gxxMbGabMn17uUaHTgJLXbXArkwS4a5YyUapbp7s8H5Y7ccYhpGe0CBtokZ7haNKdT95boFXk+A2LTqt9EAq8b74e7crVdAq4gkpvSQiiF9zb2Ez4RmpQol3WTcyIVat2RAFU2ZHWotso+EEg46rHo5zRntW6fHpiMovE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VY0Hg0nxwztT94;
	Mon,  6 May 2024 19:56:31 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 12C0B1800C7;
	Mon,  6 May 2024 19:59:55 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 19:59:54 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - adjust vf configuration sequence and optimize zip reg offset
Date: Mon, 6 May 2024 19:59:51 +0800
Message-ID: <20240506115953.2282155-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

