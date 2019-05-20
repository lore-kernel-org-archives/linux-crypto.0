Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28CBC04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A26A2171F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558370994;
	bh=EjQjHNtMC6jZpaYoZytHwycdIN/+hh8iA33Z9hqsjcQ=;
	h=From:To:Subject:Date:List-ID:From;
	b=EskQue1zy4yuka5BJ18gxpEZaGhkrKa9h3pq5RTJeWcxNqQKtNY9hpzviQHvEC3lJ
	 k0HzNEkQ7L7qv2MrsrwEVYK7dy72TXmg7DHtUdET5eVI8bP7bCZD3EJuRPBQIramop
	 bNnIo9nsQX4bV6ljcWbQaG1V5Efxy4P+d8oedmJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389585AbfETQty (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:49:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388598AbfETQtx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:49:53 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BB9214DA;
        Mon, 20 May 2019 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558370993;
        bh=EjQjHNtMC6jZpaYoZytHwycdIN/+hh8iA33Z9hqsjcQ=;
        h=From:To:Subject:Date:From;
        b=lOQynqbhbnUXWbtJt3dVcqVzSw/h99OA6SKmNXSU+wJBEB7evg0p2whqPhPPCcTbp
         ieOH16XGcxXaj57kRW3QW1+g6NtrFWuvmhJSFl6dqNfSi/WCjAngc9LLUouytGCNh7
         KLSL43+WsH1KA5irqt6sS/hi1W47gniKrWIqS7Wc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: make all templates select CRYPTO_MANAGER
Date:   Mon, 20 May 2019 09:49:46 -0700
Message-Id: <20190520164946.167582-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The "cryptomgr" module is required for templates to be used.  Many
templates select it, but others don't.  Make all templates select it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 7009aff745cb7..af8c6b4e6a83a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -282,6 +282,7 @@ config CRYPTO_CCM
 	select CRYPTO_CTR
 	select CRYPTO_HASH
 	select CRYPTO_AEAD
+	select CRYPTO_MANAGER
 	help
 	  Support for Counter with CBC MAC. Required for IPsec.
 
@@ -291,6 +292,7 @@ config CRYPTO_GCM
 	select CRYPTO_AEAD
 	select CRYPTO_GHASH
 	select CRYPTO_NULL
+	select CRYPTO_MANAGER
 	help
 	  Support for Galois/Counter Mode (GCM) and Galois Message
 	  Authentication Code (GMAC). Required for IPSec.
@@ -300,6 +302,7 @@ config CRYPTO_CHACHA20POLY1305
 	select CRYPTO_CHACHA20
 	select CRYPTO_POLY1305
 	select CRYPTO_AEAD
+	select CRYPTO_MANAGER
 	help
 	  ChaCha20-Poly1305 AEAD support, RFC7539.
 
@@ -414,6 +417,7 @@ config CRYPTO_SEQIV
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_NULL
 	select CRYPTO_RNG_DEFAULT
+	select CRYPTO_MANAGER
 	help
 	  This IV generator generates an IV based on a sequence number by
 	  xoring it with a salt.  This algorithm is mainly useful for CTR
@@ -423,6 +427,7 @@ config CRYPTO_ECHAINIV
 	select CRYPTO_AEAD
 	select CRYPTO_NULL
 	select CRYPTO_RNG_DEFAULT
+	select CRYPTO_MANAGER
 	default m
 	help
 	  This IV generator generates an IV based on the encryption of
@@ -459,6 +464,7 @@ config CRYPTO_CTR
 config CRYPTO_CTS
 	tristate "CTS support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
 	help
 	  CTS: Cipher Text Stealing
 	  This is the Cipher Text Stealing mode as described by
@@ -524,6 +530,7 @@ config CRYPTO_XTS
 config CRYPTO_KEYWRAP
 	tristate "Key wrapping support"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_MANAGER
 	help
 	  Support for key wrapping (NIST SP800-38F / RFC3394) without
 	  padding.
@@ -554,6 +561,7 @@ config CRYPTO_ADIANTUM
 	select CRYPTO_CHACHA20
 	select CRYPTO_POLY1305
 	select CRYPTO_NHPOLY1305
+	select CRYPTO_MANAGER
 	help
 	  Adiantum is a tweakable, length-preserving encryption mode
 	  designed for fast and secure disk encryption, especially on
-- 
2.21.0.1020.gf2820cf01a-goog

