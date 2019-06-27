Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1D1C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18D7F20656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YpAKtMXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0MD3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52374 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0MD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so5466971wms.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RxWwRwdTQHpBnHUDpfQqprlLsKpWymt2PpPd392LT70=;
        b=YpAKtMXOkTYNW0lsGL/TMbV63BlGvYN1+1kiMCuM8LDuDgPZ/j//pjTlm+s23LQL/o
         tFrNPG8veiWwU8lPK/Bk42UV/lHhiODxCT94iDjC/j3s5guw4vYgZvU9ClJAePDYeReB
         rkEXiUm3HxRtWKjdMSFz9cZlFam/kS+V3HxAF+NSRSvKJ1zv5b7LucJvAcrWqFx+VSw6
         jOE0u1gnfS5vk8ErgNgV1m/fOISVWQBj8TLsLHkkazsKrh2lSVKrliOEzjkQv0WwJX1J
         pOXwRf/MfDjTKEUEBkIBgmZZecD1h0/ExXvzRO3AF9tcDXAOC0nU9RLYCYVqz73yg6t/
         AmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RxWwRwdTQHpBnHUDpfQqprlLsKpWymt2PpPd392LT70=;
        b=ZjBSn8pX8rizWVZhwNBsjM1yVxR2SkWKwLgyb1gRSDBI8RJaxhWV+3VjZ8E7CH8hBV
         4nCd/VxZqSerICEFK1+BsxTh2ouYbVTeDiP0OsYTNsicGImBN9COXL4Ck+eJ/15PwjdY
         tXoq6mBVV0sL0jR47ruOHd9cFYz8IE9XYgwDURORgR2uWSX64ALwQIAM0dNfqI5yTTKo
         OdBvGatECU1WaierwtKhh/AfofGCrQ2s5e7BB7H7JM+VEI0x9H1xRD7MqvilJp3NMnZV
         a+0AshdlwyC38r245oHP/nFE/nZE5UkaGKbLUmO42fKte132EQNUsNp8Knh4PRNctluH
         aj3Q==
X-Gm-Message-State: APjAAAVPWEwqu3gV5EXj73Q0bYQ8sZmnFphQlXA7ASGEE+1qHkPoo5gJ
        6wBajGqimhuTGTSlRvoWDwDVeoVN5cvK8A==
X-Google-Smtp-Source: APXvYqzCo6TBWn1KvheBPUSjPooGHjjwCOktxjfvNQJ67LiDPkyUsqEtPWpSF+6qQbOtd0a92gVTIA==
X-Received: by 2002:a1c:5f56:: with SMTP id t83mr2800385wmb.37.1561637005697;
        Thu, 27 Jun 2019 05:03:25 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:24 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 00/30] crypto: DES/3DES cleanup
Date:   Thu, 27 Jun 2019 14:02:44 +0200
Message-Id: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

n my effort to remove crypto_alloc_cipher() invocations from non-crypto
code, i ran into a DES call in the CIFS driver. This is addressed in
patch #30.

The other patches are cleanups for the quirky DES interface, and lots
of duplication of the weak key checks etc.

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

 arch/s390/crypto/des_s390.c                        |  23 +-
 arch/sparc/crypto/des_glue.c                       |  35 +-
 arch/x86/crypto/des3_ede_glue.c                    |  38 +-
 crypto/Kconfig                                     |   8 +-
 crypto/des_generic.c                               | 945 +-------------------
 drivers/crypto/Kconfig                             |  28 +-
 drivers/crypto/atmel-tdes.c                        |  28 +-
 drivers/crypto/bcm/cipher.c                        |  82 +-
 drivers/crypto/caam/Kconfig                        |   2 +-
 drivers/crypto/caam/caamalg.c                      |  39 +-
 drivers/crypto/caam/caamalg_qi.c                   |  17 +-
 drivers/crypto/caam/caamalg_qi2.c                  |  17 +-
 drivers/crypto/caam/compat.h                       |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             |  16 +-
 drivers/crypto/cavium/nitrox/Kconfig               |   2 +-
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |  11 +-
 drivers/crypto/ccp/ccp-crypto-des3.c               |   5 +-
 drivers/crypto/ccree/cc_aead.c                     |  10 +-
 drivers/crypto/ccree/cc_cipher.c                   |  15 +-
 drivers/crypto/hifn_795x.c                         |  30 +-
 drivers/crypto/hisilicon/sec/sec_algs.c            |  34 +-
 drivers/crypto/inside-secure/safexcel_cipher.c     |  18 +-
 drivers/crypto/ixp4xx_crypto.c                     |  21 +-
 drivers/crypto/marvell/cipher.c                    |  20 +-
 drivers/crypto/n2_core.c                           |  26 +-
 drivers/crypto/omap-des.c                          |  25 +-
 drivers/crypto/picoxcell_crypto.c                  |  21 +-
 drivers/crypto/qce/ablkcipher.c                    |  55 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   2 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c |  21 +-
 drivers/crypto/stm32/Kconfig                       |   2 +-
 drivers/crypto/stm32/stm32-cryp.c                  |  24 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c          |  22 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h                 |   2 +-
 drivers/crypto/talitos.c                           |  28 +-
 drivers/crypto/ux500/Kconfig                       |   2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |  31 +-
 fs/cifs/Kconfig                                    |   2 +-
 fs/cifs/cifsfs.c                                   |   1 -
 fs/cifs/smbencrypt.c                               |  18 +-
 include/crypto/des.h                               |  77 +-
 include/crypto/internal/des.h                      | 103 +++
 lib/crypto/Makefile                                |   3 +
 lib/crypto/des.c                                   | 902 +++++++++++++++++++
 44 files changed, 1390 insertions(+), 1423 deletions(-)
 create mode 100644 include/crypto/internal/des.h
 create mode 100644 lib/crypto/des.c

-- 
2.20.1

