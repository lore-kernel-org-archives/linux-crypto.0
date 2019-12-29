Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB3CC2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91AEA20748
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656207;
	bh=8MQFwtIzx/zix1NPMC/XunuLYk/aQQVRu8b/QMglYgk=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TDCAysuOqP9q+smvuunnozy1NFb7vKlXW8GW5+g0cGA9T+ibrKXlY4k5jdJGNk3n8
	 A4pvjX4Me1PCnJptZ2eaw6/0iu42RiRd9RPj1MM2yFjIXzTjiYIzYNPM+qZ7FeiHQs
	 U5mucyGcgtBQoh6r/FXGwc+SneyeKF6+2JXxu1lU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfL2VuG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfL2VuG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32CB207FF
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656206;
        bh=8MQFwtIzx/zix1NPMC/XunuLYk/aQQVRu8b/QMglYgk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=qd1BKsCYOFEZ2L1ssuluX8GEuJNT8I0fac0Fz8WQre+NV9wPWcvp/iXWuKhAt1V69
         6FSRj46SGJxAv6m3Vs/+iv5iMpB1PCf5lM1tJbBvm72tEyQUS2MsnJ4d6Bd5ZACi+L
         7H2I0hZwwrpR6xEWmhxmz7gyXLun0P7YJME/JEbw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 6/6] crypto: algapi - enforce that all instances have a ->free() method
Date:   Sun, 29 Dec 2019 15:48:30 -0600
Message-Id: <20191229214830.260965-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229214830.260965-1-ebiggers@kernel.org>
References: <20191229214830.260965-1-ebiggers@kernel.org>
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
index a1a3f47c98e1..8dc9dc80b379 100644
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

