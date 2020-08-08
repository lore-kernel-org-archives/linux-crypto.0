Return-Path: <SRS0=gV+R=BS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DCCC433E3
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 23:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B3A2087C
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 23:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596930600;
	bh=IHgBT8Vjik3BbIgxDcxrZBpBmFQ3aLVlSzGsnPVE574=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DXf7R0EQC2Z8LgZg+UBA4Suxy2ayn6wbYCxAOCAs8nxg74S0rBxpcY0l/iNxXKdQW
	 Sjo6eR0eBK8NNuYs297LhLmAH4QoCBj0sMWLKJTAlodonxYeYNyT7NEOY6BG4zPUnp
	 ABbq/VubVUdk/2x4y2j/scjeKuQtFQKC9SkKBb20=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgHHXgs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Aug 2020 19:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgHHXgs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Aug 2020 19:36:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C441C20716;
        Sat,  8 Aug 2020 23:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929807;
        bh=IHgBT8Vjik3BbIgxDcxrZBpBmFQ3aLVlSzGsnPVE574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxh0eIuM3eM8/J0i6gwwopCXJ5jioROjcy5r1vXBYfanHPNSDKePjQihKlXsuQC3d
         FfeIBWYi2Tur6i+lSc1N8cjFG5agvaEKb5yUv5dtVUkKCt3/TW2RvCgJCWBcOKCKXj
         avwoKu2arCbl1w1U1L7KO8o6yIsCDkpopj/qyfcY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.8 44/72] crypto: x86/crc32c - fix building with clang ias
Date:   Sat,  8 Aug 2020 19:35:13 -0400
Message-Id: <20200808233542.3617339-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233542.3617339-1-sashal@kernel.org>
References: <20200808233542.3617339-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 44623b2818f4a442726639572f44fd9b6d0ef68c ]

The clang integrated assembler complains about movzxw:

arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'

It seems that movzwq is the mnemonic that it expects instead,
and this is what objdump prints when disassembling the file.

Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 8501ec4532f4f..442599cbe7960 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -170,7 +170,7 @@ continue_block:
 
 	## branch into array
 	lea	jump_table(%rip), %bufp
-	movzxw  (%bufp, %rax, 2), len
+	movzwq  (%bufp, %rax, 2), len
 	lea	crc_array(%rip), %bufp
 	lea     (%bufp, len, 1), %bufp
 	JMP_NOSPEC bufp
-- 
2.25.1

