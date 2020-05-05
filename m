Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A650C47259
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 21:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5042087E
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 21:55:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jAfetrHu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgEEVzR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 17:55:17 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42207 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgEEVzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 17:55:16 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bd6ce752;
        Tue, 5 May 2020 21:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=u7+BpfoX6KW/0eplcukpa4yaY
        Ng=; b=jAfetrHuBFqgKxqGGvEtEM8adtJR3HtdBTd+L5GqQSVP43QPkUr/E0TOW
        YuQWbIVRCYRygt4kL9j6WuG3kUmfUdAz6+RvLHAvzJSrDAVL8ONy/ifurjGq04r4
        mIe2EDVPDzTSu0dvIdMhonttNCPVw12+jHPEiAlQVaU7MRA9OIAISAHVuJtOzFvO
        dC1JSlvswbfrHkTeh3C3XoYsk3CU+XQfN1JQvHIyyDydLSSIeA1TOmzODQUOs/cb
        TxxpKYCdUxQCFqoahNcG6Zr4HqvAvtOMu+NzsOCPKboL0PXQj2MxC+5Ehgx7WTZy
        WVV9mJB8ZqEeHnNgSxl5XUnMEsnLA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6efe512b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 May 2020 21:42:39 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, arnd@arndb.de
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        George Burgess <gbiv@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH] Kbuild: disable FORTIFY_SOURCE on clang-10
Date:   Tue,  5 May 2020 15:55:03 -0600
Message-Id: <20200505215503.691205-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
References: <CAHmME9oMcfY4nwkknwN9c4rB-O7xD4GCAOFPoZCbdnq=034=Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

clang-10 has a broken optimization stage that doesn't enable the
compiler to prove at compile time that certain memcpys are within
bounds, and thus the outline memcpy is always called, resulting in
horrific performance, and in some cases, excessive stack frame growth.
Here's a simple reproducer:

    typedef unsigned long size_t;
    void *c(void *dest, const void *src, size_t n) __asm__("memcpy");
    extern inline __attribute__((gnu_inline)) void *memcpy(void *dest, const void *src, size_t n) { return c(dest, src, n); }
    void blah(char *a)
    {
      unsigned long long b[10], c[10];
      int i;

      memcpy(b, a, sizeof(b));
      for (i = 0; i < 10; ++i)
        c[i] = b[i] ^ b[9 - i];
      for (i = 0; i < 10; ++i)
        b[i] = c[i] ^ a[i];
      memcpy(a, b, sizeof(b));
    }

Compile this with clang-9 and clang-10 and observe:

zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-10 -Wframe-larger-than=0 -O3 -c b.c -o c10.o
b.c:5:6: warning: stack frame size of 104 bytes in function 'blah' [-Wframe-larger-than=]
void blah(char *a)
     ^
1 warning generated.
zx2c4@thinkpad /tmp/curve25519-hacl64-stack-frame-size-test $ clang-9 -Wframe-larger-than=0 -O3 -c b.c -o c9.o

Looking at the disassembly of c10.o and c9.o, one can see that c9.o is
properly optimized in the obvious way one would expect, while c10.o has
blown up and includes extern calls to memcpy.

This is present on the most trivial bits of code. Thus, for clang-10, we
just set __NO_FORTIFY globally, so that this issue won't be incurred.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: clang-built-linux <clang-built-linux@googlegroups.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: George Burgess <gbiv@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://bugs.llvm.org/show_bug.cgi?id=45802
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index 49b2709ff44e..f022f077591d 100644
--- a/Makefile
+++ b/Makefile
@@ -768,6 +768,13 @@ KBUILD_CFLAGS += -Wno-gnu
 # source of a reference will be _MergedGlobals and not on of the whitelisted names.
 # See modpost pattern 2
 KBUILD_CFLAGS += -mno-global-merge
+
+# clang-10 has a broken optimization stage that causes memcpy to always be
+# outline, resulting in excessive stack frame growth and poor performance.
+ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 100000 && test $(CONFIG_CLANG_VERSION) -lt 110000; echo $$?),0)
+KBUILD_CFLAGS += -D__NO_FORTIFY
+endif
+
 else
 
 # These warnings generated too much noise in a regular build.
-- 
2.26.2

