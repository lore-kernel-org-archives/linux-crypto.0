Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022AACA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 09:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C228C2064A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 09:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vq7MMsft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403799AbfJWJux (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 05:50:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35155 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732648AbfJWJux (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 05:50:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id v6so1991235wmj.0
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 02:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7euiEZ5qUmJ55MIvkbOZJ6qG1qEsIMRuwcRG14O88Q=;
        b=Vq7MMsftXZPZcu6f0FCqIG58dK+T69VoF/4ymFEIX9B8PDqXERzUvoxmvRAf63qQBt
         sxG14zcyYlY9GebYQYGudQeosRTeTEEZjeSRT9ksGLgMm8OD4kzbbChTOdCogqkVdc+M
         gYLDTzHBKfng7Mr5njK+l23btPTZIsC3iqnKW7ZBMFtkosEbPPjaZ0LT0ZwIqOFlUGGx
         syI5xOTQvo9iusLYy5yszLv3Inq4jAsgwsQbvfprrZ7HffiF/4y/RFydIUjLeXU46YI8
         4fJHCUEAQtUbg4WcFsiua3rXkelNFDqFNLLWd1DnQVSMdREz/OapFdES2mEw47hjSHit
         PHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7euiEZ5qUmJ55MIvkbOZJ6qG1qEsIMRuwcRG14O88Q=;
        b=j36hGK0ZKfdwXE/Tvb1JhN0xp1h42uOgeVbAdYHA6Dou9mliAHNkETbICtiSYvy2Qx
         WINEZGeq8yY/T15B0RDKH0b/rd3mwraR/lPckDWLSYjq+pbO0bRhwThFRaQVEyh4bCu6
         Fr6/u9kHyj29r5de2xr7NsabDzwkrn3UdiGyp3kXrHRprli9aSep7lHiBSiDWfZRbxGz
         TD0xPfbZWE2rVHkEp2WwuW7Dd9d/C8gMJbugM2OoK2s8IPrnzAx08eCZ8b7hV5b2XDsS
         yqPItAMAYYpVxdvu2h/ptDwFylceSwo3w6+zAd2X9jlh/J46aRrKG9sCtDATNshl+5NV
         AM8w==
X-Gm-Message-State: APjAAAVZSqTSWE7G5AmoGFrHg11syoQx0jVESmXtgjgnL+2bojTh81Ky
        ladQ1ZSQsLklCD1i7CnpQ1VMWILJM3tilAeu
X-Google-Smtp-Source: APXvYqzp9RQ87woGBzNb7AnvKWMZYM0P+Voj+gZnCT1o3lLssQPvX4pAZdijxI4k8TNWj64brcQUAQ==
X-Received: by 2002:a1c:6a07:: with SMTP id f7mr7422095wmc.124.1571824251589;
        Wed, 23 Oct 2019 02:50:51 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id y186sm25914296wmb.41.2019.10.23.02.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 02:50:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: ecdh - fix big endian bug in ECC library
Date:   Wed, 23 Oct 2019 11:50:44 +0200
Message-Id: <20191023095044.12319-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The elliptic curve arithmetic library used by the EC-DH KPP implementation
assumes big endian byte order, and unconditionally reverses the byte
and word order of multi-limb quantities. On big endian systems, the byte
reordering is not necessary, while the word ordering needs to be retained.

So replace the __swab64() invocation with a call to be64_to_cpu() which
should do the right thing for both little and big endian builds.

Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ecc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index dfe114bc0c4a..8ee787723c5c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1284,10 +1284,11 @@ EXPORT_SYMBOL(ecc_point_mult_shamir);
 static inline void ecc_swap_digits(const u64 *in, u64 *out,
 				   unsigned int ndigits)
 {
+	const __be64 *src = (__force __be64 *)in;
 	int i;
 
 	for (i = 0; i < ndigits; i++)
-		out[i] = __swab64(in[ndigits - 1 - i]);
+		out[i] = be64_to_cpu(src[ndigits - 1 - i]);
 }
 
 static int __ecc_is_key_valid(const struct ecc_curve *curve,
-- 
2.20.1

