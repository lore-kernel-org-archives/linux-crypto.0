From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 13/14] crypto: drivers - remove cra_list initialization
Date: Wed, 11 Jul 2012 14:20:56 +0300
Message-ID: <20120711112056.6875.58905.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	Michal Ludvig <michal@logix.cz>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-geode@lists.infradead.org,
	Varun Wadekar <vwadekar@nvidia.com>,
	Eric =?utf-8?q?B=C3=A9nard?= <eric@eukrea.com>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37435 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab2GKLVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:21:00 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initialization of cra_list is currently mixed, most ciphers initialize =
this
field and most shashes do not. Initialization however is not needed at =
all
since cra_list is initialized/overwritten in __crypto_register_alg() wi=
th
list_add(). Therefore perform cleanup to remove all unneeded initializa=
tions
of this field in 'crypto/drivers/'.

Cc: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-geode@lists.infradead.org
Cc: Michal Ludvig <michal@logix.cz>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Cc: Varun Wadekar <vwadekar@nvidia.com>
Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Eric B=C3=A9nard <eric@eukrea.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

---

Drivers that can be compiled on x86 and arm have been compile-tested, b=
ut
'nx' driver for ppc64 have not. However since changes are pretty obviou=
s
removal of ".cra_list =3D " from crypto_alg structures, it should be fi=
ne.
---
 drivers/crypto/atmel-aes.c     |    2 --
 drivers/crypto/atmel-tdes.c    |    1 -
 drivers/crypto/geode-aes.c     |    3 ---
 drivers/crypto/nx/nx-aes-cbc.c |    1 -
 drivers/crypto/nx/nx-aes-ccm.c |    2 --
 drivers/crypto/nx/nx-aes-ctr.c |    2 --
 drivers/crypto/nx/nx-aes-ecb.c |    1 -
 drivers/crypto/nx/nx-aes-gcm.c |    2 --
 drivers/crypto/omap-aes.c      |    1 -
 drivers/crypto/padlock-aes.c   |    3 ---
 drivers/crypto/s5p-sss.c       |    1 -
 drivers/crypto/tegra-aes.c     |    2 --
 12 files changed, 21 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 6bb20ff..872ca8c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1017,7 +1017,6 @@ static int atmel_aes_register_algs(struct atmel_a=
es_dev *dd)
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(aes_algs); i++) {
-		INIT_LIST_HEAD(&aes_algs[i].cra_list);
 		err =3D crypto_register_alg(&aes_algs[i]);
 		if (err)
 			goto err_aes_algs;
@@ -1026,7 +1025,6 @@ static int atmel_aes_register_algs(struct atmel_a=
es_dev *dd)
 	atmel_aes_hw_version_init(dd);
=20
 	if (dd->hw_version >=3D 0x130) {
-		INIT_LIST_HEAD(&aes_cfb64_alg[0].cra_list);
 		err =3D crypto_register_alg(&aes_cfb64_alg[0]);
 		if (err)
 			goto err_aes_cfb64_alg;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index eb2b61e..53c1680 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1044,7 +1044,6 @@ static int atmel_tdes_register_algs(struct atmel_=
tdes_dev *dd)
 	int err, i, j;
=20
 	for (i =3D 0; i < ARRAY_SIZE(tdes_algs); i++) {
-		INIT_LIST_HEAD(&tdes_algs[i].cra_list);
 		err =3D crypto_register_alg(&tdes_algs[i]);
 		if (err)
 			goto err_tdes_algs;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index f3e36c8..933fb4b4 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -289,7 +289,6 @@ static struct crypto_alg geode_alg =3D {
 	.cra_blocksize		=3D	AES_MIN_BLOCK_SIZE,
 	.cra_ctxsize		=3D	sizeof(struct geode_aes_op),
 	.cra_module			=3D	THIS_MODULE,
-	.cra_list			=3D	LIST_HEAD_INIT(geode_alg.cra_list),
 	.cra_u				=3D	{
 		.cipher	=3D	{
 			.cia_min_keysize	=3D	AES_MIN_KEY_SIZE,
@@ -402,7 +401,6 @@ static struct crypto_alg geode_cbc_alg =3D {
 	.cra_alignmask		=3D	15,
 	.cra_type			=3D	&crypto_blkcipher_type,
 	.cra_module			=3D	THIS_MODULE,
-	.cra_list			=3D	LIST_HEAD_INIT(geode_cbc_alg.cra_list),
 	.cra_u				=3D	{
 		.blkcipher	=3D	{
 			.min_keysize	=3D	AES_MIN_KEY_SIZE,
@@ -489,7 +487,6 @@ static struct crypto_alg geode_ecb_alg =3D {
 	.cra_alignmask		=3D	15,
 	.cra_type			=3D	&crypto_blkcipher_type,
 	.cra_module			=3D	THIS_MODULE,
-	.cra_list			=3D	LIST_HEAD_INIT(geode_ecb_alg.cra_list),
 	.cra_u				=3D	{
 		.blkcipher	=3D	{
 			.min_keysize	=3D	AES_MIN_KEY_SIZE,
diff --git a/drivers/crypto/nx/nx-aes-cbc.c b/drivers/crypto/nx/nx-aes-=
cbc.c
index 69ed796..a76d4c4 100644
--- a/drivers/crypto/nx/nx-aes-cbc.c
+++ b/drivers/crypto/nx/nx-aes-cbc.c
@@ -127,7 +127,6 @@ struct crypto_alg nx_cbc_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_blkcipher_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_cbc_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_cbc_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_blkcipher =3D {
diff --git a/drivers/crypto/nx/nx-aes-ccm.c b/drivers/crypto/nx/nx-aes-=
ccm.c
index 7aeac67..ef5eae6 100644
--- a/drivers/crypto/nx/nx-aes-ccm.c
+++ b/drivers/crypto/nx/nx-aes-ccm.c
@@ -430,7 +430,6 @@ struct crypto_alg nx_ccm_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_aead_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_ccm_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_ccm_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_aead =3D {
@@ -453,7 +452,6 @@ struct crypto_alg nx_ccm4309_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_nivaead_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_ccm4309_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_ccm_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_aead =3D {
diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-=
ctr.c
index 52d4eb0..b6286f1 100644
--- a/drivers/crypto/nx/nx-aes-ctr.c
+++ b/drivers/crypto/nx/nx-aes-ctr.c
@@ -141,7 +141,6 @@ struct crypto_alg nx_ctr_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_blkcipher_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_ctr_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_ctr_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_blkcipher =3D {
@@ -163,7 +162,6 @@ struct crypto_alg nx_ctr3686_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_blkcipher_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_ctr3686_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_ctr_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_blkcipher =3D {
diff --git a/drivers/crypto/nx/nx-aes-ecb.c b/drivers/crypto/nx/nx-aes-=
ecb.c
index 7b77bc2..ba5f161 100644
--- a/drivers/crypto/nx/nx-aes-ecb.c
+++ b/drivers/crypto/nx/nx-aes-ecb.c
@@ -126,7 +126,6 @@ struct crypto_alg nx_ecb_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_blkcipher_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_ecb_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_ecb_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_blkcipher =3D {
diff --git a/drivers/crypto/nx/nx-aes-gcm.c b/drivers/crypto/nx/nx-aes-=
gcm.c
index 9ab1c73..c8109ed 100644
--- a/drivers/crypto/nx/nx-aes-gcm.c
+++ b/drivers/crypto/nx/nx-aes-gcm.c
@@ -316,7 +316,6 @@ struct crypto_alg nx_gcm_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_aead_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_gcm_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_gcm_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_aead =3D {
@@ -338,7 +337,6 @@ struct crypto_alg nx_gcm4106_aes_alg =3D {
 	.cra_ctxsize     =3D sizeof(struct nx_crypto_ctx),
 	.cra_type        =3D &crypto_nivaead_type,
 	.cra_module      =3D THIS_MODULE,
-	.cra_list        =3D LIST_HEAD_INIT(nx_gcm4106_aes_alg.cra_list),
 	.cra_init        =3D nx_crypto_ctx_aes_gcm_init,
 	.cra_exit        =3D nx_crypto_ctx_exit,
 	.cra_aead =3D {
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 63e57b5..093a8af 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -876,7 +876,6 @@ static int omap_aes_probe(struct platform_device *p=
dev)
=20
 	for (i =3D 0; i < ARRAY_SIZE(algs); i++) {
 		pr_debug("i: %d\n", i);
-		INIT_LIST_HEAD(&algs[i].cra_list);
 		err =3D crypto_register_alg(&algs[i]);
 		if (err)
 			goto err_algs;
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.=
c
index 37b2e94..633ba94 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -328,7 +328,6 @@ static struct crypto_alg aes_alg =3D {
 	.cra_ctxsize		=3D	sizeof(struct aes_ctx),
 	.cra_alignmask		=3D	PADLOCK_ALIGNMENT - 1,
 	.cra_module		=3D	THIS_MODULE,
-	.cra_list		=3D	LIST_HEAD_INIT(aes_alg.cra_list),
 	.cra_u			=3D	{
 		.cipher =3D {
 			.cia_min_keysize	=3D	AES_MIN_KEY_SIZE,
@@ -408,7 +407,6 @@ static struct crypto_alg ecb_aes_alg =3D {
 	.cra_alignmask		=3D	PADLOCK_ALIGNMENT - 1,
 	.cra_type		=3D	&crypto_blkcipher_type,
 	.cra_module		=3D	THIS_MODULE,
-	.cra_list		=3D	LIST_HEAD_INIT(ecb_aes_alg.cra_list),
 	.cra_u			=3D	{
 		.blkcipher =3D {
 			.min_keysize		=3D	AES_MIN_KEY_SIZE,
@@ -491,7 +489,6 @@ static struct crypto_alg cbc_aes_alg =3D {
 	.cra_alignmask		=3D	PADLOCK_ALIGNMENT - 1,
 	.cra_type		=3D	&crypto_blkcipher_type,
 	.cra_module		=3D	THIS_MODULE,
-	.cra_list		=3D	LIST_HEAD_INIT(cbc_aes_alg.cra_list),
 	.cra_u			=3D	{
 		.blkcipher =3D {
 			.min_keysize		=3D	AES_MIN_KEY_SIZE,
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index bc986f8..a227144 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -626,7 +626,6 @@ static int s5p_aes_probe(struct platform_device *pd=
ev)
 	crypto_init_queue(&pdata->queue, CRYPTO_QUEUE_LEN);
=20
 	for (i =3D 0; i < ARRAY_SIZE(algs); i++) {
-		INIT_LIST_HEAD(&algs[i].cra_list);
 		err =3D crypto_register_alg(&algs[i]);
 		if (err)
 			goto err_algs;
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 422a976..e66c143 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -1004,8 +1004,6 @@ static int tegra_aes_probe(struct platform_device=
 *pdev)
=20
 	aes_dev =3D dd;
 	for (i =3D 0; i < ARRAY_SIZE(algs); i++) {
-		INIT_LIST_HEAD(&algs[i].cra_list);
-
 		algs[i].cra_priority =3D 300;
 		algs[i].cra_ctxsize =3D sizeof(struct tegra_aes_ctx);
 		algs[i].cra_module =3D THIS_MODULE;
