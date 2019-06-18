Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0A6C31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 11:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6031720873
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 11:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfFRLUL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 07:20:11 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:54111 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfFRLUK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 07:20:10 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N7zJl-1ihrb10qH5-014zfL; Tue, 18 Jun 2019 13:20:00 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] crypto: serpent - mark __serpent_setkey_sbox noinline
Date:   Tue, 18 Jun 2019 13:19:42 +0200
Message-Id: <20190618111953.3183723-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VIWQh7CGc1e7ltY83od0FlOkocpGFJuJKawvgRQ5EwYbCB8I42u
 7dpn0qwdoSWNr3+V9YzfMMHU1OpbH+9VYy4ji/hfTL9c6Wq8Lh+d9yDy3ahSKquSfPrDTG8
 2h35j5Wt7KmOHdFtds3TtDu0YGLppBaMxodi+EGl9/yHBYi/CozL9FgopJ0565GQr01thZR
 ghX1zLytq4EqAVWGu8UeQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Exce4h1rSxc=:NgW1DRQhB2jU9fDRpSqrqZ
 NkDrx8pqzA+SOEghvSwELrk+k5e28L/lu2Dvb3w08iOS2AQcgAjDVLM5qu8CDynf3unvNWXsG
 ocV8xs4MiaMcWy1aFIY30PNEClGYcsKB0koAPKDuR5g3lMim4knCt+9nPpzfpWTRyumokvQ1z
 zL1tNTQ0tABgrEZt1Y0DiO50cFXxKdCJ3vnmt8ogaNf0mp7LLR41hQgKSj2gbt3sVKIcpnoaq
 +fTdZ25uu/v7TkjVdb2UMtyS+BtWrRsXUDA0FHU1B45G7Q6zaHQjh6ngWUe4TlwG0TjYKY0xt
 fcelSULF6cE/+BZ47RpnkFIlH5Y2taWPn0SJSid3PC8vKk6LarpRfmZnILQ0jCfG8KffXy9y7
 nb+0lxYmR6SwCctbz8RwvL1sitaARBXE6A5rTktbTQV4s3jC8Bfkn3emvU1Q0SLGqj0gbcOle
 uuFDuSbExWqqeAOCp9mjQtcgQhDFuuWw04Uuj0Rmd3r4DD5fOOplGQk0xF4DOo9+DxvsrMqLq
 jvmuM4EVvAxhgjw4LqC9IP0RoSm9/lct5arMN8z8KOL/8JivZrA+7VK2X7E6r++Cap1/d+/6p
 Zzb+A9k/d6Rqj507JIBJVl61YYqLt4+nHU4MaKHoXgqG/h4AfibQ6AClwExY9TRI32M6OQZMr
 UM74UFE/kM9wqbAy+bZ/BnzfG9Sdlrp/OWbBUokBvkvAPqwJqCQZ5yerxNgStKu/08TBZcCqG
 GXD3BsGaK9GHy5hwCDdTEktYAI3vnhP9nEPF6g==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The same bug that gcc hit in the past is apparently now showing
up with clang, which decides to inline __serpent_setkey_sbox:

crypto/serpent_generic.c:268:5: error: stack frame size of 2112 bytes in function '__serpent_setkey' [-Werror,-Wframe-larger-than=]

Marking it 'noinline' reduces the stack usage from 2112 bytes to
192 and 96 bytes, respectively, and seems to generate more
useful object code.

Fixes: c871c10e4ea7 ("crypto: serpent - improve __serpent_setkey with UBSAN")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: style improvements suggested by Eric Biggers
---
 crypto/serpent_generic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index e57757904677..56fa665a4f01 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -225,7 +225,13 @@
 	x4 ^= x2;					\
 	})
 
-static void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2, u32 r3, u32 r4, u32 *k)
+/*
+ * both gcc and clang have misoptimized this function in the past,
+ * producing horrible object code from spilling temporary variables
+ * on the stack. Forcing this part out of line avoids that.
+ */
+static noinline void __serpent_setkey_sbox(u32 r0, u32 r1, u32 r2,
+					   u32 r3, u32 r4, u32 *k)
 {
 	k += 100;
 	S3(r3, r4, r0, r1, r2); store_and_load_keys(r1, r2, r4, r3, 28, 24);
-- 
2.20.0

