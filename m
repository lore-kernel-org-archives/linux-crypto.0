Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF86ECE587
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A91D2084B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 12:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kyVXH2fC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfJNMTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:19:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55887 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfJNMTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 08:19:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so17013939wma.5
        for <linux-crypto@vger.kernel.org>; Mon, 14 Oct 2019 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUyn6zjh6Xqdpf9taLeqUappHYvg4kIVAoZYT0lQFl8=;
        b=kyVXH2fCO5ekUqRJUZ6N9lLM4+cZai5N+ix8JipblthEivAEOZ00/eWvHfb0CbFFdM
         tb3tRAqM60GdU58DS1Xg0fuW4ymx2tyFVsSuM8KMgAxt/hhTGKDU+kkU6v8RVcqRiiU3
         yYM4Eim2yVIhvJ5EiuqmQMHeWb+TxAkenXqVJK0IDqt1CAEn4RBaB93xbnr+yj2oKVFj
         uJbyUX17EtllxxhPEMIcWu4sUaqOGitHcAzHwoFOXxquNHDr9U0LnLwmtoYP6n5kN3Op
         gQQxw7sOIs0hv8/fs3hl7Luq17JJxO+1gXhoQw6CtIvPpPeuTKrUL3+Xa+nd9dyC3eO3
         ts9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUyn6zjh6Xqdpf9taLeqUappHYvg4kIVAoZYT0lQFl8=;
        b=djb0ke//tlDatf1u+pA9J+ufeCaLIAIpqycwLIf5j4pykGN2K9xgHFONw111p2QRMk
         mrstm0hQNqeKRPj8EduuGLbQ8VVyuSPswD/rJPm5IhAY9Ygt474jH8G+sTGpsKf8kKeH
         UnZk6Fluh4jgu/2MWEcbUuZU7SWZGffNijZqYdXz/XrypS/VY72WTmtnB1aVaQxKXEBs
         ORfsFYFDXuWKm2zzjKfjJOxrY0tPhyXvHN3DdDBnRCcH6Dxo/f1x8TgCuKH+jAhfKLX0
         HcmTH+uLb2/+3xvJqCtzZDq4zdFMvnGX4rYrAyXQzpsrGTkFhaiwdB+Tvpz1S7wM+Ap/
         6LIw==
X-Gm-Message-State: APjAAAUmo7joDZJjUhcEuDht1QJ8gX7Dr3XeKHttIWrtIdh0PnihtE+w
        yNm+QC3GAyi5kifjYmOLPiiBdSTDucsXLg==
X-Google-Smtp-Source: APXvYqyfXx2pfaQ6thJnzfvHgdHIMj+8IIlg1HK0CAzPY/fQA5wHodw2KYV3h5W5ZMVlDdY58ySmfA==
X-Received: by 2002:a7b:caa9:: with SMTP id r9mr14433069wml.58.1571055577120;
        Mon, 14 Oct 2019 05:19:37 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id i1sm20222470wmb.19.2019.10.14.05.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 05:19:36 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 00/25] crypto: convert h/w accelerator driver to skcipher API
Date:   Mon, 14 Oct 2019 14:18:45 +0200
Message-Id: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series converts all drivers for h/w accelerators that produce the
ablkcipher API to the skcipher API, so that we can finally retire the
long deprecated blkcipher code.

Patches #1, #2 are fixes for the virtio driver, which need to be applied
first so that they can be backported

Patches #3 and #4 have been tested on actual 'hardware' (given the virtual
nature of the virtio driver). Patch #7 was tested successfully in kernelci.

All other patches have been build tested *only*, and should be tested on
actual hardware before being merged.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com> 
Cc: linux-arm-kernel@lists.infradead.org

Ard Biesheuvel (25):
  crypto: virtio - implement missing support for output IVs
  crypto: virtio - deal with unsupported input sizes
  crypto: virtio - switch to skcipher API
  crypto: ccp - switch from ablkcipher to skcipher
  crypto: omap - switch to skcipher API
  crypto: ux500 - switch to skcipher API
  crypto: s5p - switch to skcipher API
  crypto: atmel-aes - switch to skcipher API
  crypto: atmel-tdes - switch to skcipher API
  crypto: bcm-spu - switch to skcipher API
  crypto: nitrox - remove cra_type reference to ablkcipher
  crypto: cavium/cpt - switch to skcipher API
  crypto: chelsio - switch to skcipher API
  crypto: hifn - switch to skcipher API
  crypto: ixp4xx - switch to skcipher API
  crypto: mxs - switch to skcipher API
  crypto: mediatek - switch to skcipher API
  crypto: picoxcell - switch to skcipher API
  crypto: sahara - switch to skcipher API
  crypto: stm32 - switch to skcipher API
  crypto: rockchip - switch to skcipher API
  crypto: qce - switch to skcipher API
  crypto: niagara2 - switch to skcipher API
  crypto: talitos - switch to skcipher API
  crypto: qat - switch to skcipher API

 drivers/crypto/Kconfig                             |   2 +-
 drivers/crypto/atmel-aes.c                         | 507 +++++++++---------
 drivers/crypto/atmel-tdes.c                        | 433 ++++++++-------
 drivers/crypto/bcm/cipher.c                        | 373 +++++++------
 drivers/crypto/bcm/cipher.h                        |  10 +-
 drivers/crypto/bcm/spu2.c                          |   6 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c             | 292 +++++-----
 drivers/crypto/cavium/nitrox/nitrox_skcipher.c     |   1 -
 drivers/crypto/ccp/ccp-crypto-aes-galois.c         |   7 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c            |  94 ++--
 drivers/crypto/ccp/ccp-crypto-aes.c                | 169 +++---
 drivers/crypto/ccp/ccp-crypto-des3.c               | 100 ++--
 drivers/crypto/ccp/ccp-crypto-main.c               |  14 +-
 drivers/crypto/ccp/ccp-crypto.h                    |  13 +-
 drivers/crypto/chelsio/chcr_algo.c                 | 332 ++++++------
 drivers/crypto/chelsio/chcr_algo.h                 |   2 +-
 drivers/crypto/chelsio/chcr_crypto.h               |  14 +-
 drivers/crypto/hifn_795x.c                         | 183 +++----
 drivers/crypto/ixp4xx_crypto.c                     | 228 ++++----
 drivers/crypto/mediatek/mtk-aes.c                  | 248 ++++-----
 drivers/crypto/mxs-dcp.c                           | 140 +++--
 drivers/crypto/n2_core.c                           | 194 ++++---
 drivers/crypto/omap-aes.c                          | 208 ++++----
 drivers/crypto/omap-aes.h                          |   4 +-
 drivers/crypto/omap-des.c                          | 232 ++++----
 drivers/crypto/picoxcell_crypto.c                  | 386 +++++++-------
 drivers/crypto/qat/qat_common/qat_algs.c           | 255 +++++----
 drivers/crypto/qat/qat_common/qat_crypto.h         |   4 +-
 drivers/crypto/qce/Makefile                        |   2 +-
 drivers/crypto/qce/cipher.h                        |   8 +-
 drivers/crypto/qce/common.c                        |  12 +-
 drivers/crypto/qce/common.h                        |   3 +-
 drivers/crypto/qce/core.c                          |   2 +-
 drivers/crypto/qce/{ablkcipher.c => skcipher.c}    | 172 +++---
 drivers/crypto/rockchip/Makefile                   |   2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |   8 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   3 +-
 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 556 --------------------
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   | 538 +++++++++++++++++++
 drivers/crypto/s5p-sss.c                           | 191 ++++---
 drivers/crypto/sahara.c                            | 156 +++---
 drivers/crypto/stm32/stm32-cryp.c                  | 338 ++++++------
 drivers/crypto/talitos.c                           | 306 +++++------
 drivers/crypto/ux500/cryp/cryp_core.c              | 371 ++++++-------
 drivers/crypto/virtio/virtio_crypto_algs.c         | 192 +++----
 drivers/crypto/virtio/virtio_crypto_common.h       |   2 +-
 46 files changed, 3487 insertions(+), 3826 deletions(-)
 rename drivers/crypto/qce/{ablkcipher.c => skcipher.c} (61%)
 delete mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
 create mode 100644 drivers/crypto/rockchip/rk3288_crypto_skcipher.c

-- 
2.20.1

