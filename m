Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7D0C43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E62FF20775
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585144531;
	bh=HZlZx/i1exfv5OBx61Tg9RzFBr0Dx5dc05i1nNrm9Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t1FBSZIJvABBS/zni95Xd3MkeAcXya2DXLe1UIFhhUYG7ZHnnSZtZwPublMLNE/ID
	 fSMW8BfmtWw7UlGbc30VmCh4gOw6DzbzLqCLcTAXv8JGCBZ/9+B8FwI1UhsR+0on/x
	 eGXQbhicpumcqLPHph349EOE92tdqZOCwPq1f540=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCYNza (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:55:30 -0400
Received: from foss.arm.com ([217.140.110.172]:48806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgCYNza (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 09:55:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C25DDFEC;
        Wed, 25 Mar 2020 06:55:29 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 445B83F71E;
        Wed, 25 Mar 2020 06:55:29 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 1/2] arm64: crypto: Consistently enable extension
Date:   Wed, 25 Mar 2020 13:55:21 +0000
Message-Id: <20200325135522.7782-2-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325135522.7782-1-broonie@kernel.org>
References: <20200325135522.7782-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently most of the crypto files enable the crypto extension using the
.arch directive but crct10dif-ce-core.S uses .cpu instead. Move that over
to .arch for consistency.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/crypto/crct10dif-ce-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 5a95c2628fbf..111d9c9abddd 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -66,7 +66,7 @@
 #include <asm/assembler.h>
 
 	.text
-	.cpu		generic+crypto
+	.arch		armv8-a+crypto
 
 	init_crc	.req	w19
 	buf		.req	x20
-- 
2.20.1

