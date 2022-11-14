Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22045C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 11:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236618AbiKNLHL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiKNLHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2022 06:07:08 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85051DA77
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 03:07:07 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4N9mjL1RYqz4f3thK
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 19:07:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.102.38])
        by APP4 (Coremail) with SMTP id gCh0CgDH69hYIXJjTUALAg--.19413S4;
        Mon, 14 Nov 2022 19:07:05 +0800 (CST)
From:   Wei Yongjun <weiyongjun@huaweicloud.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        zhenwei pi <pizhenwei@bytedance.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
Date:   Mon, 14 Nov 2022 11:07:40 +0000
Message-Id: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgDH69hYIXJjTUALAg--.19413S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4fCF1kGrW5Wry5JFWDurg_yoWkGFX_J3
        s7W39rZryjgF10vrWDZ3yrWrZFva4rZFykWr4ftry8Ja43ZF45GF12qrnxCFyUX34jyF45
        Cws3tr9xuw1fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbokYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
        z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
        AF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
        IxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr
        1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
        vfC2KfnxnUUI43ZEXa7IU189N3UUUUU==
X-CM-SenderInfo: 5zhl50pqjm3046kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
and should be freed in the invalid ctrl_status->status error handling
case. Otherwise there is a memory leak.

Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index e553ccadbcbc..e5876286828b 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	err = 0;
-- 
2.34.1

