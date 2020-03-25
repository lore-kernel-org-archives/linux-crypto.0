Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C190EC54FD0
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A0EC20772
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585136476;
	bh=8KLdrbtUe7tOHJWaYztQY17PQBXg8G2PxmpA8ckecVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MWlg2Tf6gpZrcgD2RHtl8XOLS7z8n0rI2YqjUZYRibG9Bnh4E05THe8CQBB1lsTnS
	 IMhB3b+TR7Ka8hTQKqk4QDdecff9yxVVQrr2JZNaaIQhQcP4P8Uygcaxp5FFdGvbIP
	 hg4TgBMJtsR2KzPK9lA771dYK46qB8gSjiZ0bepA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCYLlQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:41:16 -0400
Received: from foss.arm.com ([217.140.110.172]:47176 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbgCYLlP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:41:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CD6E31B;
        Wed, 25 Mar 2020 04:41:15 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 014E13F71F;
        Wed, 25 Mar 2020 04:41:14 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/3] arm64: asm: Provide macro to control enabling architecture extensions
Date:   Wed, 25 Mar 2020 11:41:08 +0000
Message-Id: <20200325114110.23491-2-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325114110.23491-1-broonie@kernel.org>
References: <20200325114110.23491-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently several assembler files override the default architecture to
enable extensions in order to allow them to implement optimised routines
for systems with those extensions. Since inserting BTI landing pads into
assembler functions will require us to change the default architecture we
need a way to enable extensions without hard coding the architecture.
The assembler has the .arch_extension feature but this was introduced
for arm64 in gas 2.26 which is too modern for us to rely on it.

We could just update the base architecture used by these assembler files
but this would mean the assembler would no longer catch attempts to use
newer instructions so instead introduce a macro which sets the default
architecture centrally.  Doing this will also make our use of .arch and
.cpu to select the base architecture more consistent.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/linkage.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/linkage.h b/arch/arm64/include/asm/linkage.h
index ebee3113a62f..e5856c75720b 100644
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -20,4 +20,10 @@
 		SYM_FUNC_END(x);		\
 		SYM_FUNC_END_ALIAS(__pi_##x)
 
+/*
+ * Enable additional architecture extensions (eg, for optimized asm
+ * routines).
+ */
+#define ARM64_EXTENSIONS(x) .arch armv8-a+x
+
 #endif
-- 
2.20.1

