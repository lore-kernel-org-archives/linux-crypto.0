From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Fri, 28 Nov 2014 10:40:36 -0800
Message-ID: <20141128184036.11421.36028.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19122 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaK1Snt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2014 13:43:49 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
algif_skcipher sends 127 sgl buffers for encryption regardless of how
many buffers acctually have data to process, where the few first with
valid len and the rest with zero len. This is not very eficient and may cause
problems when algs do something like this without checking the buff
lenght:
for_each_sg(sgl, sg, sg_nents, i)
	sg_virt(sg)
This patch marks the last one with data as the last one to process.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f80e652..46a0758 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -441,6 +441,8 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 		char __user *from = iov->iov_base;
 
 		while (seglen) {
+			int nents;
+
 			sgl = list_first_entry(&ctx->tsgl,
 					       struct skcipher_sg_list, list);
 			sg = sgl->sg;
@@ -468,6 +470,9 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			if (!used)
 				goto free;
 
+			nents = sg_nents(ctx->rsgl.sg);
+			sg_mark_end(&sg[nents - 1]);
+
 			ablkcipher_request_set_crypt(&ctx->req, sg,
 						     ctx->rsgl.sg, used,
 						     ctx->iv);
@@ -477,6 +482,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 					crypto_ablkcipher_encrypt(&ctx->req) :
 					crypto_ablkcipher_decrypt(&ctx->req),
 				&ctx->completion);
+			sg_unmark_end(&sg[nents - 1]);
 
 free:
 			af_alg_free_sg(&ctx->rsgl);
