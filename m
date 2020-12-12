Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C407EC433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CED0207C9
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 10:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438554AbgLLKFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Dec 2020 05:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407218AbgLLJy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Dec 2020 04:54:27 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] crypto: gcm-aes-ni cleanups
Date:   Sat, 12 Dec 2020 10:16:56 +0100
Message-Id: <20201212091700.11776-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clean up some issues and peculiarities in the gcm(aes-ni) driver.

Cc: Eric Biggers <ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (4):
  crypto: x86/gcm-aes-ni - prevent misaligned IV buffers on the stack
  crypto: x86/gcm-aes-ni - drop unused asm prototypes
  crypto: x86/gcm-aes-ni - clean up mapping of associated data
  crypto: x86/gcm-aes-ni - refactor scatterlist processing

 arch/x86/crypto/aesni-intel_glue.c | 238 ++++++--------------
 1 file changed, 74 insertions(+), 164 deletions(-)

-- 
2.17.1

