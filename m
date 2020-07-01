Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A512DC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72178207D0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 04:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593579150;
	bh=QR0SSjCQOo0ugtEqCSQNmQYc2nErKk+Cxy2AzO70BzA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XPXoBhyzBrt2U+AHwVhFTQ2D/UzSCHeSoAm5yiEX2/sa1DYuzXK9uCdJ2Arr09e36
	 +I89k7jEkmhVbnLJPFBd9eOwRAkK7xQKLw4al1RwHaDoqD4BFz478/K5fq0mu2PCe6
	 Rh2Q+QZbBzW53GFBo3McEQ1baup07qHYkHauxjBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgGAEw3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgGAEw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 00:52:29 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1702070C;
        Wed,  1 Jul 2020 04:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593579148;
        bh=QR0SSjCQOo0ugtEqCSQNmQYc2nErKk+Cxy2AzO70BzA=;
        h=From:To:Cc:Subject:Date:From;
        b=MZtFsV7ApoeInX6kOJL1fpAQhvEacyK5cP3jcwGZsCYJ9st7KoYkDdmL0279zZnRX
         lgIfpd/SKr5s7RPtM7smHZ6yhQN20dMqKIUnYMh6iSQLlyV7lgECeac6LcNLDY24nA
         BJ1BXTxh1K7Sx0WkIMYMqAmyQDnxjx+nGW95wfgc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH 0/6] crypto: add CRYPTO_ALG_ALLOCATES_MEMORY
Date:   Tue, 30 Jun 2020 21:52:11 -0700
Message-Id: <20200701045217.121126-1-ebiggers@kernel.org>
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

Note: Mikulas's patch "crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY"
still needs to be checked for cases where the flag no longer needs to be
set due to the usage constraints I documented.

Eric Biggers (4):
  crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
  crypto: algapi - use common mechanism for inheriting flags
  crypto: algapi - introduce the flag CRYPTO_ALG_ALLOCATES_MEMORY
  crypto: algapi - remove crypto_check_attr_type()

Mikulas Patocka (2):
  crypto: set the flag CRYPTO_ALG_ALLOCATES_MEMORY
  dm-crypt: don't use drivers that have CRYPTO_ALG_ALLOCATES_MEMORY

 crypto/adiantum.c                             |   4 +-
 crypto/algapi.c                               |  17 +--
 crypto/authenc.c                              |   4 +-
 crypto/authencesn.c                           |   4 +-
 crypto/ccm.c                                  |  23 ++--
 crypto/chacha20poly1305.c                     |   4 +-
 crypto/cmac.c                                 |  15 ++-
 crypto/cryptd.c                               |  59 ++++-----
 crypto/ctr.c                                  |   8 +-
 crypto/cts.c                                  |   3 +-
 crypto/echainiv.c                             |   2 +-
 crypto/essiv.c                                |  11 +-
 crypto/gcm.c                                  |  10 +-
 crypto/geniv.c                                |   9 +-
 crypto/hmac.c                                 |  15 ++-
 crypto/lrw.c                                  |   3 +-
 crypto/pcrypt.c                               |  14 +--
 crypto/rsa-pkcs1pad.c                         |   3 +-
 crypto/seqiv.c                                |   2 +-
 crypto/simd.c                                 |   6 +-
 crypto/skcipher.c                             |   3 +-
 crypto/vmac.c                                 |  15 ++-
 crypto/xcbc.c                                 |  15 ++-
 crypto/xts.c                                  |   3 +-
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
 drivers/crypto/qat/qat_common/qat_algs.c      |  12 +-
 drivers/crypto/qce/skcipher.c                 |   1 +
 drivers/crypto/talitos.c                      | 117 ++++++++++++------
 drivers/crypto/virtio/virtio_crypto_algs.c    |   3 +-
 drivers/crypto/xilinx/zynqmp-aes-gcm.c        |   1 +
 drivers/md/dm-crypt.c                         |  17 ++-
 include/crypto/algapi.h                       |  23 +++-
 include/crypto/internal/geniv.h               |   2 +-
 include/linux/crypto.h                        |  32 +++++
 62 files changed, 550 insertions(+), 279 deletions(-)

-- 
2.27.0

