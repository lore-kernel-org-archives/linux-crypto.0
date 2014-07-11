From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/2] Fix build break on dependency from CRYPTO
Date: Fri, 11 Jul 2014 18:59:43 +0300
Message-ID: <cover.1405094060.git.d.kasatkin@samsung.com>
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I got a message from random config robot that he found a build break...
It happens because certain modules which are compiled as builtin depends
on CRYPTO=m and select required components as modules instead of making
them builtin. Here is couple of patches to fix it.

config: i386-randconfig-c1-07060441 (attached as .config)

All error/warnings:

   security/built-in.o: In function `asymmetric_verify':
   >> (.text+0x75b6): undefined reference to `mpi_read_raw_data'
      security/built-in.o: In function `asymmetric_verify':
   >> (.text+0x75d8): undefined reference to `mpi_free'
         crypto/built-in.o: In function `public_key_destroy':
    >> (.text+0x383): undefined reference to `mpi_free'
	    crypto/built-in.o: In function `RSA_verify_signature':
    >> rsa.c:(.text+0x474): undefined reference to `mpi_get_nbits'
    >> rsa.c:(.text+0x481): undefined reference to `mpi_get_nbits'
    >> rsa.c:(.text+0x491): undefined reference to `mpi_cmp_ui'
    >> rsa.c:(.text+0x49f): undefined reference to `mpi_cmp'
    >> rsa.c:(.text+0x4aa): undefined reference to `mpi_alloc'
    >> rsa.c:(.text+0x4c4): undefined reference to `mpi_powm'
    >> rsa.c:(.text+0x4d2): undefined reference to `mpi_free'
    >> rsa.c:(.text+0x4f1): undefined reference to `mpi_free'
    >> rsa.c:(.text+0x52e): undefined reference to `mpi_get_nbits'
    >> rsa.c:(.text+0x54a): undefined reference to `mpi_get_buffer'
    >> rsa.c:(.text+0x5fb): undefined reference to `__crypto_memneq'
    >> rsa.c:(.text+0x618): undefined reference to `__crypto_memneq'
       crypto/built-in.o: In function `x509_free_certificate':
    >> (.text+0x90a): undefined reference to `mpi_free'
         crypto/built-in.o: In function `x509_cert_parse':
    >> (.text+0x986): undefined reference to `asn1_ber_decoder'
      crypto/built-in.o: In function `x509_cert_parse':
    >> (.text+0x9a1): undefined reference to `asn1_ber_decoder'
        crypto/built-in.o: In function `x509_note_OID':
    >> (.text+0x9e4): undefined reference to `look_up_OID'
	   crypto/built-in.o: In function `x509_note_OID':
   >> (.text+0xa01): undefined reference to `sprint_oid'
       crypto/built-in.o: In function `rsa_extract_mpi':


- Dmitry

Dmitry Kasatkin (2):
  asymmetric_keys: make crypto builtin if asymmetric keys selected as
    builtin
  digsig: make crypto builtin if digsig selected as builtin

 crypto/Kconfig                 | 6 +++++-
 crypto/asymmetric_keys/Kconfig | 2 ++
 lib/Kconfig                    | 3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

-- 
1.9.1

