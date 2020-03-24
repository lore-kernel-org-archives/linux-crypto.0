Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A35C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 08:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FF55208D5
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585039882;
	bh=Iv3Ytq8bh69ZiOc5Glx1Gv7cmvr5X7NaNRuGu5x/ZT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HtHwEy+enskycILFZ0P4uONEj4NdTb+wyo3wf0f1k7WgrMpxpDeJWt7IgOa7hOcrk
	 39YiN0d/3j6FYQfv9M1161XBKvYEjcYI+WGQ40qShhbl30KdbdLHDt1HY0OKyDWwJI
	 iXVnbdDe9FVKYekqa0veBYHgUCv8LD9UIWtTU7/8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgCXIvV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:51:21 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:17233 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgCXIvL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 04:51:11 -0400
Received: from pug.e01.socionext.com (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O8mgsk011219;
        Tue, 24 Mar 2020 17:49:00 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O8mgsk011219
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585039740;
        bh=+sBpYXedQh2YzVb03jkJMbz9JNuGcrw07RIglD9uxfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9RusmaBll+27qhYBFIXlTiemgqggu13Qa7n14wuVoCHAhETdtWLrtnjV8ZNRJXDS
         NNBqD11dc85K2uijg50eldHcFAl4EqN4nul2gJlFo5Y2/88+9A2olIwEGfSUuJPSXQ
         hfogxDr82ybyTUvuQPKwQBBtvfFTKWBfz2n379+xohHovrNGOQb0NZ7rPH8M8tQwqq
         33VzRfCB4fI1MB3vhNeg6ngj2bcUFGcvctdVQXH50TFa7rqXox3sErAwLQ7CVpljc6
         L558GI83D9EEIRVD1667yOhm4SBk0sOuN8uATfebq4SCi5oPL1pCsWZOGxEzn8XAyv
         OwgbU8g1u+zhw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        clang-built-linux@googlegroups.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 13/16] crypto: curve25519 - do not pollute dispatcher based on assembler
Date:   Tue, 24 Mar 2020 17:48:18 +0900
Message-Id: <20200324084821.29944-14-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324084821.29944-1-masahiroy@kernel.org>
References: <20200324084821.29944-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

Since we're doing a static inline dispatch here, we normally branch
based on whether or not there's an arch implementation. That would have
been fine in general, except the crypto Makefile prior used to turn
things off -- despite the Kconfig -- resulting in us needing to also
hard code various assembler things into the dispatcher too. The horror!
Now that the assembler config options are done by Kconfig, we can get
rid of the inconsistency.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 include/crypto/curve25519.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/crypto/curve25519.h b/include/crypto/curve25519.h
index 9ecb3c1f0f15..4e6dc840b159 100644
--- a/include/crypto/curve25519.h
+++ b/include/crypto/curve25519.h
@@ -33,8 +33,7 @@ bool __must_check curve25519(u8 mypublic[CURVE25519_KEY_SIZE],
 			     const u8 secret[CURVE25519_KEY_SIZE],
 			     const u8 basepoint[CURVE25519_KEY_SIZE])
 {
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519) &&
-	    (!IS_ENABLED(CONFIG_CRYPTO_CURVE25519_X86) || IS_ENABLED(CONFIG_AS_ADX)))
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
 		curve25519_arch(mypublic, secret, basepoint);
 	else
 		curve25519_generic(mypublic, secret, basepoint);
@@ -50,8 +49,7 @@ __must_check curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
 				    CURVE25519_KEY_SIZE)))
 		return false;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519) &&
-	    (!IS_ENABLED(CONFIG_CRYPTO_CURVE25519_X86) || IS_ENABLED(CONFIG_AS_ADX)))
+	if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CURVE25519))
 		curve25519_base_arch(pub, secret);
 	else
 		curve25519_generic(pub, secret, curve25519_base_point);
-- 
2.17.1

