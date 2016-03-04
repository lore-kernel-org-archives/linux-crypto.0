From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] KEYS: Miscellaneous bits for security/next
Date: Fri, 04 Mar 2016 00:07:19 +0000
Message-ID: <2434.1457050039@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-ID: <2433.1457050039.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

Could you pull this into security/next, please?

The most important patches here are the ones that deal with making the
asymmetric key software public key subtype use the akcipher crypto API for
the actual public key algorithm.

But there are also:

 (1) Allow space to be reserved for extra certificate insertion in the
     unsigned kernel image.

 (2) Allow modules to be signed with a raw signature.

 (3) Allow utilities to be built with LibreSSL instead of OpenSSL.

 (4) Fix X.509 time & date parsing.

 (5) Use text-based identifiers within the public key code instead of
     enums.
 
Plus other small fixes.

Thanks,
David
---
The following changes since commit 388f7b1d6e8ca06762e2454d28d6c3c55ad0fe95:

  Linux 4.5-rc3 (2016-02-07 15:38:30 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20160303

for you to fetch changes up to 4e8ae72a75aae285ec5b93518b9680da198afd0d:

  X.509: Make algo identifiers text instead of enum (2016-03-03 21:49:27 +0000)

----------------------------------------------------------------
Keyrings changes for next

----------------------------------------------------------------
Arnd Bergmann (1):
      modsign: hide openssl output in silent builds

Codarren Velvindron (1):
      v2 linux-next scripts/sign-file.c Fix LibreSSL support

Colin Ian King (1):
      PKCS#7: fix unitialized boolean 'want'

David Howells (10):
      KEYS: Add an alloc flag to convey the builtinness of a key
      KEYS: CONFIG_KEYS_DEBUG_PROC_KEYS is no longer an option
      X.509: Fix leap year handling again
      Handle ISO 8601 leap seconds and encodings of midnight in mktime64()
      X.509: Support leap seconds
      X.509: Handle midnight alternative notation in GeneralizedTime
      certs: Fix misaligned data in extra certificate list
      MODSIGN: linux/string.h should be #included to get memcpy()
      akcipher: Move the RSA DER encoding check to the crypto layer
      X.509: Make algo identifiers text instead of enum

Juerg Haefliger (1):
      scripts/sign-file.c: Add support for signing with a raw signature

Marc-Antoine Perennou (1):
      sign-file: fix build with CMS support disabled

Mehmet Kayaalp (2):
      KEYS: Reserve an extra certificate symbol for inserting without recompiling
      KEYS: Use the symbol value for list size, updated by scripts/insert-sys-cert

Paul Gortmaker (1):
      security/keys: make big_key.c explicitly non-modular

Tadeusz Struk (4):
      crypto: KEYS: convert public key and digsig asym to the akcipher api
      integrity: convert digsig to akcipher api
      crypto: public_key: remove MPIs from public_key_signature struct
      crypto: Add hash param to pkcs1pad

 arch/arm/configs/colibri_pxa270_defconfig   |   1 -
 arch/arm/configs/iop13xx_defconfig          |   1 -
 arch/arm/configs/iop32x_defconfig           |   1 -
 arch/arm/configs/trizeps4_defconfig         |   1 -
 arch/microblaze/configs/mmu_defconfig       |   1 -
 arch/microblaze/configs/nommu_defconfig     |   1 -
 arch/mips/configs/bigsur_defconfig          |   1 -
 arch/mips/configs/ip22_defconfig            |   1 -
 arch/mips/configs/ip27_defconfig            |   1 -
 arch/mips/configs/ip32_defconfig            |   1 -
 arch/mips/configs/jazz_defconfig            |   1 -
 arch/mips/configs/lemote2f_defconfig        |   1 -
 arch/mips/configs/rm200_defconfig           |   1 -
 arch/mips/configs/sb1250_swarm_defconfig    |   1 -
 arch/parisc/configs/712_defconfig           |   1 -
 arch/parisc/configs/a500_defconfig          |   1 -
 arch/parisc/configs/default_defconfig       |   1 -
 arch/parisc/configs/generic-32bit_defconfig |   1 -
 arch/powerpc/configs/c2k_defconfig          |   1 -
 arch/powerpc/configs/ppc6xx_defconfig       |   1 -
 arch/score/configs/spct6600_defconfig       |   1 -
 arch/tile/configs/tilegx_defconfig          |   1 -
 arch/tile/configs/tilepro_defconfig         |   1 -
 arch/x86/configs/i386_defconfig             |   1 -
 arch/x86/configs/x86_64_defconfig           |   1 -
 certs/Kconfig                               |  16 ++
 certs/Makefile                              |  33 ++-
 certs/system_certificates.S                 |  13 +
 certs/system_keyring.c                      |   4 +-
 crypto/asymmetric_keys/Kconfig              |   7 -
 crypto/asymmetric_keys/Makefile             |   8 +-
 crypto/asymmetric_keys/mscode_parser.c      |  14 +-
 crypto/asymmetric_keys/pkcs7_parser.c       |  32 +--
 crypto/asymmetric_keys/pkcs7_trust.c        |   2 +-
 crypto/asymmetric_keys/pkcs7_verify.c       |  10 +-
 crypto/asymmetric_keys/public_key.c         | 154 +++++++----
 crypto/asymmetric_keys/public_key.h         |  36 ---
 crypto/asymmetric_keys/rsa.c                | 278 -------------------
 crypto/asymmetric_keys/verify_pefile.c      |   4 +-
 crypto/asymmetric_keys/verify_pefile.h      |   2 +-
 crypto/asymmetric_keys/x509_cert_parser.c   |  75 ++---
 crypto/asymmetric_keys/x509_public_key.c    |  34 +--
 crypto/asymmetric_keys/x509_rsakey.asn1     |   4 -
 crypto/rsa-pkcs1pad.c                       | 182 ++++++++++--
 include/crypto/public_key.h                 |  76 +-----
 include/linux/key.h                         |   1 +
 init/Kconfig                                |   2 +-
 kernel/module_signing.c                     |   7 +
 kernel/time/time.c                          |   9 +-
 scripts/.gitignore                          |   1 +
 scripts/Makefile                            |   1 +
 scripts/extract-sys-certs.pl                |  29 +-
 scripts/insert-sys-cert.c                   | 410 ++++++++++++++++++++++++++++
 scripts/sign-file.c                         | 238 ++++++++++------
 security/integrity/Kconfig                  |   2 +-
 security/integrity/digsig_asymmetric.c      |  16 +-
 security/integrity/integrity.h              |   2 +-
 security/keys/big_key.c                     |  15 +-
 security/keys/key.c                         |   2 +
 59 files changed, 999 insertions(+), 745 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 delete mode 100644 crypto/asymmetric_keys/rsa.c
 delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
 create mode 100644 scripts/insert-sys-cert.c

