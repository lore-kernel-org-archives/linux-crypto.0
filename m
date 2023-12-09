Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0336010D2;
	Fri,  8 Dec 2023 23:05:36 -0800 (PST)
Received: from dggpemd200003.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SnJtF75c5z14LyH;
	Sat,  9 Dec 2023 15:05:09 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 dggpemd200003.china.huawei.com (7.185.36.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Sat, 9 Dec 2023 15:05:12 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - optimize the processing of qm and sec functions
Date: Sat, 9 Dec 2023 15:01:33 +0800
Message-ID: <20231209070135.555110-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemd200003.china.huawei.com (7.185.36.122)
X-CFilter-Loop: Reflected

This seires patch optimize the process of ret, and delete risky redundant
functions.

*** BLURB HERE ***

Chenghai Huang (2):
  crypto: hisilicon/qm - delete a dbg function
  crypto: hisilicon/sec2 - optimize the error return process

 drivers/crypto/hisilicon/qm.c              | 3 ---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 7 +++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.30.0

