Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33B4C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B708204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfBXGJL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:09:11 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:43868 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbfBXGJJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:09:09 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 25E9272CCAE;
        Sun, 24 Feb 2019 09:09:06 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id F12104A4AE7;
        Sun, 24 Feb 2019 09:09:05 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/10] crypto: Kconfig - create Public-key cryptography section
Date:   Sun, 24 Feb 2019 09:08:24 +0300
Message-Id: <20190224060828.2527-7-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190224060828.2527-1-vt@altlinux.org>
References: <20190224060828.2527-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Group RSA, DH, and ECDH into Public-key cryptography config section.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
 crypto/Kconfig | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index bbab6bf33519..370cbdca87a7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -113,29 +113,6 @@ config CRYPTO_ACOMP
 	select CRYPTO_ALGAPI
 	select CRYPTO_ACOMP2
 
-config CRYPTO_RSA
-	tristate "RSA algorithm"
-	select CRYPTO_AKCIPHER
-	select CRYPTO_MANAGER
-	select MPILIB
-	select ASN1
-	help
-	  Generic implementation of the RSA public key algorithm.
-
-config CRYPTO_DH
-	tristate "Diffie-Hellman algorithm"
-	select CRYPTO_KPP
-	select MPILIB
-	help
-	  Generic implementation of the Diffie-Hellman algorithm.
-
-config CRYPTO_ECDH
-	tristate "ECDH algorithm"
-	select CRYPTO_KPP
-	select CRYPTO_RNG_DEFAULT
-	help
-	  Generic implementation of the ECDH algorithm
-
 config CRYPTO_MANAGER
 	tristate "Cryptographic algorithm manager"
 	select CRYPTO_MANAGER2
@@ -253,6 +230,31 @@ config CRYPTO_GLUE_HELPER_X86
 config CRYPTO_ENGINE
 	tristate
 
+comment "Public-key cryptography"
+
+config CRYPTO_RSA
+	tristate "RSA algorithm"
+	select CRYPTO_AKCIPHER
+	select CRYPTO_MANAGER
+	select MPILIB
+	select ASN1
+	help
+	  Generic implementation of the RSA public key algorithm.
+
+config CRYPTO_DH
+	tristate "Diffie-Hellman algorithm"
+	select CRYPTO_KPP
+	select MPILIB
+	help
+	  Generic implementation of the Diffie-Hellman algorithm.
+
+config CRYPTO_ECDH
+	tristate "ECDH algorithm"
+	select CRYPTO_KPP
+	select CRYPTO_RNG_DEFAULT
+	help
+	  Generic implementation of the ECDH algorithm
+
 comment "Authenticated Encryption with Associated Data"
 
 config CRYPTO_CCM
-- 
2.11.0

