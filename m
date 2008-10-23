From: Christian Hohnstaedt <christian@hohnstaedt.de>
Subject: Re: [PATCH] ixp4xx_crypto: avoid firmware loading during module initialisation
Date: Thu, 23 Oct 2008 14:28:32 +0200
Message-ID: <20081023122832.GC16037@mail3.prorata.de>
References: <20080818064455.GK22567@mail3.prorata.de> <E1KVJFO-0007Vh-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Hohnstaedt <christian@hohnstaedt.de>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.prorata.de ([62.145.31.200]:33313 "EHLO mail3.prorata.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbYJWMfk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Oct 2008 08:35:40 -0400
Content-Disposition: inline
In-Reply-To: <E1KVJFO-0007Vh-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 19, 2008 at 02:55:10PM +1000, Herbert Xu wrote:
> Christian Hohnstaedt <christian@hohnstaedt.de> wrote:
> > By moving the firmware-loading to the transform initialisation,
> > the driver may be compiled in.
> > 
> > Notify the user if the firmware does not support AES, or even
> > no crypto at all.
> 
> What happens when two tfms are constructed at the same time?
> 

Subject: [PATCH] ixp4xx_crypto: avoid firmware loading during module initialisation

 By moving the firmware-loading to the transform initialisation,
 the driver may be compiled in.

 Notify the user if the firmware does not support AES, or even
 no crypto at all.

 Protect firmware loading and memory allocation by a mutex.

Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>
---
 drivers/crypto/ixp4xx_crypto.c |  101 ++++++++++++++++++++++++++-------------
 1 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 2d637e0..440d672 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -17,6 +17,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/semaphore.h>
 
 #include <crypto/ctr.h>
 #include <crypto/des.h>
@@ -244,44 +245,25 @@ static inline const struct ix_hash_algo *ix_hash(struct crypto_tfm *tfm)
 	return container_of(tfm->__crt_alg, struct ixp_alg, crypto)->hash;
 }
 
-static int setup_crypt_desc(void)
-{
-	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
-	crypt_virt = dma_alloc_coherent(dev,
-			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_KERNEL);
-	if (!crypt_virt)
-		return -ENOMEM;
-	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));
-	return 0;
-}
-
 static spinlock_t desc_lock;
 static struct crypt_ctl *get_crypt_desc(void)
 {
 	int i;
 	static int idx = 0;
 	unsigned long flags;
+	struct crypt_ctl *ret = NULL;
 
 	spin_lock_irqsave(&desc_lock, flags);
 
-	if (unlikely(!crypt_virt))
-		setup_crypt_desc();
-	if (unlikely(!crypt_virt)) {
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return NULL;
-	}
 	i = idx;
 	if (crypt_virt[i].ctl_flags == CTL_FLAG_UNUSED) {
 		if (++idx >= NPE_QLEN)
 			idx = 0;
 		crypt_virt[i].ctl_flags = CTL_FLAG_USED;
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return crypt_virt +i;
-	} else {
-		spin_unlock_irqrestore(&desc_lock, flags);
-		return NULL;
+		ret = crypt_virt +i;
 	}
+	spin_unlock_irqrestore(&desc_lock, flags);
+	return ret;
 }
 
 static spinlock_t emerg_lock;
@@ -291,12 +273,11 @@ static struct crypt_ctl *get_crypt_desc_emerg(void)
 	static int idx = NPE_QLEN;
 	struct crypt_ctl *desc;
 	unsigned long flags;
+	struct crypt_ctl *ret = NULL;
 
 	desc = get_crypt_desc();
 	if (desc)
 		return desc;
-	if (unlikely(!crypt_virt))
-		return NULL;
 
 	spin_lock_irqsave(&emerg_lock, flags);
 	i = idx;
@@ -304,12 +285,10 @@ static struct crypt_ctl *get_crypt_desc_emerg(void)
 		if (++idx >= NPE_QLEN_TOTAL)
 			idx = NPE_QLEN;
 		crypt_virt[i].ctl_flags = CTL_FLAG_USED;
-		spin_unlock_irqrestore(&emerg_lock, flags);
-		return crypt_virt +i;
-	} else {
-		spin_unlock_irqrestore(&emerg_lock, flags);
-		return NULL;
+		ret = crypt_virt +i;
 	}
+	spin_unlock_irqrestore(&emerg_lock, flags);
+	return ret;
 }
 
 static void free_buf_chain(struct buffer_desc *buf, u32 phys)
@@ -438,10 +417,6 @@ static int init_ixp_crypto(void)
 	if (!npe_c)
 		return ret;
 
-	if (!npe_running(npe_c)) {
-		npe_load_firmware(npe_c, npe_name(npe_c), dev);
-	}
-
 	/* buffer_pool will also be used to sometimes store the hmac,
 	 * so assure it is large enough
 	 */
@@ -526,9 +501,62 @@ static void free_sa_dir(struct ix_sa_dir *dir)
 static int init_tfm(struct crypto_tfm *tfm)
 {
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 msg[2] = { 0, 0 };
+	static u32 image_id = 0;
+	static DECLARE_MUTEX(firmware);
 	int ret;
 
+	ret = down_interruptible(&firmware);
+	if (ret != 0)
+		return ret;
+
+	if (!npe_running(npe_c)) {
+		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
+		if (ret) {
+			up(&firmware);
+			return ret;
+		}
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		image_id = msg[1];
+	}
+	if (!image_id) {
+		if (npe_send_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
+			goto npe_error;
+
+		image_id = msg[1];
+	}
+
+	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
+	if (!crypt_virt)
+		crypt_virt = dma_alloc_coherent(dev,
+			NPE_QLEN * sizeof(struct crypt_ctl),
+			&crypt_phys, GFP_KERNEL);
+	if (!crypt_virt)
+		return -ENOMEM;
+
+	up(&firmware);
+
 	atomic_set(&ctx->configuring, 0);
+	switch ((image_id>>16) & 0xff) {
+		case 3:
+			if (cipher_cfg_enc(tfm) & MOD_AES) {
+				printk(KERN_ERR "Firmware of %s lacks AES "
+					"support\n", npe_name(npe_c));
+				return -ENODEV;
+			}
+		case 4:
+		case 5:
+			break;
+		default:
+			printk(KERN_ERR "Firmware of %s lacks crypto support\n",
+				npe_name(npe_c));
+			return -ENODEV;
+	}
 	ret = init_sa_dir(&ctx->encrypt);
 	if (ret)
 		return ret;
@@ -537,6 +565,11 @@ static int init_tfm(struct crypto_tfm *tfm)
 		free_sa_dir(&ctx->encrypt);
 	}
 	return ret;
+
+npe_error:
+	printk(KERN_ERR "%s not responding\n", npe_name(npe_c));
+	up(&firmware);
+	return -EIO;
 }
 
 static int init_tfm_ablk(struct crypto_tfm *tfm)
-- 
1.5.6.5

