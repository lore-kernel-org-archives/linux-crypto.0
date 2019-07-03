Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF8FC0650E
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EFF218A3
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 08:55:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x9uIM2l9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfGCIzr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 04:55:47 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45224 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfGCIzr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 04:55:47 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so1485113lje.12
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jul 2019 01:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BTr6fg1Hs9FFHmhEKIExNXDxUhJliY2YcV2IbTXbo5A=;
        b=x9uIM2l9AHL3+msXH1V2Cu/PAe9MUHbJht883gdQG/7nISlgMj6Z2lugEItNg8zlMJ
         xOzb5y4sGEfybDAeWahpnCM6zCoMtjpZpKR+MvU8slo3lESrTyf5R1Dq+RIf7GjPwfqK
         czNATtut3vmANaVQ22FXWRuaaSrqB7zfLsh5pdJnNRYyZgieNwAg8L7lgi4U9ZDWAaxd
         YTSY0WBY9oC4wCc1j5LEEHi3dCbgElCTMwc0XVjroxN3hW9AHkFusyF6hSA0cTe6jsHw
         PXh0aKK81Zk6TEixjr585PeJBgTtdetLi/tQm/DvCFPWUs5GrnaJvu30cXIlfbdV7Pfy
         ZnlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BTr6fg1Hs9FFHmhEKIExNXDxUhJliY2YcV2IbTXbo5A=;
        b=ayrIgBnswcEGoRKdVE23s20CtQRFLS/slTc19qrF4UFqsDSnppB0jY22CQkGTZAmed
         GmQhboUcP4MnBoSLYcafT/ySQi3iSu9T+G9IHmoR+/FR5fvqttGHjH4n4uYZvHoMV/fG
         Gyo38Fz2De+irODEppTzuCRKJSjam4CvhR8Tf107Rr6vDZa8A+jCm67WjvE0zJ0HqXHa
         aAxhMH93xbO8JfSXZab1/hCr+N6UAXDpUCcq9itR2y99kaaGfM15OM1+ncyXdFHuiJ2B
         cdBT9vmmTpDC1zpIBb+nMharzz2ks5GPKmZVEwSKEuo+zOUvHBOAhK/654e3B+HdFpwz
         LGDg==
X-Gm-Message-State: APjAAAUSyvs1jyczVyBe9XXqb8dZ20hcck6Qn6utBuwQPCG7sTbmgDVq
        3SL8P8Jp8UizLYVU7p6eUHjgnTORIPUsQ/RO
X-Google-Smtp-Source: APXvYqxGX3H3ahlNB3L4mTj4NnodleeyB4RW3wEJOWQzIkYlsu6PDY3Ftzd91IecGK9q7ph7hBJePg==
X-Received: by 2002:a2e:88d3:: with SMTP id a19mr7591789ljk.32.1562144144770;
        Wed, 03 Jul 2019 01:55:44 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id h4sm354529ljj.31.2019.07.03.01.55.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 01:55:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v4 0/7] crypto: CAESAR final portfolio follow-up
Date:   Wed,  3 Jul 2019 10:55:05 +0200
Message-Id: <20190703085512.13915-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This v2/v3/v4 is a follow-up to both 'crypto: aegis128 - add NEON intrinsics
version for ARM/arm64' [0] and 'crypto: morus - remove generic and x86
implementations' [1]. Since there is some overlap, it makes sense to merge
them and avoid merge conflicts.

Now that aegis128 has been announced as one of the winners of the CAESAR
competition, it's time to provide some better support for it on arm64 (and
32-bit ARM *)

This time, instead of cloning the generic driver twice and rewriting half
of it in arm64 and ARM assembly, add hooks for an accelerated SIMD path to
the generic driver, and populate it with a C version using NEON intrinsics
that can be built for both ARM and arm64. This results in a speedup of ~11x,
resulting in a performance of 2.2 cycles per byte on Cortex-A53.

Patches #3 and #4 are fixes/improvements for the generic code. Patch #5
adds the plumbing for using a SIMD accelerated implementation. Patch #6
adds the ARM and arm64 code, and patch #7 adds a speed test.

Since aegis128l and aegis256 were not selected, and nor where any of the
morus contestants (which are in fact found to be cryptographically broken),
patches #1 and #2 remove these entirely.

Changes since v3:
- drop always_inline annotation from aegis_aes_round(), which triggers a
  warning on ARM
- add Ondrej's R-b to the series

Changes since v2:
- drop AEGIS128L/256 Kconfig symbols from crypto/Kconfig
- ensure that aese/aesmc are issued in pairs

Changes since v1s:
- add reference to research paper (#1)
- drop hunks against m68k defconfigs - these get regenerated automatically
  anyway, and so it is better to avoid the potential merge conflicts.
- drop patch to use unaligned accessors where it isn't needed
- drop hunks against aegis variants that are being removed (#3)
- add acks from Ondrej

* 32-bit ARM today rarely provides the special AES instruction that the
  implementation in this series relies on, but this may change in the future,
  and the NEON intrinsics code can be compiled for both ISAs.

Cc: Eric Biggers <ebiggers@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steve Capper <steve.capper@arm.com>
Cc: Milan Broz <gmazyland@gmail.com>

[0] https://lore.kernel.org/linux-crypto/20190624073818.29296-1-ard.biesheuvel@linaro.org/
[1] https://lore.kernel.org/linux-crypto/20190625145254.28510-1-ard.biesheuvel@linaro.org/

Ard Biesheuvel (7):
  crypto: morus - remove generic and x86 implementations
  crypto: aegis128l/aegis256 - remove x86 and generic implementations
  crypto: aegis128 - drop empty TFM init/exit routines
  crypto: aegis - avoid prerotated AES tables
  crypto: aegis128 - add support for SIMD acceleration
  crypto: aegis128 - provide a SIMD implementation based on NEON
    intrinsics
  crypto: tcrypt - add a speed test for AEGIS128

 arch/x86/crypto/Makefile               |   17 -
 arch/x86/crypto/aegis128l-aesni-asm.S  |  826 ------
 arch/x86/crypto/aegis128l-aesni-glue.c |  297 ---
 arch/x86/crypto/aegis256-aesni-asm.S   |  703 -----
 arch/x86/crypto/aegis256-aesni-glue.c  |  297 ---
 arch/x86/crypto/morus1280-avx2-asm.S   |  622 -----
 arch/x86/crypto/morus1280-avx2-glue.c  |   66 -
 arch/x86/crypto/morus1280-sse2-asm.S   |  896 -------
 arch/x86/crypto/morus1280-sse2-glue.c  |   65 -
 arch/x86/crypto/morus1280_glue.c       |  209 --
 arch/x86/crypto/morus640-sse2-asm.S    |  615 -----
 arch/x86/crypto/morus640-sse2-glue.c   |   65 -
 arch/x86/crypto/morus640_glue.c        |  204 --
 crypto/Kconfig                         |   89 +-
 crypto/Makefile                        |   16 +-
 crypto/aegis.h                         |   28 +-
 crypto/{aegis128.c => aegis128-core.c} |   53 +-
 crypto/aegis128-neon-inner.c           |  149 ++
 crypto/aegis128-neon.c                 |   43 +
 crypto/aegis128l.c                     |  522 ----
 crypto/aegis256.c                      |  473 ----
 crypto/morus1280.c                     |  542 ----
 crypto/morus640.c                      |  533 ----
 crypto/tcrypt.c                        |    7 +
 crypto/testmgr.c                       |   24 -
 crypto/testmgr.h                       | 2691 --------------------
 include/crypto/morus1280_glue.h        |   97 -
 include/crypto/morus640_glue.h         |   97 -
 include/crypto/morus_common.h          |   18 -
 29 files changed, 266 insertions(+), 9998 deletions(-)
 delete mode 100644 arch/x86/crypto/aegis128l-aesni-asm.S
 delete mode 100644 arch/x86/crypto/aegis128l-aesni-glue.c
 delete mode 100644 arch/x86/crypto/aegis256-aesni-asm.S
 delete mode 100644 arch/x86/crypto/aegis256-aesni-glue.c
 delete mode 100644 arch/x86/crypto/morus1280-avx2-asm.S
 delete mode 100644 arch/x86/crypto/morus1280-avx2-glue.c
 delete mode 100644 arch/x86/crypto/morus1280-sse2-asm.S
 delete mode 100644 arch/x86/crypto/morus1280-sse2-glue.c
 delete mode 100644 arch/x86/crypto/morus1280_glue.c
 delete mode 100644 arch/x86/crypto/morus640-sse2-asm.S
 delete mode 100644 arch/x86/crypto/morus640-sse2-glue.c
 delete mode 100644 arch/x86/crypto/morus640_glue.c
 rename crypto/{aegis128.c => aegis128-core.c} (89%)
 create mode 100644 crypto/aegis128-neon-inner.c
 create mode 100644 crypto/aegis128-neon.c
 delete mode 100644 crypto/aegis128l.c
 delete mode 100644 crypto/aegis256.c
 delete mode 100644 crypto/morus1280.c
 delete mode 100644 crypto/morus640.c
 delete mode 100644 include/crypto/morus1280_glue.h
 delete mode 100644 include/crypto/morus640_glue.h
 delete mode 100644 include/crypto/morus_common.h

-- 
2.17.1

