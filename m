From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: Fix DMA-API warning
Date: Mon, 19 May 2014 09:51:33 -0700
Message-ID: <20140519165133.GA3365@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbaESQwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 May 2014 12:52:03 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With DMA-API debug enabled testmgr triggers a "DMA-API: device driver maps memory from stack" warning, when tested on a crypto HW accelerator.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/testmgr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index dc3cf35..75c78e6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -414,16 +414,18 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	void *input;
 	void *output;
 	void *assoc;
-	char iv[MAX_IVLEN];
+	char *iv;
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
 
+	iv = kzalloc(MAX_IVLEN, GFP_KERNEL);
+	if (!iv)
+		return ret;
 	if (testmgr_alloc_buf(xbuf))
 		goto out_noxbuf;
 	if (testmgr_alloc_buf(axbuf))
 		goto out_noaxbuf;
-
 	if (diff_dst && testmgr_alloc_buf(xoutbuf))
 		goto out_nooutbuf;
 
@@ -767,6 +769,7 @@ out_nooutbuf:
 out_noaxbuf:
 	testmgr_free_buf(xbuf);
 out_noxbuf:
+	kfree(iv);
 	return ret;
 }
 
-- 
1.8.5.rc2.6.gc6f1b92.dirty
