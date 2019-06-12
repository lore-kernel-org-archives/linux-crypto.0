Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE99C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CB19208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ROkoE5gE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409155AbfFLMst (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:49 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45833 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406812AbfFLMst (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:49 -0400
Received: by mail-wr1-f50.google.com with SMTP id f9so16737161wre.12
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q9U7Fu4EToi9FiDSidT115AcciDNms4gDinyb0dLx7I=;
        b=ROkoE5gEqWyJuBTIwu9tdmazvpmQ6iNCXx0Q3CNGfaKzAkD0q79fzDpYyELZs0nmSR
         VPmvVHTabg6MMWfrj4LcG4lk7v49hd18lwoNHgdatq5c56mgRNCoIIOJ7AoxSAf29uFZ
         5/9iDbAY6Pd0RRF3Oqw8MS2zo5TSgG2s/mfBkJhFuQrGx1RI6x/ONoc84BvGei1GTcsp
         86ALdLhhILAvHHyHkpIr3GbW/wPRNjqLf+hB+6js893oKQd6Ulbbaf9KkozM4dLCbWD5
         kSl7UVoPks7xIb9t1S2bCnFYuRxsXpEyj0N3LYXqyRDu155s/DvQe9B+04LtYRJqZ/5r
         8ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q9U7Fu4EToi9FiDSidT115AcciDNms4gDinyb0dLx7I=;
        b=cM2ze4bXKMe40tTl0cNbfeoD86yfBr+tj/UtTeswMQ78iAFmwekClZBdZTythCiLyx
         460zPDperlmRLwXA7WXkOtdo4saz0uPdNyBEndiMLYSgBJ4S8NxrXgizOkhfEQRneP+H
         jZZTvMv90QCf2S/kwjd+umux1eBSi/jxpp9/spimAcFZz6BYQyTbXC417UArRCnf4I2F
         N2amyXohzhKc91LRb53Qm3ugztc7G1SOj/u9fd4DLpC2ueHAjw1wI/GPog/NzqF9v2lf
         /FFkmiWDc3QpSa/juO2JTU9L+ZGHqOcX+bJI76XSH0SJTNdlSyE5wVkdbs/oOkFDcqXM
         mkiw==
X-Gm-Message-State: APjAAAWJ2POwD49XGrip0wSyJKiWEjN9ihOac6S4rvvkzqAzzXTyhRa3
        biqWaaPgy3eDsSFBeonL6BqGG8NL+HGOOw==
X-Google-Smtp-Source: APXvYqy+Vz6yb4zLTuHTMs6q+iRxnywTuVlRsStW3aKppuhaPATIFeJK8IHXOKYmRBWlm7aqAJK8Lg==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr18210110wru.264.1560343726982;
        Wed, 12 Jun 2019 05:48:46 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 00/20] AES cleanup
Date:   Wed, 12 Jun 2019 14:48:18 +0200
Message-Id: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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

This is posted as an RFC since using the mostly-fixed-time C code as
library code for general use may be something that needs some discussion.

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
This is implemented in patches 17-20.

All the patches leading up to that are cleanups for the AES code, to reduce
the dependency on the generic table based AES code, or in some cases, hardcoded
dependencies on the scalar arm64 asm code which suffers from the same problem.
It also removes redundant key expansion routines, and gets rid of the x86
scalar asm code, which is a maintenance burden and is not actually faster than
the generic code built with a modern compiler.

Ard Biesheuvel (20):
  crypto: arm/aes-ce - cosmetic/whitespace cleanup
  crypto: arm/aes - rename local routines to prevent future clashes
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
  crypto: arm64/aes-ce-cipher - use AES library as fallback
  crypto: aes - move ctr(aes) non-SIMD fallback to AES library
  crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
  crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
  crypto: arm/ghash - provide a synchronous version

 arch/arm/crypto/Kconfig                        |   2 +-
 arch/arm/crypto/aes-ce-glue.c                  | 152 +++++---
 arch/arm/crypto/aes-cipher-glue.c              |   8 +-
 arch/arm/crypto/aes-neonbs-glue.c              |  62 ++-
 arch/arm/crypto/ghash-ce-glue.c                |  78 ++--
 arch/arm64/crypto/Kconfig                      |  10 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c            |  18 +-
 arch/arm64/crypto/aes-ce-glue.c                |   7 +-
 arch/arm64/crypto/aes-cipher-glue.c            |  11 +-
 arch/arm64/crypto/aes-ctr-fallback.h           |  53 ---
 arch/arm64/crypto/aes-glue.c                   |  29 +-
 arch/arm64/crypto/aes-neonbs-glue.c            |  20 +-
 arch/arm64/crypto/ghash-ce-glue.c              |  30 +-
 arch/x86/crypto/Makefile                       |   4 -
 arch/x86/crypto/aes-i586-asm_32.S              | 362 -----------------
 arch/x86/crypto/aes-x86_64-asm_64.S            | 185 ---------
 arch/x86/crypto/aes_glue.c                     |  71 ----
 arch/x86/crypto/aesni-intel_glue.c             |  15 +-
 arch/x86/include/asm/crypto/aes.h              |  12 -
 crypto/Kconfig                                 |  53 +--
 crypto/aes_generic.c                           | 161 +-------
 crypto/aes_ti.c                                | 335 +---------------
 drivers/crypto/Kconfig                         |   6 +-
 drivers/crypto/inside-secure/safexcel_cipher.c |   2 +-
 drivers/crypto/marvell/cipher.c                |   2 +-
 drivers/crypto/padlock-aes.c                   |   2 +-
 include/crypto/aes.h                           |  47 ++-
 lib/crypto/Makefile                            |   3 +
 lib/crypto/aes.c                               | 409 ++++++++++++++++++++
 29 files changed, 754 insertions(+), 1395 deletions(-)
 delete mode 100644 arch/arm64/crypto/aes-ctr-fallback.h
 delete mode 100644 arch/x86/crypto/aes-i586-asm_32.S
 delete mode 100644 arch/x86/crypto/aes-x86_64-asm_64.S
 delete mode 100644 arch/x86/crypto/aes_glue.c
 delete mode 100644 arch/x86/include/asm/crypto/aes.h
 create mode 100644 lib/crypto/aes.c

-- 
2.20.1

