Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66880C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C4A12084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dZTd+802"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfFVAcS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55808 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFVAcS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so7712590wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mCsEnAP2oL66UMgflkiPsBtum694MAUnMKTZwZyY2CQ=;
        b=dZTd+802WlPaJ1ZQsrZxqUX9/heuVYJkSzVtU7Ygjw6KyQLH+YruszrRWdjahzXJ5n
         s4FAz+L8q+9OXE1nwe/pWoP9BRH1BGaDzoLHGUZKEse33IpSeamAYWGtfQqe0vTBVqzG
         yVPe2Nkr3j8Jl11kd834kuU8/A6LDkNzOd/k/IYS1/5mdpaV/1qPeT9aAU4adzn0J5Fw
         y/rHBkaFfc+BTa+01Qn7yheezs5GftP/luxbilPW4KG0LQoy5QkPD5HmOvSQo5jymFV8
         uaT6fcTSZUPhzcIKvLKh/sV70Lq0MgmMaETnbo6Q/ZSyyJymI6/lC5olAB6LVim3m+BR
         b2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mCsEnAP2oL66UMgflkiPsBtum694MAUnMKTZwZyY2CQ=;
        b=ID3MHixH/ZFJrdXqPDLGMZIBBUojyIghWh7pwyGo3UwWmmN0K4ONgnxlPTcmJepj9u
         NGP3Sze1vIMldTtQ0A7SY/OBwspSVYmEejYzACLtFX7/2cSecKIE0JZroPZ60w0r4V3v
         HY1mgy5sTKN2/EUMk9Sotyvg+nrZUTUm6nWK/AQCOv/gGMGtAbfgoZtXGg2Mp0A9765k
         L8iTZae7Fv0KdepwHyvlo7GpKKsaDisdnxBJlN/vCsjmU/K6mREpoxRVnel28gJWizcf
         PzxaGKCDrKtos76V+vc4EsexdG9K0kh97UBrp94ftc8F3bTkcYKwtqrAsHWPTlOuHCIW
         sttg==
X-Gm-Message-State: APjAAAXGy3Nc/0BmZpApy55nWMJeKYM8+VM0ETWrguDluyoiRDSR3jLF
        v/IbkvH5/HRmjbJibG8AMEqJmlKIQZ/+MphN
X-Google-Smtp-Source: APXvYqxs0wf+qi+h/+CYW84SSxRQwd+7vF5zqxQWLfOLkyMXPlZTFHMoEzSZKx+G9LfevZaiLEH/Ow==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr5912789wmh.68.1561163536119;
        Fri, 21 Jun 2019 17:32:16 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 30/30] fs: cifs: move from the crypto cipher API to the new DES library interface
Date:   Sat, 22 Jun 2019 02:31:12 +0200
Message-Id: <20190622003112.31033-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
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
 fs/cifs/smbencrypt.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

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

