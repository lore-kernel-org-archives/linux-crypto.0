Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55FFC4360D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A196F21D7C
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sVEBaPJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbfIYQNx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:13:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37830 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387908AbfIYQNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:13:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id f22so5642972wmc.2
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tn6PuyCvHzBYqw98o/h7jtBUwnaA2ySt5tvs6NRZxxw=;
        b=sVEBaPJKCR8iK0Ti7MEQI9T+ABca2s8phVUtojeWGaOvvOnjGzCAWbIcwzTp83jDXY
         m5r+f8qSrlBt5lQOpjo4PbCjfXkKE1E7AhkpXc7Gewyt0NaJ1VnNP6JhkqSfMoqmY7GF
         j8xyagkcnqsJPh13J/t3KvX77GFGnCn2aaaOo208psPIV4dtHsVaEJ/ehJH3zSYUCemn
         4MlEFV8zbH5FzW68MLAwQC6BkiilCT/nnAaN30Tx0lJxhAMMEHA1RjS7B96k4pywgs/l
         E8RSZdVJ1XxGKuaBONZ5Q7tUfH03ni0EiUQRWdXTdNNWtPojWjjnjsAtJEFlLJjTztif
         q7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tn6PuyCvHzBYqw98o/h7jtBUwnaA2ySt5tvs6NRZxxw=;
        b=WXQYLmPjuH73q/3X3Aq3HEjt8ZMOjKDRT1hnVFESa+tiSYUAUl6pWi/MBdgE76WQF/
         YmyWgp1skZZ6fAMnawKwwuO6qQRgP0nEkh7HFd8E/oJnUphiz5tAgmBuQ3Y/QY4VhQfb
         hxUUQ0GmxeEhGF00PHrjHqh6hmIT0aS76U0JhIeIkkUS5QnSdrqRcexOvxpcssaeYMF3
         A4eMn1BtysDTHn7BJln6gH0jfRp9A0HqAcoF6D1v96tiBW56JXXLJOeccpG3qgqjibez
         DhhLhzJ3xlIVcsZdzClAdnP++12d/mXGhz5RRg4t7Mif15VyVG+WCSnu/iGnM6H9YMw4
         rYMQ==
X-Gm-Message-State: APjAAAXiO9xvxuR3KZB8EykakLz5TcE+A0B7ZmRH+HWes7mE56CRMrn+
        y8G0v+ueZ1jLJK7PowWOPoaIK4yM+0AInbbD
X-Google-Smtp-Source: APXvYqyiGoS0vuNCTz14AtTm1UOuqGwmutm4W/PM/ZgKxsJ2voQXgcF4hUOWb9WVVS3FaxjAQLdoPg==
X-Received: by 2002:a1c:a516:: with SMTP id o22mr5410877wme.116.1569428028214;
        Wed, 25 Sep 2019 09:13:48 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:13:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 01/18] crypto: shash - add plumbing for operating on scatterlists
Date:   Wed, 25 Sep 2019 18:12:38 +0200
Message-Id: <20190925161255.1871-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add an internal method to the shash interface that permits templates
to invoke it with a scatterlist. Drivers implementing the shash
interface can opt into using this method, making it more straightforward
for templates to pass down data provided via scatterlists without forcing
the underlying shash to process each scatterlist entry with a discrete
update() call. This will be used later in the SIMD accelerated Poly1305
to amortize SIMD begin()/end() calls over the entire input.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ahash.c                 | 18 +++++++++++++++
 crypto/shash.c                 | 24 ++++++++++++++++++++
 include/crypto/hash.h          |  3 +++
 include/crypto/internal/hash.h | 19 ++++++++++++++++
 4 files changed, 64 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3815b363a693..aecb48f0f50c 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -144,6 +144,24 @@ int crypto_hash_walk_first(struct ahash_request *req,
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
+int crypto_shash_walk_sg(struct shash_desc *desc, struct scatterlist *sg,
+			 int nbytes, struct crypto_hash_walk *walk, int flags)
+{
+	walk->total = nbytes;
+
+	if (!walk->total) {
+		walk->entrylen = 0;
+		return 0;
+	}
+
+	walk->alignmask = crypto_shash_alignmask(desc->tfm);
+	walk->sg = sg;
+	walk->flags = flags;
+
+	return hash_walk_new_entry(walk);
+}
+EXPORT_SYMBOL_GPL(crypto_shash_walk_sg);
+
 int crypto_ahash_walk_first(struct ahash_request *req,
 			    struct crypto_hash_walk *walk)
 {
diff --git a/crypto/shash.c b/crypto/shash.c
index e83c5124f6eb..b16ab5590dc4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -121,6 +121,30 @@ int crypto_shash_update(struct shash_desc *desc, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_shash_update);
 
+int crypto_shash_update_from_sg(struct shash_desc *desc, struct scatterlist *sg,
+				unsigned int len, bool atomic)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+	struct crypto_hash_walk walk;
+	int flags = 0;
+	int nbytes;
+
+	if (!atomic)
+		flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	if (shash->update_from_sg)
+		return shash->update_from_sg(desc, sg, len, flags);
+
+	for (nbytes = crypto_shash_walk_sg(desc, sg, len, &walk, flags);
+	     nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, nbytes))
+		nbytes = crypto_shash_update(desc, walk.data, nbytes);
+
+	return nbytes;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_update_from_sg);
+
 static int shash_final_unaligned(struct shash_desc *desc, u8 *out)
 {
 	struct crypto_shash *tfm = desc->tfm;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index ef10c370605a..0b83d85a3828 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -158,6 +158,7 @@ struct shash_desc {
  * struct shash_alg - synchronous message digest definition
  * @init: see struct ahash_alg
  * @update: see struct ahash_alg
+ * @update_from_sg: variant of update() taking a scatterlist as input [optional]
  * @final: see struct ahash_alg
  * @finup: see struct ahash_alg
  * @digest: see struct ahash_alg
@@ -175,6 +176,8 @@ struct shash_alg {
 	int (*init)(struct shash_desc *desc);
 	int (*update)(struct shash_desc *desc, const u8 *data,
 		      unsigned int len);
+	int (*update_from_sg)(struct shash_desc *desc, struct scatterlist *sg,
+			      unsigned int len, int flags);
 	int (*final)(struct shash_desc *desc, u8 *out);
 	int (*finup)(struct shash_desc *desc, const u8 *data,
 		     unsigned int len, u8 *out);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index bfc9db7b100d..6f4bfa057bea 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -50,6 +50,8 @@ extern const struct crypto_type crypto_ahash_type;
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
+int crypto_shash_walk_sg(struct shash_desc *desc, struct scatterlist *sg,
+			 int nbytes, struct crypto_hash_walk *walk, int flags);
 int crypto_ahash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
 
@@ -242,5 +244,22 @@ static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_shash, base);
 }
 
+/**
+ * crypto_shash_update_from_sg() - add data from a scatterlist to message digest
+ * 				   for processing
+ * @desc: operational state handle that is already initialized
+ * @data: scatterlist with input data to be added to the message digest
+ * @len: length of the input data
+ * @atomic: whether or not the call is permitted to sleep
+ *
+ * Updates the message digest state of the operational state handle.
+ *
+ * Context: Any context.
+ * Return: 0 if the message digest update was successful; < 0 if an error
+ *	   occurred
+ */
+int crypto_shash_update_from_sg(struct shash_desc *desc, struct scatterlist *sg,
+				unsigned int len, bool atomic);
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.20.1

