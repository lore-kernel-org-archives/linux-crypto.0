Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A53DC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7262D20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZAcK2nlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfF0MEC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:04:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50815 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfF0MEC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:04:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id c66so5474412wmf.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JECSO/bEpbkseNS0KKB92/HftgO7GU1wpPzeVM070Yw=;
        b=ZAcK2nlwd7nE2u1VzolngiDy5WZV49PtW7B9sRIZiYINoYR56ehr2hSy81OMcZMxtT
         3bd646J8JJuUxrc9ogwItMSYd3Bgga0iYrq60V7YVNI/8pT9O2fuj9H17wVfovYgNaRJ
         RJne5vWKOkUIvZPwYqgYIT1EE73yWdWzvxOwgBUCk2hLO9+wQkTTgOStFsxZDyE0Q4Sx
         eoXGuGREuns2Cj3txzjEJ0j3wR44+O1hNCsrE506lAoOvHTNbrisQQkQSqwYZ5lZFttM
         Qn1Jjz/iyN7OcCAZIYiW49Sf9CLMg3Z7MwZQfUzMdJ7ZCJhzleUSsnjaH23Kn5Jix5Ng
         mzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JECSO/bEpbkseNS0KKB92/HftgO7GU1wpPzeVM070Yw=;
        b=QLHP9L03xWrQYCusdSMxyGkVx5kUVvapEwB7yBmcX0sLzLSs7sbF1NHQ/EZhjwRHEB
         rXtxTE+obuwNroaJWA3/9crzIv1Y+PvsMO/pwkGq+dW3CLIvJ8iSFQfOhD0Ud02QxF9m
         qjcu7uSJS10SW03Pcu+8hC6Z1IJSef8KvNJkMKUfw3Vhc87J+7uB4PEnIyXrMgAZgcDy
         u1lTl83/7zmoV3kVi/rUnmH5Q/el718IeUY4W6i1jK3xq1O5df9XO6OeN56Rq/uNJrAR
         Rh7T8bmGBM/NLCvSMC2PCMpXzw5pHf1azOUFORGFBoTMb1N8DNqN5VZdhnxu/NkM/pwB
         B2jA==
X-Gm-Message-State: APjAAAWt4TGyqbQDXKmMPHUgwTi7wz1TN5EWHR+zgpFokDYVu/bhvAsn
        6L9SuUzJAttEpUUYc8irvN7e2UY5gDSllg==
X-Google-Smtp-Source: APXvYqzcKbSdQS1Y6lJR1HWtLk3VJ5hbCc78fSgNPKezrFy1XzN72uGrKZK1vEgyzZdzp0zVbQYsFw==
X-Received: by 2002:a1c:96c7:: with SMTP id y190mr2751564wmd.87.1561637039257;
        Thu, 27 Jun 2019 05:03:59 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 30/30] fs: cifs: move from the crypto cipher API to the new DES library interface
Date:   Thu, 27 Jun 2019 14:03:14 +0200
Message-Id: <20190627120314.7197-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some legacy code in the CIFS driver uses single DES to calculate
some password hash, and uses the crypto cipher API to do so. Given
that there is no point in invoking an accelerated cipher for doing
56-bit symmetric encryption on a single 8-byte block of input, the
flexibility of the crypto cipher API does not add much value here,
and so we're much better off using a library call into the generic
C implementation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/cifs/Kconfig      |  2 +-
 fs/cifs/cifsfs.c     |  1 -
 fs/cifs/smbencrypt.c | 18 +++++++++---------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 3da294231dcc..dedab8f79ee8 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -14,7 +14,7 @@ config CIFS
 	select CRYPTO_CCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
-	select CRYPTO_DES
+	select CRYPTO_LIB_DES
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
 	  (including support for the most recent, most secure dialect SMB3.1.1)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e55afaf9e5a3..44f4cc160197 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1590,7 +1590,6 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: des");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
 MODULE_SOFTDEP("pre: md4");
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index a0b80ac651a6..5c55c35f47d6 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -23,13 +23,14 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/fips.h>
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <crypto/des.h>
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "cifspdu.h"
@@ -70,19 +71,18 @@ static int
 smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 {
 	unsigned char key2[8];
-	struct crypto_cipher *tfm_des;
+	struct des_ctx ctx;
 
 	str_to_key(key, key2);
 
-	tfm_des = crypto_alloc_cipher("des", 0, 0);
-	if (IS_ERR(tfm_des)) {
-		cifs_dbg(VFS, "could not allocate des crypto API\n");
-		return PTR_ERR(tfm_des);
+	if (fips_enabled) {
+		cifs_dbg(VFS, "FIPS compliance enabled: DES not permitted\n");
+		return -ENOENT;
 	}
 
-	crypto_cipher_setkey(tfm_des, key2, 8);
-	crypto_cipher_encrypt_one(tfm_des, out, in);
-	crypto_free_cipher(tfm_des);
+	des_expand_key(&ctx, key2, DES_KEY_SIZE);
+	des_encrypt(&ctx, out, in);
+	memzero_explicit(&ctx, sizeof(ctx));
 
 	return 0;
 }
-- 
2.20.1

