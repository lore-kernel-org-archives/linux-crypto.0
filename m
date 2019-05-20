Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556D7C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E31B2171F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558371197;
	bh=Z2o4G3D5YiDXTU6glE+pKthV1dES/iVyp7OFnedfRRg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1vlWZwDd1OZkk0qyS5Am1gEVfhSdBbWTrTSGcbjhCn5bxKUf42q2DYcmifwXKigYE
	 3JVITA9PPzm2f6//ZIW2Rh6eJXWthAI4Asp67G6YuAF5DMC0Qa0c3LqRyJjxMpYvO3
	 CNV59BmPwdUSCQ085ltrpBUBQtHTllOCEpvC7ASI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731488AbfETQxQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfETQxQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:53:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE64216B7;
        Mon, 20 May 2019 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558371195;
        bh=Z2o4G3D5YiDXTU6glE+pKthV1dES/iVyp7OFnedfRRg=;
        h=From:To:Cc:Subject:Date:From;
        b=qn6ydxZ+TEAJI5JSghM6q0GQFgFvse3FpBvTOLdzQbekjtuDYM0zYy0Y8u4khKJuS
         1V+5lg0VUIL2+u9GyuhbYVuAoEVR+mF3kGZIhfPaXYbtcb5eqaVb+waoJipw8bMwO3
         SlbkOr+uD+hsfBPf0PdLXNvQ9b++NRDilP1Lm/Dc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: echainiv - change to 'default n'
Date:   Mon, 20 May 2019 09:52:07 -0700
Message-Id: <20190520165207.168925-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

echainiv is the only algorithm or template in the crypto API that is
enabled by default.  But there doesn't seem to be a good reason for it.
And it pulls in a lot of stuff as dependencies, like AEAD support and a
"NIST SP800-90A DRBG" including HMAC-SHA256.

The commit which made it default 'm', commit 3491244c6298 ("crypto:
echainiv - Set Kconfig default to m"), mentioned that it's needed for
IPsec.  However, later commit 32b6170ca59c ("ipv4+ipv6: Make INET*_ESP
select CRYPTO_ECHAINIV") made the IPsec kconfig options select it.

So, remove the 'default m'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index af8c6b4e6a83a..1062e1031f73a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -428,7 +428,6 @@ config CRYPTO_ECHAINIV
 	select CRYPTO_NULL
 	select CRYPTO_RNG_DEFAULT
 	select CRYPTO_MANAGER
-	default m
 	help
 	  This IV generator generates an IV based on the encryption of
 	  a sequence number xored with a salt.  This is the default
-- 
2.21.0.1020.gf2820cf01a-goog

