Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852EEC43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B9D520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MGwPA4QG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfFVTew (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:52 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33742 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFVTew (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so11351678wme.0
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TEkyEzYA9z24dLcVZzAphhOs6uMPB3TRScCj5mulxhM=;
        b=MGwPA4QG2l1a7CsZmkd46vcd1qlG3ozWuiFkR6iVpRp2qCFSNs2q8yctk/eCr3booL
         baHALEcUZPE4O6OG5Xh8T0qsI2UWIx1UmBnUK//JNF273U1Aeml5h1OYZOSWkV4+2tT+
         qCNzT9fG3QRVHaRmLoSJeezaM70E5+l4TH9pVU2op8s3fYmrq+jpEa+sxhZnE6fdUDeM
         Nk8+sc/2gZ+tr1Sev0vKS3aQ+WcnoJpP64hzODQldUi46qAybqDoc12KDeSx+hzkjT/n
         O+R//nIitNcWHldcKhVdP8mPwpPjA1zpkK4JKPBg2aJrFuRkYzJNaT6vxOdLHcP+aF7U
         u9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TEkyEzYA9z24dLcVZzAphhOs6uMPB3TRScCj5mulxhM=;
        b=eFoUEni2Grbk4tPSjFBXKHCPYQ6Ftevz/7kBuOYC1Z1zB1L3qFRqp08N/6BYdXMzpn
         iALtG37KEW7dnLKkZslDAjTndfePOyMonpHE+H0d5mkHik+fiZigRMx7soIqZJdCa+bU
         P5czwFLk5xABOf+d8h30DNHrii1CyN4SJ+v7ZfLuwz9PJAJgIoV3QmjAqTd+eGOgb0ZH
         obJClDIU08+WswbviZur4v0P3q9yGuaNDYWWJgNcmLy0gRcq0wWyA5hIuLORMwJyQZxk
         Ek8IcUYbVZQBiBm67f1DSFtxOzSQIQa+42i09t+1+kcHK/5iw6xIjmUtA6H1wncevnc1
         g8cA==
X-Gm-Message-State: APjAAAXRvks+1hUrR24lDXpDB5sNKiMXpPlRUrTrqJ6OaA6hsHEY1fTF
        11LekU7If7pQJAbDW7bSFlwNwQc134xMEMCy
X-Google-Smtp-Source: APXvYqweNjVAFFRanqiG38DYJyYcfuTjzHQsSq/W4/CTEGw6d69w26y0XEvHHPqNGxWKixLQF1J7Rg==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr8384504wmc.128.1561232089800;
        Sat, 22 Jun 2019 12:34:49 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 09/26] crypto: safexcel/aes - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:10 +0200
Message-Id: <20190622193427.20336-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig                         | 2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fdccadc94819..b30b84089d11 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -718,7 +718,7 @@ config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
 	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..19ec086dce4f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -178,7 +178,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
-	ret = crypto_aes_expand_key(&aes, key, len);
+	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.20.1

