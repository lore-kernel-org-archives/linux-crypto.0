Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80DE9C636D3
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 01:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjAaB2v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAaB2v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 20:28:51 -0500
Received: from aib29gb127.yyz1.oracleemaildelivery.com (aib29gb127.yyz1.oracleemaildelivery.com [192.29.72.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA84244AC
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 17:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=do3EneJF+S8l3V8vKcLRoZebpzQCljaTPQICu6PcUgg=;
 b=Mhjxzs/zLKHstlLq2WCsNJFK9YGh1tfgd8oU834hsbg4iCehHxVJzyVL1KREql+2AKwFeA7VgbNV
   Jl8b96zva05/egjtVnxOpouzMq0drv+cfCDlZj1XM0oIlgR0ovbqbOi8R0sqFuKIZ2GHIFsSXdAi
   MT0NP2kFnxuK+o5e6T8ggdRvsMCaqYf+xzjmXMjzoqdRqESvEk4sg5jq6M3LDLXPrnuJB06ZOk/1
   +suOWrsM32cgFmPCkmsQxFyyneQ5FyYvkK6vMx2CnPLqs4C+Z39XiTJjip8osLkr2coYW/Qv18S3
   vOpl38SwbT9tY+swTyGTDKkqCbhfeA7S5Ew3Uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=do3EneJF+S8l3V8vKcLRoZebpzQCljaTPQICu6PcUgg=;
 b=ocXSdoo28so+OjkAJ95qbPqr52jkdgRnB0YhAhsMGxDWn/SUmaTnN+FEav3S5B1aRd6RtJB+dh2M
   3PDwTfY6eoBli6DjUHWg8gO7LaWBOj1nu4Gwuvl7DxOUFKIdudP/AyXuZUGfoGswseLWlq3mvkIF
   RS6HbWiXEkRhTHnyfYAHDDC2RdRCCiVLB2XizIosRTlVcMvINNsMup/ioVRLfczGDm5mmEYU6quc
   bZwBFpo655yYReySRPy6Mbp2RgXxX/H0/9kogYEubFZACzhCPPG72t9Tbc//sZja+/1KUChNLXrj
   OkH2HvPRLQ7lTHH3x1nYR8FMH0zH9UPDYkE9xQ==
Received: by omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RPB007MZTG14E40@omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Tue, 31 Jan 2023 01:28:49 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH v2 3/3] crypto: x86/blowfish - Eliminate use of
 SYM_TYPED_FUNC_START in asm
Date:   Mon, 30 Jan 2023 20:28:40 -0500
Message-id: <20230131012840.6451-2-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAGWioRAdVITWWhzPlJd+pmQusV4E1h1Ox0YFOuh4JDzZd3NCVgm54FD6KjHqxWx
 4ovx3py0K1m1k+JO0U646uFmDxD5p811aq5Nd8GRk1zQVSEv/M3UjTkOh4c/2hxx
 NF96VOa9iH7qtGzy/zVKjM8X777vVlPkgOv5lQR1oAlR0cRM9Jsq802VbkdK45sL
 QnSc0DkeIRZDZc0MthYJrnIx1t5hUQJhul3xyfwH3wxpVT2d/ygw5k4Pw0uRVuh9
 yJHOKyvZhhRt+VKtAFltBv9A+GHl/RMr5AaEuII94jt0tukz7C4nRtJD1dzdHFYI
 VRNLRlomHIq6hEXdzajH3lE0fDnuI46hFZUHhTYdZvqE/y1XFlx+G+7fzi2hEyse
 XqWC9ZVvPd0A8dSy/+/82lGF0CWHdo31+ZqL+noXmLIMesqSWgGqSg/Ytry8X3A=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that we use the ECB/CBC macros, none of the asm functions in
blowfish-x86_64 are called indirectly. So we can safely use
SYM_FUNC_START instead of SYM_TYPED_FUNC_START with no effect, allowing
us to remove an include.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
v1 -> v2:
 - Fixed typo that caused an assembler failure
 - Added note about performance to cover letter

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

