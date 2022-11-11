Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB15DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 22:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiKKWgW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 17:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiKKWgV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 17:36:21 -0500
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 14:36:19 PST
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8876713B
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 14:36:19 -0800 (PST)
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 23E002328B9
        for <linux-crypto@vger.kernel.org>; Fri, 11 Nov 2022 22:29:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.26])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6C3601A006F;
        Fri, 11 Nov 2022 22:29:02 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EF34E940081;
        Fri, 11 Nov 2022 22:29:01 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 15DC513C2B0;
        Fri, 11 Nov 2022 14:29:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 15DC513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1668205741;
        bh=sR6ydi+bBJ3s55HLU4zSRBlXchfPMeikHACE4GxpvHA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=X2ZMPnkL9hnu8+PQSab1Od7sXHQvShx7Z4GtBL9uG9esbe82g44+TEMMqyevEI0Da
         fNcsY8tArBzhszm2txUL5kYVsrDB0sIm6XoBsreN3+GEL1RGn6AtlIpbg+VZQthhFt
         /3aisDoPWgq1fOfcORMtLEZkqwQy0u+9/Jq/jJrk=
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
References: <20201210024342.GA26428@gondor.apana.org.au>
 <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au>
 <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au>
 <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au>
 <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
 <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com>
Date:   Fri, 11 Nov 2022 14:29:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------C33E7C51322E00A5B7E413AC"
Content-Language: en-US
X-MDID: 1668205742-slwXTfPRH3WH
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a multi-part message in MIME format.
--------------C33E7C51322E00A5B7E413AC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/22 2:05 AM, Ard Biesheuvel wrote:
> On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
>>>
>>> While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
>>> and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
>>> supported upstream now?  Or is it specific to whatever xctr is?  If so,
>>> any chance the patch is wanted upstream now?
>>
>> AFAICS the xctr patch has nothing to do with what you were trying
>> to achieve with wireless.  My objection still stands with regards
>> to wireless, we should patch wireless to use the async crypto
>> interface and not hack around it in the Crypto API.
>>
> 
> Indeed. Those are just add/add conflicts because both patches
> introduce new code into the same set of files. The resolution is
> generally to keep both sides.
> 
> As for Herbert's objection: I will note here that in the meantime,
> arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
> skipcher implementations, because those are only callable in task or
> softirq context, and the arm64 SIMD wrappers now disable softirq
> processing. This means that the condition that results in the fallback
> being needed can no longer occur, making the SIMD helper dead code on
> arm64.
> 
> I suppose we might do the same thing on x86, but since the kernel mode
> SIMD handling is highly arch specific, you'd really need to raise this
> with the x86 maintainers.
> 

Hello Ard,

Could you please review the attached patch to make sure I merged it properly?  My concern
is the cleanup section and/or some problems I might have introduced related to the similarly
named code that was added upstream.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------C33E7C51322E00A5B7E413AC
Content-Type: text/x-patch; charset=UTF-8;
 name="aesni.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="aesni.patch"

commit 32812e13c542751fce409a305a383fa0baa59b63
Author: Ard Biesheuvel <ardb@kernel.org>
Date:   Tue Dec 1 20:45:56 2020 +0100

    crypto: aesni - add ccm(aes) algorithm implementation
    
    Add ccm(aes) implementation from linux-wireless mailing list (see
    http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
    
    This eliminates FPU context store/restore overhead existing in more
    general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
    
    Suggested-by: Ben Greear <greearb@candelatech.com>
    Co-developed-by: Steve deRosier <derosier@cal-sierra.com>
    Signed-off-by: Steve deRosier <derosier@cal-sierra.com>
    Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index a5b0cb3efeba..aa666aefee0e 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -105,6 +105,8 @@ asmlinkage void aesni_xts_encrypt(const struct crypto_aes_ctx *ctx, u8 *out,
 
 asmlinkage void aesni_xts_decrypt(const struct crypto_aes_ctx *ctx, u8 *out,
 				  const u8 *in, unsigned int len, u8 *iv);
+asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
 
 #ifdef CONFIG_X86_64
 
@@ -489,6 +491,377 @@ static int cts_cbc_decrypt(struct skcipher_request *req)
 	return skcipher_walk_done(&walk, 0);
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
 static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv)
@@ -1226,6 +1599,23 @@ static struct aead_alg aesni_aeads[] = { {
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
@@ -1274,6 +1664,12 @@ static int __init aesni_init(void)
 	if (err)
 		goto unregister_skciphers;
 
+	if (IS_ENABLED(CONFIG_X86_64)) {
+		err = crypto_register_aead(&aesni_ccm_aead);
+		if (err)
+			goto unregister_aeads_ccm;
+	}
+
 #ifdef CONFIG_X86_64
 	if (boot_cpu_has(X86_FEATURE_AVX))
 		err = simd_register_skciphers_compat(&aesni_xctr, 1,
@@ -1290,6 +1686,9 @@ static int __init aesni_init(void)
 				aesni_simd_aeads);
 #endif /* CONFIG_X86_64 */
 
+unregister_aeads_ccm:
+	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
+			      aesni_simd_aeads);
 unregister_skciphers:
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),
 				  aesni_simd_skciphers);
@@ -1300,6 +1699,9 @@ static int __init aesni_init(void)
 
 static void __exit aesni_exit(void)
 {
+	if (IS_ENABLED(CONFIG_X86_64))
+		crypto_unregister_aead(&aesni_ccm_aead);
+
 	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
 			      aesni_simd_aeads);
 	simd_unregister_skciphers(aesni_skciphers, ARRAY_SIZE(aesni_skciphers),

--------------C33E7C51322E00A5B7E413AC--
