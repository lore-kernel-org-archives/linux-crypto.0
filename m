Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B601C31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E744E20657
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfFQN0K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:26:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:41463 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQN0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 09:26:10 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MX0TX-1i9gNF0AcT-00XJq8; Mon, 17 Jun 2019 15:25:44 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sun4i-ss - reduce stack usage
Date:   Mon, 17 Jun 2019 15:25:17 +0200
Message-Id: <20190617132538.2759714-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dFwYisfe6d2an5iBSpuKsBUEx+RF3JE6zy3kMwlMfCg7C2kZf0c
 PJikbpLoKWB73dg8OZ7imWqut7mlrzfXDcXPVF7ZaYE0RbSUY+R7X/cUixMA94QK8XjJd21
 WZuqEXE7u2uV7j45rFWcWnO0Jk87FpZ1a7nxkWWLEk7FQH7/KbYMNlo+/IEFTtNltB6+9/S
 yJWrQw+tofrEr5PREnDfg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:exdzb5w2Xvg=:CR0sH9nRwYSNSihZH7/ieP
 PqFOiHTJoHbbDqjQ4h4U4kp9gYCvssxRdDXHNk73s+boKIHlXHfX1VxeTCfAQ1KMxvk4obJbc
 8DvnpBdS67DPeTimuip5YhBQHQSUFWO+y+hI4daiVknrVFSbSZOnMqbsc9jKoYRUJBMB5J/Jz
 iRLQIml9Y1ukfycCtY6x4Bf8eB7CyGJOe01JAtJZ0RMryNtNJlEBNyMh4YlUSO2OE+5IcJzqR
 B7EX8efA8KNgB2kCXXCbOAjrH+eebd9bHHBwMB908emBwSSW0pelmwQUZntZNbibogvJnIedQ
 wiAlAYa4RXc8eLAc7PUrDuO+QVHxugAnlEo+7f5OriGvDNP6d4Dafb6Q3BFZ0j+aPsmalwSI5
 m/7ZhXzZeN/q0lMp5QuffDXm1ggDDI3lJNvXwyCFwJxVzA9Q7Z8tEHoU9uwyIl6j6YmLtIEF8
 2i4KeOl4UIhwApvdupvgnElE2J/0Gpd5WAnG4fUhsNQuj3FLeGTioPsNk7U361BNXEAzwgi0h
 JdtidaMv0V+WGpjTYgVG6duYDv1Ajo17MBMkjdSX5CuCMZO6pelE66pBr8luJyCvHsQbhC315
 Ggt3vpGPPepYDU26se02fp4WUTcILALRo4Hp4sn1aVzmO2tQNA/EKHxnDbd95H3WoAA6u6IVC
 Nzi+lXiJJNgp8D6PTYGrh/b4XbTUV0XZ5Ws4+Dw/O75R3OT25AJA6stsiyIuTXTtopOV/IyQR
 SaBO9W4HYbEj3e8+BSysPB5eyxlF2kB56t2dEw==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After the latest addition, the stack usage of sun4i_ss_cipher_poll
grew beyond the warning limit when KASAN is enabled:

drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:118:12: error: stack frame size of 1152 bytes in function 'sun4i_ss_cipher_poll' [-Werror,-Wframe-larger-than=]
static int sun4i_ss_cipher_poll(struct skcipher_request *areq)

Reduce it in three ways:

- split out the new code into a separate function so its stack
  usage can overlap that of the sun4i_ss_opti_poll() code path
- mark both special cases as noinline_for_stack, which should
  ideally result in a tail call that frees the rest of the
  stack
- move the buf and obuf variables into the code blocks in
  which they are used.

The three separate functions now use 144, 640 and 304 bytes of kernel
stack, respectively.

Fixes: 0ae1f46c55f8 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 47 +++++++++++++++--------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index 7b0c42882830..4ab14d58e85b 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -12,7 +12,7 @@
  */
 #include "sun4i-ss.h"
 
-static int sun4i_ss_opti_poll(struct skcipher_request *areq)
+static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
@@ -114,6 +114,29 @@ static int sun4i_ss_opti_poll(struct skcipher_request *areq)
 	return err;
 }
 
+
+static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct sun4i_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, op->fallback_tfm);
+	int err;
+
+	skcipher_request_set_sync_tfm(subreq, op->fallback_tfm);
+	skcipher_request_set_callback(subreq, areq->base.flags, NULL,
+				      NULL);
+	skcipher_request_set_crypt(subreq, areq->src, areq->dst,
+				   areq->cryptlen, areq->iv);
+	if (ctx->mode & SS_DECRYPTION)
+		err = crypto_skcipher_decrypt(subreq);
+	else
+		err = crypto_skcipher_encrypt(subreq);
+	skcipher_request_zero(subreq);
+
+	return err;
+}
+
 /* Generic function that support SG with size not multiple of 4 */
 static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 {
@@ -140,8 +163,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
-	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
-	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
 	unsigned int ob = 0;	/* offset in buf */
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
@@ -178,20 +199,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (no_chunk == 1 && !need_fallback)
 		return sun4i_ss_opti_poll(areq);
 
-	if (need_fallback) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, op->fallback_tfm);
-		skcipher_request_set_sync_tfm(subreq, op->fallback_tfm);
-		skcipher_request_set_callback(subreq, areq->base.flags, NULL,
-					      NULL);
-		skcipher_request_set_crypt(subreq, areq->src, areq->dst,
-					   areq->cryptlen, areq->iv);
-		if (ctx->mode & SS_DECRYPTION)
-			err = crypto_skcipher_decrypt(subreq);
-		else
-			err = crypto_skcipher_encrypt(subreq);
-		skcipher_request_zero(subreq);
-		return err;
-	}
+	if (need_fallback)
+		return sun4i_ss_cipher_poll_fallback(areq);
 
 	spin_lock_irqsave(&ss->slock, flags);
 
@@ -224,6 +233,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
+			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
+
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -281,6 +292,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				oo = 0;
 			}
 		} else {
+			char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
+
 			/*
 			 * read obl bytes in bufo, we read at maximum for
 			 * emptying the device
-- 
2.20.0

