Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC2AC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7BD8218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S95cqR8w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbfHOJB2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:28 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51658 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730774AbfHOJB1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so681466wma.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6Nq5eQ5KYsCw1zNMH/nsEna8+Y+4hdjch74qamlDtT8=;
        b=S95cqR8wts5t76/xwOliY0ksOhivrDAbQlgMk1HXYr3fM+s93iDSEEtc0HR9XAVmY5
         clymcppjpuKUdDabRfAlcgufM8wjN9wkfj1jndzxXQwXz5BKg2hErbqbsO+Bs1f8nZ8C
         1+ERnzeQJyqWYa/t714I2W6FcMuW5vwG4m04KdEjfZA1n2qIidl5Dzqh5XRDGnntibg7
         jL+v0DoDV2imAlSy1sHtUhyawY/rEZ26D0TZjIRiFX7FbDrOmW/DXIarhwto5qCXgzLY
         H4VgPs/arRAN7XxnJtcY6T2gXV3ijhFeZGDXkuVh/K+QWgFhBZsprphQT7ylEgRem7XS
         bZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Nq5eQ5KYsCw1zNMH/nsEna8+Y+4hdjch74qamlDtT8=;
        b=SfHUxI46BkodQFltWvXscgDi4k9U8hli/Cyo1t9BxqMMSlGUk2QoMu5xvKc4ZsA9qT
         nx5QhNTwCybiWrlOnAre+tufZgTQZ4kFQNNNz733I5SdpulrtHIAx7Ht+uA7hJmDY6SA
         KGSqk96AIfbaSRhLhWvYP+rU55db0TH1v9IcGvoT7KrN6r83YVyd5p161w5LwPGdjPlq
         MCSbzAYK1rGn/D9OLZDiGxib7fp6dHHBj2Rqhu9XUPtold89sDo5fGX0/iFftoCyAyM2
         K88tYtMxw5q+rdTy6fo+Q1nNu8/SgPol1bowUJeGXY0XJDxQh6xLMd60cvLToCtI+7UE
         0BDA==
X-Gm-Message-State: APjAAAV6cWLy5tyYBPnc9j3jzXS+wm7FOklgIMariPaaw5fCLZH00zrw
        DInCgEy06ldZIev6O686PBbazGbSBcuLeQOD
X-Google-Smtp-Source: APXvYqyJvhojmjraIAtqdpWktR8ob/QpUlsFnYzjTrl7U8wKx93okANKZ9LcNpfGnk1Om3E83CBLxA==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr1604960wmj.133.1565859684485;
        Thu, 15 Aug 2019 02:01:24 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:23 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 00/30] crypto: DES/3DES cleanup
Date:   Thu, 15 Aug 2019 12:00:42 +0300
Message-Id: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In my effort to remove crypto_alloc_cipher() invocations from non-crypto
code, i ran into a DES call in the CIFS driver. This is addressed in
patch #30.

The other patches are cleanups for the quirky DES interface, and lots
of duplication of the weak key checks etc.

Changes since v4:
- Use dedicated inline key verification helpers for skcipher, ablkcipher and
  aead type transforms, as requested by Herbert
- Rebase onto cryptodev/master, and fix up the resulting fallout
- Drop tested-by tags due to code changes
- Rename local s390 routines as requested by Harald (and added his R-b)

Changes since v3:
- rebase onto today's cryptodev/master
- update safexcel patch to address code that has been added in the mean time
- replace memzero_explicit() calls with memset() if they don't operate on
  stack buffers
- add T-b's from Horia and Corentin

Changes since v2:
- fixed another couple of build errors that I missed, apologies to the
  reviewers for failing to spot these
- use/retain a simplified 'return verify() ?: setkey()' pattern where possible
  (as suggested by Horia)
- ensure that the setkey() routines using the helpers return -EINVAL on weak
  keys when disallowed by the tfm's weak key policy
- remove many pointless unlikely() annotations on ice-cold setkey() paths

Changes since v1/RFC:
- fix build errors in various drivers that i failed to catch in my
  initial testing
- put all caam changes into the correct patch
- fix weak key handling error flagged by the self tests, as reported
  by Eric.
- add ack from Harald to patch #2

The KASAN error reported by Eric failed to reproduce for me, so I
didn't include a fix for that. Please check if it still reproduces for
you.

Patch #1 adds new helpers to verify DES keys to crypto/internal.des.h

The next 23 patches move all existing users of DES routines to the
new interface.

Patch #25 and #26 are preparatory patches for the new DES library
introduced in patch #27, which replaces the various DES related
functions exported to other drivers with a sane library interface.

Patch #28 switches the x86 asm code to the new librar interface.

Patch #29 removes code that is no longer used at this point.

Code can be found here:
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=des-cleanup-v5

Ard Biesheuvel (30):
  crypto: des/3des_ede - add new helpers to verify keys
  crypto: s390/des - switch to new verification routines
  crypto: sparc/des - switch to new verification routines
  crypto: atmel/des - switch to new verification routines
  crypto: bcm/des - switch to new verification routines
  crypto: caam/des - switch to new verification routines
  crypto: cpt/des - switch to new verification routines
  crypto: nitrox/des - switch to new verification routines
  crypto: ccp/des - switch to new verification routines
  crypto: ccree/des - switch to new verification routines
  crypto: hifn/des - switch to new verification routines
  crypto: hisilicon/des - switch to new verification routines
  crypto: safexcel/des - switch to new verification routines
  crypto: ixp4xx/des - switch to new verification routines
  crypto: cesa/des - switch to new verification routines
  crypto: n2/des - switch to new verification routines
  crypto: omap/des - switch to new verification routines
  crypto: picoxcell/des - switch to new verification routines
  crypto: qce/des - switch to new verification routines
  crypto: rk3288/des - switch to new verification routines
  crypto: stm32/des - switch to new verification routines
  crypto: sun4i/des - switch to new verification routines
  crypto: talitos/des - switch to new verification routines
  crypto: ux500/des - switch to new verification routines
  crypto: 3des - move verification out of exported routine
  crypto: des - remove unused function
  crypto: des - split off DES library from generic DES cipher driver
  crypto: x86/des - switch to library interface
  crypto: des - remove now unused __des3_ede_setkey()
  fs: cifs: move from the crypto cipher API to the new DES library
    interface

 arch/s390/crypto/des_s390.c                   |  25 +-
 arch/sparc/crypto/des_glue.c                  |  37 +-
 arch/x86/crypto/des3_ede_glue.c               |  38 +-
 crypto/Kconfig                                |   8 +-
 crypto/des_generic.c                          | 945 +-----------------
 drivers/crypto/Kconfig                        |  28 +-
 drivers/crypto/atmel-tdes.c                   |  28 +-
 drivers/crypto/bcm/cipher.c                   |  79 +-
 drivers/crypto/caam/Kconfig                   |   2 +-
 drivers/crypto/caam/caamalg.c                 |  49 +-
 drivers/crypto/caam/caamalg_qi.c              |  36 +-
 drivers/crypto/caam/caamalg_qi2.c             |  36 +-
 drivers/crypto/caam/compat.h                  |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  26 +-
 drivers/crypto/cavium/nitrox/Kconfig          |   2 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |   4 +-
 drivers/crypto/ccp/ccp-crypto-des3.c          |   7 +-
 drivers/crypto/ccree/cc_aead.c                |  24 +-
 drivers/crypto/ccree/cc_cipher.c              |  15 +-
 drivers/crypto/hifn_795x.c                    |  32 +-
 drivers/crypto/hisilicon/sec/sec_algs.c       |  18 +-
 .../crypto/inside-secure/safexcel_cipher.c    |  26 +-
 drivers/crypto/ixp4xx_crypto.c                |  27 +-
 drivers/crypto/marvell/cipher.c               |  25 +-
 drivers/crypto/n2_core.c                      |  32 +-
 drivers/crypto/omap-des.c                     |  27 +-
 drivers/crypto/picoxcell_crypto.c             |  24 +-
 drivers/crypto/qce/ablkcipher.c               |  55 +-
 drivers/crypto/rockchip/rk3288_crypto.h       |   2 +-
 .../rockchip/rk3288_crypto_ablkcipher.c       |  21 +-
 drivers/crypto/stm32/Kconfig                  |   2 +-
 drivers/crypto/stm32/stm32-cryp.c             |  30 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c     |  26 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h            |   2 +-
 drivers/crypto/talitos.c                      |  37 +-
 drivers/crypto/ux500/Kconfig                  |   2 +-
 drivers/crypto/ux500/cryp/cryp_core.c         |  31 +-
 fs/cifs/Kconfig                               |   2 +-
 fs/cifs/cifsfs.c                              |   1 -
 fs/cifs/smbencrypt.c                          |  18 +-
 include/crypto/des.h                          |  77 +-
 include/crypto/internal/des.h                 | 152 +++
 lib/crypto/Makefile                           |   3 +
 lib/crypto/des.c                              | 902 +++++++++++++++++
 44 files changed, 1415 insertions(+), 1550 deletions(-)
 create mode 100644 include/crypto/internal/des.h
 create mode 100644 lib/crypto/des.c

-- 
2.17.1

