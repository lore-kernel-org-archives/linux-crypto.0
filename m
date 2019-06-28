Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D496DC5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD20B208E3
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:36:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zlY2AJuc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfF1JgM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:36:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33759 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfF1JgM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:36:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so8945212wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JECSO/bEpbkseNS0KKB92/HftgO7GU1wpPzeVM070Yw=;
        b=zlY2AJucQbYM/macwfXX7nkWL8+g71mABisTQgAR01ipSHJ5py7TXZCc59woXboj0q
         SVRpo8+B+ByhLMsma4XJGGPVYmIl0QOd4pDKmxWX458MlzC07SBaLH3Yas+N6ib3BzpT
         83od6GJnu0hO3hbQzd9JOX8SEVVYZGqTsDdvsRAMUceCFK5WVs/tQENe/OuNT/Mtk2GK
         K27x3JPYokGcTJ9fUic3tidzYQtk7ZCQc0bnOIt+kLF9/JmKqlz95A/wQmJh+fvTDOul
         pwUl42BzDufuoRNh70U3rzvCzT7o82wp1QQyNnTzQAcQm+OR05LI1QZd9/Qtn2YII2dh
         AT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JECSO/bEpbkseNS0KKB92/HftgO7GU1wpPzeVM070Yw=;
        b=dbLZFLcH79kk6NXEjhe+7wNMexIfLCNPBEO7ARmITeY4rV7uew1r+MSsXAV/dvxAGy
         9utubmGlgzVa48ZiVYDaFVIC1rE5nyze7rdCQkkY7iZjzLTzznoMLzcs6iZfPo4qvbsZ
         hOro7ZZOk0fqCh0M+ZXrBtEdDZuCGKE0B06FPUiNWJ33sIXjXpPJ0/NRcO2kCLSqY75o
         OFwKmjtX2NERlo514Ao50bocG81w39c7XpQcCTY1p6uawQs5xQSBRrVnjhJz27/i3zNS
         w1wRO5bdD3PNI6YMtZ3zr2vh950xvGXWHS3jyBlOkF1kS3mR8vUyhap7dNGDaUKZQcdN
         YovA==
X-Gm-Message-State: APjAAAVFsKktS3J+xSppKFTDbDr/KR47zE6b6rCZfuw0HrvIUQeS/mkI
        HYvxaSa+wOKtwMWJVE1gHdVqxB+Z2xlPhQ==
X-Google-Smtp-Source: APXvYqyHuCkuY0/CaKWDCyXSnvGM3nHguLQfJOorrYKl4B0sBF19cbO7gKI1Kist4v0AoV/blci+Vg==
X-Received: by 2002:a7b:c455:: with SMTP id l21mr6763458wmi.114.1561714570778;
        Fri, 28 Jun 2019 02:36:10 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.36.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:36:10 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 30/30] fs: cifs: move from the crypto cipher API to the new DES library interface
Date:   Fri, 28 Jun 2019 11:35:29 +0200
Message-Id: <20190628093529.12281-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
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

