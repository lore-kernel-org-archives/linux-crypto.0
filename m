From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Fri, 21 Oct 2016 04:53:45 +0200
Message-ID: <2053893.WjF01BJSDF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

the attached patch set converts the existing crypto API documentation
from DocBook to Sphinx.

The first two patch sets perform the conversion without changes to the
content of the documentation. Starting with patch 3, fixes and
enhancements are applied.

A full review of the new kernel crypto API documentation is found
at [1].

[1] http://www.chronox.de/crypto-API/index.html

Changes v2:
 * Mark bullet list for AEAD memory structure appropriately header file
 * Mark inline function appropriately
 * add patch to optimize compilation of documentation

Stephan Mueller (8):
  crypto: doc - convert crypto API documentation to Sphinx
  crypto: doc - remove crypto API DocBook
  crypto: doc - fix source comments for Sphinx
  crypto: doc - fix separation of cipher / req API
  crypto: doc - add KPP documentation
  crypto: doc - remove crypto_alloc_ablkcipher
  crypto: doc - clarify AEAD memory structure
  crypto: doc - optimize compilation

 Documentation/DocBook/Makefile        |    2 +-
 Documentation/DocBook/crypto-API.tmpl | 2092 ---------------------------------
 Documentation/crypto/api-aead.rst     |   23 +
 Documentation/crypto/api-akcipher.rst |   20 +
 Documentation/crypto/api-digest.rst   |   35 +
 Documentation/crypto/api-kpp.rst      |   38 +
 Documentation/crypto/api-rng.rst      |   14 +
 Documentation/crypto/api-samples.rst  |  224 ++++
 Documentation/crypto/api-skcipher.rst |   62 +
 Documentation/crypto/api.rst          |   25 +
 Documentation/crypto/architecture.rst |  441 +++++++
 Documentation/crypto/devel-algos.rst  |  247 ++++
 Documentation/crypto/index.rst        |   24 +
 Documentation/crypto/intro.rst        |   74 ++
 Documentation/crypto/userspace-if.rst |  387 ++++++
 Documentation/index.rst               |    1 +
 crypto/algif_aead.c                   |   14 +-
 include/crypto/aead.h                 |   50 +-
 include/crypto/dh.h                   |   58 +
 include/crypto/ecdh.h                 |   58 +
 include/crypto/hash.h                 |    2 +-
 include/crypto/kpp.h                  |   15 +-
 include/crypto/skcipher.h             |    4 +-
 include/linux/crypto.h                |    4 +-
 24 files changed, 1770 insertions(+), 2144 deletions(-)
 delete mode 100644 Documentation/DocBook/crypto-API.tmpl
 create mode 100644 Documentation/crypto/api-aead.rst
 create mode 100644 Documentation/crypto/api-akcipher.rst
 create mode 100644 Documentation/crypto/api-digest.rst
 create mode 100644 Documentation/crypto/api-kpp.rst
 create mode 100644 Documentation/crypto/api-rng.rst
 create mode 100644 Documentation/crypto/api-samples.rst
 create mode 100644 Documentation/crypto/api-skcipher.rst
 create mode 100644 Documentation/crypto/api.rst
 create mode 100644 Documentation/crypto/architecture.rst
 create mode 100644 Documentation/crypto/devel-algos.rst
 create mode 100644 Documentation/crypto/index.rst
 create mode 100644 Documentation/crypto/intro.rst
 create mode 100644 Documentation/crypto/userspace-if.rst

-- 
2.7.4


