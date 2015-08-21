From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3 3/3] crypto: caam: Use the preferred style for memory allocations
Date: Fri, 21 Aug 2015 13:52:00 -0300
Message-ID: <1440175920-30884-3-git-send-email-festevam@gmail.com>
References: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: vicki.milhoan@freescale.com, horia.geanta@freescale.com,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34977 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbbHUQw1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 12:52:27 -0400
Received: by ykbi184 with SMTP id i184so76145798ykb.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 09:52:26 -0700 (PDT)
In-Reply-To: <1440175920-30884-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Fabio Estevam <fabio.estevam@freescale.com>

=46rom Documentation/CodingStyle:

"The preferred form for passing a size of a struct is the following:

        p =3D kmalloc(sizeof(*p), ...);
=2E...

The preferred form for allocating a zeroed array is the following:

        p =3D kcalloc(n, sizeof(...), ...); "

,so do as suggested.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Reviewed-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
Changes since v2:
- None

 drivers/crypto/caam/caamalg.c  |  2 +-
 drivers/crypto/caam/caamhash.c |  2 +-
 drivers/crypto/caam/caamrng.c  |  2 +-
 drivers/crypto/caam/ctrl.c     |  8 +++-----
 drivers/crypto/caam/jr.c       | 12 +++++-------
 5 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamal=
g.c
index 83d2306..ba79d63 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -4314,7 +4314,7 @@ static struct caam_crypto_alg *caam_alg_alloc(str=
uct caam_alg_template
 	struct caam_crypto_alg *t_alg;
 	struct crypto_alg *alg;
=20
-	t_alg =3D kzalloc(sizeof(struct caam_crypto_alg), GFP_KERNEL);
+	t_alg =3D kzalloc(sizeof(*t_alg), GFP_KERNEL);
 	if (!t_alg) {
 		pr_err("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamh=
ash.c
index 6c14261..94433b9 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1842,7 +1842,7 @@ caam_hash_alloc(struct caam_hash_template *templa=
te,
 	struct ahash_alg *halg;
 	struct crypto_alg *alg;
=20
-	t_alg =3D kzalloc(sizeof(struct caam_hash_alg), GFP_KERNEL);
+	t_alg =3D kzalloc(sizeof(*t_alg), GFP_KERNEL);
 	if (!t_alg) {
 		pr_err("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrn=
g.c
index fb0cc54..9b92af2 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -351,7 +351,7 @@ static int __init caam_rng_init(void)
 		pr_err("Job Ring Device allocation for transform failed\n");
 		return PTR_ERR(dev);
 	}
-	rng_ctx =3D kmalloc(sizeof(struct caam_rng_ctx), GFP_DMA);
+	rng_ctx =3D kmalloc(sizeof(*rng_ctx), GFP_DMA);
 	if (!rng_ctx) {
 		err =3D -ENOMEM;
 		goto free_caam_alloc;
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b4124a6..918c00a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -424,8 +424,7 @@ static int caam_probe(struct platform_device *pdev)
 	int pg_size;
 	int BLOCK_OFFSET =3D 0;
=20
-	ctrlpriv =3D devm_kzalloc(&pdev->dev, sizeof(struct caam_drv_private)=
,
-				GFP_KERNEL);
+	ctrlpriv =3D devm_kzalloc(&pdev->dev, sizeof(*ctrlpriv), GFP_KERNEL);
 	if (!ctrlpriv)
 		return -ENOMEM;
=20
@@ -583,9 +582,8 @@ static int caam_probe(struct platform_device *pdev)
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring"))
 			rspec++;
=20
-	ctrlpriv->jrpdev =3D devm_kzalloc(&pdev->dev,
-					sizeof(struct platform_device *) * rspec,
-					GFP_KERNEL);
+	ctrlpriv->jrpdev =3D devm_kcalloc(&pdev->dev, rspec,
+					sizeof(*ctrlpriv->jrpdev), GFP_KERNEL);
 	if (ctrlpriv->jrpdev =3D=3D NULL) {
 		ret =3D -ENOMEM;
 		goto iounmap_ctrl;
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index b7ec1ad..f7e0d8d 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -410,18 +410,17 @@ static int caam_jr_init(struct device *dev)
 		goto out_free_irq;
=20
 	error =3D -ENOMEM;
-	jrp->inpring =3D dma_alloc_coherent(dev, sizeof(dma_addr_t) * JOBR_DE=
PTH,
-					  &inpbusaddr, GFP_KERNEL);
+	jrp->inpring =3D dma_alloc_coherent(dev, sizeof(*jrp->inpring) *
+					  JOBR_DEPTH, &inpbusaddr, GFP_KERNEL);
 	if (!jrp->inpring)
 		goto out_free_irq;
=20
-	jrp->outring =3D dma_alloc_coherent(dev, sizeof(struct jr_outentry) *
+	jrp->outring =3D dma_alloc_coherent(dev, sizeof(*jrp->outring) *
 					  JOBR_DEPTH, &outbusaddr, GFP_KERNEL);
 	if (!jrp->outring)
 		goto out_free_inpring;
=20
-	jrp->entinfo =3D kzalloc(sizeof(struct caam_jrentry_info) * JOBR_DEPT=
H,
-			       GFP_KERNEL);
+	jrp->entinfo =3D kcalloc(JOBR_DEPTH, sizeof(*jrp->entinfo), GFP_KERNE=
L);
 	if (!jrp->entinfo)
 		goto out_free_outring;
=20
@@ -479,8 +478,7 @@ static int caam_jr_probe(struct platform_device *pd=
ev)
 	int error;
=20
 	jrdev =3D &pdev->dev;
-	jrpriv =3D devm_kmalloc(jrdev, sizeof(struct caam_drv_private_jr),
-			      GFP_KERNEL);
+	jrpriv =3D devm_kmalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
=20
--=20
1.9.1
