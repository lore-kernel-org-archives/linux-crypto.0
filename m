From: Jan Glauber <jglauber@cavium.com>
Subject: [PATCH v2 1/5] crypto: thunderx_zip: Fix fallout from CONFIG_VMAP_STACK
Date: Mon,  9 Apr 2018 17:45:50 +0200
Message-ID: <20180409154554.7578-2-jglauber@cavium.com>
References: <20180409154554.7578-1-jglauber@cavium.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Robert Richter <rrichter@cavium.com>,
        Jan Glauber <jglauber@cavium.com>,
        stable <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409154554.7578-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Enabling virtual mapped kernel stacks breaks the thunderx_zip
driver. On compression or decompression the executing CPU hangs
in an endless loop. The reason for this is the usage of __pa
by the driver which does no longer work for an address that is
not part of the 1:1 mapping.

The zip driver allocates a result struct on the stack and needs
to tell the hardware the physical address within this struct
that is used to signal the completion of the request.

As the hardware gets the wrong address after the broken __pa
conversion it writes to an arbitrary address. The zip driver then
waits forever for the completion byte to contain a non-zero value.

Allocating the result struct from 1:1 mapped memory resolves this
bug.

Signed-off-by: Jan Glauber <jglauber@cavium.com>
Reviewed-by: Robert Richter <rrichter@cavium.com>
Cc: stable <stable@vger.kernel.org> # 4.14
---
 drivers/crypto/cavium/zip/zip_crypto.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
index 8df4d26cf9d4..b92b6e7e100f 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.c
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -124,7 +124,7 @@ int zip_compress(const u8 *src, unsigned int slen,
 		 struct zip_kernel_ctx *zip_ctx)
 {
 	struct zip_operation  *zip_ops   = NULL;
-	struct zip_state      zip_state;
+	struct zip_state      *zip_state;
 	struct zip_device     *zip = NULL;
 	int ret;
 
@@ -135,20 +135,23 @@ int zip_compress(const u8 *src, unsigned int slen,
 	if (!zip)
 		return -ENODEV;
 
-	memset(&zip_state, 0, sizeof(struct zip_state));
+	zip_state = kzalloc(sizeof(*zip_state), GFP_ATOMIC);
+	if (!zip_state)
+		return -ENOMEM;
+
 	zip_ops = &zip_ctx->zip_comp;
 
 	zip_ops->input_len  = slen;
 	zip_ops->output_len = *dlen;
 	memcpy(zip_ops->input, src, slen);
 
-	ret = zip_deflate(zip_ops, &zip_state, zip);
+	ret = zip_deflate(zip_ops, zip_state, zip);
 
 	if (!ret) {
 		*dlen = zip_ops->output_len;
 		memcpy(dst, zip_ops->output, *dlen);
 	}
-
+	kfree(zip_state);
 	return ret;
 }
 
@@ -157,7 +160,7 @@ int zip_decompress(const u8 *src, unsigned int slen,
 		   struct zip_kernel_ctx *zip_ctx)
 {
 	struct zip_operation  *zip_ops   = NULL;
-	struct zip_state      zip_state;
+	struct zip_state      *zip_state;
 	struct zip_device     *zip = NULL;
 	int ret;
 
@@ -168,7 +171,10 @@ int zip_decompress(const u8 *src, unsigned int slen,
 	if (!zip)
 		return -ENODEV;
 
-	memset(&zip_state, 0, sizeof(struct zip_state));
+	zip_state = kzalloc(sizeof(*zip_state), GFP_ATOMIC);
+	if (!zip_state)
+		return -ENOMEM;
+
 	zip_ops = &zip_ctx->zip_decomp;
 	memcpy(zip_ops->input, src, slen);
 
@@ -179,13 +185,13 @@ int zip_decompress(const u8 *src, unsigned int slen,
 	zip_ops->input_len  = slen;
 	zip_ops->output_len = *dlen;
 
-	ret = zip_inflate(zip_ops, &zip_state, zip);
+	ret = zip_inflate(zip_ops, zip_state, zip);
 
 	if (!ret) {
 		*dlen = zip_ops->output_len;
 		memcpy(dst, zip_ops->output, *dlen);
 	}
-
+	kfree(zip_state);
 	return ret;
 }
 
-- 
2.16.2
