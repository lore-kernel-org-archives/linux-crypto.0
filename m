Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEBB4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE0E222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032725;
	bh=jkpKxXyYn0u1RzNF5gaPc7wqx1vcfBZwfbducWpI+Lo=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CmwY/9Y7XMVNCS1jvbu70susqqrP33ISgrt66r3nJXBBw0YE17u/JTC6KK02nLwXW
	 QXlh+ODw8+xsd5Tbso3nryoFQmkTsUJ3ViL5exV0jzNvp+ToICgqDuQ1Mm6eOO/4rK
	 AUJoX0UISfMI8sCGck5oL8nQEhcR3UpWChvxMRGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfJYTpY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfJYTpY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:24 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A7B21D81
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032723;
        bh=jkpKxXyYn0u1RzNF5gaPc7wqx1vcfBZwfbducWpI+Lo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YjBUsmpAMHSAHjDAx6Podv8bMmTmxvTVqfIT3mSJPS40nWO2SWcSuPnJKoY1nkp9V
         mBykMfF7ekesWvxFqFwfKooPNvJveRuNrVdaNsbkNgbQL1gZUs7ORKGUwcxZhYOCMQ
         FsPZhxd3U/2e52m/irOuUs+featMzfbG7bakK7jE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/5] crypto: unify the crypto_has_skcipher*() functions
Date:   Fri, 25 Oct 2019 12:41:09 -0700
Message-Id: <20191025194113.217451-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_has_skcipher() and crypto_has_skcipher2() do the same thing: they
check for the availability of an algorithm of type skcipher, blkcipher,
or ablkcipher, which also meets any non-type constraints the caller
specified.  And they have exactly the same prototype.

Therefore, eliminate the redundancy by removing crypto_has_skcipher()
and renaming crypto_has_skcipher2() to crypto_has_skcipher().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         |  4 ++--
 include/crypto/skcipher.h | 19 +------------------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 22753c1c7202..233678d07816 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -1017,12 +1017,12 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
 
-int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask)
+int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
 {
 	return crypto_type_has_alg(alg_name, &crypto_skcipher_type2,
 				   type, mask);
 }
-EXPORT_SYMBOL_GPL(crypto_has_skcipher2);
+EXPORT_SYMBOL_GPL(crypto_has_skcipher);
 
 static int skcipher_prepare_alg(struct skcipher_alg *alg)
 {
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index aada87916918..e34993f5d190 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -218,30 +218,13 @@ static inline void crypto_free_sync_skcipher(struct crypto_sync_skcipher *tfm)
  * crypto_has_skcipher() - Search for the availability of an skcipher.
  * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
  *	      skcipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the skcipher is known to the kernel crypto API; false
- *	   otherwise
- */
-static inline int crypto_has_skcipher(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_has_alg(alg_name, crypto_skcipher_type(type),
-			      crypto_skcipher_mask(mask));
-}
-
-/**
- * crypto_has_skcipher2() - Search for the availability of an skcipher.
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      skcipher
  * @type: specifies the type of the skcipher
  * @mask: specifies the mask for the skcipher
  *
  * Return: true when the skcipher is known to the kernel crypto API; false
  *	   otherwise
  */
-int crypto_has_skcipher2(const char *alg_name, u32 type, u32 mask);
+int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask);
 
 static inline const char *crypto_skcipher_driver_name(
 	struct crypto_skcipher *tfm)
-- 
2.23.0

