From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [RFC PATCH 0/8] crypto: AF_ALG support for KPP
Date: Wed, 19 Apr 2017 01:03:49 +0200
Message-ID: <2715753.J0rCo2lbig@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59006 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932565AbdDRXKN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 19:10:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

This is an RFC to discuss whether and how to support access to the
KPP kernel crypto API (Diffie-Hellman and EC Diffie-Hellman) by
user space.

The patch set is only meant for discussion and not for production use.
Testing is only performed for the DH part via [1]. The DH testing shows
that the DH operation shows the same results as OpenSSL.

The patch set includes:

- addition of PKCS#3 support for DH to allow domain parameters to be set

- extension of the setsockopt and cmsg API

- addition of AF_ALG KPP interface where the implementation follows the
  exact same coding style as currently discussed for the memory management
  fix patch set for algif_skcipher and algif_aead -- this shall allow
  the immediate incorporation of patches that replace duplicated code with
  common service functions.

The patch 8 describes the different operations that are supported by AF_ALG
KPP. This support includes generation and retaining of the private key
inside the kernel. This private key would never be sent to user space.

I am aware and in fact supported development of the DH support in the keys
subsystem. The question will be raised whether the AF_ALG KPP interface is
superfluous in light of the keys DH support. My answer is that AF_ALG KPP is
orthogonal to the keys DH support. The keys DH support use case is that
the keys are managed inside the kernel and thus has the focus on the
key management. Contrary, AF_ALG KPP does not really focus on key management
but simply externalizes the DH/ECDH support found in the kernel including
hardware acceleration. User space is in full control of the key life cycle.
This way, AF_ALG could be used to complement user-space network protocol
implementations like TLS or IKE to offload the resource intense DH
calculations to accelerators.

A full description of the DH testing and how to compare it to OpenSSL
is present in [1] with the test/kcapi-main.c tool, function "kpp".

[1] https://github.com/smuellerDD/libkcapi/tree/kpp

Stephan Mueller (8):
  crypto: AF_ALG -- add DH keygen / ssgen API
  crypto: AF_ALG -- add DH param / ECDH curve setsockopt call
  crypto: AF_ALG - eliminate code duplication
  crypto: KPP - add API crypto_kpp_set_params
  crypto: DH - allow params and key to be set independently
  crypto: DH - add PKCS#3 parameter handling
  crypto: ecdh - constify key
  crypto: AF_ALG - add KPP support

 Documentation/crypto/api-kpp.rst |    2 +-
 crypto/Kconfig                   |   10 +
 crypto/Makefile                  |    8 +-
 crypto/af_alg.c                  |   17 +-
 crypto/algif_kpp.c               | 1230 ++++++++++++++++++++++++++++++++++++++
 crypto/dh.c                      |   21 +-
 crypto/dh_helper.c               |   53 +-
 crypto/dhparameter.asn1          |    4 +
 include/crypto/dh.h              |   21 +-
 include/crypto/ecdh.h            |    2 +-
 include/crypto/if_alg.h          |    2 +
 include/crypto/kpp.h             |   28 +
 include/uapi/linux/if_alg.h      |    4 +
 13 files changed, 1384 insertions(+), 18 deletions(-)
 create mode 100644 crypto/algif_kpp.c
 create mode 100644 crypto/dhparameter.asn1

-- 
2.9.3
