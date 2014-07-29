From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 0/2] Add TLS record layer encryption module
Date: Tue, 29 Jul 2014 12:32:31 +0300
Message-ID: <1406626353-23309-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi all,

This set of patches introduces support for TLS 1.0 record layer
encryption/decryption with a corresponding algorithm called
tls10(hmac(<hash>),cbc(<cipher>)).

Similarly to authenc.c on which it is based, this module mixes the base
algorithms in software to produce an algorithm that does record layer
encryption and decryption for TLS1.0.
Any combination of hw and sw base algorithms is possible, but the purpose
is to take advantage of hardware acceleration for TLS record layer offloading
when hardware acceleration is present.

This is a software alternative to forthcoming Freescale caam patches that
will add support for one-pass hardware-only TLS record layer offloading.

Performance figures depend largely on several factors including hardware
support and record layer size. For user-space applications the
kernel/user-space interface is also important. That said, we have done several
performance tests using openssl and cryptodev on Freescale QorIQ platforms.
On P4080, for a single stream of records larger than 512 bytes, the performance
improved from about 22Mbytes/s to 64Mbytes/s while also reducing CPU load.

The purpose of this module is to enable TLS kernel offloading on hw platforms
that have acceleration for AES/SHA1 but do not have direct support for TLS
record layer.

(minor dependency on pending patch
  crypto: testmgr.c: white space fix-ups on test_aead)

Cristian Stoica (2):
  crypto: add support for TLS 1.0 record encryption
  crypto: add TLS 1.0 test vectors for AES-CBC-HMAC-SHA1

 crypto/Kconfig           |  20 ++
 crypto/Makefile          |   1 +
 crypto/authenc.c         |   5 +-
 crypto/tcrypt.c          |   5 +
 crypto/testmgr.c         |  41 +++-
 crypto/testmgr.h         | 217 +++++++++++++++++++
 crypto/tls.c             | 528 +++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/authenc.h |   3 +
 8 files changed, 808 insertions(+), 12 deletions(-)
 create mode 100644 crypto/tls.c

-- 
1.8.3.1
