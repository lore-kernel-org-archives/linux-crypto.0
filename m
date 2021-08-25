Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B9AC432BE
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 20:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538A16108D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 20:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbhHYUjz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Aug 2021 16:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231745AbhHYUjw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Aug 2021 16:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF503610D1;
        Wed, 25 Aug 2021 20:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629923946;
        bh=Al3fzVCYqH1H1gq7uGZbNi/LPmkT9JqI42bjuOzxe6w=;
        h=From:To:Cc:Subject:Date:From;
        b=j6yDQ7pwwSG8g9gbk1KgH07t9czWeOSU/SP2dFbqaqf6RU2zLEq0e+Q0+P8I7pjvy
         NTSsSjMawDRL52KBtsS+p6kxM/Lb/esTSH9g4Azp/L3bILW1ui+EIiu3KlpZsLxSGu
         0L8U/o/9W5ECU+IBtldwOueaxgCsWF33ar09tp7eCi67H3jAMUavH/vL7QIkAaCVL0
         8xQlfTlyx2nuqv258ofDjNFv8eE2WL+qS4rrJqr0c8sV4Se5Bruaph/SKivFWLBEgv
         lYm91dBy1sQZkMGCvow0idg6RKH9H60V4g1E0phTRmdQHcKY5wecwxgzLcSoiyIIt4
         PRBTRbPN3HASw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] crypto: sm4 - Do not change section of ck and sbox
Date:   Wed, 25 Aug 2021 13:38:59 -0700
Message-Id: <20210825203859.416449-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building with clang and GNU as, there is a warning about ignored
changed section attributes:

/tmp/sm4-c916c8.s: Assembler messages:
/tmp/sm4-c916c8.s:677: Warning: ignoring changed section attributes for
.data..cacheline_aligned

"static const" places the data in .rodata but __cacheline_aligned has
the section attribute to place it in .data..cacheline_aligned, in
addition to the aligned attribute.

To keep the alignment but avoid attempting to change sections, use the
____cacheline_aligned attribute, which is just the aligned attribute.

Fixes: 2b31277af577 ("crypto: sm4 - create SM4 library based on sm4 generic code")
Link: https://github.com/ClangBuiltLinux/linux/issues/1441
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/crypto/sm4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
index 633b59fed9db..284e62576d0c 100644
--- a/lib/crypto/sm4.c
+++ b/lib/crypto/sm4.c
@@ -15,7 +15,7 @@ static const u32 fk[4] = {
 	0xa3b1bac6, 0x56aa3350, 0x677d9197, 0xb27022dc
 };
 
-static const u32 __cacheline_aligned ck[32] = {
+static const u32 ____cacheline_aligned ck[32] = {
 	0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
 	0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
 	0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
@@ -26,7 +26,7 @@ static const u32 __cacheline_aligned ck[32] = {
 	0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
 };
 
-static const u8 __cacheline_aligned sbox[256] = {
+static const u8 ____cacheline_aligned sbox[256] = {
 	0xd6, 0x90, 0xe9, 0xfe, 0xcc, 0xe1, 0x3d, 0xb7,
 	0x16, 0xb6, 0x14, 0xc2, 0x28, 0xfb, 0x2c, 0x05,
 	0x2b, 0x67, 0x9a, 0x76, 0x2a, 0xbe, 0x04, 0xc3,

base-commit: abfc7fad63940b8dfdfd25da6f0fa813d9561645
-- 
2.33.0

