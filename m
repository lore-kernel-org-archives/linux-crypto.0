From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: zip - add a cast for printing atomic64_t values
Date: Mon, 20 Mar 2017 13:39:16 +0100
Message-ID: <20170320123955.4061033-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Mahipal Challa <mahipalreddy2006@gmail.com>,
        Jan Glauber <jglauber@cavium.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

kernelci.org reports a build-time regression on linux-next, with a harmless
warning in x86 allmodconfig:

drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 7 has type 'long long int' [-Wformat=]
drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'long long int' [-Wformat=]
drivers/crypto/cavium/zip/zip_main.c:489:18: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'long long int' [-Wformat=]

The return type for atomic64_read() unfortunately differs between
architectures, with some defining it as atomic_long_read() and others
returning a 64-bit type explicitly. Fixing this in general would be nice,
but also require changing other users of these functions, so the simpler
workaround is to add a cast here that avoids the warnings on the default
build.

Fixes: 09ae5d37e093 ("crypto: zip - Add Compression/Decompression statistics")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/cavium/zip/zip_main.c | 40 ++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index 0951e20b395b..49f50c0e0308 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -488,32 +488,32 @@ static int zip_show_stats(struct seq_file *s, void *unused)
 				  atomic64_read(&st->comp_out_bytes));
 			seq_printf(s, "        ZIP Device %d Stats\n"
 				      "-----------------------------------\n"
-				      "Comp Req Submitted        : \t%ld\n"
-				      "Comp Req Completed        : \t%ld\n"
-				      "Compress In Bytes         : \t%ld\n"
-				      "Compressed Out Bytes      : \t%ld\n"
+				      "Comp Req Submitted        : \t%lld\n"
+				      "Comp Req Completed        : \t%lld\n"
+				      "Compress In Bytes         : \t%lld\n"
+				      "Compressed Out Bytes      : \t%lld\n"
 				      "Average Chunk size        : \t%llu\n"
 				      "Average Compression ratio : \t%llu\n"
-				      "Decomp Req Submitted      : \t%ld\n"
-				      "Decomp Req Completed      : \t%ld\n"
-				      "Decompress In Bytes       : \t%ld\n"
-				      "Decompressed Out Bytes    : \t%ld\n"
-				      "Decompress Bad requests   : \t%ld\n"
-				      "Pending Req               : \t%ld\n"
+				      "Decomp Req Submitted      : \t%lld\n"
+				      "Decomp Req Completed      : \t%lld\n"
+				      "Decompress In Bytes       : \t%lld\n"
+				      "Decompressed Out Bytes    : \t%lld\n"
+				      "Decompress Bad requests   : \t%lld\n"
+				      "Pending Req               : \t%lld\n"
 					"---------------------------------\n",
 				       index,
-				       atomic64_read(&st->comp_req_submit),
-				       atomic64_read(&st->comp_req_complete),
-				       atomic64_read(&st->comp_in_bytes),
-				       atomic64_read(&st->comp_out_bytes),
+				       (u64)atomic64_read(&st->comp_req_submit),
+				       (u64)atomic64_read(&st->comp_req_complete),
+				       (u64)atomic64_read(&st->comp_in_bytes),
+				       (u64)atomic64_read(&st->comp_out_bytes),
 				       avg_chunk,
 				       avg_cr,
-				       atomic64_read(&st->decomp_req_submit),
-				       atomic64_read(&st->decomp_req_complete),
-				       atomic64_read(&st->decomp_in_bytes),
-				       atomic64_read(&st->decomp_out_bytes),
-				       atomic64_read(&st->decomp_bad_reqs),
-				       atomic64_read(&st->pending_req));
+				       (u64)atomic64_read(&st->decomp_req_submit),
+				       (u64)atomic64_read(&st->decomp_req_complete),
+				       (u64)atomic64_read(&st->decomp_in_bytes),
+				       (u64)atomic64_read(&st->decomp_out_bytes),
+				       (u64)atomic64_read(&st->decomp_bad_reqs),
+				       (u64)atomic64_read(&st->pending_req));
 
 			/* Reset pending requests  count */
 			atomic64_set(&st->pending_req, 0);
-- 
2.9.0
