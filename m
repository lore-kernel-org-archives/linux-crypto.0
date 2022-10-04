Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F69C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Oct 2022 04:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJDEt0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Oct 2022 00:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJDEtZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Oct 2022 00:49:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C962B605
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 21:49:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso17519104pjf.5
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 21:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=zsaW0j8rNgb9WN8UAjFvDEXP+6JPhqUGlrwDj9o5ijg=;
        b=TnLhAVX5bYwfU/tgIhIAjF/mDoX64dwPfCsl2+49VC/AdoXvmIJz5/zFLO8NU0vqpQ
         MJSK8D8F45PPeACw1qRV30nVioK6OyTza/zJbo0yginEvPU4O5293z5+1QPi8pWuLeAe
         q8i2nwAvxg1NRN8BqHoyURTgy+o7EOn+mVTU7vlkjONlUrH6layHUM4PB2lghzroAjhQ
         +BoQkrFvLiBq8o8HBLX50ej1B++w/DmZrTuxBnsy922kWexp6OjoRDlKaJJi7DnbAKhH
         eDpWRW0+6FL5Y5fIv2e6gBmuDY7syjjP0WV+59MM/ckPo6nZUg0SEyzS9I3axqZccUiF
         lQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zsaW0j8rNgb9WN8UAjFvDEXP+6JPhqUGlrwDj9o5ijg=;
        b=c5jiOsPil0wrNnsLntuj+smAFT1XIe+jotovYB1goLsYr9Gx9e+TEiHYd1CkUN+qd4
         O5p5ybMrAueiUSMR20bALowQUehgwOIjX4sVr9sFPHe+2iy//hmKk/iOh6A5dfSQx+PJ
         z+3J1TBxYYW5vwWBqnxvVlDxV5+uI7lVM3pPy5+wHp89SJRZyv4K4TpB9yETnQs3Ju1e
         1n5qYNi2njf0Ufgs2cIjHW4USOqxifO1PjUd4JFSCmIRlZRtQFKQwskkbO+ZaeUo6iWT
         V+DRFq1HYokXzpmM0dhtH8OAOdo3x16Px70ASLZ3HqDKWi+Yq4R4BCODZuxm5MVzCUpK
         x17w==
X-Gm-Message-State: ACrzQf3n18HO0l1Be5y0YOAfmb3oLWPMzskjOdgu8/eLvEOVSKO2twlE
        yMnk21e3xrW6DK6Q9+DsWLWuq59bxFg=
X-Google-Smtp-Source: AMsMyM5mkxbxAnc/YNC8/Rt2uh+yADD6VjiCcsNQB7BOk9VygykBhe8C9KAZib8UKeK7M6iccvgepQ==
X-Received: by 2002:a17:90b:4f42:b0:20a:6dcd:4ddd with SMTP id pj2-20020a17090b4f4200b0020a6dcd4dddmr16111537pjb.32.1664858963288;
        Mon, 03 Oct 2022 21:49:23 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 188-20020a6204c5000000b005289a50e4c2sm8285129pfe.23.2022.10.03.21.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 21:49:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, ardb@kernel.org, ebiggers@google.com
Cc:     ap420073@gmail.com
Subject: [PATCH] crypto: x86: Do not acquire fpu context for too long
Date:   Tue,  4 Oct 2022 04:49:12 +0000
Message-Id: <20221004044912.24770-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Many drivers such as camellia, cast5, etc are using ECB macro.
ECB macro internally calls kernel_fpu_begin() then calls encrypt()
and decrypt() and then it calls kernel_fpu_end().
If too many blocks are given, it acquires fpu context for too long.

kernel_fpu_{begin | end}() internally calls preempt_{disable | enable}().
So, RCU stall would occur because of too long FPU context
period.

The purpose of this is to not exceed 4096 bytes to encrypt() and
decrypt() in an FPU context.

Fixes: 827ee47228a6 ("crypto: x86 - add some helper macros for ECB and CBC modes")
Suggested-by: Elliott, Robert (Servers) <elliott@hpe.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 arch/x86/crypto/ecb_cbc_helpers.h | 34 ++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/x86/crypto/ecb_cbc_helpers.h b/arch/x86/crypto/ecb_cbc_helpers.h
index eaa15c7b29d6..551d8bdfd037 100644
--- a/arch/x86/crypto/ecb_cbc_helpers.h
+++ b/arch/x86/crypto/ecb_cbc_helpers.h
@@ -11,19 +11,35 @@
  * having to rely on indirect calls and retpolines.
  */
 
+#define ECB_CBC_WALK_MAX	4096
+
 #define ECB_WALK_START(req, bsize, fpu_blocks) do {			\
 	void *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));	\
+	unsigned int walked_bytes = 0;					\
 	const int __bsize = (bsize);					\
 	struct skcipher_walk walk;					\
-	int err = skcipher_walk_virt(&walk, (req), false);		\
+	int err;							\
+									\
+	err = skcipher_walk_virt(&walk, (req), false);			\
 	while (walk.nbytes > 0) {					\
-		unsigned int nbytes = walk.nbytes;			\
-		bool do_fpu = (fpu_blocks) != -1 &&			\
-			      nbytes >= (fpu_blocks) * __bsize;		\
 		const u8 *src = walk.src.virt.addr;			\
-		u8 *dst = walk.dst.virt.addr;				\
 		u8 __maybe_unused buf[(bsize)];				\
-		if (do_fpu) kernel_fpu_begin()
+		u8 *dst = walk.dst.virt.addr;				\
+		unsigned int nbytes;					\
+		bool do_fpu;						\
+									\
+		if (walk.nbytes - walked_bytes > ECB_CBC_WALK_MAX) {	\
+			nbytes = ECB_CBC_WALK_MAX;			\
+			walked_bytes += ECB_CBC_WALK_MAX;		\
+		} else {						\
+			nbytes = walk.nbytes - walked_bytes;		\
+			walked_bytes = walk.nbytes;			\
+		}							\
+									\
+		do_fpu = (fpu_blocks) != -1 &&				\
+			 nbytes >= (fpu_blocks) * __bsize;		\
+		if (do_fpu)						\
+			kernel_fpu_begin()
 
 #define CBC_WALK_START(req, bsize, fpu_blocks)				\
 	ECB_WALK_START(req, bsize, fpu_blocks)
@@ -65,8 +81,12 @@
 } while (0)
 
 #define ECB_WALK_END()							\
-		if (do_fpu) kernel_fpu_end();				\
+		if (do_fpu)						\
+			kernel_fpu_end();				\
+		if (walked_bytes < walk.nbytes)				\
+			continue;					\
 		err = skcipher_walk_done(&walk, nbytes);		\
+		walked_bytes = 0;					\
 	}								\
 	return err;							\
 } while (0)
-- 
2.17.1

