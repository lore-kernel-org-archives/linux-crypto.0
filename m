Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:51702 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732558AbeLUP7s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 10:59:48 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        Iuliana Prodan <Iuliana.Prodan@nxp.com>
Subject: [PATCH 1/3] crypto: caam - fix error reporting for caam_hash_alloc
Date: Fri, 21 Dec 2018 17:59:08 +0200
Message-Id: <20181221155910.6235-2-horia.geanta@nxp.com>
In-Reply-To: <20181221155910.6235-1-horia.geanta@nxp.com>
References: <20181221155910.6235-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Iuliana Prodan <Iuliana.Prodan@nxp.com>

Fix error reporting when preparation of an hmac algorithm
for registration fails: print the hmac algorithm name, not the unkeyed
hash algorithm name.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 81712aa5d0f2..33f7c19efb62 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1870,7 +1870,8 @@ static int __init caam_algapi_hash_init(void)
 		t_alg = caam_hash_alloc(alg, true);
 		if (IS_ERR(t_alg)) {
 			err = PTR_ERR(t_alg);
-			pr_warn("%s alg allocation failed\n", alg->driver_name);
+			pr_warn("%s alg allocation failed\n",
+				alg->hmac_driver_name);
 			continue;
 		}
 
-- 
2.16.2
