From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 0/2] crypto: Introduce Public Key Encryption API
Date: Thu, 30 Apr 2015 15:36:47 -0700
Message-ID: <20150430223647.10157.82156.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: corbet@lwn.net, keescook@chromium.org, qat-linux@intel.com,
	jwboyer@redhat.com, richard@nod.at, d.kasatkin@samsung.com,
	linux-kernel@vger.kernel.org, steved@redhat.com,
	dhowells@redhat.com, vgoyal@redhat.com, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	jdelvare@suse.de, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch set introduces a Public Key Encryption API.
What is proposed is a new crypto type called crypto_pke_type
plus new struct pke_alg and struct pke_tfm together with number
of helper functions to register pke type algorithms and allocate
tfm instances. This is to make it similar to how the existing crypto
API works for the ablkcipher, ahash, and aead types.
The operations the new interface will allow to provide are:

	int (*sign)(struct pke_request *pkereq);
	int (*verify)(struct pke_request *pkereq);
	int (*encrypt)(struct pke_request *pkereq);
	int (*decrypt)(struct pke_request *pkereq);

The benefits it gives comparing to the struct public_key_algorithm
interface are:
- drivers can add many implementations of RSA or DSA
  algorithms and user will allocate instances (tfms) of these, base on
  algorithm priority, in the same way as it is with the symmetric ciphers.
- the new interface allows for asynchronous implementations that
  can use crypto hardware to offload the calculations to.
- integrating it with linux crypto api allows using all its benefits
  i.e. managing algorithms using NETLINK_CRYPTO, monitoring implementations
  using /proc/crypto. etc

New helper functions have been added to allocate pke_tfm instances
and invoke the operations to make it easier to use.
For instance to verify a public_signature against a public_key using
the RSA algorithm a user would do:

	struct crypto_pke *tfm = crypto_alloc_pke("rsa", 0, 0);
	struct pke_request *req = pke_request_alloc(tfm, GFP_KERNEL);
	pke_request_set_crypt(req, pub_key, signature);
	int ret = crypto_pke_verify(req);
	pke_request_free(req);
	crypto_free_pke(tfm);
	return ret;

Additionally existing public_key and rsa code have been reworked to
use the new interface for verifying signed modules.
As part of the rework the enum pkey_algo has been removed as the algorithm
to allocate will be indicated by a string - for instance "rsa" or "dsa",
similarly as it is with the symmetric algs e.g. "aes".
It will also make it easier to extend in the future when new algorithms
will be added.
---
Tadeusz Struk (2):
      crypto: add PKE API
      crypto: RSA: KEYS: convert rsa and public key to new PKE API


 Documentation/crypto/asymmetric-keys.txt  |   10 +-
 crypto/Kconfig                            |    6 +
 crypto/Makefile                           |    1 
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/pkcs7_parser.c     |    4 -
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    5 -
 crypto/asymmetric_keys/public_key.c       |   73 +++++++----
 crypto/asymmetric_keys/public_key.h       |   36 -----
 crypto/asymmetric_keys/rsa.c              |   47 ++++++-
 crypto/asymmetric_keys/x509_cert_parser.c |   14 ++
 crypto/asymmetric_keys/x509_public_key.c  |   14 +-
 crypto/crypto_user.c                      |   23 +++
 crypto/pke.c                              |  114 +++++++++++++++++
 include/crypto/algapi.h                   |    6 +
 include/crypto/public_key.h               |   24 +---
 include/linux/crypto.h                    |  191 +++++++++++++++++++++++++++++
 include/linux/cryptouser.h                |    7 +
 kernel/module_signing.c                   |    9 +
 19 files changed, 471 insertions(+), 116 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 crypto/pke.c

-- 
