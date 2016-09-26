From: Megha Dey <megha.dey@linux.intel.com>
Subject: [PATCH v5 0/7] crypto: AES CBC multibuffer implementation
Date: Mon, 26 Sep 2016 10:27:32 -0700
Message-ID: <1474910859-11713-1-git-send-email-megha.dey@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, tim.c.chen@linux.intel.com,
        megha.dey@intel.com, Megha Dey <megha.dey@linux.intel.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:17589 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161617AbcIZRUp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2016 13:20:45 -0400
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

v5
1. Use an async implementation of the inner algorithm instead of sync
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

Megha Dey (1):
  crypto: Multi-buffer encryption infrastructure support

Tim Chen (6):
  crypto: AES CBC multi-buffer data structures
  crypto: AES CBC multi-buffer scheduler
  crypto: AES CBC by8 encryption
  crypto: AES CBC multi-buffer glue code
  crypto: AES vectors for AES CBC multibuffer testing
  crypto: AES CBC multi-buffer tcrypt

 arch/x86/crypto/Makefile                           |    1 +
 arch/x86/crypto/aes-cbc-mb/Makefile                |   22 +
 arch/x86/crypto/aes-cbc-mb/aes_cbc_enc_x8.S        |  775 ++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c            |  839 +++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h        |   97 ++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h        |  132 ++
 arch/x86/crypto/aes-cbc-mb/aes_mb_mgr_init.c       |  146 ++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S     |  271 ++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_inorder_x8_asm.S |  223 +++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_ooo_x8_asm.S     |  417 ++++++
 arch/x86/crypto/aes-cbc-mb/reg_sizes.S             |  126 ++
 crypto/Kconfig                                     |   15 +
 crypto/mcryptd.c                                   |  256 ++++
 crypto/tcrypt.c                                    |  257 +++-
 crypto/testmgr.c                                   |  759 +++++++++-
 crypto/testmgr.h                                   | 1496 ++++++++++++++++++++
 include/crypto/algapi.h                            |   10 +
 include/crypto/mcryptd.h                           |   36 +
 18 files changed, 5864 insertions(+), 14 deletions(-)
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
