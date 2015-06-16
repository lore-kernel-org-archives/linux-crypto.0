From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v7 0/3] crypto: Introduce Public Key Encryption API
Date: Tue, 16 Jun 2015 10:30:50 -0700
Message-ID: <20150616173050.1248.21847.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	tadeusz.struk@intel.com, steved@redhat.com, qat-linux@intel.com,
	dhowells@redhat.com, linux-crypto@vger.kernel.org,
	james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net, vgoyal@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62566 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440AbbFPRa4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 13:30:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch set introduces a Public Key Encryption API.
What is proposed is a new crypto type called crypto_akcipher_type,
plus new struct akcipher_alg and struct crypto_akcipher, together with number
of helper functions to register akcipher type algorithms and allocate
tfm instances. This is to make it similar to how the existing crypto
API works for the ablkcipher, ahash, and aead types.
The operations the new interface will allow to provide are:

	int (*sign)(struct akcipher_request *req);
	int (*verify)(struct akcipher_request *req);
	int (*encrypt)(struct akcipher_request *req);
	int (*decrypt)(struct akcipher_request *req);

The benefits it gives interface are:
- drivers can add many implementations of RSA or DSA
  algorithms and user will allocate instances (tfms) of these, base on
  algorithm priority, in the same way as it is with the symmetric ciphers.
- the new interface allows for asynchronous implementations that
  can use crypto hardware to offload the calculations to.
- integrating it with linux crypto api allows using all its benefits
  i.e. managing algorithms using NETLINK_CRYPTO, monitoring implementations
  using /proc/crypto. etc

New helper functions have been added to allocate crypto_akcipher instances
and invoke the operations to make it easier to use.
For instance to verify a public_signature against a public_key using
the RSA algorithm a user would do:

	struct crypto_akcipher *tfm = crypto_alloc_akcipher("rsa", 0, 0);
	struct akcipher_request *req = akcipher_request_alloc(tfm, GFP_KERNEL);
	akcipher_request_set_crypt(req, pub_key, signature);
	int ret = crypto_akcipher_verify(src, dst, src_len, dst_len, &res_len);
	akcipher_request_free(req);
	crypto_free_akcipher(tfm);
	return ret;

Changes in v7:
 - change req->dst_len to be int instead of int *
 - remove result_len from comments - it's not longer there
 - use crypto_akcipher_reqtfm helper instead of __crypto_akcipher_tfm
 - fix memleak in rsa.c
 - change error code to -EOVERFLOW if dst buf is not big enough
 - drop redundant cra_ctxsize inits
 - add type-safe init/exit functions
 - cleanup headers in rsa_helpers
 - remove checks for NULL before mpi_free

Changes in v6:
 - in FIPS mode only allow key sizes 2K & 3K
 - remove result_len and use dst_len as in/out param
 - remove subtype from akcipher reports
 - store rsa_key in tfm ctx and change ras_parse_key to take struct rsa_key
   instead of tfm. 
 - export rsa_free_key, which free memory allocated by ras_parse_key.
 - split akcipher.h into public and internal with public key specific helpers
 - remove maxsize() and set the required size in enc/dec/sign/verify instead
 - add public key vector
 - split AKCIPHER into AKCIPHER and AKCIPHER2 in Kconfig
 - remove MPI patch from the series - already applied

Changes in v5:
 - make mpi_get_size() function inline.
 - add a setkey function to the algorithm and rsa_parse_key() helper to
   parse rsa keys from BER encoded to MPI. The helper will also validate
   the given key if it is strong enough in case FIPS mode is enabled.
 - change the format of the key from struct public_key * to void * BER encoded
   buffer.
 - change the format of the rsa keys in testmgr to BER encoded form.
 - change mpi_free to use kzfree instead of kfree because it is used to free
   crypto keys

Changes in v4:
 - add an rsa generic implementation
 - don't convert the existing public_key implementation to the new interface.
   This will be done after the new interface is accepted.
 - add new mpi_get_buf(), mpi_copy() and mpi_get_size() mpi helpers 
 - on set key the ftm now will clone the key instead of just setting a ptr
 - add a check on enc/dec/sign/veryfi to make sure a valid (public or private)
   key is setup
 - add maxsize fn into algorith that will be used to query implementation
   what is the max size of a result for a give public key that the user needs
   to allocate
 - removed private ctx from crypto_akcipher as the crypto_tfm base has one
   already
 - add 2K bit RSA test vectors
 - add cipher text validation in crypto test mgr as (required for FIPS)

Changes in v3:
 - changed input and output parameters type from sgl to void *
   and added separate src_len & dst_len - requested by Herbert Xu
 - separated rsa implementation into cryptographic primitives and
   left encryption scheme details outside of the algorithm implementation
 - added SW implementation for RSA encrypt, decrypt and sign operation
 - added RSA test vectors 
   
Changes in v2:
 - remodeled not to use obsolete cra_u and crt_u unions
 - changed type/funct names from pke_* to pkey_*
 - retained the enum pkey_algo type for it is external to the kernel
 - added documentation

---
Tadeusz Struk (3):
      crypto: add PKE API
      crypto: rsa: add a new rsa generic implementation
      crypto: add tests vectors for RSA


 crypto/Kconfig                     |   19 ++
 crypto/Makefile                    |    9 +
 crypto/akcipher.c                  |  117 ++++++++++++
 crypto/crypto_user.c               |   22 ++
 crypto/rsa.c                       |  316 +++++++++++++++++++++++++++++++++
 crypto/rsa_helper.c                |  121 +++++++++++++
 crypto/rsakey.asn1                 |    5 +
 crypto/testmgr.c                   |  156 +++++++++++++++++
 crypto/testmgr.h                   |  187 ++++++++++++++++++++
 include/crypto/akcipher.h          |  340 ++++++++++++++++++++++++++++++++++++
 include/crypto/internal/akcipher.h |   60 ++++++
 include/crypto/internal/rsa.h      |   27 +++
 include/linux/crypto.h             |    1 
 include/linux/cryptouser.h         |    5 +
 14 files changed, 1385 insertions(+)
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/rsa.c
 create mode 100644 crypto/rsa_helper.c
 create mode 100644 crypto/rsakey.asn1
 create mode 100644 include/crypto/akcipher.h
 create mode 100644 include/crypto/internal/akcipher.h
 create mode 100644 include/crypto/internal/rsa.h
-- 
