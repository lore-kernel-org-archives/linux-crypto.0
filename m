From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC v4 0/4] crypto: Introduce Public Key Encryption API
Date: Thu, 11 Jun 2015 12:05:33 -0700
Message-ID: <20150611190533.31826.13956.stgit@tstruk-mobl1>
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
Received: from mga09.intel.com ([134.134.136.24]:41319 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbFKTFb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 15:05:31 -0400
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

Changes in v4:
 - add a rsa generic implementation
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
Tadeusz Struk (4):
      MPILIB: add mpi_get_buf(), mpi_copy() and mpi_get_size() helpers
      crypto: add PKE API
      crypto: RSA: KEYS: convert rsa and public key to new PKE API
      crypto: add tests vectors for RSA


 crypto/Kconfig             |   14 ++
 crypto/Makefile            |    2 
 crypto/akcipher.c          |  155 +++++++++++++++++
 crypto/crypto_user.c       |   23 ++
 crypto/rsa.c               |  289 +++++++++++++++++++++++++++++++
 crypto/testmgr.c           |  164 ++++++++++++++++++
 crypto/testmgr.h           |  142 +++++++++++++++
 include/crypto/akcipher.h  |  408 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/crypto.h     |    1 
 include/linux/cryptouser.h |    6 +
 include/linux/mpi.h        |    3 
 lib/mpi/mpicoder.c         |   85 +++++++--
 lib/mpi/mpiutil.c          |   46 +++++
 13 files changed, 1319 insertions(+), 19 deletions(-)
 create mode 100644 crypto/akcipher.c
 create mode 100644 crypto/rsa.c
 create mode 100644 include/crypto/akcipher.h
-- 
