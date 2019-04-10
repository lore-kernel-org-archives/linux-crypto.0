Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62A0C10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9838217D6
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878931;
	bh=BL8h9weJQtcqPlCWvVxrxDOwaLAK/0LPO7irD/2V7xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OWl65eTnWu/ufMyYKBb66ocQ9g4cKGvSOzij8kFDBI/1oYKstlHcxZe8d5B0FY8Dv
	 yauVB9YY7H+90XGqWKEwpypKOdhVuOx1P80WFAAMzOpU22qhBSUtd78L6iON0KA28i
	 5GtxfxgHAsR0/UkxcWIbntNVPlzUAqN2eTy0vxsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfDJGsu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfDJGss (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:48 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAF6C2083E;
        Wed, 10 Apr 2019 06:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878927;
        bh=BL8h9weJQtcqPlCWvVxrxDOwaLAK/0LPO7irD/2V7xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SJXohzve7NbD/o+q+RrqunN15lXZUFuubeS1rRKDh4cH0fZI4SOkuPb/1XgLBHyIj
         ZP0IwgwadL3dWJHkyjoL1cLxYx6vMB7yUXD7mDFYr0nMrZgN4vWo0TsLc5wK1P5RNb
         oMKSBtVYO0qbetnxnZ4XYUxq5rB6C58K8cp355H4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Daniel Axtens <dja@axtens.net>
Subject: [PATCH v2 7/7] crypto: vmx - return correct error code on failed setkey
Date:   Tue,  9 Apr 2019 23:46:35 -0700
Message-Id: <20190410064635.11813-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190410064635.11813-1-ebiggers@kernel.org>
References: <20190410064635.11813-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In the VMX implementations of AES and AES modes, return -EINVAL when an
invalid key length is provided, rather than some unusual error code
determined via a series of additions.  This makes the behavior match the
other AES implementations in the kernel's crypto API.

Cc: Daniel Axtens <dja@axtens.net>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/vmx/aes.c     | 7 ++++---
 drivers/crypto/vmx/aes_cbc.c | 7 ++++---
 drivers/crypto/vmx/aes_ctr.c | 5 +++--
 drivers/crypto/vmx/aes_xts.c | 9 +++++----
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index d7316f7a3a696..b00d6947e02f4 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -78,13 +78,14 @@ static int p8_aes_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_disable();
 	enable_kernel_vsx();
 	ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
-	ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
+	ret |= aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
 	disable_kernel_vsx();
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_cipher_setkey(ctx->fallback, key, keylen);
-	return ret;
+	ret |= crypto_cipher_setkey(ctx->fallback, key, keylen);
+
+	return ret ? -EINVAL : 0;
 }
 
 static void p8_aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index c5c5ff82b52e0..fbe882ef1bc5d 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -81,13 +81,14 @@ static int p8_aes_cbc_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_disable();
 	enable_kernel_vsx();
 	ret = aes_p8_set_encrypt_key(key, keylen * 8, &ctx->enc_key);
-	ret += aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
+	ret |= aes_p8_set_decrypt_key(key, keylen * 8, &ctx->dec_key);
 	disable_kernel_vsx();
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
-	return ret;
+	ret |= crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
+
+	return ret ? -EINVAL : 0;
 }
 
 static int p8_aes_cbc_encrypt(struct blkcipher_desc *desc,
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 8a2fe092cb8e0..214c69db9ebdf 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -83,8 +83,9 @@ static int p8_aes_ctr_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
-	return ret;
+	ret |= crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
+
+	return ret ? -EINVAL : 0;
 }
 
 static void p8_aes_ctr_final(struct p8_aes_ctr_ctx *ctx,
diff --git a/drivers/crypto/vmx/aes_xts.c b/drivers/crypto/vmx/aes_xts.c
index ecd64e5cc5bbb..5bf4c38566502 100644
--- a/drivers/crypto/vmx/aes_xts.c
+++ b/drivers/crypto/vmx/aes_xts.c
@@ -86,14 +86,15 @@ static int p8_aes_xts_setkey(struct crypto_tfm *tfm, const u8 *key,
 	pagefault_disable();
 	enable_kernel_vsx();
 	ret = aes_p8_set_encrypt_key(key + keylen/2, (keylen/2) * 8, &ctx->tweak_key);
-	ret += aes_p8_set_encrypt_key(key, (keylen/2) * 8, &ctx->enc_key);
-	ret += aes_p8_set_decrypt_key(key, (keylen/2) * 8, &ctx->dec_key);
+	ret |= aes_p8_set_encrypt_key(key, (keylen/2) * 8, &ctx->enc_key);
+	ret |= aes_p8_set_decrypt_key(key, (keylen/2) * 8, &ctx->dec_key);
 	disable_kernel_vsx();
 	pagefault_enable();
 	preempt_enable();
 
-	ret += crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
-	return ret;
+	ret |= crypto_sync_skcipher_setkey(ctx->fallback, key, keylen);
+
+	return ret ? -EINVAL : 0;
 }
 
 static int p8_aes_xts_crypt(struct blkcipher_desc *desc,
-- 
2.21.0

