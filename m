From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/4] crypto: s5p-sss: Remove useless check for non-null request
Date: Thu,  1 Mar 2018 21:50:12 +0100
Message-ID: <1519937413-24468-3-git-send-email-krzk@kernel.org>
References: <1519937413-24468-1-git-send-email-krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519937413-24468-1-git-send-email-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ahash_request 'req' argument passed by the caller
s5p_hash_handle_queue() cannot be NULL here because it is obtained from
non-NULL pointer via container_of().

This fixes smatch warning:
    drivers/crypto/s5p-sss.c:1213 s5p_hash_prepare_request() warn: variable dereferenced before check 'req' (see line 1208)

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 5d64c08b7f47..d7c8163e5068 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1210,9 +1210,6 @@ static int s5p_hash_prepare_request(struct ahash_request *req, bool update)
 	int xmit_len, hash_later, nbytes;
 	int ret;
 
-	if (!req)
-		return 0;
-
 	if (update)
 		nbytes = req->nbytes;
 	else
-- 
2.7.4
