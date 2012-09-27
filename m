From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/3 v2] Optimize CRC32C calculation using PCLMULQDQ in
 crc32c-intel module
Date: Thu, 27 Sep 2012 15:44:14 -0700
Message-ID: <1348785854.17632.15.camel@schen9-DESK>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	David Cote <david.m.cote@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Chaohong Guo <chaohong.guo@intel.com>,
	Austin Zhang <austin_zhang@linux.intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Min Li <min.a.li@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Version 2
This version of the patch series fixes compilation errors for
32 bit x86 targets.

Version 1
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

 arch/x86/crypto/Makefile                           |    2 +
 .../crypto/{crc32c-intel.c => crc32c-intel_glue.c} |   81 ++++
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S          |  460 ++++++++++++++++++++
 crypto/Kconfig                                     |   10 +
 crypto/tcrypt.c                                    |    4 +
 5 files changed, 557 insertions(+), 0 deletions(-)
 rename arch/x86/crypto/{crc32c-intel.c => crc32c-intel_glue.c} (69%)
 create mode 100644 arch/x86/crypto/crc32c-pcl-intel-asm_64.S

-- 
1.7.7.6
