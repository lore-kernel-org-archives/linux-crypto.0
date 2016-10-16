From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/7] Conversion crypto API documentation to Sphinx
Date: Sun, 16 Oct 2016 05:15:16 +0200
Message-ID: <2721226.4nLlHD9uQ6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53532 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752203AbcJPD27 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Oct 2016 23:28:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

the attached patch set converts the existing crypto API documentation
from DocBook to Sphinx.

The first two patch sets perform the conversion without changes to the
content of the documentation. Starting with patch 3, fixes and
enhancements are applied.

A full review of the new kernel crypto API documentation is found
at [1].

[1] http://www.chronox.de/crypto-API/index.html

Stephan Mueller (7):
  crypto: doc - convert crypto API documentation to Sphinx
  crypto: doc - remove crypto API DocBook
  crypto: doc - fix source comments for Sphinx
  crypto: doc - fix separation of cipher / req API
  crypto: doc - add KPP documentation
  crypto: doc - remove crypto_alloc_ablkcipher
  crypto: doc - clarify AEAD memory structure

 Documentation/DocBook/Makefile        |    2 +-
 Documentation/DocBook/crypto-API.tmpl | 2092 ---------------------------------
 Documentation/crypto/api-aead.rst     |   68 ++
 Documentation/crypto/api-akcipher.rst |   57 +
 Documentation/crypto/api-digest.rst   |  122 ++
 Documentation/crypto/api-kpp.rst      |   92 ++
 Documentation/crypto/api-rng.rst      |   32 +
 Documentation/crypto/api-samples.rst  |  224 ++++
 Documentation/crypto/api-skcipher.rst |  200 ++++
 Documentation/crypto/api.rst          |   25 +
 Documentation/crypto/architecture.rst |  441 +++++++
 Documentation/crypto/devel-algos.rst  |  247 ++++
 Documentation/crypto/index.rst        |   24 +
 Documentation/crypto/intro.rst        |   74 ++
 Documentation/crypto/userspace-if.rst |  387 ++++++
 Documentation/index.rst               |    1 +
 crypto/algif_aead.c                   |   14 +-
 include/crypto/aead.h                 |   49 +-
 include/crypto/dh.h                   |   58 +
 include/crypto/ecdh.h                 |   58 +
 include/crypto/hash.h                 |    2 +-
 include/crypto/kpp.h                  |   15 +-
 include/crypto/skcipher.h             |    4 +-
 include/linux/crypto.h                |    4 +-
 24 files changed, 2148 insertions(+), 2144 deletions(-)
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
