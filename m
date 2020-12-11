Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3383C2BB40
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 12:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B816C23EB1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 12:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbgLKM2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 07:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395552AbgLKM2U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 07:28:20 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 0/2] crypto: remove bare cipher from public API
Date:   Fri, 11 Dec 2020 13:27:13 +0100
Message-Id: <20201211122715.15090-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Patch #2 puts the cipher API (which should not be used outside of the
crypto API implementation) into an internal header file and module
namespace

Patch #1 is a prerequisite for this, to avoid having to make the chelsio
driver import the crypto internal namespace.

Changes since v1:
- add missing Kconfig dependency on CRYPT_LIB_AES (#1)
- add missing module namespace import into skcipher.c (#2) - this addresses
  the kbuild failure report
- add module import to QAT driver, which now contains a valid use of the
  bare cipher API

Cc: Eric Biggers <ebiggers@google.com>

Ard Biesheuvel (2):
  chcr_ktls: use AES library for single use cipher
  crypto: remove cipher routines from public crypto API

 Documentation/crypto/api-skcipher.rst         |   4 +-
 arch/arm/crypto/aes-neonbs-glue.c             |   3 +
 arch/s390/crypto/aes_s390.c                   |   2 +
 crypto/adiantum.c                             |   2 +
 crypto/ansi_cprng.c                           |   2 +
 crypto/cbc.c                                  |   1 +
 crypto/ccm.c                                  |   2 +
 crypto/cfb.c                                  |   2 +
 crypto/cipher.c                               |   7 +-
 crypto/cmac.c                                 |   2 +
 crypto/ctr.c                                  |   2 +
 crypto/drbg.c                                 |   2 +
 crypto/ecb.c                                  |   1 +
 crypto/essiv.c                                |   2 +
 crypto/keywrap.c                              |   2 +
 crypto/ofb.c                                  |   2 +
 crypto/pcbc.c                                 |   2 +
 crypto/skcipher.c                             |   2 +
 crypto/testmgr.c                              |   3 +
 crypto/vmac.c                                 |   2 +
 crypto/xcbc.c                                 |   2 +
 crypto/xts.c                                  |   2 +
 drivers/crypto/geode-aes.c                    |   2 +
 drivers/crypto/inside-secure/safexcel.c       |   1 +
 drivers/crypto/inside-secure/safexcel_hash.c  |   1 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      |   1 +
 drivers/crypto/vmx/aes.c                      |   1 +
 drivers/crypto/vmx/vmx.c                      |   1 +
 .../ethernet/chelsio/inline_crypto/Kconfig    |   1 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  19 +-
 include/crypto/algapi.h                       |  39 ----
 include/crypto/internal/cipher.h              | 218 ++++++++++++++++++
 include/crypto/internal/skcipher.h            |   1 +
 include/linux/crypto.h                        | 163 -------------
 35 files changed, 281 insertions(+), 219 deletions(-)
 create mode 100644 include/crypto/internal/cipher.h

-- 
2.17.1

