From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v3] crypto: algif - Mark sgl end at the end of data
Date: Mon, 08 Dec 2014 12:03:42 -0800
Message-ID: <20141208200342.15309.4739.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41681 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaLHUGo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 15:06:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
algif_skcipher sends 127 sgl buffers for encryption regardless of how
many buffers acctually have data to process, where the few first with
valid len and the rest with zero len. This is not very eficient.
This patch marks the last one with data as the last one to process.

Changes:
v2 - use data len to find the last buffer instead of nents in RX list.
v3 - Mark/unmark end when data is added and sgl->cur changed.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/algif_skcipher.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 3e84f4a..9b84765 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -330,6 +330,7 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 
 		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 		sg = sgl->sg;
+		sg_unmark_end(sg + sgl->cur);
 		do {
 			i = sgl->cur;
 			plen = min_t(int, len, PAGE_SIZE);
@@ -355,6 +356,9 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 			sgl->cur++;
 		} while (len && sgl->cur < MAX_SGL_ENTS);
 
+		if (!size)
+			sg_mark_end(sg + sgl->cur - 1);
+
 		ctx->merge = plen & (PAGE_SIZE - 1);
 	}
 
@@ -401,6 +405,10 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	ctx->merge = 0;
 	sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 
+	if (sgl->cur)
+		sg_unmark_end(sgl->sg + sgl->cur - 1);
+
+	sg_mark_end(sgl->sg + sgl->cur);
 	get_page(page);
 	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
 	sgl->cur++;
