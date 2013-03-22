From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 00/11] Optimize SHA256 and SHA512 for Intel x86_64 with
 SSSE3, AVX or AVX2 instructions
Date: Fri, 22 Mar 2013 14:28:57 -0700
Message-ID: <1363987737.8972.54.camel@schen9-DESK>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Kirk Yap <kirk.s.yap@intel.com>,
	David Cote <david.m.cote@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12738 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423270Ab3CVV2z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Mar 2013 17:28:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert, 

The following patch series provides optimized SHA256 and SHA512 routines
using the SSSE3, AVX or AVX2 instructions on x86_64 for Intel cpus.
Depending on cpu capabilities, speedup between 40% to 70% or more can be achieved
over the generic SHA256 and SHA512 routines.


Tim Chen (11):
  Added macro to check for AVX2 feature.
  Expose SHA256 generic routine to be callable externally.
  Optimized sha256 x86_64 assembly routine using Supplemental SSE3
    instructions.
  Optimized sha256 x86_64 assembly routine with AVX instructions.
  Optimized sha256 x86_64 routine using AVX2's RORX instructions
  Create module providing optimized SHA256 routines using     SSSE3,
    AVX or AVX2 instructions.
  Expose generic sha512 routine to be callable from other modules
  Optimized SHA512 x86_64 assembly routine using Supplemental SSE3
    instructions.
  Optimized SHA512 x86_64 assembly routine using AVX instructions.
  Optimized SHA512 x86_64 assembly routine using AVX2 RORX instruction.
  Create module providing optimized SHA512 routines using     SSSE3,
    AVX or AVX2 instructions.

 arch/x86/crypto/Makefile            |   4 +
 arch/x86/crypto/sha256-avx-asm.S    | 493 +++++++++++++++++++++++
 arch/x86/crypto/sha256-avx2-asm.S   | 769 ++++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha256-ssse3-asm.S  | 504 +++++++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c | 269 +++++++++++++
 arch/x86/crypto/sha512-avx-asm.S    | 420 ++++++++++++++++++++
 arch/x86/crypto/sha512-avx2-asm.S   | 741 ++++++++++++++++++++++++++++++++++
 arch/x86/crypto/sha512-ssse3-asm.S  | 419 ++++++++++++++++++++
 arch/x86/crypto/sha512_ssse3_glue.c | 276 +++++++++++++
 arch/x86/include/asm/cpufeature.h   |   1 +
 crypto/Kconfig                      |  22 ++
 crypto/sha256_generic.c             |  11 +-
 crypto/sha512_generic.c             |  13 +-
 include/crypto/sha.h                |   5 +
 14 files changed, 3936 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/crypto/sha256-avx-asm.S
 create mode 100644 arch/x86/crypto/sha256-avx2-asm.S
 create mode 100644 arch/x86/crypto/sha256-ssse3-asm.S
 create mode 100644 arch/x86/crypto/sha256_ssse3_glue.c
 create mode 100644 arch/x86/crypto/sha512-avx-asm.S
 create mode 100644 arch/x86/crypto/sha512-avx2-asm.S
 create mode 100644 arch/x86/crypto/sha512-ssse3-asm.S
 create mode 100644 arch/x86/crypto/sha512_ssse3_glue.c

-- 
1.7.11.7
