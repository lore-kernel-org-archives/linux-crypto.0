Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B3AC433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A272072E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362109;
	bh=5tkYiQlvb6KjO1ssHvhld8saZ31rHdrjvBBdKg4ftf8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=MS9aKiRr9V3xTrOOq/BcOj5Lqv/5r7dLOhE8CV5NRfcXtCN9iRJaR7W86Mau+qU7c
	 LXuQT95ht1nIW0ir55+tA2400cDXEix2SYdIOYV5k5zy02YBADWuvw6e5yVg4ehFQ+
	 Za9db6OWEnHZ3eqnrYpNF68FuUWnDBPAqamKObPs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgGJGVq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgGJGVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:21:46 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE3A22072E;
        Fri, 10 Jul 2020 06:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362105;
        bh=5tkYiQlvb6KjO1ssHvhld8saZ31rHdrjvBBdKg4ftf8=;
        h=From:To:Cc:Subject:Date:From;
        b=e5rSC6yA4q6aFJJVqzvj0jaAGfsShhL2b7RfRABnw1AepSt2WTs5cnPfsQ4HeeCos
         CplPbiqaWVhb8JRZeVGEshjapW6KT314Gdbb5JLbE9t38xRUm8DefhwLWCgb1Mn63C
         aWiM2NOCv0i5DVGAkTdwQzwVSbNzO6rG9YGskW54=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH v2 0/7] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Thu,  9 Jul 2020 23:20:35 -0700
Message-Id: <20200710062042.113842-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series introduces a flag that algorithms can set to indicate that
they allocate memory during processing of typical inputs, and thus
shouldn't be used in cases like dm-crypt where memory allocation
failures aren't acceptable.

Compared to Mikulas's patches, I've made the following improvements:

- Tried to clearly document the semantics of
  CRYPTO_ALG_ALLOCATES_MEMORY.  This includes documenting the usage
  constraints, since there are actually lots of cases that were
  overlooked where algorithms can still allocate memory in some edge
  cases where inputs are misaligned, fragemented, etc.  E.g. see
  crypto/skcipher.c and crypto/ahash.c.  Mikulas, please let me know if
  there are any concerns for dm-crypt.

- Moved the common mechanism for inheriting flags to its own patch.

- crypto_grab_spawn() now handles propagating CRYPTO_ALG_INHERITED_FLAGS
  to the new template instance.

- Inherit the flags in various places that were missed.

- Other cleanups.

Additional changes v1 => v2:

- Made crypto_check_attr_type() return the mask.

- Added patch that adds NEED_FALLBACK to INHERITED_FLAGS.

- Added patch that removes seqiv_create().

Eric Biggers (5):
  crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
  crypto: seqiv - remove seqiv_create()
  crypto: algapi - use common mechanism for inheriting flags
  crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
  crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY

Mikulas Patocka (2):
  crypto: drivers - set the flag CRYPTO_ALG_ALLOCATES_MEMORY
  dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY

 crypto/adiantum.c                             |  14 +--
 crypto/algapi.c                               |  21 +++-
 crypto/authenc.c                              |  14 +--
 crypto/authencesn.c                           |  14 +--
 crypto/ccm.c                                  |  33 ++---
 crypto/chacha20poly1305.c                     |  14 +--
 crypto/cmac.c                                 |   5 +-
 crypto/cryptd.c                               |  59 ++++-----
 crypto/ctr.c                                  |  17 +--
 crypto/cts.c                                  |  13 +-
 crypto/echainiv.c                             |   2 +-
 crypto/essiv.c                                |  11 +-
 crypto/gcm.c                                  |  40 ++----
 crypto/geniv.c                                |  19 +--
 crypto/hmac.c                                 |   5 +-
 crypto/lrw.c                                  |  13 +-
 crypto/pcrypt.c                               |  14 +--
 crypto/rsa-pkcs1pad.c                         |  13 +-
 crypto/seqiv.c                                |  18 +--
 crypto/simd.c                                 |   6 +-
 crypto/skcipher.c                             |  13 +-
 crypto/vmac.c                                 |   5 +-
 crypto/xcbc.c                                 |   5 +-
 crypto/xts.c                                  |  15 +--
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |  12 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  12 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c     |   6 +-
 drivers/crypto/axis/artpec6_crypto.c          |  20 ++-
 drivers/crypto/bcm/cipher.c                   |  72 ++++++++---
 drivers/crypto/caam/caamalg.c                 |   6 +-
 drivers/crypto/caam/caamalg_qi.c              |   6 +-
 drivers/crypto/caam/caamalg_qi2.c             |   8 +-
 drivers/crypto/caam/caamhash.c                |   2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c        |  18 ++-
 drivers/crypto/cavium/nitrox/nitrox_aead.c    |   4 +-
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |  16 +--
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c      |   1 +
 drivers/crypto/ccp/ccp-crypto-aes-galois.c    |   1 +
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       |   1 +
 drivers/crypto/ccp/ccp-crypto-aes.c           |   2 +
 drivers/crypto/ccp/ccp-crypto-des3.c          |   1 +
 drivers/crypto/ccp/ccp-crypto-sha.c           |   1 +
 drivers/crypto/chelsio/chcr_algo.c            |   7 +-
 drivers/crypto/hisilicon/sec/sec_algs.c       |  24 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |   4 +-
 .../crypto/inside-secure/safexcel_cipher.c    |  47 +++++++
 drivers/crypto/inside-secure/safexcel_hash.c  |  18 +++
 drivers/crypto/ixp4xx_crypto.c                |   6 +-
 drivers/crypto/marvell/cesa/cipher.c          |  18 ++-
 drivers/crypto/marvell/cesa/hash.c            |   6 +
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |  30 ++---
 drivers/crypto/n2_core.c                      |   3 +-
 drivers/crypto/picoxcell_crypto.c             |  17 ++-
 drivers/crypto/qat/qat_common/qat_algs.c      |  13 +-
 drivers/crypto/qce/skcipher.c                 |   1 +
 drivers/crypto/talitos.c                      | 117 ++++++++++++------
 drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
 drivers/md/dm-crypt.c                         |  17 ++-
 include/crypto/algapi.h                       |  25 ++--
 include/crypto/internal/geniv.h               |   2 +-
 include/linux/crypto.h                        |  36 +++++-
 62 files changed, 562 insertions(+), 405 deletions(-)


base-commit: 3d2df84548ed88dc3344392d4e5afb8884d05360
-- 
2.27.0

