Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D87AC433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 17:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1204323AA8
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jan 2021 17:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbhAORZK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 12:25:10 -0500
Received: from mail.zx2c4.com ([167.71.246.149]:60872 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbhAORZK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 12:25:10 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2021 12:25:10 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1610731067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4eZmTKsDtQ4th5znNxHnxWkPHqjopS9x6ZgwcAgqd8k=;
        b=e+Tsc0liCxbfPUEKMon9jpvw1fPC+QVHtc4/dJ+/SvN98leZmHLYOOWsLqrNjBwzPG7fq5
        2rs88RZuXx8mEDiQf8dUh5cb/RDhSt6OIfszMxwjauNtOoyRSy2Eow/TE2CH6jxw7G+YiF
        5NdEzwMtluiPOl800hsOBfhJ9CieG9o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 19521f95 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 15 Jan 2021 17:17:47 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, ardb@kernel.org,
        herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        John Donnelly <john.p.donnelly@oracle.com>
Subject: [PATCH] crypto: lib/chacha20poly1305 - define empty module exit function
Date:   Fri, 15 Jan 2021 18:17:43 +0100
Message-Id: <20210115171743.1559595-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With no mod_exit function, users are unable to load the module after
use. I'm not aware of any reason why module unloading should be
prohibited for this one, so this commit simply adds an empty exit
function.

Reported-by: John Donnelly <john.p.donnelly@oracle.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/crypto/chacha20poly1305.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 5850f3b87359..c2fcdb98cc02 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -362,7 +362,12 @@ static int __init mod_init(void)
 	return 0;
 }
 
+static void __exit mod_exit(void)
+{
+}
+
 module_init(mod_init);
+module_exit(mod_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("ChaCha20Poly1305 AEAD construction");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
2.30.0

