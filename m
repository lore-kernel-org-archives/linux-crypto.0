From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 0/4] crypto: [sha] x86 SHA extension optimization of SHA1
 and SHA256
Date: Thu, 10 Sep 2015 15:26:52 -0700
Message-ID: <1441924012.4322.0.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43010 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbIJW0x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Sep 2015 18:26:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The new x86 SHA extensions provide new hardware accelerated instructions
for computing SHA1 and SHA256 hashes. This patch series provide the
assembly routines for SHA1 and SHA256 computation using these new
instructions to the kernel crypto library.  For 4K data blocks, we've
seen up to 3.6x speedup over existing SSSE3 enhanced routines in the
kernel crypto library on Broxton platform.

Refer to SHA extension programming guide in chapter 8.2 of the
Intel Architecture Instruction Set Extensions Programming reference.
https://software.intel.com/sites/default/files/managed/07/b7/319433-023.pdf

Pre-req patches:
[1] [PATCH] sha: Enable cpuid check for Intel SHA extensions implementations
http://marc.info/?l=linux-kernel&m=144019424304089&w=2
[2] [Patch] x86/insn: perf tools: Add new SHA instructions
http://marc.info/?l=linux-kernel&m=144119645000679&w=2

Tim Chen (4):
  crypto: [sha] Intel SHA Extensions optimized SHA1 transform function
  crypto: [sha] Intel SHA Extensions optimized SHA256 transform function
  crypto: [sha] glue code for Intel SHA extensions optimized SHA1 &
    SHA256
  crypto: [sha] Add build support for Intel SHA Extensions optimized
    SHA1 and SHA256

 arch/x86/Makefile                   |   6 +-
 arch/x86/crypto/Makefile            |   8 +
 arch/x86/crypto/sha1_ni_asm.S       | 302 ++++++++++++++++++++++++++++++
 arch/x86/crypto/sha1_ssse3_glue.c   |  12 +-
 arch/x86/crypto/sha256_ni_asm.S     | 353 ++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  38 ++--
 crypto/Kconfig                      |  10 +-
 7 files changed, 707 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/crypto/sha1_ni_asm.S
 create mode 100644 arch/x86/crypto/sha256_ni_asm.S

-- 
2.4.2
