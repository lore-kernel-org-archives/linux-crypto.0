Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53F1C33C9A
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1BF24654
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024088;
	bh=D6Bu9h7hmOJg0m8gd7GKpA4ERivZRyr1Jj0yFjm1CGk=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g1qvZsnxe7Slrl/sbsGj/DPDH2IX/L67PiVPenHjjNeGhQsZdV9mh2pNtL7fa44vl
	 QFJODreG4XH4Jm/u3sNAlabv1+ka9CcQoFjW4LyAlzdzVzlAcoKjiUvwPdRDcaC7VD
	 Wbx1D5KkaVBie1qblrEGRTjfL5D6bfURWeS7kYbA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgACEB1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbgACEB0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FE622B48
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024086;
        bh=D6Bu9h7hmOJg0m8gd7GKpA4ERivZRyr1Jj0yFjm1CGk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=1le0w7VA4CFDfOy2vUn8Yb2r6RU8MXipybYBGDVVQRS4io4Fhj5ejVIDACF3JPaTk
         fTLSEAysJCwhkh8R8H211BmNTHZ0Gb7r9wE0Lhq3jLBZ9vxzAfBoFRmGLbVUummFL4
         DV/15oAkgPiOOGXj5whcePuQ3LVAjiR8T4YygIf8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 11/28] crypto: cipher - introduce crypto_cipher_spawn and crypto_grab_cipher()
Date:   Thu,  2 Jan 2020 19:58:51 -0800
Message-Id: <20200103035908.12048-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, "cipher" (single-block cipher) spawns are usually initialized
by using crypto_get_attr_alg() to look up the algorithm, then calling
crypto_init_spawn().  In one case, crypto_grab_spawn() is used directly.

The former way is different from how skcipher, aead, and akcipher spawns
are initialized (they use crypto_grab_*()), and for no good reason.
This difference introduces unnecessary complexity.

The crypto_grab_*() functions used to have some problems, like not
holding a reference to the algorithm and requiring the caller to
initialize spawn->base.inst.  But those problems are fixed now.

Also, the cipher spawns are not strongly typed; e.g., the API requires
that the user manually specify the flags CRYPTO_ALG_TYPE_CIPHER and
CRYPTO_ALG_TYPE_MASK.  Though the "cipher" algorithm type itself isn't
yet strongly typed, we can start by making the spawns strongly typed.

So, let's introduce a new 'struct crypto_cipher_spawn', and functions
crypto_grab_cipher() and crypto_drop_cipher() to grab and drop them.

Later patches will convert all cipher spawns to use these, then make
crypto_spawn_cipher() take 'struct crypto_cipher_spawn' as well, instead
of a bare 'struct crypto_spawn' as it currently does.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/algapi.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 2779c8d34ba9..7705387f9459 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -208,6 +208,31 @@ static inline void *crypto_instance_ctx(struct crypto_instance *inst)
 	return inst->__ctx;
 }
 
+struct crypto_cipher_spawn {
+	struct crypto_spawn base;
+};
+
+static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
+				     struct crypto_instance *inst,
+				     const char *name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+
+static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_alg *crypto_spawn_cipher_alg(
+	struct crypto_cipher_spawn *spawn)
+{
+	return spawn->base.alg;
+}
+
 static inline struct crypto_cipher *crypto_spawn_cipher(
 	struct crypto_spawn *spawn)
 {
-- 
2.24.1

