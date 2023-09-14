Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E361EDE995
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbjINI2o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbjINI2e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:28:34 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C400C1FF9
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bf1935f6c2so5467605ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694680110; x=1695284910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/EigJm6/HUiXf1GCjkqew1cMCZsb5UD7SJBMzmN1lY=;
        b=HrseTqmVbQHnGFiT7quB71kwp1p7PPgraeEMf3kxPHOvxUgIO3l88p27l8VuuJbQG4
         yMWEvU9g25eUKqGbhMKdEUK8sg4AHSGmUPzu6lWzAIy6zjeEiHY09DFXPA08PwB6fs56
         Ia7RpHFzbau+g8E+DAJRP6bYm3Tq60uDZow/tNzEIRqoxbwFQzvZgFnbhq3aPVXyzW0X
         bXyZnc14LFxX/y5UPRBYBvx0qPdYGY5TjiCJgS6sgaOipFoo4a61TIcB10jk7wEYIpQy
         2Mnv8uM70+t+qWvd0CsyfqmxfNQQ6eMsRcjROVKCuWnJ1iUjnsFOkZKsw/SDt/qfSQv4
         22bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694680110; x=1695284910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r/EigJm6/HUiXf1GCjkqew1cMCZsb5UD7SJBMzmN1lY=;
        b=QANEtdpcB+nk6tccNtiXTyEwYUXA2zsV9+8RhZtVDZpUxFSwCxKAiojzKxm5EMbiOP
         LESbK/TC0Rhqm3TwbpPvJ9yCusyPbYRjeKrKXiOx/8E/NtyqzkN7j+sTr2uPNjyuySVJ
         pWpPbo1T9DhX7OCbMmhUL1z/TKpk/n4pHFReOojQqgvpz9P1acN7cv6RlTiDFn3Om1SU
         /ASODwa0pBVTqZh6FvP++ZXLoSibzcYkti+9hoR8ikOqkmZsaQ52SJyYiv3SLGVxdlOr
         QOunz9AOp1nlTaQwb9oXCH3zMoh6mj9n9fqH5ZeZe8aFZ+g8PK7joHF2wIoCKUq5kejS
         tS0Q==
X-Gm-Message-State: AOJu0Yy64dEXyeajpObaHAvo/O+rK5eovmM2JO1XBE7MzNLbutugIGaA
        vp/CoRvOTP5bjILVIVGEfLGL5WNjW9Q=
X-Google-Smtp-Source: AGHT+IFyHhYLeJfqNlcn8bdoSa4hpzEfVWNxCyGQB0ESH8GwX7U0jqD1h1fHbKcVfJzIABOeoF6Azw==
X-Received: by 2002:a17:902:ec88:b0:1c3:22a9:8643 with SMTP id x8-20020a170902ec8800b001c322a98643mr1479822plg.31.1694680109964;
        Thu, 14 Sep 2023 01:28:29 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d50d00b001bba3a4888bsm976242plg.102.2023.09.14.01.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 01:28:29 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/8] crypto: aead - Add crypto_has_aead
Date:   Thu, 14 Sep 2023 16:28:21 +0800
Message-Id: <20230914082828.895403-2-herbert@gondor.apana.org.au>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the helper crypto_has_aead.  This is meant to replace the
existing use of crypto_has_alg to locate AEAD algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/aead.c         |  6 ++++++
 include/crypto/aead.h | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index d5ba204ebdbf..54906633566a 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -269,6 +269,12 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_aead);
 
+int crypto_has_aead(const char *alg_name, u32 type, u32 mask)
+{
+	return crypto_type_has_alg(alg_name, &crypto_aead_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_has_aead);
+
 static int aead_prepare_alg(struct aead_alg *alg)
 {
 	struct crypto_istat_aead *istat = aead_get_stat(alg);
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 35e45b854a6f..51382befbe37 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -217,6 +217,18 @@ static inline void crypto_free_aead(struct crypto_aead *tfm)
 	crypto_destroy_tfm(tfm, crypto_aead_tfm(tfm));
 }
 
+/**
+ * crypto_has_aead() - Search for the availability of an aead.
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	      aead
+ * @type: specifies the type of the aead
+ * @mask: specifies the mask for the aead
+ *
+ * Return: true when the aead is known to the kernel crypto API; false
+ *	   otherwise
+ */
+int crypto_has_aead(const char *alg_name, u32 type, u32 mask);
+
 static inline const char *crypto_aead_driver_name(struct crypto_aead *tfm)
 {
 	return crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

