From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: sha512_generic - set cra_driver_name
Date: Tue, 21 May 2013 17:10:10 +0300
Message-ID: <20130521141010.16154.53640.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:51037 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3EUOKM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 May 2013 10:10:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

'sha512_generic' should set driver name now that there is alternative sha512
provider (sha512_ssse3).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/sha512_generic.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 4c58620..6ed124f 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -251,6 +251,7 @@ static struct shash_alg sha512_algs[2] = { {
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha512",
+		.cra_driver_name =	"sha512-generic",
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
@@ -263,6 +264,7 @@ static struct shash_alg sha512_algs[2] = { {
 	.descsize	=	sizeof(struct sha512_state),
 	.base		=	{
 		.cra_name	=	"sha384",
+		.cra_driver_name =	"sha384-generic",
 		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
