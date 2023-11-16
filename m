Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00451AD;
	Wed, 15 Nov 2023 18:18:04 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 511DB7FFC;
	Thu, 16 Nov 2023 10:18:03 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Nov
 2023 10:18:03 +0800
Received: from ubuntu.localdomain (202.188.176.82) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 16 Nov
 2023 10:18:00 +0800
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: starfive - Pad adata with zeroes
Date: Thu, 16 Nov 2023 10:17:52 +0800
Message-ID: <20231116021752.420680-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [202.188.176.82]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable

Ensure padding for adata is filled with zeroes. Additional bytes for
padding affects the ccm tag output even though input ad len has been
provided to the hardware.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/crypto/starfive/jh7110-aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfi=
ve/jh7110-aes.c
index 9378e6682f0e..e0fe599f8192 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -500,7 +500,7 @@ static int starfive_aes_prepare_req(struct skcipher_r=
equest *req,
 	scatterwalk_start(&cryp->out_walk, rctx->out_sg);
=20
 	if (cryp->assoclen) {
-		rctx->adata =3D kzalloc(ALIGN(cryp->assoclen, AES_BLOCK_SIZE), GFP_KER=
NEL);
+		rctx->adata =3D kzalloc(cryp->assoclen + AES_BLOCK_SIZE, GFP_KERNEL);
 		if (!rctx->adata)
 			return dev_err_probe(cryp->dev, -ENOMEM,
 					     "Failed to alloc memory for adata");
@@ -569,7 +569,7 @@ static int starfive_aes_aead_do_one_req(struct crypto=
_engine *engine, void *areq
 	struct starfive_cryp_ctx *ctx =3D
 		crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct starfive_cryp_dev *cryp =3D ctx->cryp;
-	struct starfive_cryp_request_ctx *rctx =3D ctx->rctx;
+	struct starfive_cryp_request_ctx *rctx;
 	u32 block[AES_BLOCK_32];
 	u32 stat;
 	int err;
@@ -579,6 +579,8 @@ static int starfive_aes_aead_do_one_req(struct crypto=
_engine *engine, void *areq
 	if (err)
 		return err;
=20
+	rctx =3D ctx->rctx;
+
 	if (!cryp->assoclen)
 		goto write_text;
=20
--=20
2.34.1

