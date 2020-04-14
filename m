Return-Path: <SRS0=2RfU=56=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AF9C352BE
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Apr 2020 18:27:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 387EC206A2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Apr 2020 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586888875;
	bh=II9cIOZWJLtVUfA3Wn84rFv20L4RhCPUPQs7AdZJdNw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=E9zi3s+sGYQOVcQSrEtixk1G6j71GAbD2tNJ3FvHPQdhZJiRVl2Cmo5zPJaz7HFTV
	 JMgLZUGrVZGl7+W2y8QZD3G8F1BnxJURl2seBlWSuufNQFFH5B/OmCQ0MKNnDwBlGZ
	 /nS+BpgX5e1gNJynGG0kVmRTCJ0EERIf2DFNJjOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503969AbgDNS1n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Apr 2020 14:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503947AbgDNS1l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Apr 2020 14:27:41 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B571720575;
        Tue, 14 Apr 2020 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586888861;
        bh=II9cIOZWJLtVUfA3Wn84rFv20L4RhCPUPQs7AdZJdNw=;
        h=From:To:Cc:Subject:Date:From;
        b=ynDT8kVAu4ibkwvAgPhVdwsIuPurL9Td552Zm9fQ3zO/drYH887WalclZKd8dK2/X
         //4lfp/f7BDOXUZxp/ojwu9tEzu5vCK15r+zTypUsCEYN6CFYu33NIZ+Ld3HZmfVPR
         cY64/B/gKfzH3krhFRmDHM2yPjFIsr/dgMEc2TgA=
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] arm64: crypto: Consistently enable extension
Date:   Tue, 14 Apr 2020 19:20:08 +0100
Message-Id: <20200414182008.31417-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
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
Acked-by: Ard Biesheuvel <ardb@kernel.org>
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

