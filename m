Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE337C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96BFC21881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wg1xwPEU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfICQno (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44508 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so6089273pfn.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Xrbhv/sSGjGF3D/o14uNfHtjbfk8IOEqr2rv0xU8tc8=;
        b=Wg1xwPEUBt/yYcal44/DhHmaOzlTgud9utBeCMGz70/hJcfBas4YwzEf3hntKVAMYS
         leXs5A/leol6OUnzBiAJml6BroLq3g3/KXLwfqbe8nVHDEa///YQrAVIS04E1REGuWwL
         M926mJZaewg7qs6si1oY2O1P1nPd/Ho6EpuDUV5UU6mkI64A/3gS4JmZ0RAVvESVzPan
         BiRTUd8g70QN1qNcTBxMlOrP0BOlIpamzrT7tVpZFPPXP5xPu/z9lrPrFJoQtU9yutul
         h3lKnI+pU9FqdLIzfeYNExQ/euNVFaxCni2ZElVnDIh2ZK9rE3AqPDZZVm3DlGTfMuqx
         NPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Xrbhv/sSGjGF3D/o14uNfHtjbfk8IOEqr2rv0xU8tc8=;
        b=iEyKqd1xo24+7n20poz8fxQdjVwuwK5LgDN7WsN7j5sIJYOrYv4eL699j4fwgtVr3I
         3xwjDyuROWzYOoLg2cbMcn7LXIM9zTq7J5kBpuLYm2tmNjvfmUSWILJC+eHZhCp5wR7G
         frMjfdur804/nctd7LMFeuMblSStAhGUva2hxQ0DdtCA9wz36j0dYIn1lxYzi1Cno8F6
         i+9OBOACjFQ9VJ3GSG12SgwjbMosNplixL4N46a2kGhFuhf7QKbOQ0DbzZyfHkPvBPHg
         1xSBwimpai71wweonehkDImrcbh5T3hX6T+3M9R0AHEZOQGExsfBpIGLaWHvh0YX5bJs
         RfJA==
X-Gm-Message-State: APjAAAWXAFu8io6Ds8Bl1mEZieM0r7mc+GLzbKUqTgL4a/vep1+JK4pu
        5YPX4g03+RxaUuQrIGPVKY+R+fyJDvqcNIWp
X-Google-Smtp-Source: APXvYqze0AL/6gnkc+OqEIm9pRaeKbhQZ0k10EedlVkyUqq3/eo7FZdFBMQO2ZPiY0fpRDeVyLizkg==
X-Received: by 2002:a63:10a:: with SMTP id 10mr31511303pgb.281.1567529022646;
        Tue, 03 Sep 2019 09:43:42 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/17] crypto: arm/aes - XTS ciphertext stealing and other updates
Date:   Tue,  3 Sep 2019 09:43:22 -0700
Message-Id: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a collection of improvements for the ARM and arm64 implementations
of the AES based skciphers.

NOTES:
- the last two patches add XTS ciphertext stealing test vectors and should
  NOT be merged until all AES-XTS implementations have been confirmed to work
- tested for correctness [on both QEMU and actual hardware (via kernelci)] but
  not for performance regressions

The most important part of this series is the implementation of ciphertext
stealing support for the XTS skciphers. The CE and NEON bit slicing based
code for both ARM and arm64 is updated to handle inputs of any length >= the
XTS block size of 16 bytes.

It also updates the arm64 CTS/CBC implementation not to use a request ctx
structure, and ports the resulting implementation to ARM as well.

The remaining patches are cleanups and minor improvements in the 'ongoing
maintenance' category. None of these are -stable candidates AFAICT.

Changes since v1:
- simply skcipher_walk_abort() - pass -ECANCELED instead of walk->nbytes into
  skcipher_walk_done() so that the latter does not require any changes (#8)
- rebased onto cryptodev/master


Ard Biesheuvel (16):
  crypto: arm/aes - fix round key prototypes
  crypto: arm/aes-ce - yield the SIMD unit between scatterwalk steps
  crypto: arm/aes-ce - switch to 4x interleave
  crypto: arm/aes-ce - replace tweak mask literal with composition
  crypto: arm/aes-neonbs - replace tweak mask literal with composition
  crypto: arm64/aes-neonbs - replace tweak mask literal with composition
  crypto: arm64/aes-neon - limit exposed routines if faster driver is
    enabled
  crypto: skcipher - add the ability to abort a skcipher walk
  crypto: arm64/aes-cts-cbc-ce - performance tweak
  crypto: arm64/aes-cts-cbc - move request context data to the stack
  crypto: arm64/aes - implement support for XTS ciphertext stealing
  crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS
  crypto: arm/aes-ce - implement ciphertext stealing for XTS
  crypto: arm/aes-neonbs - implement ciphertext stealing for XTS
  crypto: arm/aes-ce - implement ciphertext stealing for CBC
  crypto: testmgr - add test vectors for XTS ciphertext stealing

Pascal van Leeuwen (1):
  crypto: testmgr - Add additional AES-XTS vectors for covering CTS

 arch/arm/crypto/aes-ce-core.S       | 462 ++++++++++++++------
 arch/arm/crypto/aes-ce-glue.c       | 377 +++++++++++++---
 arch/arm/crypto/aes-neonbs-core.S   |  24 +-
 arch/arm/crypto/aes-neonbs-glue.c   |  91 +++-
 arch/arm64/crypto/aes-ce.S          |   3 +
 arch/arm64/crypto/aes-glue.c        | 299 ++++++++-----
 arch/arm64/crypto/aes-modes.S       | 107 ++++-
 arch/arm64/crypto/aes-neon.S        |   5 +
 arch/arm64/crypto/aes-neonbs-core.S |   9 +-
 arch/arm64/crypto/aes-neonbs-glue.c | 111 ++++-
 crypto/testmgr.h                    | 368 ++++++++++++++++
 include/crypto/internal/skcipher.h  |   5 +
 12 files changed, 1495 insertions(+), 366 deletions(-)

-- 
2.17.1

