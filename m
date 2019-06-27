Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4E7C48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162EF2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OMfsU/JS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfF0MD7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52430 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbfF0MD5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so5468462wms.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=OMfsU/JSW0SMZatZZnAJHpMGi3CUDPeclFT1aeZiYANbvksi3yWKt1kKFJrIaUhYvl
         mhS2oNAu33hK8o9oU/6hy/z0NGoq4MCKkPnVYRcTi/uWKnZWjbQ7sOdycFY/MuUbRIMg
         v55kEg1lsf7WkRrG8CaCu7r32gxlECR27jokVcPMG197u/vhdGNip9B6cA7s62rfM+P4
         1lTvLVKMQEz1RpiJUR64IzGvKu75SCo/FlJFIwLhLCcJ7A/Fxe2T1zwrKku3mY+AP8+X
         zghFAKEBVOEOpgV4sUKxAWeTPf/ZJCvnNfSyRRuL3ig3jkwN4WVizDZTMXS7XLL7N4OR
         8Yng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GlTPPuF7VX+eSXKr9xKNOwcbjbSTX6Pw4/5JxljOKbg=;
        b=HKRbq6JfHTqpWxcpyinvPMjBfhIQsNrcpdaLkcgLdToGiZrNF4kio4trGSCuq9DY2a
         ODQmAA3TSFOpJCm6XxcvIysp1Kwknzpj5JNgYs29neK+qo9FT1NXocIZAe3voefaJRAb
         MBdFsJ8HZPkaj2xaa4XBUSD+tOD6mQ0FQ8HMlSkj3XQdygdLwwWjvWnh4fPzXiw5Iw/C
         7wDDtj/40vbaU41wJJgg9OPVKMIknhhBhNfAN5FzYtnFWUWaYhPOWMGSZALrPZ+an+tU
         aMa4j/RXl4tZPy2w6ApZvv8S4BTeR8VFTAoPtvXsxmIVYsFqmOQHpLOewURytLLXwNTk
         OQUA==
X-Gm-Message-State: APjAAAUwlrCgWUOs7tWIJD0D/LKaEzpwu30JVorgUNpBzSO4CUBkVitP
        nrnnYEhefPV5lK5B5KCSw/ND1VojGvTyOQ==
X-Google-Smtp-Source: APXvYqwpdWwUfU7RfP7YooovToeWzUfpV5rjnhxP4jY8Ln8q16rgl0WqlqhVsOWtT3SR9SO0xoASOQ==
X-Received: by 2002:a1c:2907:: with SMTP id p7mr2980719wmp.100.1561637034837;
        Thu, 27 Jun 2019 05:03:54 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 26/30] crypto: des - remove unused function
Date:   Thu, 27 Jun 2019 14:03:10 +0200
Message-Id: <20190627120314.7197-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the old DES3 verification functions that are no longer used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/des.h | 41 --------------------
 1 file changed, 41 deletions(-)

diff --git a/include/crypto/des.h b/include/crypto/des.h
index 72c7c8e5a5a7..31b04ba835b1 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -19,47 +19,6 @@
 #define DES3_EDE_EXPKEY_WORDS	(3 * DES_EXPKEY_WORDS)
 #define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
 
-static inline int __des3_verify_key(u32 *flags, const u8 *key)
-{
-	int err = -EINVAL;
-	u32 K[6];
-
-	memcpy(K, key, DES3_EDE_KEY_SIZE);
-
-	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
-		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (fips_enabled ||
-		      (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)))
-		goto bad;
-
-	if (unlikely(!((K[0] ^ K[4]) | (K[1] ^ K[5]))) && fips_enabled)
-		goto bad;
-
-	err = 0;
-
-out:
-	memzero_explicit(K, DES3_EDE_KEY_SIZE);
-
-	return err;
-
-bad:
-	*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-	goto out;
-}
-
-static inline int des3_verify_key(struct crypto_skcipher *tfm, const u8 *key)
-{
-	u32 flags;
-	int err;
-
-	flags = crypto_skcipher_get_flags(tfm);
-	err = __des3_verify_key(&flags, key);
-	crypto_skcipher_set_flags(tfm, flags);
-	return err;
-}
-
-extern unsigned long des_ekey(u32 *pe, const u8 *k);
-
 extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 			     unsigned int keylen);
 
-- 
2.20.1

