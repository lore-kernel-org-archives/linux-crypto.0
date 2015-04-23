From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 1/2] Fixing NX data alignment with nx_sg list
Date: Thu, 23 Apr 2015 17:40:30 -0300
Message-ID: <20150423204024.GA11036@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:41120 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030684AbbDWUkm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Apr 2015 16:40:42 -0400
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Thu, 23 Apr 2015 17:40:38 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In NX we need to pass always a 16 multiple size nx_sg_list to
co processor. Trim function handle with this assuring all nx_sg_lists
are 16 multiple size, although data was not being considerated when
crop was done. It was causing an unalignment between size of the list
and data, corrupting csbcpb fields returning a -23 H_ST_PARM error, or
invalid operation.

This patch fix this recalculating how much data should be put back
in to_process variable what assures the size of sg_list will be
correct with size of the data.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/nx/nx.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 1da6dc5..3e8a50c 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -215,8 +215,15 @@ struct nx_sg *nx_walk_and_build(struct nx_sg       *nx_dst,
  * @delta:  is the amount we need to crop in order to bound the list.
  *
  */
-static long int trim_sg_list(struct nx_sg *sg, struct nx_sg *end, unsigned int delta)
+static long int trim_sg_list(struct nx_sg *sg,
+			     struct nx_sg *end,
+ 			     unsigned int delta,
+			     unsigned int *nbytes)
 {
+	long int oplen;
+	long int data_back;
+	unsigned int is_delta = delta;
+
 	while (delta && end > sg) {
 		struct nx_sg *last = end - 1;

@@ -228,7 +235,20 @@ static long int trim_sg_list(struct nx_sg *sg, struct nx_sg *end, unsigned int d
 			delta -= last->len;
 		}
 	}
-	return (sg - end) * sizeof(struct nx_sg);
+
+	/* There are cases where we need to crop list in order to make it
+ 	 * a block size multiple, but we also need to align data. In order to
+ 	 * that we need to calculate how much we need to put back to be
+ 	 * processed
+ 	 */
+	oplen = (sg - end) * sizeof(struct nx_sg);
+	if (is_delta) {
+		data_back = (abs(oplen) / AES_BLOCK_SIZE) *  sg->len;
+		data_back = *nbytes - (data_back & ~(AES_BLOCK_SIZE - 1));
+		*nbytes -= data_back;
+	}
+
+	return oplen;
 }

 /**
@@ -330,8 +350,8 @@ int nx_build_sg_lists(struct nx_crypto_ctx  *nx_ctx,
 	/* these lengths should be negative, which will indicate to phyp that
 	 * the input and output parameters are scatterlists, not linear
 	 * buffers */
-	nx_ctx->op.inlen = trim_sg_list(nx_ctx->in_sg, nx_insg, delta);
-	nx_ctx->op.outlen = trim_sg_list(nx_ctx->out_sg, nx_outsg, delta);
+	nx_ctx->op.inlen = trim_sg_list(nx_ctx->in_sg, nx_insg, delta, nbytes);
+	nx_ctx->op.outlen = trim_sg_list(nx_ctx->out_sg, nx_outsg, delta, nbytes);

 	return 0;
 }
--
1.7.1
