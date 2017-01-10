From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Tue, 10 Jan 2017 02:36:21 +0100
Message-ID: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55410 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941456AbdAJBmV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

to all driver maintainers: the patches I added are compile tested, but
I do not have the hardware to verify the code. May I ask the respective
hardware maintainers to verify that the code is appropriate and works
as intended? Thanks a lot.

Herbert, this is my proprosal for our discussion around copying the
AAD for algif_aead. Instead of adding the code to algif_aead and wait
until it transpires to all cipher implementations, I thought it would
be more helpful to fix all cipher implementations.

To do so, the AAD copy function found in authenc is extracted to a global
service function. Furthermore, the generic AEAD TFM initialization code
now allocates the null cipher too. This allows us now to only invoke
the AAD copy function in the various implementations without any additional
allocation logic.

The code for x86 and the generic code was tested with libkcapi.

The code for the drivers is compile tested for drivers applicable to
x86 only. All others are neither compile tested nor functionally tested.

Stephan Mueller (13):
  crypto: service function to copy AAD from src to dst
  crypto: gcm_generic - copy AAD during encryption
  crypto: ccm_generic - copy AAD during encryption
  crypto: rfc4106-gcm-aesni - copy AAD during encryption
  crypto: ccm-aes-ce - copy AAD during encryption
  crypto: talitos - copy AAD during encryption
  crypto: picoxcell - copy AAD during encryption
  crypto: ixp4xx - copy AAD during encryption
  crypto: atmel - copy AAD during encryption
  crypto: caam - copy AAD during encryption
  crypto: chelsio - copy AAD during encryption
  crypto: nx - copy AAD during encryption
  crypto: qat - copy AAD during encryption

 arch/arm64/crypto/aes-ce-ccm-glue.c      |  4 ++++
 arch/x86/crypto/aesni-intel_glue.c       |  5 +++++
 crypto/Kconfig                           |  4 ++--
 crypto/aead.c                            | 36 ++++++++++++++++++++++++++++++--
 crypto/authenc.c                         | 36 ++++----------------------------
 crypto/ccm.c                             | 10 +++++++++
 crypto/gcm.c                             | 17 +++++++++++++++
 drivers/crypto/atmel-aes.c               |  6 ++++++
 drivers/crypto/caam/caamalg.c            |  8 +++++++
 drivers/crypto/chelsio/chcr_algo.c       |  5 +++++
 drivers/crypto/ixp4xx_crypto.c           |  6 ++++++
 drivers/crypto/nx/nx-aes-ccm.c           |  4 ++++
 drivers/crypto/nx/nx-aes-gcm.c           | 10 +++++++++
 drivers/crypto/picoxcell_crypto.c        |  5 +++++
 drivers/crypto/qat/qat_common/qat_algs.c |  4 ++++
 drivers/crypto/talitos.c                 |  5 +++++
 include/crypto/aead.h                    |  2 ++
 include/crypto/internal/aead.h           | 12 +++++++++++
 18 files changed, 143 insertions(+), 36 deletions(-)

-- 
2.9.3
