Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5DCC07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 823D760FDB
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244216AbhGTDGv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:06:51 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55439 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347987AbhGTDGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 23:06:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UgNap9U_1626752802;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UgNap9U_1626752802)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 11:46:43 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v3 0/4] Introduce x86 assembler accelerated implementation for SM4 algorithm
Date:   Tue, 20 Jul 2021 11:46:38 +0800
Message-Id: <20210720034642.19230-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset extracts the public SM4 algorithm as a separate library,
At the same time, the acceleration implementation of SM4 in arm64 was
adjusted to adapt to this SM4 library. Then introduces an accelerated
implementation of the instruction set on x86_64.

This optimization supports the four modes of SM4, ECB, CBC, CFB, and
CTR. Since CBC and CFB do not support multiple block parallel
encryption, the optimization effect is not obvious. And all selftests
have passed already.

The main algorithm implementation comes from SM4 AES-NI work by
libgcrypt and Markku-Juhani O. Saarinen at:
https://github.com/mjosaarinen/sm4ni

Benchmark on Intel Xeon Cascadelake, the data comes from the mode 218
and mode 518 of tcrypt. The abscissas are blocks of different lengths.
The data is tabulated and the unit is Mb/s:

sm4-generic   |    16      64     128     256    1024    1420    4096
      ECB enc | 40.99   46.50   48.05   48.41   49.20   49.25   49.28
      ECB dec | 41.07   46.99   48.15   48.67   49.20   49.25   49.29
      CBC enc | 37.71   45.28   46.77   47.60   48.32   48.37   48.40
      CBC dec | 36.48   44.82   46.43   47.45   48.23   48.30   48.36
      CFB enc | 37.94   44.84   46.12   46.94   47.57   47.46   47.68
      CFB dec | 37.50   42.84   43.74   44.37   44.85   44.80   44.96
      CTR enc | 39.20   45.63   46.75   47.49   48.09   47.85   48.08
      CTR dec | 39.64   45.70   46.72   47.47   47.98   47.88   48.06
sm4-aesni-avx
      ECB enc | 33.75  134.47  221.64  243.43  264.05  251.58  258.13
      ECB dec | 34.02  134.92  223.11  245.14  264.12  251.04  258.33
      CBC enc | 38.85   46.18   47.67   48.34   49.00   48.96   49.14
      CBC dec | 33.54  131.29  223.88  245.27  265.50  252.41  263.78
      CFB enc | 38.70   46.10   47.58   48.29   49.01   48.94   49.19
      CFB dec | 32.79  128.40  223.23  244.87  265.77  253.31  262.79
      CTR enc | 32.58  122.23  220.29  241.16  259.57  248.32  256.69
      CTR dec | 32.81  122.47  218.99  241.54  258.42  248.58  256.61

---
v3 changes:
  * Remove single block algorithm that does not greatly improve performance
  * Remove accelerated for sm4 key expand, which is not performance-critical
  * Fix the warning on arm64/sm4-ce

v2 changes:
  * SM4 library functions use "sm4_" prefix instead of "crypto_" prefix
  * sm4-aesni-avx supports accelerated implementation of four specific modes
  * tcrypt benchmark supports sm4-aesni-avx
  * fixes of other reviews


Tianjia Zhang (4):
  crypto: sm4 - create SM4 library based on sm4 generic code
  crypto: arm64/sm4-ce - Make dependent on sm4 library instead of
    sm4-generic
  crypto: x86/sm4 - add AES-NI/AVX/x86_64 implementation
  crypto: tcrypt - add the asynchronous speed test for SM4

 arch/arm64/crypto/Kconfig              |   2 +-
 arch/arm64/crypto/sm4-ce-glue.c        |  20 +-
 arch/x86/crypto/Makefile               |   3 +
 arch/x86/crypto/sm4-aesni-avx-asm_64.S | 589 +++++++++++++++++++++++++
 arch/x86/crypto/sm4_aesni_avx_glue.c   | 459 +++++++++++++++++++
 crypto/Kconfig                         |  22 +
 crypto/sm4_generic.c                   | 180 +-------
 crypto/tcrypt.c                        |  26 +-
 include/crypto/sm4.h                   |  25 +-
 lib/crypto/Kconfig                     |   3 +
 lib/crypto/Makefile                    |   3 +
 lib/crypto/sm4.c                       | 176 ++++++++
 12 files changed, 1330 insertions(+), 178 deletions(-)
 create mode 100644 arch/x86/crypto/sm4-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/sm4_aesni_avx_glue.c
 create mode 100644 lib/crypto/sm4.c

-- 
2.19.1.3.ge56e4f7

