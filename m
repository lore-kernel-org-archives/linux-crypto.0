From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v2 0/2] crypto: Introduce Public Key Encryption API
Date: Wed, 06 May 2015 12:36:43 -0700
Message-ID: <20150506193643.9329.75351.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, tadeusz.struk@intel.com,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbbEFTj5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 May 2015 15:39:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set introduces a Public Key Encryption API.
What is proposed is a new crypto type called crypto_pkey_type
plus new struct pkey_alg and struct pkey_tfm together with number
of helper functions to register pkey type algorithms and allocate
tfm instances. This is to make it similar to how the existing crypto
API works for the ablkcipher, ahash, and aead types.
The operations the new interface will allow to provide are:

	int (*sign)(struct pkey_request *pkeyreq);
	int (*verify)(struct pkey_request *pkeyreq);
	int (*encrypt)(struct pkey_request *pkeyreq);
	int (*decrypt)(struct pkey_request *pkeyreq);

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

New helper functions have been added to allocate pkey_tfm instances
and invoke the operations to make it easier to use.
For instance to verify a public_signature against a public_key using
the RSA algorithm a user would do:

	struct crypto_pkey *tfm = crypto_alloc_pkey("rsa", 0, 0);
	struct pkey_request *req = pkey_request_alloc(tfm, GFP_KERNEL);
	pkey_request_set_crypt(req, pub_key, signature);
	int ret = crypto_pkey_verify(req);
	pkey_request_free(req);
	crypto_free_pkey(tfm);
	return ret;

Additionally existing public_key and rsa code have been reworked to
use the new interface for verifying signed modules.
As part of the rework the struct public_key_algorithm type has been removed.
Algorithm instance is allocated using crypto_alloc_pkey() and name defined in
pkey_algo_name table indexed by pkey_algo enum that comes from the public key.
In future this can be replaced by the name can be obtained directly from
the public key cert.

Changes in v2:
 - remodeled not to use obsolete cra_u and crt_u unions
 - changed type/funct names from pke_* to pkey_*
 - retained the enum pkey_algo type for it is external to the kernel
 - added documentation

---
Tadeusz Struk (2):
      crypto: add PKEY API
      crypto: RSA: KEYS: convert rsa and public key to new PKEY API


 crypto/Kconfig                            |    6 
 crypto/Makefile                           |    1 
 crypto/asymmetric_keys/Kconfig            |    1 
 crypto/asymmetric_keys/pkcs7_parser.c     |    2 
 crypto/asymmetric_keys/pkcs7_trust.c      |    2 
 crypto/asymmetric_keys/pkcs7_verify.c     |    3 
 crypto/asymmetric_keys/public_key.c       |   89 ++++---
 crypto/asymmetric_keys/public_key.h       |   36 ---
 crypto/asymmetric_keys/rsa.c              |   43 ++-
 crypto/asymmetric_keys/x509_cert_parser.c |    3 
 crypto/asymmetric_keys/x509_public_key.c  |    6 
 crypto/crypto_user.c                      |   24 ++
 crypto/pkey.c                             |  125 +++++++++
 include/crypto/pkey.h                     |  390 +++++++++++++++++++++++++++++
 include/crypto/public_key.h               |   10 -
 include/linux/crypto.h                    |    1 
 include/linux/cryptouser.h                |    7 +
 17 files changed, 657 insertions(+), 92 deletions(-)
 delete mode 100644 crypto/asymmetric_keys/public_key.h
 create mode 100644 crypto/pkey.c
 create mode 100644 include/crypto/pkey.h
-- 
