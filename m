From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 1/4] crypto: omap-sham: Remove useless check for non-null request
Date: Thu,  1 Mar 2018 21:50:10 +0100
Message-ID: <1519937413-24468-1-git-send-email-krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ahash_request 'req' argument passed by the caller
omap_sham_handle_queue() cannot be NULL here because it is obtained from
non-NULL pointer via container_of().

This fixes smatch warning:
    drivers/crypto/omap-sham.c:812 omap_sham_prepare_request() warn: variable dereferenced before check 'req' (see line 805)

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/omap-sham.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 86b89ace836f..7650b1b449bb 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -809,9 +809,6 @@ static int omap_sham_prepare_request(struct ahash_request *req, bool update)
 	bool final = rctx->flags & BIT(FLAGS_FINUP);
 	int xmit_len, hash_later;
 
-	if (!req)
-		return 0;
-
 	bs = get_block_size(rctx);
 
 	if (update)
-- 
2.7.4
