From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 00/11] crypto: Documentation of kernel crypto API
Date: Sun, 02 Nov 2014 21:34:22 +0100
Message-ID: <6375771.bx7QqLJLuR@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

The following patch set adds documentation files under Documentation/crypto/
covering the high-level description of the API. In addition, it contains
source code comments added to the header files of the kernel crypto API
documenting the API functions.

Changes v2:
 * Split out the user space documentation into separate document including
   the user space example code
 * Change the license of the user space interface code to match the license
   of the code that I used as a reference.
 * Addition of a precise pointer to the user space interface code reference
   code.
 * Add a missing memset(0) to the user space example code.
 * Move the API function call documentation into the header files in the hope
   for a better maintainability.
 * Merge the developer-related documentation from Marek Vasut 

Stephan Mueller (11):
  crypto: Documentation - crypto API high level spec
  crypto: Documentation - userspace interface spec
  crypto: Documentation - RNG API documentation
  crypto: Documentation - AHASH API documentation
  crypto: Documentation - SHASH API documentation
  crypto: Documentation - documentation of crypto_alg
  crypto: Documentation - ABLKCIPHER API documentation
  crypto: Documentation - AEAD API documentation
  crypto: Documentation - BLKCIPHER API documentation
  crypto: Documentation - CIPHER API documentation
  crypto: Documentation - HASH API documentation

 Documentation/crypto/crypto-API-spec.txt      |  721 ++++++++++++++
 Documentation/crypto/crypto-API-userspace.txt |  662 +++++++++++++
 include/crypto/hash.h                         |  421 +++++++++
 include/crypto/rng.h                          |  113 +++
 include/linux/crypto.h                        | 1239 ++++++++++++++++++++++++-
 5 files changed, 3136 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/crypto/crypto-API-spec.txt
 create mode 100644 Documentation/crypto/crypto-API-userspace.txt

-- 
2.1.0
