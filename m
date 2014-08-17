From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/8] DRBG: efficiency patches
Date: Sun, 17 Aug 2014 17:37:04 +0200
Message-ID: <7044529.FG2KhbPc9P@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

The following patch set contains random fixes to increase the efficiency of
the DRBG. Changes include the removal of unneeded memset(0) and sanity
checks. All changes do not weaken the implementation as only code is
removed that is clearly covered by other code paths.

In addition, the cpu_to_be kernel function together with a type cast is
used to convert an integer into its string representation. This patch
increases the speed of the DRBG by 10%.

Stephan Mueller (8):
  DRBG: replace int2byte with cpu_to_be
  DRBG: kzfree does not need a check for NULL pointer
  DRBG: remove superflowous checks
  DRBG: remove superflowous memset(0)
  DRBG: use kmalloc instead of kzalloc for V and C
  DRBG: remove unnecessary sanity checks
  DRBG: remove configuration of fixed values
  DRBG: remove unnecessary sanity check for shadow state

 crypto/drbg.c         | 130 ++++++++++++++++----------------------------------
 include/crypto/drbg.h |  19 +++-----
 2 files changed, 46 insertions(+), 103 deletions(-)

-- 
1.9.3
