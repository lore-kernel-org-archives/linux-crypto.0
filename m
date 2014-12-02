From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2] crypto: algif - Mark sgl end at the end of data
Date: Tue, 02 Dec 2014 07:07:50 -0800
Message-ID: <20141202150750.32521.20584.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:64254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaLBPKs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 10:10:48 -0500
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

Changes:
v2 - use data len to find the last buffer instead of nents in RX list.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index f2a88a7..cde507f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -414,6 +414,23 @@ unlock:
 	return err ?: size;
 }
 
+static int skcipher_get_nents_with_data(struct scatterlist *sg, int len)
+{
+	int nents;
+
+	for (nents = 0; sg; sg = sg_next(sg)) {
+		if (!sg)
+			return nents;
+
+		len -= sg->length;
+		if (!(len > 0))
+			return nents;
+		nents++;
+	}
+
+	return 0;
+}
+
 static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			    struct msghdr *msg, size_t ignored, int flags)
 {
@@ -437,6 +454,8 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 		char __user *from = iov->iov_base;
 
 		while (seglen) {
+			int nents;
+
 			sgl = list_first_entry(&ctx->tsgl,
 					       struct skcipher_sg_list, list);
 			sg = sgl->sg;
@@ -464,6 +483,8 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 			if (!used)
 				goto free;
 
+			nents = skcipher_get_nents_with_data(sg, used);
+			sg_mark_end(&sg[nents]);
 			ablkcipher_request_set_crypt(&ctx->req, sg,
 						     ctx->rsgl.sg, used,
 						     ctx->iv);
@@ -473,6 +494,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 					crypto_ablkcipher_encrypt(&ctx->req) :
 					crypto_ablkcipher_decrypt(&ctx->req),
 				&ctx->completion);
+			sg_unmark_end(&sg[nents]);
 
 free:
 			af_alg_free_sg(&ctx->rsgl);
