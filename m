Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A416CC004D4
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Jan 2023 18:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjAUSkw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Jan 2023 13:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjAUSkw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Jan 2023 13:40:52 -0500
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 Jan 2023 10:40:49 PST
Received: from aib29gb126.yyz1.oracleemaildelivery.com (aib29gb126.yyz1.oracleemaildelivery.com [192.29.72.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED71F5D7
        for <linux-crypto@vger.kernel.org>; Sat, 21 Jan 2023 10:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pMLAganrqKYVk/bJ7q4cPgOGRtJfyiwG8ewCGGAqW+k=;
 b=eXJzK8g88EsmV7Met9X6SQMnawctdjuFDospxM3giSvhjbdaYKMMMncYs0b6yDEpM3LRrvquBEOr
   wEBJ9aCaNcMtjfpAMJ27fGrK7CyUDF02knOH8y4yhAJILSuYEKYpqRUg+x+30GlnLpqfgR78YZvL
   DkkF+gApxpMwVOGSm2s3ovyt8zlfMIt9Rlm2zIRy8jppfpVolHRbSxdD7Ek0RQJa/Asmk9ccBi3O
   eKYPKCs3ujA/Z0SA/eZ3bhBauRYZSQAYoGJIpFnsdwr3Vj64dwWLceGEcyGeLbtEu4HE57ssEzJC
   F0qbcj0uIk8Vgw7IukZMfwVL/UslbsvctdtqrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=pMLAganrqKYVk/bJ7q4cPgOGRtJfyiwG8ewCGGAqW+k=;
 b=H/Xws22KdvF7dhUE5ndJEt0qpxAo3WhXyb1c2CGmuODY/RyL30tlIVTSlNi6kaCHSgwkt0gGsiBO
   9moMPxJzCOHPDP5JPPkgWiLm9zaD0aTosUnepXo+4sWYGlHf4xfJQtfk1iTZmEeDiyUAZfjso5pf
   29ZYbNFMVgBJpgu1m+64+R3Hxw0Dk3l60NHlIcsGrJycMsvjirKKqGEdaaURE/St/vxf1vPybT4f
   Qod8r+5qAv4Wf/MWEBFHrhkO6+obVy1nHCURqsF9ODowyW4yZgM1yc//R7+NUuqrK+ejXZ7+I4/c
   4MxkMcVaKeh7N8Cgl71eOBIMhWsKFG/9NrJ2CQ==
Received: by omta-ad1-fd3-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0ROU00C9AMBOTZ30@omta-ad1-fd3-101-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Sat, 21 Jan 2023 18:35:48 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, ardb@kernel.org,
        linux-kernel@vger.kernel.org, conor.dooley@microchip.com,
        x86@kernel.org
Subject: [PATCH RESEND] crypto: x86 - exit fpu context earlier in ECB/CBC macros
Date:   Sat, 21 Jan 2023 13:34:50 -0500
Message-id: <20230121183450.14570-1-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAHti/A/VBUEry6Wh9cg4KLobGKhnYtxA2zEdZswC1iVMoZYeOrD2P26pp6VvkhJ
 hDYDYUod6foXe7OH+gHF77bs70d6kWYZ9KHoYpCrg1j78tVkpFvfuL6ftU6vdV5p
 V7Qf6FdAGuJ/9nARyw+W3Rqj05rbaynaRZ6mCj2HL5jxTz4evBd8VGtCAU57sQ8L
 OXdUY1xkR9qwLlyqHriQu+80xTnNSNgMAT0w/HnEkpNoct/x9ErQauXMQf/Qe+67
 cej150OXP7XFjq7mBav6hyVPlJqUOtm7p7mNZi7tQ5/9bObybZT7kn27wQ/svUG4
 g1WEP9i95QdDj3e2QpW3evATKW9FMcJevxl0lk/K9pehOCv9CE/Gq2ZmPgtglLLg
 L0pKlsLiPvgEOc96pc2tVltzx1QbLFa3gqa3QsiopcQ8JTGeaUeX5fxJ1ZAw6Mfi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the ecb/cbc macros hold fpu context unnecessarily when using
scalar cipher routines (e.g. when handling odd sizes of blocks per walk).

Change the macros to drop fpu context as soon as the fpu is out of use.

No performance impact found (on Intel Haswell).

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/ecb_cbc_helpers.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/ecb_cbc_helpers.h b/arch/x86/crypto/ecb_cbc_helpers.h
index eaa15c7b29d6..11955bd01af1 100644
--- a/arch/x86/crypto/ecb_cbc_helpers.h
+++ b/arch/x86/crypto/ecb_cbc_helpers.h
@@ -13,13 +13,14 @@
 
 #define ECB_WALK_START(req, bsize, fpu_blocks) do {			\
 	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));	\
+	const int __fpu_blocks = (fpu_blocks);				\
 	const int __bsize = (bsize);					\
 	struct skcipher_walk walk;					\
 	int err = skcipher_walk_virt(&walk, (req), false);		\
 	while (walk.nbytes > 0) {					\
 		unsigned int nbytes = walk.nbytes;			\
-		bool do_fpu = (fpu_blocks) != -1 &&			\
-			      nbytes >= (fpu_blocks) * __bsize;		\
+		bool do_fpu = __fpu_blocks != -1 &&			\
+			      nbytes >= __fpu_blocks * __bsize;		\
 		const u8 *src = walk.src.virt.addr;			\
 		u8 *dst = walk.dst.virt.addr;				\
 		u8 __maybe_unused buf[(bsize)];				\
@@ -35,7 +36,12 @@
 } while (0)
 
 #define ECB_BLOCK(blocks, func) do {					\
-	while (nbytes >= (blocks) * __bsize) {				\
+	const int __blocks = (blocks);					\
+	if (do_fpu && __blocks < __fpu_blocks) {			\
+		kernel_fpu_end();					\
+		do_fpu = false;						\
+	}								\
+	while (nbytes >= __blocks * __bsize) {				\
 		(func)(ctx, dst, src);					\
 		ECB_WALK_ADVANCE(blocks);				\
 	}								\
@@ -53,7 +59,12 @@
 } while (0)
 
 #define CBC_DEC_BLOCK(blocks, func) do {				\
-	while (nbytes >= (blocks) * __bsize) {				\
+	const int __blocks = (blocks);					\
+	if (do_fpu && __blocks <  __fpu_blocks) {			\
+		kernel_fpu_end();					\
+		do_fpu = false;						\
+	}								\
+	while (nbytes >= __blocks * __bsize) {				\
 		const u8 *__iv = src + ((blocks) - 1) * __bsize;	\
 		if (dst == src)						\
 			__iv = memcpy(buf, __iv, __bsize);		\
-- 
2.39.0

