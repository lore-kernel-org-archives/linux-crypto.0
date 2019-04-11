Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE10C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 19:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78B5A2173C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555011082;
	bh=ycO9yGHUX+7rVRcrLCRFLTp3y2AZo4I1kFRK4y83NAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=In8RbfwR53iqDPRMEvvhee3/FmOiETVN39z7qDFGAqp9+oriCXPKri3WUYuKzAEnR
	 SvjG/bXRAOrdYUXGIbQYweukzsGO9gAl8Dg5ZjTiGZxvV8zjSDHK+fhPf6pFjsb1Yx
	 29MYXzwEtv4Ul3UoYOEdzLFKzwWbWOLV6B0wBBjE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbfDKTbV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 15:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfDKTbV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 15:31:21 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8EF206BA;
        Thu, 11 Apr 2019 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555011081;
        bh=ycO9yGHUX+7rVRcrLCRFLTp3y2AZo4I1kFRK4y83NAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZIr1QirXMr4zf+bzOukody9xmdqxnZchuRy+QI6v8+BiE7dmuYuHFWtIPu9kil/O
         iPaS6bhOwJO3+Gqij8dxjmVJPJws8N7e1dosXN62V0pI2D7qNo4qYQ4x/W6w6V7kN+
         USubL0sTI/DSOWcu4x+kb6/lz/B6gSIeSgrWXKHc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Laura Abbott <labbott@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: [PATCH] crypto: testmgr - allocate buffers with __GFP_COMP
Date:   Thu, 11 Apr 2019 12:28:27 -0700
Message-Id: <20190411192827.72551-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190411192607.GD225654@gmail.com>
References: <20190411192607.GD225654@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This is needed so that CONFIG_HARDENED_USERCOPY_PAGESPAN=y doesn't
incorrectly report a buffer overflow when the destination of
copy_from_iter() spans the page boundary in the 2-page buffer.

Fixes: 3f47a03df6e8 ("crypto: testmgr - add testvec_config struct and helper functions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f6bfb6ce6a46..3522c0bed2492 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -156,7 +156,8 @@ static int __testmgr_alloc_buf(char *buf[XBUFSIZE], int order)
 	int i;
 
 	for (i = 0; i < XBUFSIZE; i++) {
-		buf[i] = (char *)__get_free_pages(GFP_KERNEL, order);
+		buf[i] = (char *)__get_free_pages(GFP_KERNEL | __GFP_COMP,
+						  order);
 		if (!buf[i])
 			goto err_free_buf;
 	}
-- 
2.21.0.392.gf8f6787159e-goog

