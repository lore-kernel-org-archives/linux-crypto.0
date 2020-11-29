Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046A0C3E8C5
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Nov 2020 18:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE6C20731
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Nov 2020 18:21:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z36CtwZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgK2SVX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Nov 2020 13:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgK2SVW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Nov 2020 13:21:22 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-175-141.w2-15.abo.wanadoo.fr [2.15.255.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346FC20731;
        Sun, 29 Nov 2020 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606674041;
        bh=VcIZIPQEJW4lH7eWYwvcSkDR8IK9z2g3/NxvnSNp7kQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Z36CtwZaiFxDw7dYXBFXIdw5ZuI+vfwu+G5tUW4ZCK6TUtaquu/nGZDng+AeGRhA2
         BWqJ5K5AZrX2bx+gWX7DEgjAClv6U9z8Q8pdMuxREoGXUwlvzgXLKGxDBAwEWQjmcE
         H8Vbnkj4uMIO1Ucj7BBn7j8nmfTptUrD1JklYTog=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, greearb@candelatech.com,
        Steve deRosier <ardb@kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: [PATCH] crypto: aesni - add ccm(aes) algorithm implementation
Date:   Sun, 29 Nov 2020 19:20:35 +0100
Message-Id: <20201129182035.7015-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Steve deRosier <ardb@kernel.org>

Add ccm(aes) implementation from linux-wireless mailing list (see
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).

This eliminates FPU context store/restore overhead existing in more
general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.

Suggested-by: Ben Greear <greearb@candelatech.com>
Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
Ben,

This is almost a rewrite of the original patch, switching to the new
skcipher API, using the existing SIMD helper, and drop numerous unrelated
changes. The basic approach is almost identical, though, so I expect this
to perform on par or perhaps slightly faster than the original.

Could you please confirm with some numbers?

Thanks,
Ard.


 arch/x86/crypto/aesni-intel_glue.c | 310 ++++++++++++++++++++
 1 file changed, 310 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ad8a7188a2bf..f59f3c8772a6 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -513,6 +513,298 @@ static int ctr_crypt(struct skcipher_request *req)
 	return err;
 }
 
+static int aesni_ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
+			    unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return aes_set_key_common(crypto_aead_tfm(tfm), ctx, in_key, key_len);
+}
+
+static int aesni_ccm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	if ((authsize & 1) || authsize < 4)
+		return -EINVAL;
+	return 0;
+}
+
+static int ccm_set_msg_len(u8 *block, unsigned int msglen, int csize)
+{
+	__be32 data;
+
+	memset(block, 0, csize);
+	block += csize;
+
+	if (csize >= 4)
+		csize = 4;
+	else if (msglen > (1 << (8 * csize)))
+		return -EOVERFLOW;
+
+	data = cpu_to_be32(msglen);
+	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
+
+	return 0;
+}
+
+static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	__be32 *n = (__be32 *)&maciv[AES_BLOCK_SIZE - 8];
+	u32 l = req->iv[0] + 1;
+
+	/* verify that CCM dimension 'L' is set correctly in the IV */
+	if (l < 2 || l > 8)
+		return -EINVAL;
+
+	/* verify that msglen can in fact be represented in L bytes */
+	if (l < 4 && msglen >> (8 * l))
+		return -EOVERFLOW;
+
+	/*
+	 * Even if the CCM spec allows L values of up to 8, the Linux cryptoapi
+	 * uses a u32 type to represent msglen so the top 4 bytes are always 0.
+	 */
+	n[0] = 0;
+	n[1] = cpu_to_be32(msglen);
+
+	memcpy(maciv, req->iv, AES_BLOCK_SIZE - l);
+
+	/*
+	 * Meaning of byte 0 according to CCM spec (RFC 3610/NIST 800-38C)
+	 * - bits 0..2	: max # of bytes required to represent msglen, minus 1
+	 *                (already set by caller)
+	 * - bits 3..5	: size of auth tag (1 => 4 bytes, 2 => 6 bytes, etc)
+	 * - bit 6	: indicates presence of authenticate-only data
+	 */
+	maciv[0] |= (crypto_aead_authsize(aead) - 2) << 2;
+	if (req->assoclen)
+		maciv[0] |= 0x40;
+
+	memset(&req->iv[AES_BLOCK_SIZE - l], 0, l);
+	return ccm_set_msg_len(maciv + AES_BLOCK_SIZE - l, msglen, l);
+}
+
+static int compute_mac(struct crypto_aes_ctx *ctx, u8 mac[], u8 *data, int n,
+		       unsigned int ilen, u8 *idata)
+{
+	unsigned int bs = AES_BLOCK_SIZE;
+	u8 *odata = mac;
+	int datalen, getlen;
+
+	datalen = n;
+
+	/* first time in here, block may be partially filled. */
+	getlen = bs - ilen;
+	if (datalen >= getlen) {
+		memcpy(idata + ilen, data, getlen);
+
+		aesni_cbc_enc(ctx, odata, idata, AES_BLOCK_SIZE, odata);
+
+		datalen -= getlen;
+		data += getlen;
+		ilen = 0;
+	}
+
+	/* now encrypt rest of data */
+	while (datalen >= bs) {
+		aesni_cbc_enc(ctx, odata, data, AES_BLOCK_SIZE, odata);
+
+		datalen -= bs;
+		data += bs;
+	}
+
+	/* check and see if there's leftover data that wasn't
+	 * enough to fill a block.
+	 */
+	if (datalen) {
+		memcpy(idata + ilen, data, datalen);
+		ilen += datalen;
+	}
+	return ilen;
+}
+
+static void ccm_calculate_auth_mac(struct aead_request *req,
+				   struct crypto_aes_ctx *ctx, u8 mac[],
+				   struct scatterlist *src)
+{
+	unsigned int len = req->assoclen;
+	struct scatter_walk walk;
+	u8 idata[AES_BLOCK_SIZE];
+	unsigned int ilen;
+	struct {
+		__be16 l;
+		__be32 h;
+	} __packed *ltag = (void *)idata;
+
+	/* prepend the AAD with a length tag */
+	if (len < 0xff00) {
+		ltag->l = cpu_to_be16(len);
+		ilen = 2;
+	} else  {
+		ltag->l = cpu_to_be16(0xfffe);
+		ltag->h = cpu_to_be32(len);
+		ilen = 6;
+	}
+
+	scatterwalk_start(&walk, src);
+
+	while (len) {
+		u8 *src;
+		int n;
+
+		n = scatterwalk_clamp(&walk, len);
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		src = scatterwalk_map(&walk);
+
+		ilen = compute_mac(ctx, mac, src, n, ilen, idata);
+		len -= n;
+
+		scatterwalk_unmap(src);
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+	}
+
+	/* any leftover needs padding and then encrypted */
+	if (ilen) {
+		crypto_xor(mac, idata, ilen);
+		aesni_enc(ctx, mac, mac);
+	}
+}
+
+static int aesni_ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	u32 l = req->iv[0] + 1;
+	int err;
+
+	err = ccm_init_mac(req, mac, req->cryptlen);
+	if (err)
+		return err;
+
+	kernel_fpu_begin();
+
+	aesni_enc(ctx, mac, mac);
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, ctx, mac, req->src);
+
+	req->iv[AES_BLOCK_SIZE - 1] = 0x1;
+	err = skcipher_walk_aead_encrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int len = walk.nbytes & AES_BLOCK_MASK;
+		int n;
+
+		for (n = 0; n < len; n += AES_BLOCK_SIZE)
+			aesni_cbc_enc(ctx, mac, walk.src.virt.addr + n,
+				      AES_BLOCK_SIZE, mac);
+
+		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr, len,
+			      walk.iv);
+
+		err = skcipher_walk_done(&walk, walk.nbytes & ~AES_BLOCK_MASK);
+	}
+	if (walk.nbytes) {
+		u8 __aligned(8) buf[AES_BLOCK_SIZE] = {};
+
+		memcpy(buf, walk.src.virt.addr, walk.nbytes);
+		aesni_cbc_enc(ctx, mac, buf, AES_BLOCK_SIZE, mac);
+
+		ctr_crypt_final(ctx, &walk);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		goto fail;
+
+	memset(walk.iv + AES_BLOCK_SIZE - l, 0, l);
+	aesni_ctr_enc(ctx, mac, mac, AES_BLOCK_SIZE, walk.iv);
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+
+fail:
+	kernel_fpu_end();
+	return err;
+}
+
+static int aesni_ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	unsigned int authsize = crypto_aead_authsize(aead);
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u8 __aligned(8) tag[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	u32 l = req->iv[0] + 1;
+	int err;
+
+	err = ccm_init_mac(req, mac, req->cryptlen - authsize);
+	if (err)
+		return err;
+
+	/* copy authtag from end of src */
+	scatterwalk_map_and_copy(tag, req->src,
+				 req->assoclen + req->cryptlen - authsize,
+				 authsize, 0);
+
+	kernel_fpu_begin();
+
+	aesni_enc(ctx, mac, mac);
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, ctx, mac, req->src);
+
+	req->iv[AES_BLOCK_SIZE - 1] = 0x1;
+	err = skcipher_walk_aead_decrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int len = walk.nbytes & AES_BLOCK_MASK;
+		int n;
+
+		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr, len,
+			      walk.iv);
+
+		for (n = 0; n < len; n += AES_BLOCK_SIZE)
+			aesni_cbc_enc(ctx, mac, walk.dst.virt.addr + n,
+				      AES_BLOCK_SIZE, mac);
+
+		err = skcipher_walk_done(&walk, walk.nbytes & ~AES_BLOCK_MASK);
+	}
+	if (walk.nbytes) {
+		u8 __aligned(8) buf[AES_BLOCK_SIZE] = {};
+
+		ctr_crypt_final(ctx, &walk);
+
+		memcpy(buf, walk.dst.virt.addr, walk.nbytes);
+		aesni_cbc_enc(ctx, mac, buf, AES_BLOCK_SIZE, mac);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		goto fail;
+
+	memset(walk.iv + AES_BLOCK_SIZE - l, 0, l);
+	aesni_ctr_enc(ctx, mac, mac, AES_BLOCK_SIZE, walk.iv);
+
+	/* compare calculated auth tag with the stored one */
+	if (crypto_memneq(mac, tag, authsize))
+		err = -EBADMSG;
+
+fail:
+	kernel_fpu_end();
+	return err;
+}
+
 static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -1044,6 +1336,24 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_alignmask		= AESNI_ALIGN - 1,
 		.cra_module		= THIS_MODULE,
 	},
+}, {
+	.setkey		= aesni_ccm_setkey,
+	.setauthsize	= aesni_ccm_setauthsize,
+	.encrypt	= aesni_ccm_encrypt,
+	.decrypt	= aesni_ccm_decrypt,
+	.ivsize		= AES_BLOCK_SIZE,
+	.chunksize	= AES_BLOCK_SIZE,
+	.maxauthsize	= AES_BLOCK_SIZE,
+	.base = {
+		.cra_name		= "__ccm(aes)",
+		.cra_driver_name	= "__ccm-aesni",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_blocksize		= 1,
+		.cra_ctxsize		= sizeof(struct crypto_aes_ctx),
+		.cra_alignmask		= AESNI_ALIGN - 1,
+		.cra_module		= THIS_MODULE,
+	},
 } };
 #else
 static struct aead_alg aesni_aeads[0];
-- 
2.17.1

