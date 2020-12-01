Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1203C64E7B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 19:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756EE206F9
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 19:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pSMjlCFT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgLATqn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 14:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbgLATqn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 14:46:43 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-175-141.w2-15.abo.wanadoo.fr [2.15.255.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9131206F9;
        Tue,  1 Dec 2020 19:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606851962;
        bh=xY++p9CbwDx+6dG6ti4+1x0Z/poqFoL1M5bukPHVmTo=;
        h=From:To:Cc:Subject:Date:From;
        b=pSMjlCFTUSdURq7GzITdle8ra6J7l2AHRLI4x6CFxqnqJJ/pklTIDXUfaUe/gVPmN
         xIMCqEjluWml/1r9bbYlVY3ktLTPISxrNIKiyKTGdv4sr4xa1fRrOZup335WhKjwSF
         ln3EwTvbqnn7whxxtNWtADtc3iw0w0UWeXImaXvg=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, greearb@candelatech.com,
        Ard Biesheuvel <ardb@kernel.org>,
        Steve deRosier <derosier@cal-sierra.com>
Subject: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Date:   Tue,  1 Dec 2020 20:45:56 +0100
Message-Id: <20201201194556.5220-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add ccm(aes) implementation from linux-wireless mailing list (see
http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).

This eliminates FPU context store/restore overhead existing in more
general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.

Suggested-by: Ben Greear <greearb@candelatech.com>
Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v2: avoid the SIMD helper, as it produces an CRYPTO_ALG_ASYNC aead, which
    is not usable by the 802.11 ccmp driver

 arch/x86/crypto/aesni-intel_glue.c | 406 +++++++++++++++++++-
 1 file changed, 404 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ad8a7188a2bf..d90b03d9b420 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -97,12 +97,13 @@ asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 #define AVX_GEN2_OPTSIZE 640
 #define AVX_GEN4_OPTSIZE 4096
 
+asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
+
 #ifdef CONFIG_X86_64
 
 static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
-asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			      const u8 *in, unsigned int len, u8 *iv);
 
 asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
 				 const u8 *in, bool enc, le128 *iv);
@@ -454,6 +455,377 @@ static int cbc_decrypt(struct skcipher_request *req)
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
+		       unsigned int ilen, u8 *idata, bool do_simd)
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
+		if (likely(do_simd)) {
+			aesni_cbc_enc(ctx, odata, idata, AES_BLOCK_SIZE, odata);
+		} else {
+			crypto_xor(odata, idata, AES_BLOCK_SIZE);
+			aes_encrypt(ctx, odata, odata);
+		}
+
+		datalen -= getlen;
+		data += getlen;
+		ilen = 0;
+	}
+
+	/* now encrypt rest of data */
+	while (datalen >= bs) {
+		if (likely(do_simd)) {
+			aesni_cbc_enc(ctx, odata, data, AES_BLOCK_SIZE, odata);
+		} else {
+			crypto_xor(odata, data, AES_BLOCK_SIZE);
+			aes_encrypt(ctx, odata, odata);
+		}
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
+				   struct scatterlist *src,
+				   bool do_simd)
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
+		ilen = compute_mac(ctx, mac, src, n, ilen, idata, do_simd);
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
+		if (likely(do_simd))
+			aesni_enc(ctx, mac, mac);
+		else
+			aes_encrypt(ctx, mac, mac);
+	}
+}
+
+static int aesni_ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	bool const do_simd = crypto_simd_usable();
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u8 __aligned(8) buf[AES_BLOCK_SIZE];
+	struct skcipher_walk walk;
+	u32 l = req->iv[0] + 1;
+	int err;
+
+	err = ccm_init_mac(req, mac, req->cryptlen);
+	if (err)
+		return err;
+
+	if (likely(do_simd)) {
+		kernel_fpu_begin();
+		aesni_enc(ctx, mac, mac);
+	} else {
+		aes_encrypt(ctx, mac, mac);
+	}
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, ctx, mac, req->src, do_simd);
+
+	req->iv[AES_BLOCK_SIZE - 1] = 0x1;
+	err = skcipher_walk_aead_encrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int len = walk.nbytes & AES_BLOCK_MASK;
+		int n;
+
+		for (n = 0; n < len; n += AES_BLOCK_SIZE) {
+			if (likely(do_simd)) {
+				aesni_cbc_enc(ctx, mac, walk.src.virt.addr + n,
+					      AES_BLOCK_SIZE, mac);
+			} else {
+				crypto_xor(mac, walk.src.virt.addr + n,
+					   AES_BLOCK_SIZE);
+				aes_encrypt(ctx, mac, mac);
+
+				aes_encrypt(ctx, buf, walk.iv);
+				crypto_inc(walk.iv, AES_BLOCK_SIZE);
+				crypto_xor_cpy(walk.dst.virt.addr + n,
+					       walk.src.virt.addr + n,
+					       buf, AES_BLOCK_SIZE);
+			}
+		}
+		if (likely(do_simd))
+			aesni_ctr_enc(ctx, walk.dst.virt.addr,
+				      walk.src.virt.addr, len, walk.iv);
+
+		err = skcipher_walk_done(&walk, walk.nbytes & ~AES_BLOCK_MASK);
+	}
+	if (walk.nbytes) {
+		if (likely(do_simd))
+			aesni_enc(ctx, buf, walk.iv);
+		else
+			aes_encrypt(ctx, buf, walk.iv);
+
+		crypto_xor(mac, walk.src.virt.addr, walk.nbytes);
+		crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       buf, walk.nbytes);
+
+		if (likely(do_simd))
+			aesni_enc(ctx, mac, mac);
+		else
+			aes_encrypt(ctx, mac, mac);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		goto fail;
+
+	memset(walk.iv + AES_BLOCK_SIZE - l, 0, l);
+
+	if (likely(do_simd)) {
+		aesni_ctr_enc(ctx, mac, mac, AES_BLOCK_SIZE, walk.iv);
+	} else {
+		aes_encrypt(ctx, buf, walk.iv);
+		crypto_xor(mac, buf, AES_BLOCK_SIZE);
+	}
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+
+fail:
+	if (likely(do_simd))
+		kernel_fpu_end();
+	return err;
+}
+
+static int aesni_ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	unsigned int authsize = crypto_aead_authsize(aead);
+	bool const do_simd = crypto_simd_usable();
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u8 __aligned(8) tag[AES_BLOCK_SIZE];
+	u8 __aligned(8) buf[AES_BLOCK_SIZE];
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
+	if (likely(do_simd)) {
+		kernel_fpu_begin();
+		aesni_enc(ctx, mac, mac);
+	} else {
+		aes_encrypt(ctx, mac, mac);
+	}
+
+	if (req->assoclen)
+		ccm_calculate_auth_mac(req, ctx, mac, req->src, do_simd);
+
+	req->iv[AES_BLOCK_SIZE - 1] = 0x1;
+	err = skcipher_walk_aead_decrypt(&walk, req, true);
+
+	while (walk.nbytes >= AES_BLOCK_SIZE) {
+		int len = walk.nbytes & AES_BLOCK_MASK;
+		int n;
+
+		if (likely(do_simd))
+			aesni_ctr_enc(ctx, walk.dst.virt.addr,
+				      walk.src.virt.addr, len, walk.iv);
+
+		for (n = 0; n < len; n += AES_BLOCK_SIZE) {
+			if (likely(do_simd)) {
+				aesni_cbc_enc(ctx, mac, walk.dst.virt.addr + n,
+					      AES_BLOCK_SIZE, mac);
+			} else {
+				aes_encrypt(ctx, buf, walk.iv);
+				crypto_inc(walk.iv, AES_BLOCK_SIZE);
+				crypto_xor_cpy(walk.dst.virt.addr + n,
+					       walk.src.virt.addr + n,
+					       buf, AES_BLOCK_SIZE);
+
+				crypto_xor(mac, walk.dst.virt.addr + n,
+					   AES_BLOCK_SIZE);
+				aes_encrypt(ctx, mac, mac);
+			}
+		}
+
+		err = skcipher_walk_done(&walk, walk.nbytes & ~AES_BLOCK_MASK);
+	}
+	if (walk.nbytes) {
+		if (likely(do_simd))
+			aesni_enc(ctx, buf, walk.iv);
+		else
+			aes_encrypt(ctx, buf, walk.iv);
+
+		crypto_xor_cpy(walk.dst.virt.addr, walk.src.virt.addr,
+			       buf, walk.nbytes);
+		crypto_xor(mac, walk.dst.virt.addr, walk.nbytes);
+
+		if (likely(do_simd))
+			aesni_enc(ctx, mac, mac);
+		else
+			aes_encrypt(ctx, mac, mac);
+
+		err = skcipher_walk_done(&walk, 0);
+	}
+
+	if (err)
+		goto fail;
+
+	memset(walk.iv + AES_BLOCK_SIZE - l, 0, l);
+
+	if (likely(do_simd)) {
+		aesni_ctr_enc(ctx, mac, mac, AES_BLOCK_SIZE, walk.iv);
+	} else {
+		aes_encrypt(ctx, buf, walk.iv);
+		crypto_xor(mac, buf, AES_BLOCK_SIZE);
+	}
+
+	/* compare calculated auth tag with the stored one */
+	if (crypto_memneq(mac, tag, authsize))
+		err = -EBADMSG;
+
+fail:
+	if (likely(do_simd))
+		kernel_fpu_end();
+	return err;
+}
+
 #ifdef CONFIG_X86_64
 static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 			    struct skcipher_walk *walk)
@@ -1045,10 +1417,28 @@ static struct aead_alg aesni_aeads[] = { {
 		.cra_module		= THIS_MODULE,
 	},
 } };
+
 #else
 static struct aead_alg aesni_aeads[0];
 #endif
 
+static struct aead_alg aesni_ccm_aead = {
+	.base.cra_name		= "ccm(aes)",
+	.base.cra_driver_name	= "ccm-aesni",
+	.base.cra_priority	= 400,
+	.base.cra_blocksize	= 1,
+	.base.cra_ctxsize	= sizeof(struct crypto_aes_ctx),
+	.base.cra_module	= THIS_MODULE,
+
+	.setkey			= aesni_ccm_setkey,
+	.setauthsize		= aesni_ccm_setauthsize,
+	.encrypt		= aesni_ccm_encrypt,
+	.decrypt		= aesni_ccm_decrypt,
+	.ivsize			= AES_BLOCK_SIZE,
+	.chunksize		= AES_BLOCK_SIZE,
+	.maxauthsize		= AES_BLOCK_SIZE,
+};
+
 static struct simd_aead_alg *aesni_simd_aeads[ARRAY_SIZE(aesni_aeads)];
 
 static const struct x86_cpu_id aesni_cpu_id[] = {
@@ -1098,8 +1488,17 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_skciphers;
 
+	if (IS_ENABLED(CONFIG_X86_64)) {
+		err = crypto_register_aead(&aesni_ccm_aead);
+		if (err)
+			goto unregister_aeads;
+	}
+
 	return 0;
 
+unregister_aeads:
+	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+			      aesni_simd_aeads);
 unregister_skciphers:
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
@@ -1110,6 +1509,9 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
+	if (IS_ENABLED(CONFIG_X86_64))
+		crypto_unregister_aead(&aesni_ccm_aead);
+
 	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
 			      aesni_simd_aeads);
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
-- 
2.17.1

