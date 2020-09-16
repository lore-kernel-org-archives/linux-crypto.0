Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9307AC433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9F721D7D
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 06:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600236876;
	bh=0nSj3j35RCFZr6qtVi1QaNSon8iL7sof8KVTioP5RtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MPFb3T5JbhJp9n1aWY+XLs9utWoTZOI07ywQZLvCQPgkiEMQLzHc0Mh6aGdFr3R7R
	 aPI6VOWQF5164/NqBflrSNTB1iupIpwlwLiesNSuFC9uFWwERVb2pJLgjLZVJ76Bue
	 FTYPgYG6GomSZJAibN3+rHFBXqW5b5YgoZm80lTM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgIPGOf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:14:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgIPGOc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 02:14:32 -0400
Received: from e123331-lin.nice.arm.com (adsl-245.46.190.88.tellas.gr [46.190.88.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27B221D7D;
        Wed, 16 Sep 2020 06:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600236871;
        bh=0nSj3j35RCFZr6qtVi1QaNSon8iL7sof8KVTioP5RtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMTACuyG+FKgvnRSOhoTca4xvu/Pmee4Bw+7aOlNM6DaLMKh3Obx9XzZx7kS3ymNQ
         /BUivn6VZxGEuhDY6Tac00lf1aMOHTn87flytuEIPUUazxjtSePN9zQN3ZxPartg+J
         J+WMhs/igDx5buA1E3NgyNTI3JKs0c2gVnw/ff24=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>
Subject: [PATCH v2 1/2] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
Date:   Wed, 16 Sep 2020 09:14:17 +0300
Message-Id: <20200916061418.9197-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916061418.9197-1-ardb@kernel.org>
References: <20200916061418.9197-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ADRL pseudo instruction is not an architectural construct, but a
convenience macro that was supported by the ARM proprietary assembler
and adopted by binutils GAS as well, but only when assembling in 32-bit
ARM mode. Therefore, it can only be used in assembler code that is known
to assemble in ARM mode only, but as it turns out, the Clang assembler
does not implement ADRL at all, and so it is better to get rid of it
entirely.

So replace the ADRL instruction with a ADR instruction that refers to
a nearer symbol, and apply the delta explicitly using an additional
instruction.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/sha256-armv4.pl       | 4 ++--
 arch/arm/crypto/sha256-core.S_shipped | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
index 9f96ff48e4a8..f3a2b54efd4e 100644
--- a/arch/arm/crypto/sha256-armv4.pl
+++ b/arch/arm/crypto/sha256-armv4.pl
@@ -175,7 +175,6 @@ $code=<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -471,7 +470,8 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	$H,sp,#16*4+16
-	adrl	$Ktbl,K256
+	adr	$Ktbl,.Lsha256_block_data_order
+	sub	$Ktbl,$Ktbl,#.Lsha256_block_data_order-K256
 	bic	$H,$H,#15		@ align for 128-bit stores
 	mov	$t2,sp
 	mov	sp,$H			@ alloca
diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
index ea04b2ab0c33..6363014a50d7 100644
--- a/arch/arm/crypto/sha256-core.S_shipped
+++ b/arch/arm/crypto/sha256-core.S_shipped
@@ -56,7 +56,6 @@
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
 	stmdb	sp!,{r4-r12,lr}
 
 	sub	r11,sp,#16*4+16
-	adrl	r14,K256
+	adr	r14,.Lsha256_block_data_order
+	sub	r14,r14,#.Lsha256_block_data_order-K256
 	bic	r11,r11,#15		@ align for 128-bit stores
 	mov	r12,sp
 	mov	sp,r11			@ alloca
-- 
2.17.1

