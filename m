From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] crypto: constify drbg_state_ops structures
Date: Mon,  7 Dec 2015 21:36:57 +0100
Message-ID: <1449520617-1964-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:16828 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932984AbbLGUtI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 15:49:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The drbg_state_ops structures are never modified, so declare them as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 crypto/drbg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a7c2314..ab6ef1d 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -626,7 +626,7 @@ out:
 	return len;
 }
 
-static struct drbg_state_ops drbg_ctr_ops = {
+static const struct drbg_state_ops drbg_ctr_ops = {
 	.update		= drbg_ctr_update,
 	.generate	= drbg_ctr_generate,
 	.crypto_init	= drbg_init_sym_kernel,
@@ -752,7 +752,7 @@ static int drbg_hmac_generate(struct drbg_state *drbg,
 	return len;
 }
 
-static struct drbg_state_ops drbg_hmac_ops = {
+static const struct drbg_state_ops drbg_hmac_ops = {
 	.update		= drbg_hmac_update,
 	.generate	= drbg_hmac_generate,
 	.crypto_init	= drbg_init_hash_kernel,
@@ -1032,7 +1032,7 @@ out:
  * scratchpad usage: as update and generate are used isolated, both
  * can use the scratchpad
  */
-static struct drbg_state_ops drbg_hash_ops = {
+static const struct drbg_state_ops drbg_hash_ops = {
 	.update		= drbg_hash_update,
 	.generate	= drbg_hash_generate,
 	.crypto_init	= drbg_init_hash_kernel,
