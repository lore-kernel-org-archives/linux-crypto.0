Return-Path: <SRS0=wcu2=DU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC76CC433E7
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 23:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E46D221FC
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Oct 2020 23:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602631628;
	bh=mjfg69poC9wP7Of+UI7cHThU0f9/Uq356LBAlVBWEnY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=a3pw5AD8AoSh2M2aCC0vH9wwrXngkAOwWAmexOmNU+JQLmoSakzCHJl0w4lxJIntj
	 KH7XT55M4Umg7Cy5GG+s5qYwZXLQ9qfNzKhaP4SMpRzL8HLyYtN9/RmYsvGACVJXqe
	 AfQjrWi4bOp5dBAI2AuTCBJjEpb9P9VpLIK7XTd8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgJMX1H (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgJMX1H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Oct 2020 19:27:07 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 508E7221FC;
        Tue, 13 Oct 2020 23:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602631627;
        bh=mjfg69poC9wP7Of+UI7cHThU0f9/Uq356LBAlVBWEnY=;
        h=From:To:Cc:Subject:Date:From;
        b=zAnRQX+Px/HlOGhZH0Dy91TSuYljnMn+Iq2Fg8l2e+SrYPxisBWOPPJP/RnOhNbcZ
         mQEMvvK7iq+YRDIsXDMSV/GDtmFkFByF75t/kfUEJQ76XtNYOT342DyWKlNHrHm4PZ
         TNpNyV+lcnfqWtGrwlpO3cMfx/+72qF/Fck09N9g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: x86 - remove unused file aes_glue.c
Date:   Tue, 13 Oct 2020 16:26:50 -0700
Message-Id: <20201013232650.2361475-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Commit 1d2c3279311e ("crypto: x86/aes - drop scalar assembler
implementations") was meant to remove aes_glue.c, but it actually left
it as an unused one-line file.  Remove this unused file.

Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aes_glue.c | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 arch/x86/crypto/aes_glue.c

diff --git a/arch/x86/crypto/aes_glue.c b/arch/x86/crypto/aes_glue.c
deleted file mode 100644
index 7b7dc05fa1a4..000000000000
--- a/arch/x86/crypto/aes_glue.c
+++ /dev/null
@@ -1 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-- 
2.28.0.1011.ga647a8990f-goog

