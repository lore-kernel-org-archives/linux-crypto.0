Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865E172B;
	Mon, 11 Dec 2023 04:02:09 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Spfs82Rl8z1FDmK;
	Mon, 11 Dec 2023 19:38:52 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (unknown [7.185.36.236])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F4F91800DA;
	Mon, 11 Dec 2023 19:42:26 +0800 (CST)
Received: from DESKTOP-8LI8G6S.china.huawei.com (10.174.149.11) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Dec 2023 19:42:25 +0800
From: Gonglei <arei.gonglei@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<lixiao91@huawei.com>, wangyangxin <wangyangxin1@huawei.com>
Subject: [PATCH 0/2] crypto: virtio-crypto: Wait for tasklet to complete on device remove and fix warnings
Date: Mon, 11 Dec 2023 19:42:14 +0800
Message-ID: <1702294936-61080-1-git-send-email-arei.gonglei@huawei.com>
X-Mailer: git-send-email 2.8.2.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500006.china.huawei.com (7.185.36.236)

From: wangyangxin <wangyangxin1@huawei.com>

This serie wait for tasklet to complete on device remove and fix gcc check warnings.

wangyangxin (2):
  crypto: virtio-crypto: Wait for tasklet to complete on device remove
  crypto: virtio-crypto: Fix gcc check warnings

 drivers/crypto/virtio/virtio_crypto_common.h | 5 ++---
 drivers/crypto/virtio/virtio_crypto_core.c   | 3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

-- 
2.33.0

