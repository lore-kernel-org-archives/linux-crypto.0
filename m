Return-Path: <SRS0=FgZY=WM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518A5C3A59E
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28309206C1
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Aug 2019 21:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfHPVQh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Aug 2019 17:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727674AbfHPVQh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Aug 2019 17:16:37 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDAF33084295;
        Fri, 16 Aug 2019 21:16:36 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79FA487BE;
        Fri, 16 Aug 2019 21:16:33 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] crypto: sha256 - Use get_unaligned_be32 to get input, memzero_explicit
Date:   Fri, 16 Aug 2019 23:16:09 +0200
Message-Id: <20190816211611.2568-5-hdegoede@redhat.com>
In-Reply-To: <20190816211611.2568-1-hdegoede@redhat.com>
References: <20190816211611.2568-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 16 Aug 2019 21:16:37 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use get_unaligned_be32 in the lib/crypto/sha256.c sha256_transform()
implementation so that it can be used with unaligned buffers too,
making it more generic.

And use memzero_explicit for better clearing of sensitive data.

Note unlike other patches in this series this commit actually makes
functional changes to the sha256 code as used by the purgatory code.

This fully aligns the lib/crypto/sha256.c sha256_transform()
implementation with the one from crypto/sha256_generic.c allowing us
to remove the latter in further patches in this series.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/crypto/sha256.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
index b8114028d06f..09a435d845fc 100644
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
-- 
2.22.0

