Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D19C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C457207FC
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585144533;
	bh=e0Waz1hrM3xrAOBfwOlKvrWNDka3dmCpuclsgJDmB00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UeD5VPcUDFi3ZPFNfalrO7XUarkf9YbWuM9L2AT1N7yLIpm3kWAnokgKd89zm1LDh
	 bqr4orw0obJb9cHDfZjMPWfTcNDcDvWeItudN+YYXOJzgADnE1mbGspSQEK3ARm7Eb
	 g+TLhRL8ridGpIaKRVUzbBMy7p5nuelYcvtk245s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgCYNzc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:55:32 -0400
Received: from foss.arm.com ([217.140.110.172]:48816 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgCYNzc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 09:55:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00E061045;
        Wed, 25 Mar 2020 06:55:32 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78B1D3F71E;
        Wed, 25 Mar 2020 06:55:31 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/2] arm64: lib: Consistently enable crc32 extension
Date:   Wed, 25 Mar 2020 13:55:22 +0000
Message-Id: <20200325135522.7782-3-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325135522.7782-1-broonie@kernel.org>
References: <20200325135522.7782-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently most of the assembly files that use architecture extensions
enable them using the .arch directive but crc32.S uses .cpu instead. Move
that over to .arch for consistency.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/lib/crc32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
index 243e107e9896..0f9e10ecda23 100644
--- a/arch/arm64/lib/crc32.S
+++ b/arch/arm64/lib/crc32.S
@@ -9,7 +9,7 @@
 #include <asm/alternative.h>
 #include <asm/assembler.h>
 
-	.cpu		generic+crc
+	.arch		armv8-a+crc
 
 	.macro		__crc32, c
 	cmp		x2, #16
-- 
2.20.1

