From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] crypto: img-hash - fix some compile warnings
Date: Fri, 20 Mar 2015 17:21:12 +0300
Message-ID: <20150320142112.GA5108@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	James Hartley <james.hartley@imgtec.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

GCC complains about that %u is the wrong format string for size_t and
also that "ret" is unused.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index fec61fc..601ab35 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -192,7 +192,7 @@ static int img_hash_xmit_cpu(struct img_hash_dev *hdev, const u8 *buf,
 	u32 count, len32;
 	const u32 *buffer = (const u32 *)buf;
 
-	dev_dbg(hdev->dev, "xmit_cpu:  length: %u bytes\n", length);
+	dev_dbg(hdev->dev, "xmit_cpu:  length: %zu bytes\n", length);
 
 	if (final)
 		hdev->flags |= DRIVER_FLAGS_FINAL;
@@ -459,7 +459,6 @@ static int img_hash_hw_init(struct img_hash_dev *hdev)
 {
 	unsigned long long nbits;
 	u32 u, l;
-	int ret;
 
 	img_hash_write(hdev, CR_RESET, CR_RESET_SET);
 	img_hash_write(hdev, CR_RESET, CR_RESET_UNSET);
