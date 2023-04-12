Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E81C77B6E
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Apr 2023 11:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDLLBC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Apr 2023 07:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDLLBA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Apr 2023 07:01:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B2A65B0
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 04:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB33C632EE
        for <linux-crypto@vger.kernel.org>; Wed, 12 Apr 2023 11:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF39C4339E;
        Wed, 12 Apr 2023 11:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681297258;
        bh=QIM4dvy+y3uMDNtnBsSv0HyVwFsc2IPurP1uLhVlB6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUc1jB3s4OWmcYrxzPWlTf0Hcp83OXraIUdGJLDtTxhJHmf49kYA9Cs0uA4J7vpDG
         zsC6npQXsyyKSabxyHpKC69XTwGMlsYE0AZPrYg/wPg9f0VpboUNvEa08w1pEO/znJ
         4jSYW4kmnNv261NLqP3hlkhDODed5zD5mMbw+4XqjoJOYPLJ2CMssrZ1k4oxiwlG5N
         DvWfQOe/H7ZOyFvxnjG25z+KcMUk1bPaC328fwskclF+E8zF/s5NM8x6ecaPuQxIFG
         xvkfQWU6kezb6Sj2VMYXrpgcpL0Z8aSwAbUCtIrlYgY1tPX7CCVw3SQK8W1PEbnTQx
         EbBjUXrU2UAjg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 07/13] crypto: x86/crc32c - Use RIP-relative addressing
Date:   Wed, 12 Apr 2023 13:00:29 +0200
Message-Id: <20230412110035.361447-8-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412110035.361447-1-ardb@kernel.org>
References: <20230412110035.361447-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=795; i=ardb@kernel.org; h=from:subject; bh=QIM4dvy+y3uMDNtnBsSv0HyVwFsc2IPurP1uLhVlB6M=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWs3zs48Ht06m4vRWkr9U2V6VXOp28zRBkkblljkt1y0 MjKY3lHKQuDGAeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmIh8HsP/8O4rNb/N6m7kOCQp h1upFH58/Zz9dPVVRabTKrb/m7NmMjIsUVdNW6x2N7tONavw3PclBzNTMoTVheP99OMDYjfkWvE BAA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Prefer RIP-relative addressing where possible, which removes the need
for boot time relocation fixups.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index ec35915f0901a087..5f843dce77f1de66 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -168,7 +168,8 @@ continue_block:
 	xor     crc2, crc2
 
 	## branch into array
-	mov	jump_table(,%rax,8), %bufp
+	leaq	jump_table(%rip), %bufp
+	mov	(%bufp,%rax,8), %bufp
 	JMP_NOSPEC bufp
 
 	################################################################
-- 
2.39.2

