Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED51C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BFC821019
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEWGfe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:35:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47606 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWGfe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:35:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThK8-0001Zh-PY; Thu, 23 May 2019 14:35:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThK6-0003Zc-P7; Thu, 23 May 2019 14:35:30 +0800
Date:   Thu, 23 May 2019 14:35:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>
Subject: crypto: ixp4xx - Fix cross-compile errors due to type mismatch
Message-ID: <20190523063530.m5hgp4x6twces7v5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch changes multiple uses of u32s to dma_addr_t where the
physical address is used.  This fixes COMPILE_TEST errors on 64-bit
platforms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index c99ba75caf3a..8db107f111dd 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -104,7 +106,7 @@ struct buffer_desc {
 	u16 pkt_len;
 	u16 buf_len;
 #endif
-	u32 phys_addr;
+	dma_addr_t phys_addr;
 	u32 __reserved[4];
 	struct buffer_desc *next;
 	enum dma_data_direction dir;
@@ -121,9 +123,9 @@ struct crypt_ctl {
 	u8 mode;		/* NPE_OP_*  operation mode */
 #endif
 	u8 iv[MAX_IVLEN];	/* IV for CBC mode or CTR IV for CTR mode */
-	u32 icv_rev_aes;	/* icv or rev aes */
-	u32 src_buf;
-	u32 dst_buf;
+	dma_addr_t icv_rev_aes;	/* icv or rev aes */
+	dma_addr_t src_buf;
+	dma_addr_t dst_buf;
 #ifdef __ARMEB__
 	u16 auth_offs;		/* Authentication start offset */
 	u16 auth_len;		/* Authentication data length */
@@ -324,7 +326,8 @@ static struct crypt_ctl *get_crypt_desc_emerg(void)
 	}
 }
 
-static void free_buf_chain(struct device *dev, struct buffer_desc *buf,u32 phys)
+static void free_buf_chain(struct device *dev, struct buffer_desc *buf,
+			   dma_addr_t phys)
 {
 	while (buf) {
 		struct buffer_desc *buf1;
@@ -606,7 +609,7 @@ static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
 	struct buffer_desc *buf;
 	int i;
 	u8 *pad;
-	u32 pad_phys, buf_phys;
+	dma_addr_t pad_phys, buf_phys;
 
 	BUILD_BUG_ON(NPE_CTX_LEN < HMAC_PAD_BLOCKLEN);
 	pad = dma_pool_alloc(ctx_pool, GFP_KERNEL, &pad_phys);
@@ -791,7 +794,7 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 	for (; nbytes > 0; sg = sg_next(sg)) {
 		unsigned len = min(nbytes, sg->length);
 		struct buffer_desc *next_buf;
-		u32 next_buf_phys;
+		dma_addr_t next_buf_phys;
 		void *ptr;
 
 		nbytes -= len;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
