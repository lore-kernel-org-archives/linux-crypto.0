From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH V7 0/7] crypto: AES CBC multibuffer implementation
Date: Tue, 25 Jul 2017 19:09:53 -0700
Message-ID: <1501035000-6283-1-git-send-email-megha.dey@linux.intel.com>
Cc: tim.c.chen@linux.intel.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:3056 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbdGZB6h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 21:58:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In this patch series, we introduce AES CBC encryption that is parallelized on
x86_64 cpu with XMM registers. The multi-buffer technique encrypt 8 data
streams in parallel with SIMD instructions. Decryption is handled as in the
existing AESNI Intel CBC implementation which can already parallelize decryption
even for a single data stream.

Please see the multi-buffer whitepaper for details of the technique:
http://www.intel.com/content/www/us/en/communications/communications-ia-multi-buffer-paper.html

It is important that any driver uses this algorithm properly for scenarios
where we have many data streams that can fill up the data lanes most of the
time. It shouldn't be used when only a single data stream is expected mostly.
Otherwise we may incur extra delays when we have frequent gaps in data lanes,
causing us to wait till data come in to fill the data lanes before initiating
encryption.  We may have to wait for flush operations to commence when no new
data come in after some wait time. However we keep this extra delay to a
minimum by opportunistically flushing the unfinished jobs if crypto daemon is
the only active task running on a cpu.

By using this technique, we saw a throughput increase of up to 5.7x under
optimal conditions when we have fully loaded encryption jobs filling up all
the data lanes.

Change Log:

v7
1. Add the CRYPTO_ALG_ASYNC flag to the internal algorithm
2. Remove the irq_disabled check

v6
1. Move away from the compat naming scheme and update the names of the inner
   and outer algorithm
2. Move wrapper code around synchronous internal algorithm from simd.c
   to mcryptd.c

v5
1. Use an async implementation of the inner algorithm instead of sync and use
   the latest skcipher interface instead of the older blkcipher interface.
   (we have picked up this work after a while)

v4
1. Make the decrypt path also use ablkcpher walk.
http://lkml.iu.edu/hypermail/linux/kernel/1512.0/01807.html

v3
1. Use ablkcipher_walk helpers to walk the scatter gather list
and eliminated needs to modify blkcipher_walk for multibuffer cipher

v2
1. Update cpu feature check to make sure SSE is supported
2. Fix up unloading of aes-cbc-mb module to properly free memory

Megha Dey (7):
  crypto: Multi-buffer encryption infrastructure support
  crypto: AES CBC multi-buffer data structures
  crypto: AES CBC multi-buffer scheduler
  crypto: AES CBC by8 encryption
  crypto: AES CBC multi-buffer glue code
  crypto: AES vectors for AES CBC multibuffer testing
  crypto: AES CBC multi-buffer tcrypt

 arch/x86/crypto/Makefile                           |    1 +
 arch/x86/crypto/aes-cbc-mb/Makefile                |   22 +
 arch/x86/crypto/aes-cbc-mb/aes_cbc_enc_x8.S        |  775 ++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c            |  720 ++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h        |   97 ++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h        |  132 ++
 arch/x86/crypto/aes-cbc-mb/aes_mb_mgr_init.c       |  146 ++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S     |  271 ++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_inorder_x8_asm.S |  223 +++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_ooo_x8_asm.S     |  417 ++++++
 arch/x86/crypto/aes-cbc-mb/reg_sizes.S             |  126 ++
 crypto/Kconfig                                     |   15 +
 crypto/mcryptd.c                                   |  475 +++++++
 crypto/tcrypt.c                                    |  259 +++-
 crypto/testmgr.c                                   |  707 +++++++++
 crypto/testmgr.h                                   | 1496 ++++++++++++++++++++
 include/crypto/mcryptd.h                           |   56 +
 17 files changed, 5936 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/crypto/aes-cbc-mb/Makefile
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_enc_x8.S
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h
 create mode 100644 arch/x86/crypto/aes-cbc-mb/aes_mb_mgr_init.c
 create mode 100644 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S
 create mode 100644 arch/x86/crypto/aes-cbc-mb/mb_mgr_inorder_x8_asm.S
 create mode 100644 arch/x86/crypto/aes-cbc-mb/mb_mgr_ooo_x8_asm.S
 create mode 100644 arch/x86/crypto/aes-cbc-mb/reg_sizes.S

-- 
1.9.1
