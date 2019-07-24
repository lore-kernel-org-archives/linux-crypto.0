Return-Path: <SRS0=LUcm=VV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A19C76186
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 18:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0915F21841
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Jul 2019 18:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfGXSwa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Jul 2019 14:52:30 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:38155 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfGXSwa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Jul 2019 14:52:30 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N4z2Y-1iZMDt3sXc-010r7i; Wed, 24 Jul 2019 20:52:10 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kasan-dev@googlegroups.com,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] crypto: jitterentropy: build without sanitizer
Date:   Wed, 24 Jul 2019 20:51:55 +0200
Message-Id: <20190724185207.4023459-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:2QZYaO519OJxYJsrSQIe/UzdE5AmrOwOkLjXT+CjRW8Dx1lg2Dy
 XV/NNUYdwM3vTfiFDwSD0F4fyLZmjd6jW+NV7AJpT+rAQ/sdhR4X1aKa+ZOReDYN8zdd2t/
 Ox2vDe5VdQRl1nHDLe+c38FlsGf4wYILrfhx66IL+1gIA7RT6JgkxFaiP7CwnYG/V2V5wfs
 fgvfUk/OsccuBGMrqhh/g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZAZZZe+kadI=:rnEzG0t1GmceK0/lAFvYax
 Ex+XREoW3yNiDExdl9vfsXIjNkyvMdsCAn1FwWI7ElysOPL8L+Dx/4F9Ep3vW5LunKGgsyQQI
 yv00OJ6maRvK3LcMCmWUJIbWFUE8sskArxmHTlPGR7InwTiBMgZUHuRbnS8StCea9EgLWeL3r
 jy83jMfnVRvdKH7Jth/itcIV/WUhwQe2LDxJ3VuCreyugM/3bTF8MpMl0zcCN//tEyD0w8+xW
 Du4tJ4rFmi+sUNpeyvSGqSVK7gAn9NhOI3H/BVBkMnEhU9bB9J/ZVYxXIcKq+BMhlwE3Ra6k6
 f2Se4X678XzaJuT1ov055sLk0MnEFvD/inMo7rXZ9fDcJ7b1kQ0JLNX4NOapppsAkAxejmo7c
 9ke/cBlq2BAcDMkWdVfjbZzd+BPR3ORrzjnJu5WLtnJeB1u7q+rieUaCeJY36DgH0hqCNRysh
 69709d1BQlv3lfq+fXkple66lk7o126EGCSeuuhYxWrxN5PIazkrjeftVuZaUeS6pcCl7sSHd
 EdwAJHRSdgxtUWv6p92aNNsRhFJa0e8Hv43wSqKQrvPVq8xhELBOl5LvAKOcGQ/UKH+h5PJCu
 QYuanTrvsit0f4rxUE0kdYpNix8gPchck9Q8ZXw4Z2wXB/EF0wnfg27WTonImdt4nl/B/yR9b
 X4XrmEhr1kEVinpZHGB0gB/jOW6ftgC8qNgRmY8Ff6uL3Hs1ONFB6V1Ycbez4KvGP6w3j8rzz
 yhQXpQFLY+j8/q6KKgqbwrTRwUd6KVxz+18WNQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Recent clang-9 snapshots double the kernel stack usage when building
this file with -O0 -fsanitize=kernel-hwaddress, compared to clang-8
and older snapshots, this changed between commits svn364966 and
svn366056:

crypto/jitterentropy.c:516:5: error: stack frame size of 2640 bytes in function 'jent_entropy_init' [-Werror,-Wframe-larger-than=]
int jent_entropy_init(void)
    ^
crypto/jitterentropy.c:185:14: error: stack frame size of 2224 bytes in function 'jent_lfsr_time' [-Werror,-Wframe-larger-than=]
static __u64 jent_lfsr_time(struct rand_data *ec, __u64 time, __u64 loop_cnt)
             ^

I prepared a reduced test case in case any clang developers want to
take a closer look, but from looking at the earlier output it seems
that even with clang-8, something was very wrong here.

Turn off any KASAN and UBSAN sanitizing for this file, as that likely
clashes with -O0 anyway.  Turning off just KASAN avoids the warning
already, but I suspect both of these have undesired side-effects
for jitterentropy.

Link: https://godbolt.org/z/fDcwZ5
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 9479e1a45d8c..176b2623dd68 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -136,6 +136,8 @@ obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
+KASAN_SANITIZE_jitterentropy.o = n
+UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
-- 
2.20.0

