Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C32C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3786D2075B
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ox6TXqJQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfHERCY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33731 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729439AbfHERCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so85263888wru.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pe1t6EIo+yRXqpRd0fashi/U/Hk4eqLBq4nJecNCty0=;
        b=Ox6TXqJQFVqWJDT+hz6MGFOkPVyUXtopQ03D4JvexUQ4hxtOUMIVAGUKDxkaE+GxqI
         lEu1aYMazq0OB5bSnSaxvg9H2BitqLDHZiSNUOFvHa800ebBBHsPQ80ejqUzFfLc4Ho/
         Y83QDq5XM1BA/lIY9nC3Oi/5Qt+0dEb9X8SKOPFxoVhzx2kAE0/OMtOJaZzxu3uxAnua
         91bhw4EMDM4T/7JFMCiS2PfwW9aWigaRNI+T7wLYmwP8p1E9RjtO62VRE6fKdbmPpFIK
         qO0oVVtqylpXUuOjCzjIngvy0ATXzxDNTnO/QLwG8RsNO52nBkO1G9T4spjBsZB+4f1y
         0wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pe1t6EIo+yRXqpRd0fashi/U/Hk4eqLBq4nJecNCty0=;
        b=GFYsBPT1VgKNXWYv87yOzxwuTB6343zYc2nch5izVU91oJnG4NuCvH88NEECVhDr16
         W/EvnXUBIlY/uDDLTvNhYJ6/89jkGAS6nQEp+zWE+bI4qU4wFUPpSFuVeCPdLqQyy66Q
         Kn8z6Foy9XMNGGvkKlWahR6/lbBJSY9AK9Bx/ITV093ez8A6bFtpSiU65IGhiLvm5FMd
         j1NaWbPmZ2yBDtSuZ1JhkGJNs/EIJcJShaS04kvfNsr7xI6RdHysHzF8QJ6rGbYOxRov
         jYA1z+mwin2n7dLGLn47M70ODUURWuvwNzxu7EONzercwt8S19rFzrXzP6FZPtcHQRUK
         lB3w==
X-Gm-Message-State: APjAAAX9gwV4ELLtBUuY33CaseOEfnXcVNFTIfl2S8TAxYqC0KEcCJ+y
        NmtTWLUHCWqc0hTBbGuS0PBybK2blm5AmA==
X-Google-Smtp-Source: APXvYqxhke2MmjpgN1so06TiRFrDUnlipV+/iSo/Tv6zZFzLnKrDrOwj2mDodWD9i7a9R2Sy7YmVrg==
X-Received: by 2002:adf:b60c:: with SMTP id f12mr129771122wre.231.1565024542003;
        Mon, 05 Aug 2019 10:02:22 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:21 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 26/30] crypto: des - remove unused function
Date:   Mon,  5 Aug 2019 20:00:33 +0300
Message-Id: <20190805170037.31330-27-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
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
2.17.1

