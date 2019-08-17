Return-Path: <SRS0=KYaN=WN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCC1C3A59F
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 14:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F00C20880
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Aug 2019 14:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHQOYx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Aug 2019 10:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfHQOYx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Aug 2019 10:24:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB2027BDA9;
        Sat, 17 Aug 2019 14:24:52 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-22.ams2.redhat.com [10.36.116.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E56F4E;
        Sat, 17 Aug 2019 14:24:49 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] crypto: sha256 - Use get/put_unaligned_be32 to get input, memzero_explicit
Date:   Sat, 17 Aug 2019 16:24:32 +0200
Message-Id: <20190817142435.8532-5-hdegoede@redhat.com>
In-Reply-To: <20190817142435.8532-1-hdegoede@redhat.com>
References: <20190817142435.8532-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sat, 17 Aug 2019 14:24:52 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use get/put_unaligned_be32 in lib/crypto/sha256.c to load / store data
so that it can be used with unaligned buffers too, making it more generic.

And use memzero_explicit for better clearing of sensitive data.

Note unlike other patches in this series this commit actually makes
functional changes to the sha256 code as used by the purgatory code.

This fully aligns the lib/crypto/sha256.c sha256 implementation with the
one from crypto/sha256_generic.c allowing us to remove the latter in
further patches in this series.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Also switch to put_unaligned_be32 to store the hash
---
 lib/crypto/sha256.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index b8114028d06f..1458a20d53a5 100644
--- a/lib/crypto/sha256.c
+++ b/lib/crypto/sha256.c
@@ -14,7 +14,7 @@
 #include <linux/bitops.h>
 #include <linux/string.h>
 #include <crypto/sha256.h>
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
@@ -33,7 +33,7 @@ static inline u32 Maj(u32 x, u32 y, u32 z)
 
 static inline void LOAD_OP(int I, u32 *W, const u8 *input)
 {
-	W[I] = __be32_to_cpu(((__be32 *)(input))[I]);
+	W[I] = get_unaligned_be32((__u32 *)input + I);
 }
 
 static inline void BLEND_OP(int I, u32 *W)
@@ -201,7 +201,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 
 	/* clear any sensitive info... */
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
-	memset(W, 0, 64 * sizeof(u32));
+	memzero_explicit(W, 64 * sizeof(u32));
 }
 
 int sha256_init(struct sha256_state *sctx)
@@ -270,7 +270,7 @@ int sha256_final(struct sha256_state *sctx, u8 *out)
 
 	/* Store state in digest */
 	for (i = 0; i < 8; i++)
-		dst[i] = cpu_to_be32(sctx->state[i]);
+		put_unaligned_be32(sctx->state[i], &dst[i]);
 
 	/* Zeroize sensitive information. */
 	memset(sctx, 0, sizeof(*sctx));
-- 
2.23.0.rc2

