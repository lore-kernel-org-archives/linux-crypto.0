Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653C9C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 329CD2171F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558371229;
	bh=UQAOkGmHmIQhS7/QkDFt4018BSq09XxKHrmdZPgiRkY=;
	h=From:To:Subject:Date:List-ID:From;
	b=M4V30qFidLpt1na+66BZk5H0+I97p8Kg0/UQi6bFWCl3KoJYoWNvzkmGVsYhh7hlU
	 MrL2+1Df8CG97UCkBbWJafkQ7ZStIYkO+664tb7w6xMeMvj3V8QRuQL01MM772tNvO
	 FEzLDmNGRTpM5z+GN8wZ6f70koZK5IMcEwLcVQDk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390064AbfETQxs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfETQxs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:53:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18FE2216B7;
        Mon, 20 May 2019 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558371228;
        bh=UQAOkGmHmIQhS7/QkDFt4018BSq09XxKHrmdZPgiRkY=;
        h=From:To:Subject:Date:From;
        b=Lz5SZug8A209KpHIaOvs1zjzPwuYB9DC7wF2a/Ywdl/FtY0x73EWY9JPylmWmcAnr
         /iIkNiRy60XM8a9wHoolxNEZuDiZOwXhS1k6hni7mOqp11VELZqftcqzyQLd+GGQsH
         8RcB++4JfuGYs9Mr6XeBmlSXiWI3DiejjibVd6vc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: gf128mul - make unselectable by user
Date:   Mon, 20 May 2019 09:53:43 -0700
Message-Id: <20190520165343.169176-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

There's no reason for users to select CONFIG_CRYPTO_GF128MUL, since it's
just some helper functions, and algorithms that need it select it.

Remove the prompt string so that it's not shown to users.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1062e1031f73a..5350aa9368ecd 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -159,13 +159,7 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 endif	# if CRYPTO_MANAGER2
 
 config CRYPTO_GF128MUL
-	tristate "GF(2^128) multiplication functions"
-	help
-	  Efficient table driven implementation of multiplications in the
-	  field GF(2^128).  This is needed by some cypher modes. This
-	  option will be selected automatically if you select such a
-	  cipher mode.  Only select this option by hand if you expect to load
-	  an external module that requires these functions.
+	tristate
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
-- 
2.21.0.1020.gf2820cf01a-goog

