From: "Aseem Rastogi" <arastogi@cs.sunysb.edu>
Subject: PATCH crypto/zlib: Allow Z_OK return value from zlib_deflate
Date: Sun, 20 Dec 2009 14:34:09 -0500
Message-ID: <20091220192122.M17448@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Cc: vtaras@cs.sunysb.edu
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sbcs.cs.sunysb.edu ([130.245.1.15]:44597 "EHLO
	sbcs.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZLTUPM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Dec 2009 15:15:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Aseem Rastogi

crypto/zlib: When zlib_deflate is called with Z_FINISH flag, it should be
considered valid if it returns Z_OK instead of Z_STREAM_END.

zlib_defalte allows callers to call it with Z_FINISH flag multiple times. This
is useful if output buffer did not have enough space first time zlib_deflate
was called with Z_FINISH set. zlib_deflate returns Z_OK in that case and
expects that caller will invoke it again with Z_FINISH set to collect
remaining data. So, return value from zlib_deflate can be Z_OK OR
Z_STREAM_END. zlib_compress_final is modified to allow return value of Z_OK.

Signed-off-by: Aseem Rastogi <arastogi@cs.sunysb.edu>
Tested-by: Aseem Rastogi <arastogi@cs.sunysb.edu>
Reviewed-by: Vasily Tarasov <vtaras@cs.sunysb.edu>

diff --git a/crypto/zlib.c b/crypto/zlib.c
index c301573..c63c520 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -190,7 +190,7 @@ static int zlib_compress_final(struct crypto_pcomp *tfm,
 	stream->avail_out = req->avail_out;
 
 	ret = zlib_deflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
+	if ((ret != Z_STREAM_END) && (ret != Z_OK)) {
 		pr_debug("zlib_deflate failed %d\n", ret);
 		return -EINVAL;
 	}
