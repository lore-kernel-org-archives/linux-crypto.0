X-Greylist: delayed 1136 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Dec 2023 04:01:24 PST
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D585F3;
	Mon, 11 Dec 2023 04:01:24 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Spfw35jl3z29fpt;
	Mon, 11 Dec 2023 19:41:23 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (unknown [7.185.36.236])
	by mail.maildlp.com (Postfix) with ESMTPS id 90AF21A0178;
	Mon, 11 Dec 2023 19:42:29 +0800 (CST)
Received: from DESKTOP-8LI8G6S.china.huawei.com (10.174.149.11) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Dec 2023 19:42:29 +0800
From: Gonglei <arei.gonglei@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<lixiao91@huawei.com>, wangyangxin <wangyangxin1@huawei.com>, Gonglei
	<arei.gonglei@huawei.com>
Subject: [PATCH 1/2] crypto: virtio-crypto: Wait for tasklet to complete on device remove
Date: Mon, 11 Dec 2023 19:42:15 +0800
Message-ID: <1702294936-61080-2-git-send-email-arei.gonglei@huawei.com>
X-Mailer: git-send-email 2.8.2.windows.1
In-Reply-To: <1702294936-61080-1-git-send-email-arei.gonglei@huawei.com>
References: <1702294936-61080-1-git-send-email-arei.gonglei@huawei.com>
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

The scheduled tasklet needs to be executed on device remove.

Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 428d76562447..b909c6a2bf1c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -500,12 +500,15 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
 static void virtcrypto_remove(struct virtio_device *vdev)
 {
 	struct virtio_crypto *vcrypto = vdev->priv;
+	int i;
 
 	dev_info(&vdev->dev, "Start virtcrypto_remove.\n");
 
 	flush_work(&vcrypto->config_work);
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
+	for (i = 0; i < vcrypto->max_data_queues; i++)
+		tasklet_kill(&vcrypto->data_vq[i].done_task);
 	virtio_reset_device(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	virtcrypto_clear_crypto_engines(vcrypto);
-- 
2.33.0

