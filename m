Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7256CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D9521D82
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032725;
	bh=Ns/oA6RsvkhT0G/EC+ixoD7+P2/WuyH6YTrMC6kJJKI=;
	h=From:To:Subject:Date:List-ID:From;
	b=qWyfV4htB+DJuNPTpAsMceBB/Npb/AeQz7MXHU3P2bnOlIx4u7+1ghDtmmPgQNNvT
	 51OVb4T4zesyRkSYB1J6HtT2/6pXoDaAKQlPErzDyyd6vg1kFL17xxRas/VNWoRwzD
	 aoxqDPIAtwHPs79+VX9JfIlY4KWcCiJBqdWpOb90=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfJYTpY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfJYTpY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:24 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84CD221D71
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032723;
        bh=Ns/oA6RsvkhT0G/EC+ixoD7+P2/WuyH6YTrMC6kJJKI=;
        h=From:To:Subject:Date:From;
        b=X11D8KUNLw14K44HN8QkOJFGzD4zTWLFAEaZ3BEyK2kwvAbNLT0xTJB2yrs7vjXbg
         WqBFPoRgaY7ojmuKAQs++nxAcRAoXwMQI1KcuD00AMnlnTbxtiR0f7nBaYEre/2SY0
         fCYYtNMO7IqBpdB0nQ+3jf0rDyR6jBSa1XbAfMzs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 0/5] crypto: remove blkcipher
Date:   Fri, 25 Oct 2019 12:41:08 -0700
Message-Id: <20191025194113.217451-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Now that all "blkcipher" algorithms have been converted to "skcipher",
this series removes the blkcipher algorithm type.

The skcipher (symmetric key cipher) algorithm type was introduced a few
years ago to replace both blkcipher and ablkcipher (synchronous and
asynchronous block cipher).  The advantages of skcipher include:

  - A much less confusing name, since none of these algorithm types have
    ever actually been for raw block ciphers, but rather for all
    length-preserving encryption modes including block cipher modes of
    operation, stream ciphers, and other length-preserving modes.

  - It unified blkcipher and ablkcipher into a single algorithm type
    which supports both synchronous and asynchronous implementations.
    Note, blkcipher already operated only on scatterlists, so the fact
    that skcipher does too isn't a regression in functionality.

  - Better type safety by using struct skcipher_alg, struct
    crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.

  - It sometimes simplifies the implementations of algorithms.

Also, the blkcipher API was no longer being tested.

Eric Biggers (5):
  crypto: unify the crypto_has_skcipher*() functions
  crypto: remove crypto_has_ablkcipher()
  crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
  crypto: remove the "blkcipher" algorithm type
  crypto: rename the crypto_blkcipher module and kconfig option

 Documentation/crypto/api-skcipher.rst |  13 +-
 Documentation/crypto/architecture.rst |   2 -
 Documentation/crypto/devel-algos.rst  |  27 +-
 arch/arm/crypto/Kconfig               |   6 +-
 arch/arm64/crypto/Kconfig             |   8 +-
 crypto/Kconfig                        |  84 ++--
 crypto/Makefile                       |   7 +-
 crypto/api.c                          |   2 +-
 crypto/blkcipher.c                    | 548 --------------------------
 crypto/cryptd.c                       |   2 +-
 crypto/crypto_user_stat.c             |   4 -
 crypto/essiv.c                        |   6 +-
 crypto/skcipher.c                     | 124 +-----
 drivers/crypto/Kconfig                |  52 +--
 drivers/crypto/amlogic/Kconfig        |   2 +-
 drivers/crypto/caam/Kconfig           |   6 +-
 drivers/crypto/cavium/nitrox/Kconfig  |   2 +-
 drivers/crypto/ccp/Kconfig            |   2 +-
 drivers/crypto/hisilicon/Kconfig      |   2 +-
 drivers/crypto/qat/Kconfig            |   2 +-
 drivers/crypto/ux500/Kconfig          |   2 +-
 drivers/crypto/virtio/Kconfig         |   2 +-
 drivers/net/wireless/cisco/Kconfig    |   2 +-
 include/crypto/algapi.h               |  74 ----
 include/crypto/internal/skcipher.h    |  12 -
 include/crypto/skcipher.h             |  27 +-
 include/linux/crypto.h                | 426 +-------------------
 net/bluetooth/Kconfig                 |   2 +-
 net/rxrpc/Kconfig                     |   2 +-
 net/xfrm/Kconfig                      |   2 +-
 net/xfrm/xfrm_algo.c                  |   4 +-
 31 files changed, 124 insertions(+), 1332 deletions(-)
 delete mode 100644 crypto/blkcipher.c

-- 
2.23.0

