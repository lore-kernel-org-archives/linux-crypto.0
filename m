Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B5AC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0C142147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w6KQNL0R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfHERAz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:00:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43087 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHERAy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:00:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so10568306wru.10
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blBuI15MMY0MGa+yP7ydP9PfuIXdWhGkChiZpEAVEHI=;
        b=w6KQNL0Rea0c2paIi1nKkPs7W8jcYJz/5bggkkct1gsdxleeF97S8gBizyEyUipNkw
         UjRpapjtBHZq5h+2f2z2gZ5XuRc79xxjcOC22ILXuiPwlQnfYzKaqxeEmLWg3bP74983
         lVjN3ELcSCj1AOMyBmEfNMLEgQ8OpEpG2oBc3SJ52aBpAKw/r0ZL8TUWxP06NBYYkYnA
         FNZo8UeLtKvmN7h12J8QpY+ym+e/tYeEJ2Z2HiuIAcpFUxplJoUEZyQw67FWhzx8MKlS
         IdgPB8QblP60Zc4ObTv/wnaK1mlle94UN/4bybyJqzGd/l+ipOyiyXYtMLsZjK90M1oK
         BYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blBuI15MMY0MGa+yP7ydP9PfuIXdWhGkChiZpEAVEHI=;
        b=VRrsxhCiTf0seOig48BTCbxJXchz3/0cefPdUS+yDCJgGqGbMsCTCQKpC0LxS1t0Qj
         Dr+Jl76KhW7/kOB3ySfnLPLjhxzpkTxgGVI967XA67F57ku7pezsSAsqVhibO8CMq96k
         TL/9+sp9T50VgFdvT92vzhWfyW2XjHkuo/PcEwpohBNiECXSZkqS2lIq4LrQk0bvTzUB
         RPiUazo5AV47v+3yIqej3nYxPgREf3Jo78jxW0dH0zBmGc+E+SpwpJNUvW8dgRw1nOfI
         FK7pSpBcegW3FyacA709iNxLImuRfPDwuMeECpodm9TZxzcJINuaNXzmYc2MfymzCrrN
         eLgw==
X-Gm-Message-State: APjAAAWgMQXCncLMqS0NYYzaFDNmqE2YVvI9xJ7fJqpPqAb9zHaod801
        bJsKBjsOWcBnYEtSpcWV/jypYRhT/cF2Cg==
X-Google-Smtp-Source: APXvYqzzzxls1cGZLYjOIMp+EqnaAymkr5DqK8AH+UGFSkSZ48BKhm8FKFOGn+r8gGCkoCLHTSJtvg==
X-Received: by 2002:adf:b60c:: with SMTP id f12mr129765643wre.231.1565024451482;
        Mon, 05 Aug 2019 10:00:51 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.00.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:00:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 00/30] crypto: DES/3DES cleanup
Date:   Mon,  5 Aug 2019 20:00:07 +0300
Message-Id: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=des-cleanup-v4

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
 drivers/crypto/bcm/cipher.c                   |  82 +-
 drivers/crypto/caam/Kconfig                   |   2 +-
 drivers/crypto/caam/caamalg.c                 |  38 +-
 drivers/crypto/caam/caamalg_qi.c              |  13 +-
 drivers/crypto/caam/caamalg_qi2.c             |  13 +-
 drivers/crypto/caam/compat.h                  |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  26 +-
 drivers/crypto/cavium/nitrox/Kconfig          |   2 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |   4 +-
 drivers/crypto/ccp/ccp-crypto-des3.c          |   7 +-
 drivers/crypto/ccree/cc_aead.c                |  13 +-
 drivers/crypto/ccree/cc_cipher.c              |  15 +-
 drivers/crypto/hifn_795x.c                    |  29 +-
 drivers/crypto/hisilicon/sec/sec_algs.c       |  18 +-
 .../crypto/inside-secure/safexcel_cipher.c    |  29 +-
 drivers/crypto/ixp4xx_crypto.c                |  28 +-
 drivers/crypto/marvell/cipher.c               |  22 +-
 drivers/crypto/n2_core.c                      |  26 +-
 drivers/crypto/omap-des.c                     |  25 +-
 drivers/crypto/picoxcell_crypto.c             |  21 +-
 drivers/crypto/qce/ablkcipher.c               |  55 +-
 drivers/crypto/rockchip/rk3288_crypto.h       |   2 +-
 .../rockchip/rk3288_crypto_ablkcipher.c       |  21 +-
 drivers/crypto/stm32/Kconfig                  |   2 +-
 drivers/crypto/stm32/stm32-cryp.c             |  30 +-
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c     |  26 +-
 drivers/crypto/sunxi-ss/sun4i-ss.h            |   2 +-
 drivers/crypto/talitos.c                      |  34 +-
 drivers/crypto/ux500/Kconfig                  |   2 +-
 drivers/crypto/ux500/cryp/cryp_core.c         |  31 +-
 fs/cifs/Kconfig                               |   2 +-
 fs/cifs/cifsfs.c                              |   1 -
 fs/cifs/smbencrypt.c                          |  18 +-
 include/crypto/des.h                          |  77 +-
 include/crypto/internal/des.h                 | 106 ++
 lib/crypto/Makefile                           |   3 +
 lib/crypto/des.c                              | 902 +++++++++++++++++
 44 files changed, 1357 insertions(+), 1481 deletions(-)
 create mode 100644 include/crypto/internal/des.h
 create mode 100644 lib/crypto/des.c

-- 
2.17.1

