Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B89C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86C7E2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BFVsY8QO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfFVAbr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50923 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAbr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id c66so7735484wmf.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z/SNY01K+Dib4uXimvvBpQRRvasHSP+w79EhbaEwgw0=;
        b=BFVsY8QObMVbuHKfeIBKiQnWBMIPb1d9bQnoZPgXpjFK6tBPGdHQ3q8F31uZX/07IO
         /i2VFUFdTQ/AwpJj/I83VOrs5f6XtnFASDjrpHb3hcoe6EsK8rGoUCLCIUQ/+6UYQBBc
         sMQnyvbjULOuRt4cSviMT1FAz2nq38Rb3J9ypt+qer4XkNvMqzLovOlJ0O0OchziHyk9
         yvPagtWRnpiojJpHJpifLPYW4eisBRrH8/3rI+oGBYd+o3hmni9PbqT7zlaPIcv+LVsI
         ElCFkwTqS2kuYSx6blo+rivesQ8KhGexbuaGeZGMA33JQDAG3LWHYML7Nqx7PKU4bgrL
         cfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z/SNY01K+Dib4uXimvvBpQRRvasHSP+w79EhbaEwgw0=;
        b=lRSF3eDfJ46AvuVWSAh4UfSpOwxogDDNbPlJ+qnEYUIGFh0JwCgCjgt+aRuXFp2Poc
         VALdoj+e20EWkCd9K0we4RT0s1LvpE3A0J3FVFVscLtOt7sKD8y1MJ7RDSypdHF6YhdS
         5a6tkVZZd/ZdrZNXeehHb1mh8j5T2zIPBHp02UcEY1n6sr41BIqTn9RpoO0T6mAaCpoE
         OzqIFBi47U17jktGNcLKOYYS0vTR2KzQ4QmTkXIVCrd0NJExVnKeHnJmJQa2XRNkAq+o
         s1/10TsH5JoXPv82GHjuC7N3M8ro411ITKUkVlBud7kJZxG1E6NGgrPqzN0IdIh7IIIl
         8Akw==
X-Gm-Message-State: APjAAAVh0mk0sF0yziczaS4OcvzFjrNBJ69Z2vZuLzAYkr/zt0/PYbIS
        dp1/pvHOIc77BcC3Fg0giUaal5aO2igDzSrQ
X-Google-Smtp-Source: APXvYqxxuYReyHzt52SllncRwqHPZUZSXZ6kIPTM2jpiBXgAlmCd+RBFcwKe8rYw6QiiTIHZrOCKOw==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr5580019wme.104.1561163504031;
        Fri, 21 Jun 2019 17:31:44 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 00/30] crypto: DES/3DES cleanup
Date:   Sat, 22 Jun 2019 02:30:42 +0200
Message-Id: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In my effort to remove crypto_alloc_cipher() invocations from non-crypto
code, i ran into a DES call in the CIFS driver. This is addressed in
patch #30.

The other patches are cleanups for the quirky DES interface, and lots
of duplication of the weak key checks etc.

Patch #1 adds new helpers to verify DES keys to crypto/internal.des.h

The next 23 patches move all existing users of DES routines to the
new interface.

Patch #25 and #26 are preparatory patches for the new DES library
introduced in patch #27, which replaces the various DES related
functions exported to other drivers with a sane library interface.

Patch #28 switches the x86 asm code to the new librar interface.

Patch #29 removes code that is no longer used at this point.

Ard Biesheuvel (30):
  crypto: des/3des_ede - add new helpers to verify key length
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

 arch/s390/crypto/des_s390.c                        |  15 +-
 arch/sparc/crypto/des_glue.c                       |  18 +-
 arch/x86/crypto/des3_ede_glue.c                    |  35 +-
 crypto/Kconfig                                     |   8 +-
 crypto/des_generic.c                               | 943 +-------------------
 drivers/crypto/Kconfig                             |  28 +-
 drivers/crypto/atmel-tdes.c                        |  29 +-
 drivers/crypto/bcm/cipher.c                        |  82 +-
 drivers/crypto/caam/Kconfig                        |   2 +-
 drivers/crypto/caam/caamalg.c                      |  44 +-
 drivers/crypto/caam/caamalg_qi.c                   |  23 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  23 +-
 drivers/crypto/caam/compat.h                       |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  18 +-
 drivers/crypto/cavium/nitrox/Kconfig               |   2 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |  12 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |   6 +-
 drivers/crypto/ccree/cc_aead.c                     |  15 +-
 drivers/crypto/ccree/cc_cipher.c                   |  12 +-
 drivers/crypto/hifn_795x.c                         |  30 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  34 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  18 +-
 drivers/crypto/ixp4xx_crypto.c                     |  22 +-
 drivers/crypto/marvell/cipher.c                    |  20 +-
 drivers/crypto/n2_core.c                           |  26 +-
 drivers/crypto/omap-des.c                          |  26 +-
 drivers/crypto/picoxcell_crypto.c                  |  23 +-
 drivers/crypto/qce/ablkcipher.c                    |  23 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  20 +-
 drivers/crypto/stm32/Kconfig                       |   2 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  25 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  22 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |   2 +-
 drivers/crypto/talitos.c                           |  33 +-
 drivers/crypto/ux500/Kconfig                       |   2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |  32 +-
 fs/cifs/Kconfig                                    |   2 +-
 fs/cifs/smbencrypt.c                               |  18 +-
 include/crypto/des.h                               |  56 +-
 include/crypto/internal/des.h                      |  90 ++
 lib/crypto/Makefile                                |   3 +
 lib/crypto/des.c                                   | 897 +++++++++++++++++++
 43 files changed, 1333 insertions(+), 1412 deletions(-)
 create mode 100644 include/crypto/internal/des.h
 create mode 100644 lib/crypto/des.c

-- 
2.20.1

