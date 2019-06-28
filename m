Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A042C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616372083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="btIq2Ioj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfF1RII (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47078 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1RII (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so7007912wrw.13
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YTUrkACJ1JTeKJYaOxyEoZUtEdmnGivkR/StiBTRGBU=;
        b=btIq2IojuynuCZ7QA0LVvSMkG8bIFcCxeYipN2zRX8IZNXAQtPurWyI5eXiT9jkSEa
         lSAhtTogvr+Yla/XVG4FxxWazuMWluWuVtZ3F1iQVoLsseL5txI9YS3gALLAr6WINghI
         XiLPZrel1+7hFFMqS8bTGuseWKIVFBUQbvvhHzQEyksiEY/Hvej2pdxZNDytPVrV/YGT
         bPc1Lf6GwE+PYDO5HveeM2e4+wJU+5cG4oO0j1rebKpk48eqvCUyv22ZnonvTiQ1qbph
         Yqhtd5gDRj1EsF9FVmWDX2ohKv0VevUzLMxTzKFoiJtsqqZUJdWI5cMcpuKBJRxFObQ6
         qj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YTUrkACJ1JTeKJYaOxyEoZUtEdmnGivkR/StiBTRGBU=;
        b=UZXcUpespWEYEgLqR5Y/O1gW0jJo/y0mn+Bi1w9uWzGs5gCwgP5UcRv47XtZu3SO73
         yOOSoaKUvelPdI2JamxCbNt/Jdira/H01UBTFz04zTsf0Mrolq4rkLXtLMce50Pfzks/
         kRDn53M/rbKQv6pBjzfGSqAvVvulqIN1WaPgBQ84vw/lUjRYnimNflcmBUuNz9gLZgPS
         FnwVCm9l9d4WxyhCmNKs4GT4dX1j80LvvUSlLHI5OuNKrDlYeALxPZZsF+fXHDWY0f+3
         E+k7jbgQgF1kCYdXO4rxfccWLsCM87HtPBOtbzq1JuH15pA8N3NfD39yU4hhy4GNplof
         YJkA==
X-Gm-Message-State: APjAAAUz2SjSGCY0RFmv+Y833Yl7CK0MXppj7xQoWKTWZvQFJ8pHGLZU
        L+tKBXfbF6A+/xHA2MeXfG/vwWExAFVq4A==
X-Google-Smtp-Source: APXvYqz/O7NT/XNJIkA6tkjxesaHC5VTi6TG4w3naD+MN9tWEKaXXgFsK4L5Y0YlzYE7YkNzL67QMg==
X-Received: by 2002:adf:9003:: with SMTP id h3mr9197208wrh.172.1561741685453;
        Fri, 28 Jun 2019 10:08:05 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:04 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 0/7] crypto: CAESAR final portfolio follow-up
Date:   Fri, 28 Jun 2019 19:07:39 +0200
Message-Id: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This v2 is a follow-up to both 'crypto: aegis128 - add NEON intrinsics
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
 crypto/Kconfig                         |   61 +-
 crypto/Makefile                        |   16 +-
 crypto/aegis.h                         |   28 +-
 crypto/{aegis128.c => aegis128-core.c} |   53 +-
 crypto/aegis128-neon-inner.c           |  132 +
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
 29 files changed, 250 insertions(+), 9969 deletions(-)
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
2.20.1

