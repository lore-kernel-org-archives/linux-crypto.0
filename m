From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v4 4/4] fs/pstore: fs/squashfs: Change usage of LZ4 to work with new LZ4 version
Date: Sun, 22 Jan 2017 20:35:17 +0100
Message-ID: <1485113717-29261-5-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485113717-29261-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485113717-29261-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates fs/pstore and fs/squashfs to use the updated
functions from the new LZ4 module.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 fs/pstore/platform.c      | 14 +++++++-------
 fs/squashfs/lz4_wrapper.c | 12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 729677e..85c4c58 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -342,31 +342,31 @@ static int compress_lz4(const void *in, void *out, size_t inlen, size_t outlen)
 {
 	int ret;
 
-	ret = lz4_compress(in, inlen, out, &outlen, workspace);
-	if (ret) {
+	ret = LZ4_compress_default(in, out, inlen, outlen, workspace);
+	if (!ret) {
 		pr_err("lz4_compress error, ret = %d!\n", ret);
 		return -EIO;
 	}
 
-	return outlen;
+	return ret;
 }
 
 static int decompress_lz4(void *in, void *out, size_t inlen, size_t outlen)
 {
 	int ret;
 
-	ret = lz4_decompress_unknownoutputsize(in, inlen, out, &outlen);
-	if (ret) {
+	ret = LZ4_decompress_safe(in, out, inlen, outlen);
+	if (ret < 0) {
 		pr_err("lz4_decompress error, ret = %d!\n", ret);
 		return -EIO;
 	}
 
-	return outlen;
+	return ret;
 }
 
 static void allocate_lz4(void)
 {
-	big_oops_buf_sz = lz4_compressbound(psinfo->bufsize);
+	big_oops_buf_sz = LZ4_compressBound(psinfo->bufsize);
 	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
 	if (big_oops_buf) {
 		workspace = kmalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
diff --git a/fs/squashfs/lz4_wrapper.c b/fs/squashfs/lz4_wrapper.c
index ff4468b..95da653 100644
--- a/fs/squashfs/lz4_wrapper.c
+++ b/fs/squashfs/lz4_wrapper.c
@@ -97,7 +97,6 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	struct squashfs_lz4 *stream = strm;
 	void *buff = stream->input, *data;
 	int avail, i, bytes = length, res;
-	size_t dest_len = output->length;
 
 	for (i = 0; i < b; i++) {
 		avail = min(bytes, msblk->devblksize - offset);
@@ -108,12 +107,13 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
 		put_bh(bh[i]);
 	}
 
-	res = lz4_decompress_unknownoutputsize(stream->input, length,
-					stream->output, &dest_len);
-	if (res)
+	res = LZ4_decompress_safe(stream->input, stream->output,
+		length, output->length);
+
+	if (res < 0)
 		return -EIO;
 
-	bytes = dest_len;
+	bytes = res;
 	data = squashfs_first_page(output);
 	buff = stream->output;
 	while (data) {
@@ -128,7 +128,7 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	}
 	squashfs_finish_page(output);
 
-	return dest_len;
+	return res;
 }
 
 const struct squashfs_decompressor squashfs_lz4_comp_ops = {
-- 
2.1.4
