Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6944FCCA46B
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Jun 2023 21:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbjFLVIb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbjFLVHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Jun 2023 17:07:55 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C350698;
        Mon, 12 Jun 2023 14:05:01 -0700 (PDT)
Received: from i53875b22.versanet.de ([83.135.91.34] helo=phil.lan)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1q8oia-0005fR-KP; Mon, 12 Jun 2023 23:04:52 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     palmer@dabbelt.com, paul.walmsley@sifive.com
Cc:     heiko@sntech.de, aou@eecs.berkeley.edu,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: [PATCH v5 0/4] Implement GCM ghash using Zbc and Zbkb extensions
Date:   Mon, 12 Jun 2023 23:04:38 +0200
Message-Id: <20230612210442.1805962-1-heiko.stuebner@vrull.eu>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@vrull.eu>

This was originally part of my vector crypto series, but was part
of a separate openssl merge request implementing GCM ghash as using
non-vector extensions.

As that pull-request
    https://github.com/openssl/openssl/pull/20078
got merged recently into openssl, we could also check if this could
go into the kernel as well and provide a base for further accelerated
cryptographic support.

Changes in v5:
- rebased on top of 6.4-based riscv/next
- code from openssl is now dual-licensed under Apache + BSD
  see https://github.com/openssl/openssl/pull/20649
- separate init functions instead of creating them with macros (Nathan)

Changes in v4:
- rebase on top of riscv/for-next
- split out the scalar crypto implementation from the vector series
- refresh code from openSSL to match exactly
- Remove RFC label, as Zbc and Zbkb are ratified and
  the cryptographic code was merged into openSSL

changes in v3:
- rebase on top of 6.3-rc2
- rebase on top of vector-v14 patchset
- add the missing Co-developed-by mentions to showcase
  the people that did the actual openSSL crypto code

changes in v2:
- rebased on 6.2 + zbb series, so don't include already
  applied changes anymore
- refresh code picked from openssl as that side matures
- more algorithms (SHA512, AES, SM3, SM4)

Heiko Stuebner (4):
  RISC-V: add Zbc extension detection
  RISC-V: add Zbkb extension detection
  RISC-V: hook new crypto subdir into build-system
  RISC-V: crypto: add accelerated GCM GHASH implementation

 arch/riscv/Kbuild                      |   1 +
 arch/riscv/Kconfig                     |  22 ++
 arch/riscv/crypto/Kconfig              |  18 ++
 arch/riscv/crypto/Makefile             |  18 ++
 arch/riscv/crypto/ghash-riscv64-glue.c | 296 +++++++++++++++++
 arch/riscv/crypto/ghash-riscv64-zbc.pl | 427 +++++++++++++++++++++++++
 arch/riscv/crypto/riscv.pm             | 258 +++++++++++++++
 arch/riscv/include/asm/hwcap.h         |   2 +
 arch/riscv/kernel/cpu.c                |   2 +
 arch/riscv/kernel/cpufeature.c         |   2 +
 crypto/Kconfig                         |   3 +
 11 files changed, 1049 insertions(+)
 create mode 100644 arch/riscv/crypto/Kconfig
 create mode 100644 arch/riscv/crypto/Makefile
 create mode 100644 arch/riscv/crypto/ghash-riscv64-glue.c
 create mode 100644 arch/riscv/crypto/ghash-riscv64-zbc.pl
 create mode 100644 arch/riscv/crypto/riscv.pm

-- 
2.39.0

