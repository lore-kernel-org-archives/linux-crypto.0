Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49221C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 018EC64EB8
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhBASES (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhBASES (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8929064EA4;
        Mon,  1 Feb 2021 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202584;
        bh=41NkKPwBINPNhH3vH8P0Nqh9BMhuATrNvq/U/G3tqJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=llNoHeE+qOVXMDSE4EZbydED11mZ/WmV+Qy2RuqrF9nyC7UVwkwV4JSflYGgYgQow
         66CwB01EF8Bse5H9J9J3JsFwTIh3Ad06Ff4rGJ6ZXqc0m/PPmtJEq15iGoNcQ7/84k
         PLogq05uF/IzpRdml5Tet8xskhVbn9XV6WlTLZB76znSfG2Zc+vwdGi68fcANCt0Yq
         +Ep8oKLeio1Yc5NbMO3KqyuFSM8ik3+YCxIb/mhMdKiaEKTGrmF52efGwR7lHEDkhc
         cMvHgY/ixtvn0tyIQNwPxRSoALm61H+v3mU5KJoTQwPtcvELzEPciLLaf6mlBI53kP
         Li29sBqqhyMxA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6/9] crypto: cast5 - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:34 +0100
Message-Id: <20210201180237.3171-7-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of the
CAST5 input and output blocks, which propagates to mode drivers, and
results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/cast5_generic.c | 23 ++++++++------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/crypto/cast5_generic.c b/crypto/cast5_generic.c
index 4095085d4e51..0257c14cefc2 100644
--- a/crypto/cast5_generic.c
+++ b/crypto/cast5_generic.c
@@ -13,7 +13,7 @@
 */
 
 
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/module.h>
@@ -302,8 +302,6 @@ static const u32 sb8[256] = {
 
 void __cast5_encrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 {
-	const __be32 *src = (const __be32 *)inbuf;
-	__be32 *dst = (__be32 *)outbuf;
 	u32 l, r, t;
 	u32 I;			/* used by the Fx macros */
 	u32 *Km;
@@ -315,8 +313,8 @@ void __cast5_encrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 	/* (L0,R0) <-- (m1...m64).  (Split the plaintext into left and
 	 * right 32-bit halves L0 = m1...m32 and R0 = m33...m64.)
 	 */
-	l = be32_to_cpu(src[0]);
-	r = be32_to_cpu(src[1]);
+	l = get_unaligned_be32(inbuf);
+	r = get_unaligned_be32(inbuf + 4);
 
 	/* (16 rounds) for i from 1 to 16, compute Li and Ri as follows:
 	 *  Li = Ri-1;
@@ -347,8 +345,8 @@ void __cast5_encrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 
 	/* c1...c64 <-- (R16,L16).  (Exchange final blocks L16, R16 and
 	 *  concatenate to form the ciphertext.) */
-	dst[0] = cpu_to_be32(r);
-	dst[1] = cpu_to_be32(l);
+	put_unaligned_be32(r, outbuf);
+	put_unaligned_be32(l, outbuf + 4);
 }
 EXPORT_SYMBOL_GPL(__cast5_encrypt);
 
@@ -359,8 +357,6 @@ static void cast5_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 
 void __cast5_decrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 {
-	const __be32 *src = (const __be32 *)inbuf;
-	__be32 *dst = (__be32 *)outbuf;
 	u32 l, r, t;
 	u32 I;
 	u32 *Km;
@@ -369,8 +365,8 @@ void __cast5_decrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 	Km = c->Km;
 	Kr = c->Kr;
 
-	l = be32_to_cpu(src[0]);
-	r = be32_to_cpu(src[1]);
+	l = get_unaligned_be32(inbuf);
+	r = get_unaligned_be32(inbuf + 4);
 
 	if (!(c->rr)) {
 		t = l; l = r; r = t ^ F1(r, Km[15], Kr[15]);
@@ -391,8 +387,8 @@ void __cast5_decrypt(struct cast5_ctx *c, u8 *outbuf, const u8 *inbuf)
 	t = l; l = r; r = t ^ F2(r, Km[1], Kr[1]);
 	t = l; l = r; r = t ^ F1(r, Km[0], Kr[0]);
 
-	dst[0] = cpu_to_be32(r);
-	dst[1] = cpu_to_be32(l);
+	put_unaligned_be32(r, outbuf);
+	put_unaligned_be32(l, outbuf + 4);
 }
 EXPORT_SYMBOL_GPL(__cast5_decrypt);
 
@@ -513,7 +509,6 @@ static struct crypto_alg alg = {
 	.cra_flags		= CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		= CAST5_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct cast5_ctx),
-	.cra_alignmask		= 3,
 	.cra_module		= THIS_MODULE,
 	.cra_u			= {
 		.cipher = {
-- 
2.20.1

