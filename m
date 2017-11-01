From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/4] crypto: dh - input validation fixes
Date: Wed,  1 Nov 2017 15:25:13 -0700
Message-ID: <20171101222517.41602-1-ebiggers3@gmail.com>
Cc: keyrings@vger.kernel.org,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Stephan Mueller <smueller@chronox.de>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45427 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933494AbdKAW2X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 18:28:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

This series fixes several corner cases in the Diffie-Hellman key
exchange implementations:

- With CONFIG_DEBUG_SG=y and the software DH implementation, setting 'p'
  to 0 caused a BUG_ON().
- Both the software and QAT DH implementations had a double-free bug in
  the case where 'g' could not be allocated.
- With the QAT DH implementation, setting 'g' or 'key' larger than 'p'
  caused a buffer underflow.

Note that in kernels configured with CONFIG_KEY_DH_OPERATIONS=y, these
bugs are reachable by unprivileged users via KEYCTL_DH_COMPUTE.

Eric Biggers (4):
  crypto: dh - fix double free of ctx->p
  crypto: dh - don't permit 'p' to be 0
  crypto: qat - fix double free of ctx->p
  crypto: dh - don't permit 'key' or 'g' size longer than 'p'

 crypto/dh.c                                   | 18 +++++++++---------
 crypto/dh_helper.c                            | 16 ++++++++++++++++
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 15 ++++++++-------
 3 files changed, 33 insertions(+), 16 deletions(-)

-- 
2.15.0.403.gc27cc4dac6-goog
