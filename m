From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 14/14] crypto: arch/s390 - cleanup - remove unneeded cra_list
 initialization
Date: Wed, 11 Jul 2012 14:21:01 +0300
Message-ID: <20120711112101.6875.85841.stgit@localhost6.localdomain6>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Glauber <jang@de.ibm.com>, linux-s390@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Gerald Schaefer <gerald.schaefer@de.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:34275 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab2GKLVE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:21:04 -0400
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initialization of cra_list is currently mixed, most ciphers initialize this
field and most shashes do not. Initialization however is not needed at all
since cra_list is initialized/overwritten in __crypto_register_alg() with
list_add(). Therefore perform cleanup to remove all unneeded initializations
of this field in 'arch/s390/crypto/'

Cc: Jan Glauber <jang@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

---

Due to lack of cross-compiler, this is entirely untested. However it just
removes the ".cra_list = " lines from crypto_alg structures, so it should
be fine.
---
 arch/s390/crypto/aes_s390.c   |    5 -----
 arch/s390/crypto/des_s390.c   |   10 ----------
 arch/s390/crypto/ghash_s390.c |    1 -
 3 files changed, 16 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index a9ce135..4b59b21 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -216,7 +216,6 @@ static struct crypto_alg aes_alg = {
 	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(aes_alg.cra_list),
 	.cra_init               =       fallback_init_cip,
 	.cra_exit               =       fallback_exit_cip,
 	.cra_u			=	{
@@ -398,7 +397,6 @@ static struct crypto_alg ecb_aes_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(ecb_aes_alg.cra_list),
 	.cra_init		=	fallback_init_blk,
 	.cra_exit		=	fallback_exit_blk,
 	.cra_u			=	{
@@ -508,7 +506,6 @@ static struct crypto_alg cbc_aes_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(cbc_aes_alg.cra_list),
 	.cra_init		=	fallback_init_blk,
 	.cra_exit		=	fallback_exit_blk,
 	.cra_u			=	{
@@ -710,7 +707,6 @@ static struct crypto_alg xts_aes_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_xts_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(xts_aes_alg.cra_list),
 	.cra_init		=	xts_fallback_init,
 	.cra_exit		=	xts_fallback_exit,
 	.cra_u			=	{
@@ -832,7 +828,6 @@ static struct crypto_alg ctr_aes_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_aes_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(ctr_aes_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	AES_MIN_KEY_SIZE,
diff --git a/arch/s390/crypto/des_s390.c b/arch/s390/crypto/des_s390.c
index a52bfd1..1554262 100644
--- a/arch/s390/crypto/des_s390.c
+++ b/arch/s390/crypto/des_s390.c
@@ -70,7 +70,6 @@ static struct crypto_alg des_alg = {
 	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(des_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	DES_KEY_SIZE,
@@ -163,7 +162,6 @@ static struct crypto_alg ecb_des_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(ecb_des_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES_KEY_SIZE,
@@ -206,7 +204,6 @@ static struct crypto_alg cbc_des_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(cbc_des_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES_KEY_SIZE,
@@ -271,7 +268,6 @@ static struct crypto_alg des3_alg = {
 	.cra_blocksize		=	DES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(des3_alg.cra_list),
 	.cra_u			=	{
 		.cipher = {
 			.cia_min_keysize	=	DES3_KEY_SIZE,
@@ -314,8 +310,6 @@ static struct crypto_alg ecb_des3_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(
-						ecb_des3_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES3_KEY_SIZE,
@@ -358,8 +352,6 @@ static struct crypto_alg cbc_des3_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(
-						cbc_des3_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES3_KEY_SIZE,
@@ -452,7 +444,6 @@ static struct crypto_alg ctr_des_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(ctr_des_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES_KEY_SIZE,
@@ -496,7 +487,6 @@ static struct crypto_alg ctr_des3_alg = {
 	.cra_ctxsize		=	sizeof(struct s390_des_ctx),
 	.cra_type		=	&crypto_blkcipher_type,
 	.cra_module		=	THIS_MODULE,
-	.cra_list		=	LIST_HEAD_INIT(ctr_des3_alg.cra_list),
 	.cra_u			=	{
 		.blkcipher = {
 			.min_keysize		=	DES3_KEY_SIZE,
diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index b1bd170..1ebd3a1 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -135,7 +135,6 @@ static struct shash_alg ghash_alg = {
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
 		.cra_ctxsize		= sizeof(struct ghash_ctx),
 		.cra_module		= THIS_MODULE,
-		.cra_list		= LIST_HEAD_INIT(ghash_alg.base.cra_list),
 	},
 };
 
