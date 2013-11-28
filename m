From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 4/4] crypto: testmgr - fix sglen in test_aead for case 'dst != src'
Date: Thu, 28 Nov 2013 15:11:18 +0200
Message-ID: <1385644278-14928-4-git-send-email-horia.geanta@freescale.com>
References: <5282A387.1020200@iki.fi>
 <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:38336
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758364Ab3K1NSN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Nov 2013 08:18:13 -0500
In-Reply-To: <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit d8a32ac25698cd60b02bed2100379803c7f964e3 (crypto: testmgr - make
test_aead also test 'dst != src' code paths) added support for different
source and destination buffers in test_aead.

This patch modifies the source and destination buffer lengths accordingly:
the lengths are not equal since encryption / decryption adds / removes
the ICV.

Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 crypto/testmgr.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e091ef6..a130871 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -503,16 +503,16 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				goto out;
 			}
 
-			sg_init_one(&sg[0], input,
-				    template[i].ilen + (enc ? authsize : 0));
-
 			if (diff_dst) {
 				output = xoutbuf[0];
 				output += align_offset;
+				sg_init_one(&sg[0], input, template[i].ilen);
 				sg_init_one(&sgout[0], output,
+					    template[i].rlen);
+			} else {
+				sg_init_one(&sg[0], input,
 					    template[i].ilen +
 						(enc ? authsize : 0));
-			} else {
 				output = input;
 			}
 
@@ -612,12 +612,6 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 				memcpy(q, template[i].input + temp,
 				       template[i].tap[k]);
 
-				n = template[i].tap[k];
-				if (k == template[i].np - 1 && enc)
-					n += authsize;
-				if (offset_in_page(q) + n < PAGE_SIZE)
-					q[n] = 0;
-
 				sg_set_buf(&sg[k], q, template[i].tap[k]);
 
 				if (diff_dst) {
@@ -625,13 +619,17 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 					    offset_in_page(IDX[k]);
 
 					memset(q, 0, template[i].tap[k]);
-					if (offset_in_page(q) + n < PAGE_SIZE)
-						q[n] = 0;
 
 					sg_set_buf(&sgout[k], q,
 						   template[i].tap[k]);
 				}
 
+				n = template[i].tap[k];
+				if (k == template[i].np - 1 && enc)
+					n += authsize;
+				if (offset_in_page(q) + n < PAGE_SIZE)
+					q[n] = 0;
+
 				temp += template[i].tap[k];
 			}
 
@@ -650,10 +648,10 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 					goto out;
 				}
 
-				sg[k - 1].length += authsize;
-
 				if (diff_dst)
 					sgout[k - 1].length += authsize;
+				else
+					sg[k - 1].length += authsize;
 			}
 
 			sg_init_table(asg, template[i].anp);
-- 
1.7.7.6
