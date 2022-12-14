Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02754C4167B
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Dec 2022 17:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiLNRUT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbiLNRUO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2022 12:20:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4F4615E
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 09:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BFE6B8199B
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2022 17:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9E5C433D2;
        Wed, 14 Dec 2022 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671038410;
        bh=emWnJXOmgbwid9xQxjK2JCCw+pEOjcgMhyAXsdZe05Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V0wftsTsY9x8otWnNrpQWuMbPi+50ITemHUjkEjdMDETHaLtmXa4KXrs+emzWAm/z
         d+3qCDZFfDNm+EfGfxFr24RB4ut9kfMeCzC2Bdq+HECMKHXpJdYVWnWLlm3TtiiM1j
         BwbNbBDDs0fkJHCA6Z2xBphUo8tbrUXRHK96vh3O/YzSkiOKIlJPM3xO06MXvfncbV
         a+LRu5jztkz6LA/uTMMen31KEWnf5wR/rwMo9RPk1CEDp9FJbkdkUzF8InEfuMw1ZW
         D5ChsSLvuIXK2RlvSis+LH61vwICWdj2tSbzjOWJyRwYnjDIJNbCLRYSv61DvmTDDG
         +s4KDE7E0WRJQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 4/4] crypto: aead - fix inaccurate documentation
Date:   Wed, 14 Dec 2022 18:19:57 +0100
Message-Id: <20221214171957.2833419-5-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221214171957.2833419-1-ardb@kernel.org>
References: <20221214171957.2833419-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2669; i=ardb@kernel.org; h=from:subject; bh=emWnJXOmgbwid9xQxjK2JCCw+pEOjcgMhyAXsdZe05Q=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjmgW84aa3h+eTpSlMVuKEgrphi4FTcQfgXE2sxduI RrGq3diJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5oFvAAKCRDDTyI5ktmPJHD6DA DF/5rdk/mmMWwRG4KxPO67NGaOgwyPEeSCNo/AUMlBJVq/kMsrKLhg7jnNYWxD2MY6hFiJoI6ggNn0 IPH/8KUMQFfhTLqMCtr8mxf9AeOLH1a/jYUW9x4Y1HUPVqXHmpU8K6GbTMxGNWBcNA+aY3Z1tjd4sN C/FK4b0hN3Nh1pG+kKDbdZ/px3IXxmMPJhA0+tpstmQR3osz37lf23MDAt1wOP9JGClFhBfEe6ix1h T4nh6aQZAfQcW7Uuttb5lZwXFPI3faqVuhosNTXyNoXMkNqd6vfAfEJl1UZBP1iPcx5xMwVPUZZ9rd lk9iAcargc5rcMDYe6sJNMtK/JZ6LbsHo6FrVQh6rFBwZNMHgs6sg3EgDXaeghJDHaXlvKmU/+HoKk BM3pTZ3MW6qWbPcV9nnl2IGjncdjm2Ab4vGiH2jrr8Ii0rMyZIX+MBteNKlJnuXzRrKLI/ZWSH3bKr GXXH4rsPdxO5UquJ51FHtEou9lvr3O6r0GWT7yEWJq9GI=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AEAD documentation conflates associated data and authentication
tags: the former (along with the ciphertext) is authenticated by the
latter. Fix the doc accordingly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/crypto/aead.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 14db3bee0519ee85..4a2b7e6e0c1fa7cd 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -27,15 +27,12 @@
  *
  * For example: authenc(hmac(sha256), cbc(aes))
  *
- * The example code provided for the symmetric key cipher operation
- * applies here as well. Naturally all *skcipher* symbols must be exchanged
- * the *aead* pendants discussed in the following. In addition, for the AEAD
- * operation, the aead_request_set_ad function must be used to set the
- * pointer to the associated data memory location before performing the
- * encryption or decryption operation. In case of an encryption, the associated
- * data memory is filled during the encryption operation. For decryption, the
- * associated data memory must contain data that is used to verify the integrity
- * of the decrypted data. Another deviation from the asynchronous block cipher
+ * The example code provided for the symmetric key cipher operation applies
+ * here as well. Naturally all *skcipher* symbols must be exchanged the *aead*
+ * pendants discussed in the following. In addition, for the AEAD operation,
+ * the aead_request_set_ad function must be used to set the pointer to the
+ * associated data memory location before performing the encryption or
+ * decryption operation. Another deviation from the asynchronous block cipher
  * operation is that the caller should explicitly check for -EBADMSG of the
  * crypto_aead_decrypt. That error indicates an authentication error, i.e.
  * a breach in the integrity of the message. In essence, that -EBADMSG error
@@ -49,7 +46,10 @@
  *
  * The destination scatterlist has the same layout, except that the plaintext
  * (resp. ciphertext) will grow (resp. shrink) by the authentication tag size
- * during encryption (resp. decryption).
+ * during encryption (resp. decryption). The authentication tag is generated
+ * during the encryption operation and appended to the ciphertext. During
+ * decryption, the authentication tag is consumed along with the ciphertext and
+ * used to verify the integrity of the plaintext and the associated data.
  *
  * In-place encryption/decryption is enabled by using the same scatterlist
  * pointer for both the source and destination.
-- 
2.35.1

