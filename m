Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbeKLUUP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 15:20:15 -0500
From: Roberto Sassu <roberto.sassu@huawei.com>
To: <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH 00/12] keys: add support for PGP keys and signatures
Date: Mon, 12 Nov 2018 11:24:11 +0100
Message-ID: <20181112102423.30415-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set is based on kernel/git/dhowells/linux-modsign.git
(branch: pgp-parser) at git.kernel.org.

The goal of this patch set is to add support for PGP keys and signatures,
so that it will be possible to verify RPM header signatures (included in
RPM-based Linux distributions) when IMA Appraisal is enabled.

The patch set includes two preliminary patches: the first introduces
mpi_key_length(), to get the number of bits and bytes of an MPI; the second
introduces rsa_parse_priv_key_raw() and rsa_parse_pub_key_raw(), to parse
an RSA key in RAW format if the ASN.1 parser returns an error.

The remaining of the patch set includes the original patches with
modifications to work with the current kernel. It additionally introduces
verify_pgp_signature(), to verify PGP signatures with built-in or secondary
trusted keys. Trusted keys can be included in the kernel by enabling
CONFIG_PGP_PRELOAD_PUBLIC_KEYS and by copying the file pubring.gpg
containing the PGP keyring to the kernel source directory.

The changelog is included in the description of each patch.

David Howells (8):
  PGPLIB: PGP definitions (RFC 4880)
  PGPLIB: Basic packet parser
  PGPLIB: Signature parser
  KEYS: PGP data parser
  KEYS: Provide PGP key description autogeneration
  KEYS: PGP-based public key signature verification
  PGP: Provide a key type for testing PGP signatures
  KEYS: Provide a function to load keys from a PGP keyring blob

Roberto Sassu (4):
  mpi: introduce mpi_key_length()
  rsa: add parser of raw format
  verification: introduce verify_pgp_signature()
  KEYS: Introduce load_pgp_public_keyring()

 certs/Kconfig                           |   7 +
 certs/Makefile                          |   3 +
 certs/system_keyring.c                  |  64 +++
 crypto/asymmetric_keys/Kconfig          |  38 ++
 crypto/asymmetric_keys/Makefile         |  15 +
 crypto/asymmetric_keys/pgp_library.c    | 625 ++++++++++++++++++++++++
 crypto/asymmetric_keys/pgp_parser.h     |  22 +
 crypto/asymmetric_keys/pgp_preload.c    | 118 +++++
 crypto/asymmetric_keys/pgp_public_key.c | 380 ++++++++++++++
 crypto/asymmetric_keys/pgp_signature.c  | 428 ++++++++++++++++
 crypto/asymmetric_keys/pgp_test_key.c   | 132 +++++
 crypto/rsa.c                            |  14 +-
 crypto/rsa_helper.c                     |  69 +++
 include/crypto/internal/rsa.h           |   6 +
 include/linux/mpi.h                     |   2 +
 include/linux/pgp.h                     | 215 ++++++++
 include/linux/pgp_sig.h                 |  24 +
 include/linux/pgplib.h                  |  87 ++++
 include/linux/verification.h            |   5 +
 lib/mpi/mpicoder.c                      |  33 +-
 20 files changed, 2276 insertions(+), 11 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pgp_library.c
 create mode 100644 crypto/asymmetric_keys/pgp_parser.h
 create mode 100644 crypto/asymmetric_keys/pgp_preload.c
 create mode 100644 crypto/asymmetric_keys/pgp_public_key.c
 create mode 100644 crypto/asymmetric_keys/pgp_signature.c
 create mode 100644 crypto/asymmetric_keys/pgp_test_key.c
 create mode 100644 include/linux/pgp.h
 create mode 100644 include/linux/pgp_sig.h
 create mode 100644 include/linux/pgplib.h

-- 
2.17.1
