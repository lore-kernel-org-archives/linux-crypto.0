Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B9CC05027
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Jan 2023 03:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjAZD5I (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Jan 2023 22:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjAZD5H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2023 22:57:07 -0500
Received: from aib29gb127.yyz1.oracleemaildelivery.com (aib29gb127.yyz1.oracleemaildelivery.com [192.29.72.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E97D46145
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jan 2023 19:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NspjpaU/YktkL646lovxnDP4XXbd3pu+4MnmaUDd+I0=;
 b=EdleV7lBZVX1QovhGuLdThxJg5m3quvAgtAppsjaKPE6/k8MM9f9Ir+aYM62GAkd4XPqejaLswPX
   c9MxAVT4f095YNByCxjJnd/eoI2lBTxcWZeHmrdkI+7EZr6CmorPvrZeSFuCw9B8Cm2GY3TdDgKg
   TwyR0/m+ltAk3oxVmt/poeZxRzKjANBMXTlBAbzaix5HJEEmwtjA+aopyLOsh90cUe9N7YS2JQ1l
   +27iw12FHbVPRSSr2jkwLqAqae+PRQ6fIG3cMs6t1SayUMUzbWIMizjApjx59zSIo+HwQoxl6DZF
   j7fYvzhoyJsdOomq7+cvmL6BVWIL26xS9fQocQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=NspjpaU/YktkL646lovxnDP4XXbd3pu+4MnmaUDd+I0=;
 b=iFRoSqeml8h2TXp0HZPJFCJyOYBR2GkIAs+LS8OasUQY5fSEVQYYDhatOWkdwjLgCp2ummaR5ym9
   Nb1QBNiaq2zb9u2Bd//fMKSL3T/UhEIF8ZS1sUaEotNBlhPEHI+T8SDnPDvtApzcvWWXljFtm1hg
   V2gdGjnU219EnTn0Pqj4MiXm7iTywsgFosyWqMwmP5QgZeLuSKJVhEPeiySF+YzLbcBCmvpeeG6S
   FVo74k9ONDtTBxuqyr78+SAwYj6/DXaQL3LcKm6Bz2xX5xA/9eqb4O5HofnFwOhVWkl2ReXoaHIx
   AetMQu6oneR0jxU7YLIpxyw9GrCfzpxn3JWfOA==
Received: by omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP2002CLQZ5FR50@omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Thu, 26 Jan 2023 03:57:05 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 3/3] crypto: x86/blowfish - Eliminate use of
 SYM_TYPED_FUNC_START in asm
Date:   Wed, 25 Jan 2023 22:56:47 -0500
Message-id: <20230126035647.5497-2-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAE0e4rh3aa2Me+pSlujrZLR6JRy1uPGw3DW7Onzc0kf8+obXg2owfa2x/jab28e
 JkauB8QvsbOqnl5oY3uRgE3k1nBleGttFEbdRwgvoM2Nag9uB/7zICkc/sn3yPMo
 Eah7bJnzx2IuO8KS7JJvTHRUT+lsaq5xm4/x86sfwi0SIQ/D6kmcFiYQM6ymGxrF
 Vblgt0ey5TWpwYY5Aiir+RBZ/pImiy69zdgLEsYFcAC1SWdoeppS9k/h8CP45L9w
 zrJtyWXk9/1IS6wpzhisCp0yQ0rM/iRmGTVxQUO8S2SM9jjas0NS1HXnvFJa/7cI
 wy8f473i66DNQU1e3LnbYU0awjJM7AAXyxS2PfDuIR4eGrak/R7+DydbPtLVBmsV
 vS9DLZcfMKjG1qRDlqpfZFidwYSM7N92ZcPJ4sEgkcJQjZeIWMYTXPxt53MOBrEi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that we use the ECB/CBC macros, none of the asm functions in
blowfish-x86_64 are called indirectly. So we can safely use
SYM_FUNC_START instead of SYM_TYPED_FUNC_START with no effect, allowing
us to remove an include.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/blowfish-x86_64-asm_64.S | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/blowfish-x86_64-asm_64.S b/arch/x86/crypto/blowfish-x86_64-asm_64.S
index 767a209ca989..fda2f9a3d83c 100644
--- a/arch/x86/crypto/blowfish-x86_64-asm_64.S
+++ b/arch/x86/crypto/blowfish-x86_64-asm_64.S
@@ -6,7 +6,6 @@
  */
 
 #include <linux/linkage.h>
-#include <linux/cfi_types.h>
 
 .file "blowfish-x86_64-asm.S"
 .text
@@ -100,7 +99,7 @@
 	bswapq 			RX0; \
 	movq RX0, 		(RIO);
 
-SYM_TYPED_FUNC_START(blowfish_enc_blk)
+SYM_FUNC_START(blowfish_enc_blk)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -131,7 +130,7 @@ SYM_TYPED_FUNC_START(blowfish_enc_blk)
 	RET;
 SYM_FUNC_END(blowfish_enc_blk)
 
-SYM_TYPED_FUNC_START(blowfish_dec_blk)
+SYM_FUNC_START(blowfish_dec_blk)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -273,7 +272,7 @@ SYM_FUNC_END(blowfish_dec_blk)
 	bswapq			RT3; \
 	xorq RT3,		RX3;
 
-SYM_TYPED_FUNC_START(blowfish_enc_blk_4way)
+SYM_FUNC_START(blowfish_enc_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
@@ -308,7 +307,7 @@ SYM_TYPED_FUNC_START(blowfish_enc_blk_4way)
 	RET;
 SYM_FUNC_END(blowfish_enc_blk_4way)
 
-SYM_TYPED_FUNC_START(__blowfish_dec_blk_4way)
+SYM_FUNC_START(__blowfish_dec_blk_4way)
 	/* input:
 	 *	%rdi: ctx
 	 *	%rsi: dst
-- 
2.39.1

