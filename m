From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v6 2/5] lib/decompress_unlz4: Change module to work with new LZ4 module version
Date: Fri, 27 Jan 2017 23:02:01 +0100
Message-ID: <1485554524-4844-3-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485554524-4844-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36625 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751715AbdA0WEk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2017 17:04:40 -0500
In-Reply-To: <1485554524-4844-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch updates the unlz4 wrapper to work with the
updated LZ4 kernel module version.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 lib/decompress_unlz4.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/decompress_unlz4.c b/lib/decompress_unlz4.c
index 036fc88..1b0baf3 100644
--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -72,7 +72,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 		error("NULL input pointer and missing fill function");
 		goto exit_1;
 	} else {
-		inp = large_malloc(lz4_compressbound(uncomp_chunksize));
+		inp = large_malloc(LZ4_compressBound(uncomp_chunksize));
 		if (!inp) {
 			error("Could not allocate input buffer");
 			goto exit_1;
@@ -136,7 +136,7 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			inp += 4;
 			size -= 4;
 		} else {
-			if (chunksize > lz4_compressbound(uncomp_chunksize)) {
+			if (chunksize > LZ4_compressBound(uncomp_chunksize)) {
 				error("chunk length is longer than allocated");
 				goto exit_2;
 			}
@@ -152,11 +152,14 @@ STATIC inline int INIT unlz4(u8 *input, long in_len,
 			out_len -= dest_len;
 		} else
 			dest_len = out_len;
-		ret = lz4_decompress(inp, &chunksize, outp, dest_len);
+
+		ret = LZ4_decompress_fast(inp, outp, dest_len);
+		chunksize = ret;
 #else
 		dest_len = uncomp_chunksize;
-		ret = lz4_decompress_unknownoutputsize(inp, chunksize, outp,
-				&dest_len);
+
+		ret = LZ4_decompress_safe(inp, outp, chunksize, dest_len);
+		dest_len = ret;
 #endif
 		if (ret < 0) {
 			error("Decoding failed");
-- 
2.1.4
