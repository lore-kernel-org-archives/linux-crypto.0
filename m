Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A158C77B71
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Apr 2023 15:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjDHP1y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Apr 2023 11:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDHP1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Apr 2023 11:27:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F8EB47A
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 08:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8E8B60B42
        for <linux-crypto@vger.kernel.org>; Sat,  8 Apr 2023 15:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC03C4339C;
        Sat,  8 Apr 2023 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680967669;
        bh=QIM4dvy+y3uMDNtnBsSv0HyVwFsc2IPurP1uLhVlB6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzPOkFSSg6oU7LxdT9nkNIxKAnu18p3r6mKPA/wjWd73wk3U6oj0pobp4CyQVY5P4
         ybPflmmGFhfk8nU8SK33NRDAlwOk6cCyh7W9n8Sn1VmxcCj8mEeOq8g8bpQ0akJDbs
         xyDdxKCUOujRGXNqcG5fBY1ZgYFVY/E8NAe5qPlN7lLTllALIKIpCbyuEB6ecgWGHt
         GUjZvKmp5Zcd/n7fNeC8csSIadjAQIL/40gsDkE/EUtk2lD3DA/RCBr+k9gTTGDOK0
         bRqJa+ZlBHf88YCFsAF1f5ZVHvkfwy0+HxJPgWMVyBhsqa8NePH5RavKNWzREHPc6T
         BdzxTHkNymO6A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 07/10] crypto: x86/crc32c - Use RIP-relative addressing
Date:   Sat,  8 Apr 2023 17:27:19 +0200
Message-Id: <20230408152722.3975985-8-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230408152722.3975985-1-ardb@kernel.org>
References: <20230408152722.3975985-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=795; i=ardb@kernel.org; h=from:subject; bh=QIM4dvy+y3uMDNtnBsSv0HyVwFsc2IPurP1uLhVlB6M=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIcWw/Vpw4Pfo1N1eitJW6psq06ucT99miDJI3LLGJLvlo JGVx/KOUhYGMQ4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJHI6wz/3VYtnjXvi673ouh0 d4sdJ9Ty7V/+3L+jMUTz0P0z3tpnljL84dgoutZeY6dhY+xdkf0/Y76pHA8/n/R57c6/T6O2xHo +5wYA
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

