Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDF8C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2616320657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jcll5BDq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfFVTem (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:42 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43435 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfFVTem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:42 -0400
Received: by mail-wr1-f51.google.com with SMTP id p13so9693637wru.10
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sF051ileh54l0aMFAbBQnpaORRhuhIyArr6dJaAH4JU=;
        b=Jcll5BDqeXjf74c8VNi1W30NYBa9HA8Lzky0ytiWF9h7a2OoW9kbyA9bCc1jeOphXg
         vM7IPq/sVSrSkj4FU4/ER/mfroRXCrU6Vs3c8Vd3cvPUbMmqpDfqW8c8vBV5ryJB5t6k
         BrbTKnSrnU9iQNsMQFbSskuTIazPRn+zFpff+h6T9Nc2Ssuplw1XFk2lb/AeCfl5txQN
         9JHvnbE1Rk+kEjL0ZRFf7LABMGVvrzVOKKuyU3cUrOXvFX018B17T32gGGwbfT0EkepH
         9Bxj7RW19WCeMI6YddT5qJ7ni44GbL2Ieg70O6lmeoMNWOCMRBlmqq+RMiz02vKBUzln
         q98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sF051ileh54l0aMFAbBQnpaORRhuhIyArr6dJaAH4JU=;
        b=bVThAEFozKFRtlHhokENoeXKLWnrw7ERETbdxZ+0NJCQKkMP5flTNnRnWQUv0v6vIv
         H0vMMgsdEUskKW59WJoSS2Aim9IxWUBknQhYaPcfA5KsqoYBWfR7JsKXcTwQSvYZWwst
         DbG+deYIPr7Af0QbIMGzbVPE1G7bQ8nyEM8ERMJm/TPQ/DcW75NKHKHroXyldoGQ78Cg
         0LDTXjNbkwvmbUDa9r8lquwaJJ0kJL/HZMdUq4SjgsQbXhW9fEP0Sep2IrqjGAWBSMnd
         5prrTuwsLidXhh6e5zAMuNvwwMc+MHtOOIr1W+Jz90aLttoFiea6dcr1Jd5/Nkdy3qAC
         PGsg==
X-Gm-Message-State: APjAAAWgJdN9rFxRwYMSSbPJkKTZe6aSCKHl4IqTiqK7+NMRrpOPpUvK
        uRhREO/UBGg1YTt8Lzr2rtcbhcaRZ2KmpzfL
X-Google-Smtp-Source: APXvYqyG6MPxC64RCjkmVVkGjTQrzZpCLIL+1o12vM/VsN8iBCqB4G1//UqM2z+1GACzDljeKWVoHA==
X-Received: by 2002:adf:afd5:: with SMTP id y21mr99772387wrd.12.1561232079294;
        Sat, 22 Jun 2019 12:34:39 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/26]crypto: AES cleanup
Date:   Sat, 22 Jun 2019 21:34:01 +0200
Message-Id: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This started out as an attempt to provide synchronous SIMD based GCM
on 32-bit ARM, but along the way, I ended up changing and cleaning up
so many things that it is more of a general AES cleanup now rather than
anything else.

Changes since v1/RFC:
- rename x86 AES-NI and padlock routines as well, in order to avoid clashes (#2)
- move irq en/disabling out of the AES library into the callers (aes-ti
  and the skcipher helper for sync ctr(aes) added in #17)
- align 32-bit ARM CE key schedule endianness with other AES drivers, to
  avoid problems on BE systems when using the synchronous ctr fallback (#18)
- replace some occurrences where a "aes" or "aes-generic" cipher was allocated
  explicitly, and use library calls instead.
- use a generic helper in crypto/ctr.h instead of adding a CTR helper to the
  AES library for providing the synchronous CTR fallback code.

Some users of the AES cipher are being switched to other algorithms (i.e.,
SipHash for TCP fastopen and CCM or cbcmac for wusb and lib80211). These
have been posted separately, since they have no build time interdependencies.

----- Original blurb below ------

On 32-bit ARM, asynchronous GCM can be provided by the following drivers:

                                              |  cycles per byte on low end Si
  gcm_base(ctr(aes-generic),ghash-generic)    |            65.3
  gcm_base(ctr-aes-neonbs,ghash-ce) [*]       |            27.7
  gcm_base(ctr-aes-ce,ghash-ce) [**]          |             3.7

  [*]  ghash-ce using vmull.p8 instructions
  [**] ghash-ce using optional vmull.p64 instructions

The third and fastest option is actually only available on 32-bit cores that
implement the v8 Crypto Extensions, which are rare, but the NEON based runner
up is obviously a huge improvement over the generic code, not only in terms of
performance, but also because it is time invariant (generic AES and generic
GHASH are both implemented using lookup tables, which are susceptible to
cache timing attacks)

However, when allocating the gcm(aes) skcipher in synchronous mode, we end up
with the generic code, due to the fact that the NEON code has no handling for
invocations that occur from a context where the NEON cannot be used, and so
it defers the processing to a kthread, which is only permitted for asynchronous
ciphers.

So let's implement this fallback handling, by reusing some of the logic that
has already been implemented for arm64. Note that these fallbacks are rarely
called in practice, but the API requires the functionality to be there.
This is implemented in patches 16-22.

All the patches leading up to that are cleanups for the AES code, to reduce
the dependency on the generic table based AES code, or in some cases, hardcoded
dependencies on the scalar arm64 asm code which suffers from the same problem.
It also removes redundant key expansion routines, and gets rid of the x86
scalar asm code, which is a maintenance burden and is not actually faster than
the generic code built with a modern compiler.

Ard Biesheuvel (26):
  crypto: arm/aes-ce - cosmetic/whitespace cleanup
  crypto: aes - rename local routines to prevent future clashes
  crypto: aes/fixed-time - align key schedule with other implementations
  crypto: aes - create AES library based on the fixed time AES code
  crypto: x86/aes-ni - switch to generic for fallback and key routines
  crypto: x86/aes - drop scalar assembler implementations
  crypto: padlock/aes - switch to library version of key expansion
    routine
  crypto: cesa/aes - switch to library version of key expansion routine
  crypto: safexcel/aes - switch to library version of key expansion
    routine
  crypto: arm64/ghash - switch to AES library
  crypto: arm/aes-neonbs - switch to library version of key expansion
    routine
  crypto: arm64/aes-ccm - switch to AES library
  crypto: arm64/aes-neonbs - switch to library version of key expansion
    routine
  crypto: arm64/aes-ce - switch to library version of key expansion
    routine
  crypto: generic/aes - drop key expansion routine in favor of library
    version
  crypto: ctr - add helper for performing a CTR encryption walk
  crypto: aes - move sync ctr(aes) to AES library and generic helper
  crypto: arm64/aes-ce-cipher - use AES library as fallback
  crypto: aes/arm - use native endiannes for key schedule
  crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
  crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
  crypto: arm/ghash - provide a synchronous version
  bluetooth: switch to AES library
  crypto: amcc/aes - switch to AES library for GCM key derivation
  crypto: ccp - move to AES library for CMAC key derivation
  crypto: chelsio/aes - replace AES cipher calls with library calls

 arch/arm/crypto/Kconfig                        |   2 +-
 arch/arm/crypto/aes-ce-core.S                  |  20 +-
 arch/arm/crypto/aes-ce-glue.c                  | 168 +++++----
 arch/arm/crypto/aes-cipher-glue.c              |   8 +-
 arch/arm/crypto/aes-neonbs-glue.c              |  69 +++-
 arch/arm/crypto/ghash-ce-glue.c                |  78 +++--
 arch/arm64/crypto/Kconfig                      |  10 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c            |  18 +-
 arch/arm64/crypto/aes-ce-glue.c                |   7 +-
 arch/arm64/crypto/aes-cipher-glue.c            |  11 +-
 arch/arm64/crypto/aes-ctr-fallback.h           |  53 ---
 arch/arm64/crypto/aes-glue.c                   |  39 ++-
 arch/arm64/crypto/aes-neonbs-glue.c            |  29 +-
 arch/arm64/crypto/ghash-ce-glue.c              |  30 +-
 arch/x86/crypto/Makefile                       |   4 -
 arch/x86/crypto/aes-i586-asm_32.S              | 362 --------------------
 arch/x86/crypto/aes-x86_64-asm_64.S            | 185 ----------
 arch/x86/crypto/aes_glue.c                     |  70 ----
 arch/x86/crypto/aesni-intel_glue.c             |  23 +-
 arch/x86/include/asm/crypto/aes.h              |  12 -
 crypto/Kconfig                                 |  52 +--
 crypto/aes_generic.c                           | 161 +--------
 crypto/aes_ti.c                                | 317 +----------------
 drivers/crypto/Kconfig                         |   8 +-
 drivers/crypto/amcc/crypto4xx_alg.c            |  24 +-
 drivers/crypto/ccp/Kconfig                     |   1 +
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c       |  25 +-
 drivers/crypto/ccp/ccp-crypto.h                |   3 -
 drivers/crypto/chelsio/Kconfig                 |   1 +
 drivers/crypto/chelsio/chcr_algo.c             |  46 +--
 drivers/crypto/chelsio/chcr_crypto.h           |   1 -
 drivers/crypto/chelsio/chcr_ipsec.c            |  19 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c        |  20 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |   2 +-
 drivers/crypto/marvell/cipher.c                |   2 +-
 drivers/crypto/padlock-aes.c                   |  10 +-
 include/crypto/aes.h                           |  36 +-
 include/crypto/ctr.h                           |  53 +++
 lib/crypto/Makefile                            |   3 +
 lib/crypto/aes.c                               | 350 +++++++++++++++++++
 net/bluetooth/Kconfig                          |   3 +-
 net/bluetooth/smp.c                            | 103 ++----
 42 files changed, 860 insertions(+), 1578 deletions(-)
 delete mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
 delete mode 100644 arch/x86/crypto/aes-i586-asm_32.S
 delete mode 100644 arch/x86/crypto/aes-x86_64-asm_64.S
 delete mode 100644 arch/x86/crypto/aes_glue.c
 delete mode 100644 arch/x86/include/asm/crypto/aes.h
 create mode 100644 lib/crypto/aes.c

-- 
2.20.1

