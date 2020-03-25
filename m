Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4A3C1975A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF98C20775
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585136478;
	bh=/utdjAOROBXe+ztowGIx5MDm2JtI/c+EWXT0oT3FuUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vsKp9wqCaCARiJ+Qw57SG7STdeHPvRVL9fGnWgZGNTwzf4xwulkN+Y7UIsvkqY0eW
	 Z8rGpKEJjhbzucsShUPY8cdMKYuas3fespj45t/Y2RcokolT3lGNCJ1a+fSNdLrlRn
	 xsOOdYfiMR6bg4tlFyZIHPU3skUfimlR+M+TJ5dg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgCYLlS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:41:18 -0400
Received: from foss.arm.com ([217.140.110.172]:47188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgCYLlS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:41:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B6F6931B;
        Wed, 25 Mar 2020 04:41:17 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39D513F71F;
        Wed, 25 Mar 2020 04:41:17 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/3] arm64: lib: Use ARM64_EXTENSIONS()
Date:   Wed, 25 Mar 2020 11:41:09 +0000
Message-Id: <20200325114110.23491-3-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325114110.23491-1-broonie@kernel.org>
References: <20200325114110.23491-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the newly introduced ARM64_EXTENSIONS() macro to enable the CRC
instructions.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/lib/crc32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32.S
index 243e107e9896..0fd9ef030ab1 100644
--- a/arch/arm64/lib/crc32.S
+++ b/arch/arm64/lib/crc32.S
@@ -9,7 +9,7 @@
 #include <asm/alternative.h>
 #include <asm/assembler.h>
 
-	.cpu		generic+crc
+ARM64_EXTENSIONS(crc)
 
 	.macro		__crc32, c
 	cmp		x2, #16
-- 
2.20.1

