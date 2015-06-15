From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 09/11] crypto: caam - Fix incorrect size when DMA unmapping buffer
Date: Mon, 15 Jun 2015 16:52:57 -0700
Message-ID: <1434412379-11623-10-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0135.outbound.protection.outlook.com ([157.56.111.135]:51388
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842AbbFPAHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:07:55 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CAAM driver uses two data buffers to store data for a hashing operation,
with one buffer defined as active. This change forces switching of the
active buffer when executing a hashing operation to avoid a later DMA unmap
using the length of the opposite buffer.

Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index f2f1e87..6720332 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -843,17 +843,17 @@ static int ahash_update_ctx(struct ahash_request *req)
 			src_map_to_sec4_sg(jrdev, req->src, src_nents,
 					   edesc->sec4_sg + sec4_sg_src_index,
 					   chained);
-			if (*next_buflen) {
+			if (*next_buflen)
 				scatterwalk_map_and_copy(next_buf, req->src,
 							 to_hash - *buflen,
 							 *next_buflen, 0);
-				state->current_buf = !state->current_buf;
-			}
 		} else {
 			(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=
 							SEC4_SG_LEN_FIN;
 		}
 
+		state->current_buf = !state->current_buf;
+
 		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
 		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
@@ -1276,9 +1276,10 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			scatterwalk_map_and_copy(next_buf, req->src,
 						 to_hash - *buflen,
 						 *next_buflen, 0);
-			state->current_buf = !state->current_buf;
 		}
 
+		state->current_buf = !state->current_buf;
+
 		sh_len = desc_len(sh_desc);
 		desc = edesc->hw_desc;
 		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-- 
2.1.4
