Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74DC7C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37AA520828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WYtB8DpB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfF0K1w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:27:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35044 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0K1v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:27:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so5135124wml.0
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F5gSJaWTe+cHGc+JNU9MyGloi+SK+aBYuOU9a6jHnnU=;
        b=WYtB8DpBCaw2A+rIepg2MjQaEcqq441YVFxKK1ecrF215W6TeHh7BjmRNv4Y4NW/W3
         ilBziU2QGRYHu9AnfPQzL9bHMQvm20kdRle5weZnisI8CdXz+p1lvQIODx1kGSomipnR
         sXMbuB0h0aeDFo+ORQ8EqaEMsi5PgmZbo0p5IOcz9IEHG3gNqPXvpSv7msftzKLsq89J
         cYtf4gPk4bMXx/bbAJz0y+sgMpk5r+6OwqmsJw7R2knS9STV2U+lBMPuwsQyTs8t7Rcu
         LFr3wdWzHjYvKZHGL1noEPRi/FVsh20h/aQAZ9PyhcW7uhGf5WPkjFoUQadLygLuAlVg
         /OYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F5gSJaWTe+cHGc+JNU9MyGloi+SK+aBYuOU9a6jHnnU=;
        b=mKnJg/yLsBsEMgZgbqrp3AH8K2SKCCeVEBEBmrqN0HWdImddAVMfSb8/KknC6Mn8Uv
         N5Tr3/NygIiqyh9qMYP9tffVx5Dd/wzslKo0zS47OO0iftob4Ke7HK7ELAzcH5o7Cdte
         zlK+GTBKe18Fcq/OVIAjEdRyWnCBaPJ/ZR4PyAw1YNRxWsaZdK7Z5Wn0qjtKCGDueXbN
         dnb1hklK2U+25gtxluedehb2rYZMCebsRFC+4QkqMdQH/kYtTihNlroXhbJawoAlBzzT
         r9Ji+svYl8vp9aQoK8DKfxVcV9TOz5gWyejbt7m92tUcPOyoPjKS+/kLSQH3W8yQWn7t
         eZzg==
X-Gm-Message-State: APjAAAUapR82zX2V0LeIVXhKpmOWSl7HrOHpg772girYT+DoAMvTSdGm
        ndSXgQLI95FNQPxdqW3MvyULXiJz/oQ=
X-Google-Smtp-Source: APXvYqyWcOHFuIlJYP0nT4w7JuHGXgOnKin48MSO8yfU0gdqIwUpOGiwmtmJxD2kGiEKWTTRZdt3uA==
X-Received: by 2002:a1c:9dc5:: with SMTP id g188mr2808315wme.93.1561631268732;
        Thu, 27 Jun 2019 03:27:48 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 00/32] crypto: AES cleanup
Date:   Thu, 27 Jun 2019 12:26:15 +0200
Message-Id: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
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

Changes since v2:
- fix a bug in the CTR helper function - use chunksize not blocksize of the
  skcipher as the blocksize of the CTR transformation
- add a couple of patches so all AES implementation share the forward and
  inverse Sboxes that are in the AES library.
- unexpert data structures and helpers that are not actually (or should be)
  used outside the drivers that define them

Code can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=aes-cleanup-v3

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

Ard Biesheuvel (32):
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
  crypto: aes/generic - unexport last-round AES tables
  crypto: lib/aes - export sbox and inverse sbox
  crypto: arm64/aes-neon - switch to shared AES Sboxes
  crypto: arm/aes-cipher - switch to shared AES inverse Sbox
  crypto: arm64/aes-cipher - switch to shared AES inverse Sbox
  crypto: arm/aes-scalar - unexport en/decryption routines

 arch/arm/crypto/Kconfig                        |   2 +-
 arch/arm/crypto/aes-ce-core.S                  |  20 +-
 arch/arm/crypto/aes-ce-glue.c                  | 168 +++++----
 arch/arm/crypto/aes-cipher-core.S              |  40 +--
 arch/arm/crypto/aes-cipher-glue.c              |  11 +-
 arch/arm/crypto/aes-neonbs-glue.c              |  69 +++-
 arch/arm/crypto/ghash-ce-glue.c                |  78 +++--
 arch/arm64/crypto/Kconfig                      |  10 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c            |  18 +-
 arch/arm64/crypto/aes-ce-glue.c                |   7 +-
 arch/arm64/crypto/aes-cipher-core.S            |  40 +--
 arch/arm64/crypto/aes-cipher-glue.c            |  11 +-
 arch/arm64/crypto/aes-ctr-fallback.h           |  53 ---
 arch/arm64/crypto/aes-glue.c                   |  39 ++-
 arch/arm64/crypto/aes-neon.S                   |  74 +---
 arch/arm64/crypto/aes-neonbs-glue.c            |  29 +-
 arch/arm64/crypto/ghash-ce-glue.c              |  30 +-
 arch/x86/crypto/Makefile                       |   4 -
 arch/x86/crypto/aes-i586-asm_32.S              | 362 --------------------
 arch/x86/crypto/aes-x86_64-asm_64.S            | 185 ----------
 arch/x86/crypto/aes_glue.c                     |  70 ----
 arch/x86/crypto/aesni-intel_glue.c             |  23 +-
 arch/x86/include/asm/crypto/aes.h              |  12 -
 crypto/Kconfig                                 |  52 +--
 crypto/aes_generic.c                           | 167 +--------
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
 include/crypto/aes.h                           |  41 ++-
 include/crypto/ctr.h                           |  50 +++
 lib/crypto/Makefile                            |   3 +
 lib/crypto/aes.c                               | 356 +++++++++++++++++++
 net/bluetooth/Kconfig                          |   3 +-
 net/bluetooth/smp.c                            | 103 ++----
 45 files changed, 873 insertions(+), 1736 deletions(-)
 delete mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
 delete mode 100644 arch/x86/crypto/aes-i586-asm_32.S
 delete mode 100644 arch/x86/crypto/aes-x86_64-asm_64.S
 delete mode 100644 arch/x86/crypto/aes_glue.c
 delete mode 100644 arch/x86/include/asm/crypto/aes.h
 create mode 100644 lib/crypto/aes.c

-- 
2.20.1

