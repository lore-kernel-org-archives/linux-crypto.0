Return-Path: <SRS0=7mlD=VM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD5AC7618F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 15:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A60652054F
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jul 2019 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563203323;
	bh=mpv5qIPsHtYPw+A/BGE2sSjzuUPliIMI57zTeeXOEkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=09t8FK3TANFXpNUsdCLviTEAA06KHTTdrMPWc3cWmnReMUIyugF9iNgiYh3C2URw7
	 cNItO2imNiH8z5/wrZ1nzzgQauj6p1Px5ZH6iGe7XDObXXC8EF9E25yIpP/92eQhNc
	 Jy2dWTs3i9CE3tuho23F1k2+H2Vr3c80SmcUaIG4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbfGON6C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732131AbfGON6B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 09:58:01 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB2A2083D;
        Mon, 15 Jul 2019 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199081;
        bh=mpv5qIPsHtYPw+A/BGE2sSjzuUPliIMI57zTeeXOEkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XndKUVdmiLtVgioKQQVtQto2N6v8y4VaUGHdhI4aP5NVTqS24Tc65GyJLmtKgRGuE
         x2pXLh2dc/XMxDImml84v3ed8PsmgON2odJ4UlDg57/7VPzbk6maRTD9J3UFSg2Oi+
         FAhhOXc/so2ZP5X/y2GRm2x2aIGUVoCCar4V28e0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 184/249] crypto: asymmetric_keys - select CRYPTO_HASH where needed
Date:   Mon, 15 Jul 2019 09:45:49 -0400
Message-Id: <20190715134655.4076-184-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 90acc0653d2bee203174e66d519fbaaa513502de ]

Build testing with some core crypto options disabled revealed
a few modules that are missing CRYPTO_HASH:

crypto/asymmetric_keys/x509_public_key.o: In function `x509_get_sig_params':
x509_public_key.c:(.text+0x4c7): undefined reference to `crypto_alloc_shash'
x509_public_key.c:(.text+0x5e5): undefined reference to `crypto_shash_digest'
crypto/asymmetric_keys/pkcs7_verify.o: In function `pkcs7_digest.isra.0':
pkcs7_verify.c:(.text+0xab): undefined reference to `crypto_alloc_shash'
pkcs7_verify.c:(.text+0x1b2): undefined reference to `crypto_shash_digest'
pkcs7_verify.c:(.text+0x3c1): undefined reference to `crypto_shash_update'
pkcs7_verify.c:(.text+0x411): undefined reference to `crypto_shash_finup'

This normally doesn't show up in randconfig tests because there is
a large number of other options that select CRYPTO_HASH.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index be70ca6c85d3..1f1f004dc757 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -15,6 +15,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 	select MPILIB
 	select CRYPTO_HASH_INFO
 	select CRYPTO_AKCIPHER
+	select CRYPTO_HASH
 	help
 	  This option provides support for asymmetric public key type handling.
 	  If signature generation and/or verification are to be used,
@@ -65,6 +66,7 @@ config TPM_KEY_PARSER
 config PKCS7_MESSAGE_PARSER
 	tristate "PKCS#7 message parser"
 	depends on X509_CERTIFICATE_PARSER
+	select CRYPTO_HASH
 	select ASN1
 	select OID_REGISTRY
 	help
@@ -87,6 +89,7 @@ config SIGNED_PE_FILE_VERIFICATION
 	bool "Support for PE file signature verification"
 	depends on PKCS7_MESSAGE_PARSER=y
 	depends on SYSTEM_DATA_VERIFICATION
+	select CRYPTO_HASH
 	select ASN1
 	select OID_REGISTRY
 	help
-- 
2.20.1

