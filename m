Return-Path: <SRS0=5fel=PH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51238 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbeL3Nqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Dec 2018 08:46:34 -0500
From: Colin King <colin.king@canonical.com>
To: Gonglei <arei.gonglei@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: virtio: clean up indentation, replace spaces with tab
Date: Sun, 30 Dec 2018 13:46:21 +0000
Message-Id: <20181230134621.7502-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

A statement is indented with spaces and not indented enough, fix this
replacing spaces with a tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/virtio/virtio_crypto_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
index 2c573d1aaa64..0704833ece92 100644
--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -406,7 +406,7 @@ __virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request *vc_sym_req,
 	} else {
 		req_data->header.session_id =
 			cpu_to_le64(ctx->dec_sess_info.session_id);
-	    req_data->header.opcode =
+		req_data->header.opcode =
 			cpu_to_le32(VIRTIO_CRYPTO_CIPHER_DECRYPT);
 	}
 	req_data->u.sym_req.op_type = cpu_to_le32(VIRTIO_CRYPTO_SYM_OP_CIPHER);
-- 
2.19.1
