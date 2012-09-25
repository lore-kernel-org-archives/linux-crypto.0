From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/3] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
Date: Tue, 25 Sep 2012 14:50:08 -0700
Message-ID: <1348609808.9977.205.camel@schen9-DESK>
References: <cover.1348599489.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>,
	James Guilford <james.guilford@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2419 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2IYVuJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Sep 2012 17:50:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series optimized CRC32C calculations with PCLMULQDQ
instruction for crc32c-intel module.  It speeds up the original
implementation by 1.6x for 1K buffer and by 3x for buffer 4k or
more.  The tcrypt module was enhanced for doing speed test
on crc32c calculations.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
Tim Chen (3):
  Rename crc32c-intel.c to crc32c-intel_glue.c
  Optimize CRC32C calculation with PCLMULQDQ instruction
  Added speed test in tcrypt for crc32c

 arch/x86/crypto/Makefile                           |    1 +
 .../crypto/{crc32c-intel.c => crc32c-intel_glue.c} |   75 ++++
 arch/x86/crypto/crc32c-pcl-intel-asm.S             |  460 ++++++++++++++++++++
 crypto/tcrypt.c                                    |    4 +
 4 files changed, 540 insertions(+), 0 deletions(-)
 rename arch/x86/crypto/{crc32c-intel.c => crc32c-intel_glue.c} (70%)
 create mode 100644 arch/x86/crypto/crc32c-pcl-intel-asm.S

-- 
1.7.7.6
