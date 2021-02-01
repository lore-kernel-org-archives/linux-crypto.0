Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760E2C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F6C64EA5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhBASEU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhBASET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B0F564EAA;
        Mon,  1 Feb 2021 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202587;
        bh=TuCy+1Z1hMFoa6Wk0qtENMh4a9e9GljruUyAWGT7p+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZ+xzZFSvHM3QfiGYeHt/Tvuq66riL3rOCUaClnZz043EFZtraqwLx/oM/tnWXBo6
         jcBWWpHrf6aWRnmirSG6e0uY12G4vqPI5kh9aPaiyklEe6KnEzlu9gfIXoCxyPRnfn
         5YPT3EBRzqOzQIQunleS8XNqP0waLmeJWrsmjGFsj951pPxK6T+MxdeaUZ/K/4fvJF
         Izse9iytO1noUOokbnWQHN4eLp4rxbE4snGozIq5Eibr8YY/a75/x5T6S+sKrjoODJ
         oFgF58WaRMu55iwidThMMS5Pk4cvDq/fRbN6NknHSSAhlt7lH1nnxgkOsYigcp37/Q
         kziUN1ieQ9UEg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 8/9] crypto: fcrypt - drop unneeded alignmask
Date:   Mon,  1 Feb 2021 19:02:36 +0100
Message-Id: <20210201180237.3171-9-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The fcrypt implementation uses memcpy() to access the input and output
buffers so there is no need to set an alignmask.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/fcrypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 58f935315cf8..c36ea0c8be98 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -396,7 +396,6 @@ static struct crypto_alg fcrypt_alg = {
 	.cra_blocksize		=	8,
 	.cra_ctxsize		=	sizeof(struct fcrypt_ctx),
 	.cra_module		=	THIS_MODULE,
-	.cra_alignmask		=	3,
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	8,
 	.cia_max_keysize	=	8,
-- 
2.20.1

