Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9689C33C99
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9074221D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024309;
	bh=krCjoqWYb9JakE/BHd/58VVe+cWrL8n1ELLyCYUkXN0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qLdFTiHUG+Q7mYm/kQKvtWePOwofTHPmHFtgTYSmkKM3Y8Yj6s5YmRzijkHEgJJLY
	 0PjCiRUS3o5I368FYUgxelq5yY7ZFMQ4dGsaj5E8Q9hkDtuTmf8Ka80nFhDmMuiVmi
	 Uffze40BpzkMd1g/Lh2dHEF7nefsfXtaVkkj1lR8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgACEFI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgACEFH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:05:07 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED17B222C3
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024307;
        bh=krCjoqWYb9JakE/BHd/58VVe+cWrL8n1ELLyCYUkXN0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PcpiB5czGK71LceH5siTCzRnVYPXjSchrBLKTNvccI4ehIp1p31xcaBukgOrnEqut
         C1+Z0cHDti/gD+r4hPpuvigb/2XVtHIoUVGfnMxUZTZWKBfBi4QIo9W+WmUx7j1osB
         SYIStjuy4Kw4LG63/Pz7DC6CxCQ6AfinD5LnKgu8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 6/6] crypto: algapi - enforce that all instances have a ->free() method
Date:   Thu,  2 Jan 2020 20:04:40 -0800
Message-Id: <20200103040440.12375-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103040440.12375-1-ebiggers@kernel.org>
References: <20200103040440.12375-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

All instances need to have a ->free() method, but people could forget to
set it and then not notice if the instance is never unregistered.  To
help detect this bug earlier, don't allow an instance without a ->free()
method to be registered, and complain loudly if someone tries to do it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c     | 3 +++
 crypto/ahash.c    | 3 +++
 crypto/akcipher.c | 2 ++
 crypto/shash.c    | 3 +++
 crypto/skcipher.c | 3 +++
 5 files changed, 14 insertions(+)

diff --git a/crypto/aead.c b/crypto/aead.c
index 7707d3223101..16991095270d 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -288,6 +288,9 @@ int aead_register_instance(struct crypto_template *tmpl,
 {
 	int err;
 
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
+
 	err = aead_prepare_alg(&inst->alg);
 	if (err)
 		return err;
diff --git a/crypto/ahash.c b/crypto/ahash.c
index cd5d9847d513..68a0f0cb75c4 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -656,6 +656,9 @@ int ahash_register_instance(struct crypto_template *tmpl,
 {
 	int err;
 
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
+
 	err = ahash_prepare_alg(&inst->alg);
 	if (err)
 		return err;
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index eeed6c151d2f..f866085c8a4a 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -147,6 +147,8 @@ EXPORT_SYMBOL_GPL(crypto_unregister_akcipher);
 int akcipher_register_instance(struct crypto_template *tmpl,
 			       struct akcipher_instance *inst)
 {
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
 	akcipher_prepare_alg(&inst->alg);
 	return crypto_register_instance(tmpl, akcipher_crypto_instance(inst));
 }
diff --git a/crypto/shash.c b/crypto/shash.c
index 70faf28b2d14..c075b26c2a1d 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -577,6 +577,9 @@ int shash_register_instance(struct crypto_template *tmpl,
 {
 	int err;
 
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
+
 	err = shash_prepare_alg(&inst->alg);
 	if (err)
 		return err;
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 8c37243307aa..ba41f81fac0b 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -876,6 +876,9 @@ int skcipher_register_instance(struct crypto_template *tmpl,
 {
 	int err;
 
+	if (WARN_ON(!inst->free))
+		return -EINVAL;
+
 	err = skcipher_prepare_alg(&inst->alg);
 	if (err)
 		return err;
-- 
2.24.1

