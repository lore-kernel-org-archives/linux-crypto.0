Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50726C282CE
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2041320818
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 15:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfDKPwG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 11:52:06 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:44818 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfDKPwF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 11:52:05 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 40CCC72CC58;
        Thu, 11 Apr 2019 18:52:02 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id DC3CD4A4A2A;
        Thu, 11 Apr 2019 18:52:01 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/10] crypto: Kconfig - create Public-key cryptography section
Date:   Thu, 11 Apr 2019 18:51:18 +0300
Message-Id: <20190411155122.13245-7-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190411155122.13245-1-vt@altlinux.org>
References: <20190411155122.13245-1-vt@altlinux.org>
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
index 2022b9201e38..f328026dff75 100644
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

