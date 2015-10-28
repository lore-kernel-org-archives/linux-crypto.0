From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/5] x86 AES-CBC encryption with AVX2 multi-buffer
Date: Wed, 28 Oct 2015 14:17:55 -0700
Message-ID: <1446067075.14635.2.camel@schen9-desk2.jf.intel.com>
References: <cover.1445565339.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Stephan Mueller <smueller@chronox.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8009 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbbJ1VR4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Oct 2015 17:17:56 -0400
In-Reply-To: <cover.1445565339.git.tim.c.chen@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


In this patch series, we introduce AES CBC encryption that is parallelized
on x86_64 cpu with AVX2. The multi-buffer technique takes advantage
of wide AVX2 register and encrypt 8 data streams in parallel with SIMD
instructions. Decryption is handled as in the existing AESNI Intel CBC
implementation which can already parallelize decryption even for a single
data stream.

Please see the multi-buffer whitepaper for details of the technique:
http://www.intel.com/content/www/us/en/communications/communications-ia-multi-buffer-paper.html

It is important that any driver uses this algorithm properly for scenarios
where we have many data streams that can fill up the data lanes most of
the time.  It shouldn't be used when only a single data stream is expected
mostly. Otherwise we may incurr extra delays when we have frequent gaps in
data lanes, causing us to wait till data come in to fill the data lanes
before initiating encryption.  We may have to wait for flush operations
to commence when no new data come in after some wait time. However we
keep this extra delay to a minimum by opportunistically flushing the
unfinished jobs if crypto daemon is the only active task running on a cpu.

By using this technique, we saw a throughput increase of up to
5.8x under optimal conditions when we have fully loaded encryption jobs
filling up all the data lanes.

Tim Chen (5):
  crypto: Multi-buffer encryptioin infrastructure support
  crypto: AES CBC multi-buffer data structures
  crypto: AES CBC multi-buffer scheduler
  crypto: AES CBC by8 encryption
  crypto: AES CBC multi-buffer glue code

 arch/x86/crypto/Makefile                           |   1 +
 arch/x86/crypto/aes-cbc-mb/Makefile                |  22 +
 arch/x86/crypto/aes-cbc-mb/aes_cbc_enc_x8.S        | 774 +++++++++++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb.c            | 815 +++++++++++++++++++++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_ctx.h        |  96 +++
 arch/x86/crypto/aes-cbc-mb/aes_cbc_mb_mgr.h        | 131 ++++
 arch/x86/crypto/aes-cbc-mb/aes_mb_mgr_init.c       | 145 ++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_datastruct.S     | 270 +++++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_inorder_x8_asm.S | 222 ++++++
 arch/x86/crypto/aes-cbc-mb/mb_mgr_ooo_x8_asm.S     | 416 +++++++++++
 arch/x86/crypto/aes-cbc-mb/reg_sizes.S             | 125 ++++
 crypto/Kconfig                                     |  16 +
 crypto/blkcipher.c                                 |  29 +-
 crypto/mcryptd.c                                   | 256 ++++++-
 crypto/scatterwalk.c                               |   7 +
 include/crypto/algapi.h                            |   1 +
 include/crypto/mcryptd.h                           |  36 +
 include/crypto/scatterwalk.h                       |   6 +
 include/linux/crypto.h                             |   1 +
 19 files changed, 3364 insertions(+), 5 deletions(-)
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
1.7.11.7
