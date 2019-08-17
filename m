Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF1FC3A59B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 05:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352AB21773
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 05:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566020160;
	bh=83kUourjajAToQFYcBf+Jk2P2AyTWHrrkjgRqA0NZhw=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=DPwZcGt4w8fR6S5VkXo+zhqoE8S5X6dMol+G8HfMMBgRu2gKHpGKNVUNT/ejQTFCq
	 E8049wYMkltvHGdmzJQX6lrQKJGFwB7/19PknaaFR3r9IOc958gXkUpPcoQFtiMR7M
	 jrkXes6mnO+W2Mgkn/Hj7ifoEE+KZc7JioMoxI5E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfHQFf7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 01:35:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfHQFf6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 01:35:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45052173B;
        Sat, 17 Aug 2019 05:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566020157;
        bh=83kUourjajAToQFYcBf+Jk2P2AyTWHrrkjgRqA0NZhw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=XMRxWPUW+NEmokwJNLtzfP2NH5LXW+SVP5x25SSWxYHZhiUL4zmr6FTTGeJq60vV4
         iFpvaMCPr1CHdDKoZD/h9wMprqhJTETkuXBvUOHsND0LVs+zKzjjQO+sKRAavOm/U6
         tzK8c62bW59F9Q/+sja2vY3EI/kdWaINsvYayru8=
Date:   Fri, 16 Aug 2019 22:35:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] crypto: sha256_generic - Use sha256_transform from
 generic sha256 lib
Message-ID: <20190817053555.GC8209@sol.localdomain>
Mail-Followup-To: Hans de Goede <hdegoede@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190816211611.2568-1-hdegoede@redhat.com>
 <20190816211611.2568-7-hdegoede@redhat.com>
 <20190817051318.GA8209@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817051318.GA8209@sol.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 16, 2019 at 10:13:18PM -0700, Eric Biggers wrote:
> On Fri, Aug 16, 2019 at 11:16:11PM +0200, Hans de Goede wrote:
> > Drop the duplicate sha256_transform function from crypto/sha256_generic.c
> > and use the implementation from lib/crypto/sha256.c instead.
> > "diff -u lib/crypto/sha256.c sha256_generic.c"
> > shows that both implementations are identical.
> > 
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> Hi Hans, thanks for doing this!
> 
> I'm a little concerned that the only sha256 lib function which sha256_generic.c
> calls is sha256_transform().  This means that sha256_init(), sha256_update(),
> and sha256_final() are not tested by the crypto self-tests.  They could be
> broken and we wouldn't know.
> 
> IMO, it would be better to make sha256_generic.c use sha256_init(),
> sha256_update(), and sha256_final() rather than using sha256_base.h.
> Then we'd get test coverage of both the sha256 lib, and of sha256_base.h
> via the architecture-specific implementations.
> 
> To do this you'll also need to add sha224_init(), sha224_update(), and
> sha224_final().  But that's straightforward.
> 

This is basically what I'm suggesting:

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 51b3afcb5407..94bb23e33804 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -39,39 +39,42 @@ const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
 };
 EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
-static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
-				    int blocks)
+static int crypto_sha256_init(struct shash_desc *desc)
 {
-	while (blocks--) {
-		sha256_transform(sst->state, src);
-		src += SHA256_BLOCK_SIZE;
-	}
+	return sha256_init(shash_desc_ctx(desc));
+}
+
+static int crypto_sha224_init(struct shash_desc *desc)
+{
+	return sha224_init(shash_desc_ctx(desc));
 }
 
 int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
-	return sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
+	return sha256_update(shash_desc_ctx(desc), data, len);
 }
 EXPORT_SYMBOL(crypto_sha256_update);
 
 static int crypto_sha256_final(struct shash_desc *desc, u8 *out)
 {
-	sha256_base_do_finalize(desc, sha256_generic_block_fn);
-	return sha256_base_finish(desc, out);
+	if (crypto_shash_digestsize(desc->tfm) == SHA224_DIGEST_SIZE)
+		return sha224_final(shash_desc_ctx(desc), out);
+	else
+		return sha256_final(shash_desc_ctx(desc), out);
 }
 
 int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *hash)
 {
-	sha256_base_do_update(desc, data, len, sha256_generic_block_fn);
+	sha256_update(shash_desc_ctx(desc), data, len);
 	return crypto_sha256_final(desc, hash);
 }
 EXPORT_SYMBOL(crypto_sha256_finup);
 
 static struct shash_alg sha256_algs[2] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_base_init,
+	.init		=	crypto_sha256_init,
 	.update		=	crypto_sha256_update,
 	.final		=	crypto_sha256_final,
 	.finup		=	crypto_sha256_finup,
@@ -85,7 +88,7 @@ static struct shash_alg sha256_algs[2] = { {
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_base_init,
+	.init		=	crypto_sha224_init,
 	.update		=	crypto_sha256_update,
 	.final		=	crypto_sha256_final,
 	.finup		=	crypto_sha256_finup,
diff --git a/include/crypto/sha256.h b/include/crypto/sha256.h
index f596202ad85f..44e207fb13ad 100644
--- a/include/crypto/sha256.h
+++ b/include/crypto/sha256.h
@@ -21,9 +21,13 @@
  */
 
 extern int sha256_init(struct sha256_state *sctx);
-extern void sha256_transform(u32 *state, const u8 *input);
 extern int sha256_update(struct sha256_state *sctx, const u8 *input,
 			 unsigned int length);
 extern int sha256_final(struct sha256_state *sctx, u8 *hash);
 
+extern int sha224_init(struct sha256_state *sctx);
+extern int sha224_update(struct sha256_state *sctx, const u8 *input,
+			 unsigned int length);
+extern int sha224_final(struct sha256_state *sctx, u8 *hash);
+
 #endif /* SHA256_H */
diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index 3e9cc54f7e1c..d808543b3784 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -42,7 +42,7 @@ static inline void BLEND_OP(int I, u32 *W)
 	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
 }
 
-void sha256_transform(u32 *state, const u8 *input)
+static void sha256_transform(u32 *state, const u8 *input)
 {
 	u32 a, b, c, d, e, f, g, h, t1, t2;
 	u32 W[64];
@@ -204,7 +204,6 @@ void sha256_transform(u32 *state, const u8 *input)
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 	memzero_explicit(W, 64 * sizeof(u32));
 }
-EXPORT_SYMBOL(sha256_transform);
 
 int sha256_init(struct sha256_state *sctx)
 {
@@ -222,6 +221,22 @@ int sha256_init(struct sha256_state *sctx)
 }
 EXPORT_SYMBOL(sha256_init);
 
+int sha224_init(struct sha256_state *sctx)
+{
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(sha224_init);
+
 int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 {
 	unsigned int partial, done;
@@ -253,7 +268,13 @@ int sha256_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
 }
 EXPORT_SYMBOL(sha256_update);
 
-int sha256_final(struct sha256_state *sctx, u8 *out)
+int sha224_update(struct sha256_state *sctx, const u8 *data, unsigned int len)
+{
+	return sha256_update(sctx, data, len);
+}
+EXPORT_SYMBOL(sha224_update);
+
+static int __sha256_final(struct sha256_state *sctx, u8 *out, int digest_words)
 {
 	__be32 *dst = (__be32 *)out;
 	__be64 bits;
@@ -273,7 +294,7 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
 	sha256_update(sctx, (const u8 *)&bits, sizeof(bits));
 
 	/* Store state in digest */
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < digest_words; i++)
 		dst[i] = cpu_to_be32(sctx->state[i]);
 
 	/* Zeroize sensitive information. */
@@ -281,4 +302,15 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
 
 	return 0;
 }
+
+int sha256_final(struct sha256_state *sctx, u8 *out)
+{
+	return __sha256_final(sctx, out, 8);
+}
 EXPORT_SYMBOL(sha256_final);
+
+int sha224_final(struct sha256_state *sctx, u8 *out)
+{
+	return __sha256_final(sctx, out, 7);
+}
+EXPORT_SYMBOL(sha224_final);
-- 
2.22.0

