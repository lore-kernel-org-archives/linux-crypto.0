From: =?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
Subject: [PATCH 1/4] User-space API definition
Date: Thu,  5 Aug 2010 22:17:54 +0200
Message-ID: <1281039477-29703-2-git-send-email-mitr@redhat.com>
References: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org,
	=?UTF-8?q?Miloslav=20Trma=C4=8D?= <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760111Ab0HEUSU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 16:18:20 -0400
In-Reply-To: <1281039477-29703-1-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch introduces the new user-space API, <ncr.h>.

Quick overview:

* open("/dev/crypto") to get a FD, which acts as a namespace for key and
  session identifiers.

* ioctl(NCRIO_KEY_INIT) to allocate a key object; then generate the key
  material inside the kernel, load a plaintext key, unwrap a key, or derive a
  key.  Similarly the key material can be copied out of the kernel or wrapped.

* ioctl(NCRIO_SESSION_INIT) to allocate a crypto session (to encrypt, decrypt,
  hash, sign, or verify signature), the ioctl(NCRIO_SESSION_UPDATE) to act
  on chunks of data.  Deallocate the session, and optionally retrieve session
  results (e.g. hash or signature), using ioctl(NCRIO_SESSION_FINAL).

  There is also NCRIO_SESSION_ONCE for an one-shot crypto operation using
  a single user->kernel context switch.

Full documentation of the interface follows.


NAME
       /dev/crypto - kernel cryptographic module interface

SYNOPSIS
       #include <ncr.h>
       int fd = open("/dev/crypto", O_RDWR);
       int res = ioctl(fd, NCRIO..., &data);

DESCRIPTION
       The  /dev/crypto device file provides an ioctl(2) interface to the ker-
       nel-space crypto implementation.

       Each open(2) of the /dev/crypto file establishes a  separate  namespace
       within  which  crypto  operations  work.   The  namespace can be shared
       across threads and processes by  sharing  the  open  file  description.
       Last  close  of  the  open  file description automatically destroys all
       objects allocated within the namespace.

       All ioctl(2)s have the same form: The user sets  up  a  data  structure
       with  input  data,  and  passes  a pointer to the data structure as the
       third parameter to ioctl(2).  On success, output data is  available  in
       the same structure.

       The following operations are defined:

       NCRIO_KEY_INIT
              Allocate  a  kernel-space key object.  The parameter is not used
              on input (key attributes are set later, when the key material is
              initialized).   On  success,  an  integer descriptor for the key
              object (valid  within  the  current  /dev/crypto  namespace)  is
              stored in the provided area.

              There is a per-process and per-user (not per-namespace) limit on
              the number key objects that can be allocated.

       NCRIO_KEY_DEINIT
              Deallocate a kernel-space key object.  The  parameter  specifies
              the integer descriptor of the key object.  After all other oper-
              ations using this key object (if any) terminate, the  key  mate-
              rial  will  be  cleared and the object will be freed.  Note that
              this may happen both before this operation returns, and after it
              returns, depending on other references to this key object.

       NCRIO_KEY_GENERATE
              Clear  existing  key  material  in the specified key object, and
              generate new key material.

              The parameter points to struct ncr_key_generate_st, which speci-
              fies:

              desc   The key descriptor

              params.algorithm
                     The crypto algorithm with which the key will be used

              params.keyflags
                     Key  flags, a combination of NCR_KEY_FLAG_EXPORTABLE (the
                     key material can be exported in plaintext to user  space)
                     and  NCR_KEY_FLAG_WRAPPABLE  (the  key  material  can  be
                     wrapped and the result made available to user space).

              params.params
                     Algorithm-specific key parameters:  For  symmetric  keys,
                     key  length  in  bits.  For RSA keys, the public exponent
                     and modulus length in bits.  For DSA keys, p and q length
                     in bits.  For DH keys, the prime and group generator.

              Currently only symmetric keys can be generated using this opera-
              tion.

              In addition to generating the key material, the "persistent" key
              ID is reset to a random value.

       NCRIO_KEY_GENERATE_PAIR
              Similar to NCRIO_KEY_GENERATE, except that a pair of public/pri-
              vate keys is generated.

              The parameter points to struct ncr_key_generate_st as  specified
              above,  with the additional member desc2 used to specify the key
              descriptor for the public key.

              The NCR_KEY_FLAG_EXPORTABLE and NCR_KEY_FLAG_WRAPPABLE flags are
              automatically set on the public key.

       NCRIO_KEY_DERIVE
              Derive a new key using one key and additional data.

              The  parameter  points  to  struct ncr_key_derivation_params_st,
              which specifies:

              derive The derivation algorithm.  Currently  only  NCR_DERIVE_DH
                     is supported.

              newkey The descriptor of the resulting key

              keyflags
                     Flags to use for the resulting key

              key    The source key descriptor

              params Key   type-specific   parameters.    For   NCR_DERIVE_DH,
                     params.params.dh.pub and params.params.dh.pub_size  spec-
                     ify the peer's public key.

       NCRIO_KEY_EXPORT

              Export  key  material in the specified key object to user space.
              Only keys with the NCR_KEY_FLAG_EXPORTABLE flag can be  exported
              using this operation.

              The parameter points to struct ncr_key_data_st, which specifies:

              key    The key descriptor

              idata  Destination buffer

              idata_size
                     Buffer size

              Symmetric keys are written directly into the destination buffer.
              Public and private keys are formatted using ASN.1, except for DH
              public keys, which are written a raw binary number.

              On success, the idata_size member is set  to  the  size  of  the
              exported key.

       NCRIO_KEY_IMPORT
              Clear  existing  key  material  in the specified key object, and
              import key material from user space.

              The parameter points to struct ncr_key_data_st, which specifies:

              key    The key descriptor

              idata  Source data

              idata_size
                     Source data size

              key_id New "persistent" key ID.

              key_id_size
                     Size of data in key_id.

              type   Key type, one of NCR_KEY_TYPE_SECRET, NCR_KEY_TYPE_PUBLIC
                     and NCR_KEY_TYPE_PRIVATE.

              algorithm
                     The crypto algorithm with which the key will be used

              flags  Key flags

              The data format is the same as in  the  NCRIO_KEY_EXPORT  opera-
              tion.

       NCRIO_KEY_GET_INFO
              Get metadata of an existing key.

              The  parameter points to struct ncr_key_info_st, which specifies
              key, the key descriptor.  On success, the following members  are
              set:

              flags  Key flags

              type   Key type

              algorithm
                     Key algorithm

       NCRIO_KEY_WRAP
              Wrap  one key using another, and write the result to user space.
              Only keys with the NCR_KEY_FLAG_WRAPPABLE flag  can  be  wrapped
              using this operation.

              The parameter points to struct ncr_key_wrap_st, which specifies:

              algorithm
                     The    wrapping    algorithm    to    use,     one     of
                     NCR_WALG_AES_RFC3394 and NCR_WALG_AES_RFC5649.

              keytowrap
                     The descriptor of the key to wrap

              key    The descriptor of the key used for wrapping

              params Key  type-specific  parameters.   For  the currently sup-
                     ported wrapping algorithms,  params.params.cipher.iv  and
                     params.params.cipher.iv_size specify the IV.

              io     Destination buffer

              io_size
                     Size of the destination buffer

              Currently  only  secret  keys  can  be wrapped, using one of the
              above-mentioned AES-based algorithms.

              On success, the io_size member is set to the size of the wrapped
              key.

       NCRIO_KEY_UNWRAP
              Unwrap  user-space  data  into  a kernel-space key using another
              key.

              The parameter points to struct ncr_key_wrap_st, which specifies:

              algorithm
                     The wrapping algorithm to use.

              keytowrap
                     The descriptor of the target key object

              key    The descriptor of the key used for wrapping

              params Key  type-specific  parameters.   For  the currently sup-
                     ported wrapping algorithms,  params.params.cipher.iv  and
                     params.params.cipher.iv_size specify the IV.

              io     Pointer to the wrapped key

              io_size
                     Size of the wrapped key

              The unwrapped key will have the NCR_KEY_FLAG_WRAPPABLE flag set,
              and the NCR_KEY_FLAG_EXPORTABLE flag clear.

       NCRIO_KEY_STORAGE_WRAP
              Wrap a key object and associated metadata using the  system-wide
              storage master key, and write the result to user space.

              Only  keys  with  the NCR_KEY_FLAG_WRAPPABLE flag can be wrapped
              using this operation.

              The parameter points to  struct  ncr_key_storage_wrap_st,  which
              specifies:

              keytowrap
                     The descriptor of the key to wrap

              io     Destination buffer

              io_size
                     Size of the destination buffer

              On success, the io_size member is set to the size of the wrapped
              key.

              Both symmetric and asymmetric keys can  be  wrapped  using  this
              operation.   The wrapped data includes the following information
              in addition to the raw key material:

              o      Key type

              o      Key flags

              o      Key algorithm

              o      "Persistent" key ID.

       NCRIO_KEY_STORAGE_UNWRAP
              Unwrap key and associated metadata created using NCRIO_KEY_STOR-
              AGE_WRAP,  and  restore  the  information  into  a specified key
              object.

              The parameter points to  struct  ncr_key_storage_wrap_st,  which
              specifies:

              keytowrap
                     The target key descriptor

              io     Wrapped data

              io_size
                     Size of the wrapped data

              See NCRIO_KEY_STORAGE_WRAP above for the list of attributes that
              will be restored.

       NCRIO_SESSION_INIT
              Allocate a session for performing crypto operations.

              The parameter points to struct ncr_session_st, which specifies:

              algorithm
                     The crypto algorithm to use.

              key    The key to use for the operation, if required.

              params Parameters for the operation.  For symmetric ciphers, the
                     IV.  For RSA operations, the format, used hash algorithms
                     and PSS salt length.  for DSA, the signature  hash  algo-
                     rithm.

              op     The   operation   to   perform,  one  of  NCR_OP_ENCRYPT,
                     NCR_OP_DECRYPT,  NCR_OP_SIGN  and   NCR_OP_VERIFY.    Use
                     NCR_OP_SIGN  for  computing  an  unkeyed  hash as well as
                     keyed hashes and signatures.

              On success, an integer descriptor for the created session (valid
              within the current /dev/crypto namespace) is stored into the ses
              member.

       NCRIO_SESSION_UPDATE
              Update an existing crypto session with new data (for operations,
              such  as  hashing, for which data can be supplied in pieces), or
              perform a single operation using the session context (for opera-
              tions,  such  as  public  key  encryption, that work on separate
              units of data).

              The parameter points to struct ncr_session_op_st,  which  speci-
              fies:

              ses    The integer descriptor of the session.

              type   Type  of  the  data  references  used for this operation,
                     either NCR_KEY_DATA or NCR_DIRECT_DATA.

              data.udata.input, data.udata.input_size
                     If type == NCR_DIRECT_DATA, input data for the operation.

              data.kdata.input
                     If  type  == NCR_KEY_DATA, integer key descriptor serving
                     as input for the operation.  This can be  currently  used
                     only  to  compute or verify a signature or hash of a sym-
                     metric key: the keying material is directly used as input
                     data for the underlying hash.

              data.udata.output, data,udata.output_size
                     If  type == NCR_DIRECT_DATA, output buffer for the opera-
                     tion.

              data.kdata.output, data,kdata.output_size
                     If type == NCR_KEY_DATA, output buffer for the operation.

              For  the NCR_OP_ENCRYPT and NCR_OP_DECRYPT operations using sym-
              metric ciphers, the operation is performed on  the  input  data,
              resulting  in  an output data block of the same size; for opera-
              tions using public-key cryptography, a single operation is  per-
              formed  on  the  input  data, resulting in output data.  In both
              cases, the relevant output_data member is set  to  the  size  of
              valid output data on success.

              For the NCR_OP_SIGN and NCR_OP_VERIFY operations, the input data
              is supplied to the underlying hash function; no output  data  is
              produced.

       NCRIO_SESSION_FINAL
              Finalize an existing crypto session and deallocate it.

              The  parameter  points to struct ncr_session_op_st, as described
              in the NCRIO_SESSION_UPDATE section  above.   If  the  parameter
              specifies  valid  input  data,  it  is  processed  as  if  using
              NCRIO_SESSION_UPDATE; thus, the last  update  operation  can  be
              performed together with the finalization in one step.

              There  is  no  specific  finalization  operation  performed  for
              NCR_OP_ENCRYPT and NCR_OP_DECRYPT.

              For the NCR_OP_SIGN operation,  the  signature  is  created  and
              written as output data.

              For  the NCR_OP_VERIFY operation, a signature specified as input
              using the output data fields is verified;  the  result  of  this
              operation   (NCR_SUCCESS  or  NCR_VERIFICATION_FAILED)  will  be
              stored into the err member.  (Note that the  ioctl(2)  operation
              will  indicate success even if the signature verification fails,
              as long all inputs were specified correctly.)

              The session will be deallocated even if the  NCRIO_SESSION_FINAL
              operation  reports an error, as long as valid session descriptor
              was specified.

       NCRIO_SESSION_ONCE
              Perform an one-shot crypto  operation,  allocating  a  temporary
              session, supplying a single instance of data, and finalizing the
              session in one operation.

              The parameter points  to  struct  ncr_session_once_op_st,  which
              includes arguments for one NCRIO_SESSION_INIT and one NCRIO_SES-
              SION_FINAL  operation.   The  ses  member  for  the   NCRIO_SES-
              SION_FINAL sub-operation is ignored, the sub-operation automati-
              cally uses the temporary session.

       NCRIO_MASTER_KEY_SET
              Set the system-wide storage master key.   Only  a  process  with
              EUID  0  and  the CAP_SYS_ADMIN capability is allowed to perform
              this operation.  Once a master key is set,  it  can  be  changed
              only by rebooting the system and setting a different key.

              The  parameter  points to struct ncr_master_key_st, which speci-
              fies:

              key    Pointer to the key material in user space.

              key_size
                     Size of the key material in bytes.

       Currently only an AES key with size 16, 24, or 32 bytes is  acceptable.

CONFIGURATION
       The  NCRIO_KEY_STORAGE_WRAP  and NCRIO_KEY_STORAGE_UNWRAP ioctl()s work
       only after a storage master key is configured by the system administra-
       tor.  See NCRIO_MASTER_KEY_SET above.

---
 Kbuild      |    2 
 cryptodev.h |   64 ++++++++++++
 ncr.h       |  312 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 378 insertions(+)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 756f831..f35589a 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -51,6 +51,7 @@ header-y += comstats.h
 header-y += const.h
 header-y += cgroupstats.h
 header-y += cramfs_fs.h
+header-y += cryptodev.h
 header-y += cycx_cfm.h
 header-y += dcbnl.h
 header-y += dlmconstants.h
@@ -116,6 +117,7 @@ header-y += mmtimer.h
 header-y += mqueue.h
 header-y += mtio.h
 header-y += ncp_no.h
+header-y += ncr.h
 header-y += neighbour.h
 header-y += net_dropmon.h
 header-y += net_tstamp.h
diff --git a/include/linux/cryptodev.h b/include/linux/cryptodev.h
new file mode 100644
index 0000000..97507d8
--- /dev/null
+++ b/include/linux/cryptodev.h
@@ -0,0 +1,64 @@
+/* This is a source compatible implementation with the original API of 
+ * cryptodev by Angelos D. Keromytis, found at openbsd cryptodev.h.
+ * Placed under public domain */
+
+#ifndef _LINUX_CRYPTODEV_H
+#define _LINUX_CRYPTODEV_H
+
+/* API extensions for linux */
+#define CRYPTO_HMAC_MAX_KEY_LEN		512
+#define CRYPTO_CIPHER_MAX_KEY_LEN	64
+
+/* All the supported algorithms
+ */
+typedef enum {
+	CRYPTO_DES_CBC=1,
+	CRYPTO_3DES_CBC=2,
+	CRYPTO_BLF_CBC=3,
+	CRYPTO_CAST_CBC=4,
+	CRYPTO_SKIPJACK_CBC=5,
+	CRYPTO_MD5_HMAC=6,
+	CRYPTO_SHA1_HMAC=7,
+	CRYPTO_RIPEMD160_HMAC=8,
+	CRYPTO_MD5_KPDK=9,
+	CRYPTO_SHA1_KPDK=10,
+	CRYPTO_RIJNDAEL128_CBC=11,
+	CRYPTO_AES_CBC=CRYPTO_RIJNDAEL128_CBC,
+	CRYPTO_ARC4=12,
+	CRYPTO_MD5=13,
+	CRYPTO_SHA1=14,
+	CRYPTO_DEFLATE_COMP=15,
+	CRYPTO_NULL=16,
+	CRYPTO_LZS_COMP=17,
+	CRYPTO_SHA2_256_HMAC=18,
+	CRYPTO_SHA2_384_HMAC=19,
+	CRYPTO_SHA2_512_HMAC=20,
+	CRYPTO_AES_CTR=21,
+	CRYPTO_AES_XTS=22,
+
+	CRYPTO_CAMELLIA_CBC=101,
+	CRYPTO_RIPEMD160,
+	CRYPTO_SHA2_256,
+	CRYPTO_SHA2_384,
+	CRYPTO_SHA2_512,
+	CRYPTO_ALGORITHM_ALL, /* Keep updated - see below */
+} cryptodev_crypto_op_t;
+#define	CRYPTO_ALGORITHM_MAX	(CRYPTO_ALGORITHM_ALL - 1)
+
+/* Values for ciphers */
+#define DES_BLOCK_LEN		8
+#define DES3_BLOCK_LEN		8
+#define RIJNDAEL128_BLOCK_LEN	16
+#define AES_BLOCK_LEN		RIJNDAEL128_BLOCK_LEN
+#define CAMELLIA_BLOCK_LEN
+#define BLOWFISH_BLOCK_LEN	8
+#define SKIPJACK_BLOCK_LEN	8
+#define CAST128_BLOCK_LEN	8
+
+/* the maximum of the above */
+#define EALG_MAX_BLOCK_LEN	16
+
+/* Values for hashes/MAC */
+#define AALG_MAX_RESULT_LEN		64
+
+#endif /* _LINUX_CRYPTODEV_H */
diff --git a/include/linux/ncr.h b/include/linux/ncr.h
new file mode 100644
index 0000000..06f34e2
--- /dev/null
+++ b/include/linux/ncr.h
@@ -0,0 +1,312 @@
+#ifndef _LINUX_NCR_H
+#define _LINUX_NCR_H
+
+#include <linux/types.h>
+
+#define NCR_CIPHER_MAX_BLOCK_LEN 32
+#define NCR_HASH_MAX_OUTPUT_SIZE  64
+
+typedef enum {
+	NCR_ALG_NONE,
+	NCR_ALG_NULL,
+	NCR_ALG_3DES_CBC,
+	NCR_ALG_AES_CBC,
+	NCR_ALG_CAMELLIA_CBC,
+	NCR_ALG_ARCFOUR,
+	NCR_ALG_AES_ECB,
+	NCR_ALG_CAMELLIA_ECB,
+	NCR_ALG_AES_CTR,
+	NCR_ALG_CAMELLIA_CTR,
+
+	NCR_ALG_SHA1=40,
+	NCR_ALG_MD5,
+	NCR_ALG_SHA2_224,
+	NCR_ALG_SHA2_256,
+	NCR_ALG_SHA2_384,
+	NCR_ALG_SHA2_512,
+
+	NCR_ALG_HMAC_SHA1=80,
+	NCR_ALG_HMAC_MD5,
+	NCR_ALG_HMAC_SHA2_224,
+	NCR_ALG_HMAC_SHA2_256,
+	NCR_ALG_HMAC_SHA2_384,
+	NCR_ALG_HMAC_SHA2_512,
+
+	NCR_ALG_RSA=140,
+	NCR_ALG_DSA,
+	NCR_ALG_DH, /* DH as in PKCS #3 */
+} ncr_algorithm_t;
+
+
+
+typedef enum {
+	NCR_WALG_AES_RFC3394, /* for secret keys only */
+	NCR_WALG_AES_RFC5649, /* can wrap arbitrary key */
+} ncr_wrap_algorithm_t;
+
+typedef enum {
+	NCR_KEY_TYPE_INVALID,
+	NCR_KEY_TYPE_SECRET=1,
+	NCR_KEY_TYPE_PUBLIC=2,
+	NCR_KEY_TYPE_PRIVATE=3,
+} ncr_key_type_t;
+
+/* Key handling
+ */
+
+typedef int ncr_key_t;
+
+#define NCR_KEY_INVALID ((ncr_key_t)-1)
+
+#define NCR_KEY_FLAG_EXPORTABLE 1
+#define NCR_KEY_FLAG_WRAPPABLE (1<<1)
+/* when generating a pair the flags correspond to private
+ * and public key usage is implicit. For example when private
+ * key can decrypt then public key can encrypt. If private key
+ * can sign then public key can verify.
+ */
+#define NCR_KEY_FLAG_DECRYPT (1<<2)
+#define NCR_KEY_FLAG_SIGN (1<<3)
+
+struct ncr_key_generate_params_st {
+	ncr_algorithm_t algorithm; /* just a cipher algorithm when
+	* generating secret keys
+	*/
+
+	unsigned int keyflags;
+	union {
+		struct {
+			unsigned int bits;
+		} secret;
+		struct {
+			unsigned int bits;
+			unsigned long e; /* use zero for default */
+		} rsa;		
+		struct {
+			/* For DSS standard allowed values
+			 * are:            p:1024 q: 160
+			 *                 p:2048 q: 224
+			 *                 p:2048 q: 256
+			 *                 p:3072 q: 256
+			 */
+			unsigned int p_bits;
+			unsigned int q_bits;
+		} dsa;
+		struct {
+			uint8_t __user *p; /* prime */
+			size_t p_size;
+			uint8_t __user *g; /* generator */
+			size_t g_size;
+		} dh;
+	} params;
+};
+
+/* used in generation
+ */
+struct ncr_key_generate_st {
+	ncr_key_t desc;
+	ncr_key_t desc2; /* public key when called with GENERATE_PAIR */
+	struct ncr_key_generate_params_st params;
+};
+
+typedef enum {
+	RSA_PKCS1_V1_5, /* both signatures and encryption */
+	RSA_PKCS1_OAEP, /* for encryption only */
+	RSA_PKCS1_PSS, /* for signatures only */
+} ncr_rsa_type_t;
+
+/* used in derivation/encryption
+ */
+struct ncr_key_params_st {
+	/* this structure always corresponds to a key. Hence the
+	 * parameters of the union selected are based on the corresponding
+	 * key */
+	union {
+		struct {
+			uint8_t iv[NCR_CIPHER_MAX_BLOCK_LEN];
+			size_t iv_size;
+		} cipher;
+		struct {
+			uint8_t __user *pub;
+			size_t pub_size;
+		} dh;
+		struct {
+			ncr_rsa_type_t type;
+			ncr_algorithm_t oaep_hash; /* for OAEP */
+			ncr_algorithm_t sign_hash; /* for signatures */
+			unsigned int pss_salt; /* PSS signatures */
+		} rsa;
+		struct {
+			ncr_algorithm_t sign_hash; /* for signatures */
+		} dsa;
+	} params;
+};
+
+typedef enum {
+	NCR_DERIVE_DH=1,
+} ncr_derive_t;
+
+struct ncr_key_derivation_params_st {
+	ncr_derive_t derive; /* the derivation algorithm */
+
+	ncr_key_t newkey;
+	unsigned int keyflags; /* for new key */
+	
+	ncr_key_t key;
+	struct ncr_key_params_st params;
+};
+
+#define MAX_KEY_ID_SIZE 20
+
+struct ncr_key_info_st {
+	ncr_key_t key; /* input */
+
+	unsigned int flags;
+	ncr_key_type_t type;
+	ncr_algorithm_t algorithm; /* valid for public/private keys */
+
+	uint8_t key_id[MAX_KEY_ID_SIZE];
+	size_t key_id_size;
+};
+
+struct ncr_key_data_st {
+	ncr_key_t key;
+
+	void __user *idata;
+	size_t idata_size; /* rw in get */
+
+	/* in case of import this will be used as key id */
+	uint8_t key_id[MAX_KEY_ID_SIZE];
+	size_t key_id_size;
+	ncr_key_type_t type;
+	unsigned int flags;
+	ncr_algorithm_t algorithm; /* valid for public/private keys */
+};
+
+#define NCRIO_KEY_INIT			_IOW ('c', 204, ncr_key_t)
+/* generate a secret key */
+#define NCRIO_KEY_GENERATE     	_IOR ('c', 205, struct ncr_key_generate_st)
+/* generate a public key pair */
+#define NCRIO_KEY_GENERATE_PAIR _IOR ('c', 206, struct ncr_key_generate_st)
+/* derive a new key from an old one */
+#define NCRIO_KEY_DERIVE        _IOR ('c', 207, struct ncr_key_derivation_params_st)
+/* return information on a key */
+#define NCRIO_KEY_GET_INFO      _IOWR('c', 208, struct ncr_key_info_st)
+/* export a secret key */
+#define NCRIO_KEY_EXPORT       	_IOWR('c', 209, struct ncr_key_data_st)
+/* import a secret key */
+#define NCRIO_KEY_IMPORT       	_IOWR('c', 210, struct ncr_key_data_st)
+
+#define NCRIO_KEY_DEINIT       _IOR ('c', 215, ncr_key_t)
+
+/* Key wrap ioctls
+ */
+struct ncr_key_wrap_st {
+	ncr_wrap_algorithm_t algorithm;
+	ncr_key_t keytowrap;
+
+	ncr_key_t key;
+	struct ncr_key_params_st params;
+
+	void __user * io; /* encrypted keytowrap */
+	size_t io_size; /* this will be updated by the actual size on wrap */
+};
+
+#define NCRIO_KEY_WRAP        _IOWR ('c', 250, struct ncr_key_wrap_st)
+#define NCRIO_KEY_UNWRAP        _IOR ('c', 251, struct ncr_key_wrap_st)
+
+/* Internal ops  */
+struct ncr_master_key_st {
+	uint8_t __user * key;
+	uint16_t key_size;
+};
+
+#define NCRIO_MASTER_KEY_SET        _IOR ('c', 260, struct ncr_master_key_st)
+
+/* These are similar to key_wrap and unwrap except that will store some extra
+ * fields to be able to recover a key */
+struct ncr_key_storage_wrap_st {
+	ncr_key_t keytowrap;
+
+	void __user * io; /* encrypted keytowrap */
+	size_t io_size; /* this will be updated by the actual size on wrap */
+};
+
+#define NCRIO_KEY_STORAGE_WRAP        _IOWR ('c', 261, struct ncr_key_storage_wrap_st)
+#define NCRIO_KEY_STORAGE_UNWRAP        _IOR ('c', 262, struct ncr_key_storage_wrap_st)
+
+/* Crypto Operations ioctls
+ */
+
+typedef enum {
+	NCR_OP_ENCRYPT=1,
+	NCR_OP_DECRYPT,
+	NCR_OP_SIGN,
+	NCR_OP_VERIFY,
+} ncr_crypto_op_t;
+
+typedef int ncr_session_t;
+#define NCR_SESSION_INVALID ((ncr_session_t)-1)
+
+/* input of CIOCGSESSION */
+struct ncr_session_st {
+	/* input */
+	ncr_algorithm_t algorithm;
+
+	ncr_key_t key;
+	struct ncr_key_params_st params;
+	ncr_crypto_op_t op;
+
+	/* output */
+	ncr_session_t	ses;		/* session identifier */
+};
+
+typedef enum {
+	NCR_SUCCESS = 0,
+	NCR_ERROR_GENERIC = -1,
+	NCR_VERIFICATION_FAILED = -2,
+} ncr_error_t;
+
+typedef enum {
+	NCR_KEY_DATA,
+	NCR_DIRECT_DATA,
+} ncr_data_type_t;
+
+struct ncr_session_op_st {
+	/* input */
+	ncr_session_t ses;
+
+	union {
+		struct {
+			ncr_key_t input;
+			void __user * output;  /* when verifying signature this is
+					* the place of the signature.
+					*/
+			size_t output_size;
+		} kdata; /* NCR_KEY_DATA */
+		struct {
+			void __user * input;
+			size_t input_size;
+			void __user * output;
+			size_t output_size;
+		} udata; /* NCR_DIRECT_DATA */
+	} data;
+	ncr_data_type_t type;
+
+	/* output of verification */
+	ncr_error_t err;
+};
+
+struct ncr_session_once_op_st {
+	struct ncr_session_st init;
+	struct ncr_session_op_st op;
+};
+
+#define NCRIO_SESSION_INIT        _IOR ('c', 300, struct ncr_session_st)
+#define NCRIO_SESSION_UPDATE        _IOWR ('c', 301, struct ncr_session_op_st)
+#define NCRIO_SESSION_FINAL        _IOWR ('c', 302, struct ncr_session_op_st)
+
+/* everything in one call */
+#define NCRIO_SESSION_ONCE        _IOWR ('c', 303, struct ncr_session_once_op_st)
+
+#endif
