From: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Subject: [RESEND PATCH 2/2] crypto: sunxi-ss-hash: promote
 variables to match types in min3() calls
Date: Fri,  8 Jan 2016 11:24:09 +0000
Message-ID: <1452252249-12040-3-git-send-email-andre.przywara@arm.com>
References: <1452252249-12040-1-git-send-email-andre.przywara@arm.com>
Reply-To: andre.przywara-5wv7dgnIgG8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-sunxi+bncBDNZNK75ZIKRB5FYX22AKGQEPDRWJJA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1452252249-12040-1-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

(resending to add linux-crypto, patch unchanged)

The min3() macro expects all arguments to be of the same type (or
size at least).
Change the type of some local variables in sun4i-ss-hash.c to
size_t to match the type used in some generic structures we
compare against.
That shouldn't change anything for 32-bit (as size_t is unsigned int
there anyway), but allows compilation for 64-bit architectures.
There are two casts still necessary, because we can't change the type
in a generic structure.

Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 12 ++++++------
 drivers/crypto/sunxi-ss/sun4i-ss.h      |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index ff80314..c0384f1 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -170,7 +170,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 	struct sun4i_ss_ctx *ss = op->ss;
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	unsigned int in_i = 0; /* advancement in the current SG */
-	unsigned int end;
+	size_t end;
 	/*
 	 * end is the position when we need to stop writing to the device,
 	 * to be compared to i
@@ -181,7 +181,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 	size_t copied = 0;
 	struct sg_mapping_iter mi;
 
-	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
+	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%zu h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
 		op->byte_count, areq->nbytes, op->mode,
 		op->len, op->hash[0]);
@@ -206,7 +206,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 	end = ((areq->nbytes + op->len) / 64) * 64 - op->len;
 
 	if (end > areq->nbytes || areq->nbytes - end > 63) {
-		dev_err(ss->dev, "ERROR: Bound error %u %u\n",
+		dev_err(ss->dev, "ERROR: Bound error %zu %u\n",
 			end, areq->nbytes);
 		return -EINVAL;
 	}
@@ -266,7 +266,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 		}
 		if (mi.length - in_i > 3 && i < end) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
+			in_r = min3(mi.length - in_i, (size_t)areq->nbytes - i,
 				    ((mi.length - in_i) / 4) * 4);
 			/* how many bytes we can write in the device*/
 			todo = min3((u32)(end - i) / 4, rx_cnt, (u32)in_r / 4);
@@ -289,7 +289,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 	if ((areq->nbytes - i) < 64) {
 		while (i < areq->nbytes && in_i < mi.length && op->len < 64) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
+			in_r = min3(mi.length - in_i, (size_t)areq->nbytes - i,
 				    64 - op->len);
 			memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 			op->len += in_r;
@@ -352,7 +352,7 @@ int sun4i_hash_final(struct ahash_request *areq)
 	u32 wb = 0;
 	unsigned int nwait, nbw = 0;
 
-	dev_dbg(ss->dev, "%s: byte=%llu len=%u mode=%x wl=%u h=%x",
+	dev_dbg(ss->dev, "%s: byte=%llu len=%u mode=%x wl=%zu h=%x",
 		__func__, op->byte_count, areq->nbytes, op->mode,
 		op->len, op->hash[0]);
 
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss.h b/drivers/crypto/sunxi-ss/sun4i-ss.h
index 8e9c05f..c15fa21 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss.h
+++ b/drivers/crypto/sunxi-ss/sun4i-ss.h
@@ -162,7 +162,7 @@ struct sun4i_req_ctx {
 	u64 byte_count; /* number of bytes "uploaded" to the device */
 	u32 hash[5]; /* for storing SS_IVx register */
 	char buf[64];
-	unsigned int len;
+	size_t len;
 	struct sun4i_ss_ctx *ss;
 };
 
-- 
2.6.4
