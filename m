Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DC5C83010
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D316D2240C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdYbVX/S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgKTLEn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 06:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgKTLEm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:42 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BC32236F;
        Fri, 20 Nov 2020 11:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605870281;
        bh=7fZQBZXlpfxIqTMDz/rjixP6Fw/4Kfq++YJCQ1Di9e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdYbVX/SO7ik1+cbjhA/HuS4+J9J3Gz58mHRSVRfYM7FcHMSLm7v4LnTctRWsurJP
         SoEcMwoFb3T+5zBZxvPKuKP/dHCbGGkaH7WwNj37qNB7IhouBA1bcmtpAw7SRM+Dfq
         QWeyQ+OQTrfOtr/2T0VYP+sjPlyq5m8LfUdtiBrk=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 1/3] crypto: tcrypt - don't initialize at subsys_initcall time
Date:   Fri, 20 Nov 2020 12:04:31 +0100
Message-Id: <20201120110433.31090-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120110433.31090-1-ardb@kernel.org>
References: <20201120110433.31090-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit c4741b2305979 ("crypto: run initcalls for generic implementations
earlier") converted tcrypt.ko's module_init() to subsys_initcall(), but
this was unintentional: tcrypt.ko currently cannot be built into the core
kernel, and so the subsys_initcall() gets converted into module_init()
under the hood. Given that tcrypt.ko does not implement a generic version
of a crypto algorithm that has to be available early during boot, there
is no point in running the tcrypt init code earlier than implied by
module_init().

However, for crypto development purposes, we will lift the restriction
that tcrypt.ko must be built as a module, and when builtin, it makes sense
for tcrypt.ko (which does its work inside the module init function) to run
as late as possible. So let's switch to late_initcall() instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 crypto/tcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index eea0f453cfb6..fc1f3e516694 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -3066,7 +3066,7 @@ static int __init tcrypt_mod_init(void)
  */
 static void __exit tcrypt_mod_fini(void) { }
 
-subsys_initcall(tcrypt_mod_init);
+late_initcall(tcrypt_mod_init);
 module_exit(tcrypt_mod_fini);
 
 module_param(alg, charp, 0);
-- 
2.17.1

