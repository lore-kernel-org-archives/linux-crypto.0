Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A181C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21749218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="whv+LhAh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfHOJCV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56002 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730823AbfHOJCV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so674667wmf.5
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BotHPKD3g+g+mUZQ/dtkowLHJlOQtGFVF7+kbySZOcU=;
        b=whv+LhAhxs1dUKQOELKk0+c9ufyVLY04ilRm4Xr/A3joJ+etHGyyoDTbsisvPcFm1b
         hqFntJVU38lK/9tlFHSPFxW5putYTbXeMuNadA4os9moVI1ktBNzzyo2WUhryYMAGhQx
         r56uPTE+wCR/UIdyngOuDCktneeoxFL/hipPlKgqXtHg2oob1vOkpKX+Z/dLhNmqx/WO
         e1XejR5fP7q4a+WIGiKAKFDTDNy4u6WdUonPFjo8v3jBMt+JrIaHOztze1S0Bx/gdCrd
         1c6jfWFFb9RmFb0aTbQJ0Redfvmy3XFTjLoupJN8cTuaIRmVBt5u8mp7iXWnKrnZrCFR
         T2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BotHPKD3g+g+mUZQ/dtkowLHJlOQtGFVF7+kbySZOcU=;
        b=KyjjiGikWEg72e1AxdMqlWhGOc/HWwsIM8+9duKRw9inDVUYFSN8RJpsY3M1dgI2oq
         0Rc43oxsnOZYk2VABNvC5xdOuk5BGQsyr+uOcITpfJYunffpQoMEBjtCDlCUqsqxPcb3
         Bj65WkxBzTjnFk14r+r4Oc6lMefaRVRz1QVQG6NrjigpKo826zpH1kj/70MHR7LzPVV+
         uez8i0xdegp+kfqzVMhDfr10+FdbxFU75o6QqW+55RGitWyaIVybD9wRgYmP10hxWp2R
         uKJnM9ep09HXzWUmc7Iv4g6nWLXPiaaJHHiMEM2KTwFx5hTq888jSqbrwgfXWec48SbU
         z6sA==
X-Gm-Message-State: APjAAAW08Ju6Ap/AWlxpF4rYBt8yO/f8S3JuHJ96nJu80A7xc82+K2Hp
        VLxjv8aoxzje+5RAOT5z6jAPjK157FL6cJ3z
X-Google-Smtp-Source: APXvYqzVeufuERuhorwpJewkTlkl8xSQ5+LTq2b4E1lH93HW0BwdHCj41usCWo+xliKrToe4F+zH7Q==
X-Received: by 2002:a1c:3945:: with SMTP id g66mr1622342wma.139.1565859739008;
        Thu, 15 Aug 2019 02:02:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:18 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 30/30] fs: cifs: move from the crypto cipher API to the new DES library interface
Date:   Thu, 15 Aug 2019 12:01:12 +0300
Message-Id: <20190815090112.9377-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
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
index b16219e5dac9..350bc3061656 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -16,7 +16,7 @@ config CIFS
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
-	select CRYPTO_DES
+	select CRYPTO_LIB_DES
 	select KEYS
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3289b566463f..4e2f74894e9b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1601,7 +1601,6 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: des");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
 MODULE_SOFTDEP("pre: md4");
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 2b6d87bfdf8e..39a938443e3e 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -11,13 +11,14 @@
 
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
@@ -58,19 +59,18 @@ static int
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
2.17.1

