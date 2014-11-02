From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 01/11] crypto: Documentation - crypto API high level spec
Date: Sun, 02 Nov 2014 21:35:11 +0100
Message-ID: <4163724.RCMDlx8dmE@tachyon.chronox.de>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6375771.bx7QqLJLuR@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The design of the kernel crypto API as well as hints to program with
the kernel crypto API are given.

The documentation contains:
 * design aspects of crypto API
 * develper specific hints
 * references to the API function description

Signed-off-by: Stephan Mueller <smueller@chronox.de>
CC: Marek Vasut <marex@denx.de>
---
 Documentation/crypto/crypto-API-spec.txt | 721 +++++++++++++++++++++++=
++++++++
 1 file changed, 721 insertions(+)
 create mode 100644 Documentation/crypto/crypto-API-spec.txt

diff --git a/Documentation/crypto/crypto-API-spec.txt b/Documentation/c=
rypto/crypto-API-spec.txt
new file mode 100644
index 0000000..8a24c98
--- /dev/null
+++ b/Documentation/crypto/crypto-API-spec.txt
@@ -0,0 +1,721 @@
+Kernel Crypto API Interface Specification
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The kernel crypto API offers a rich set of cryptographic ciphers as we=
ll as
+other data transformation mechanisms and methods to invoke these. This=
 document
+contains a description of the API and provides example code.
+
+To understand and properly use the kernel crypto API a brief explanati=
on of its
+structure is given. Based on the architecture, the API can be separate=
d into
+different components. Following the architecture specification, hints =
to
+developers of ciphers are provided. Pointers to the API function call
+documentation are given at the end.
+
+The kernel crypto API refers to all algorithms as "transformation". Th=
erefore, a
+cipher handle variable usually has the name "tfm". Besides cryptograph=
ic
+operations, the kernel crypto API also knows compression transforms an=
d handles
+them the same way as ciphers.
+
+The kernel crypto API serves the following entity types:
+
+	* consumers requesting cryptographic services
+
+	* data transformation implementations (typically ciphers) that
+	  can be called by consumers using the kernel crypto API
+
+This specification is intended for consumers of the kernel crypto API =
as well
+as for developers implementing ciphers. This API specification, howeve=
r, does
+not discusses all API calls available to data transformation implement=
ations
+((i.e. implementations of ciphers and other transformations (such as C=
RC or
+even compression algorithms) that can register with the kernel crypto =
API).
+
+Note: The terms "transformation" and cipher algorithm are used interch=
angably.
+
+
+Terminology
+-----------
+
+The transformation implementation is an actual code or interface to ha=
rdware
+which implements a certain transformation with precisely defined behav=
ior.
+
+The transformation object (TFM) is an instance of a transformation
+implementation. There can be multiple transformation objects associate=
d with
+a single transformation implementation. Each of those transformation o=
bjects
+is held by a crypto API consumer or another transformation. Transforma=
tion
+object is allocated when a crypto API consumer requests a transformati=
on
+implementation. The consumer is then provided with a structure, which =
contains
+a transformation object (TFM).
+
+The transformation context is private data associated with the transfo=
rmation
+object.
+
+
+Kernel Crypto API Architecture
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+Cipher algorithm types
+----------------------
+
+The kernel crypto API provides different API calls for the following c=
ipher
+types:
+
+	* Symmetric ciphers
+
+	* AEAD ciphers
+
+	* Message digest, including keyed message digest
+
+	* Random number generation
+
+	* User space interface
+
+
+Ciphers and Templates
+---------------------
+
+The kernel crypto API provides implementations of single block ciphers=
 and
+message digests. In addition, the kernel crypto API provides numerous
+"templates" that can be used in conjunction with the single block ciph=
ers and
+message digests. Templates include all types of block chaining mode, t=
he HMAC
+mechanism, etc.
+
+Single block ciphers and message digests can either be directly used b=
y a
+caller or invoked together with a template to form multi-block ciphers=
 or keyed
+message digests.
+
+A single block cipher may even be called with multiple templates. Howe=
ver,
+templates cannot be used without a single cipher.
+
+
+Synchronous and asynchronous operation
+--------------------------------------
+
+The kernel crypto API provides synchronous and asynchronous API operat=
ions.
+
+When using the synchronous API operation, the caller invokes a cipher =
operation
+which is performed synchronously by the kernel crypto API. That means,=
 the
+caller waits until the cipher operation completes. Therefore, the kern=
el crypto
+API calls work like regular function calls. For synchronous operation,=
 the set
+of API calls is small and conceptually similar to any other crypto lib=
rary.
+
+Asynchronous operation is provided by the kernel crypto API which impl=
ies that
+the invocation of a cipher operation will complete almost instantly. T=
hat
+invocation triggers the cipher operation but it does not signal its co=
mpletion.
+Before invoking a cipher operation, the caller must provide a callback=
 function
+the kernel crypto API can invoke to signal the completion of the ciphe=
r
+operation. Furthermore, the caller must ensure it can handle such asyn=
chronous
+events by applying appropriate locking around its data. The kernel cry=
pto API
+does not perform any special serialization operation to protect the ca=
ller's
+data integrity.
+
+
+Kernel crypto API cipher references and priority
+------------------------------------------------
+
+A cipher is referenced by the caller with a string. That string has th=
e
+following semantics:
+
+	template(single block cipher)
+
+where "template" and "single block cipher" is the aforementioned templ=
ate and
+single block cipher, respectively. If applicable, additional templates=
 may
+enclose other templates, such as
+
+	template1(template2(single block cipher)))
+
+The kernel crypto API may provide multiple implementations of a templa=
te or a
+single block cipher. For example, AES on newer Intel hardware has the =
following
+implementations: AES-NI, assembler implementation, or straight C. Now,=
 when
+using the string "aes" with the kernel crypto API, which cipher implem=
entation
+is used? The answer to that question is the priority number assigned t=
o each
+cipher implementation by the kernel crypto API. When a caller uses the=
 string to
+refer to a cipher during initialization of a cipher handle, the kernel=
 crypto
+API looks up all implementations providing an implementation with that=
 name and
+selects the implementation with the highest priority.
+
+Now, a caller may have the need to refer to a specific cipher implemen=
tation and
+thus does not want to rely on the priority-based selection. To accommo=
date this
+scenario, the kernel crypto API allows the cipher implementation to re=
gister a
+unique name in addition to common names. When using that unique name, =
a caller
+is therefore always sure to refer to the intended cipher implementatio=
n.
+
+The list of available ciphers is given in /proc/crypto. When reading t=
hat file,
+all available ciphers are listed. However, that list does not specify =
all
+possible permutations of templates and ciphers. Each block listed in
+/proc/crypto contains the following information:
+
+	* name: the generic name of the cipher that is subject to the
+	  priority-based selection -- this name can be used by the cipher
+	  allocation API calls
+
+	* driver: the unique name of the cipher -- this name can be used by t=
he
+	  cipher allocation API calls
+
+	* module: the kernel module providing the cipher implementation (or
+	  "kernel" for statically linked ciphers)
+
+	* priority: the priority value of the cipher implementation
+
+	* refcnt: the reference count of the respective cipher (i.e. the numb=
er
+	  of current consumers of this cipher)
+
+	* selftest: specification whether the self test for the cipher passed
+
+	* type:
+		- blkcipher for symmetric block ciphers
+		- ablkcipher for asymmetric block ciphers
+		- cipher for single block ciphers that may be used with an
+		  additional template
+		- shash for symmetric message digest
+		- ahash for asymmetric message digest
+		- aead for AEAD cipher type
+		- compression for compression type transforms
+		- rng for random number generator
+		- givcipher for cipher with associated IV generator
+
+	* blocksize: blocksize of cipher in bytes
+
+	* keysize: key size in bytes
+
+	* ivsize: IV size in bytes
+
+	* seedsize: required size of seed data for random number generator
+
+	* digestsize: output size of the message digest
+
+	* geniv: IV generation type:
+		- eseqiv for encrypted sequence number based IV generation
+		- seqiv for sequence number based IV generation
+		- chainiv for chain iv generation
+		- <builtin> is a marker that the cipher implements IV generation
+		  and handling as it is specific to the given cipher
+
+
+Key sizes
+---------
+
+When allocating a cipher handle, the caller only specifies the cipher =
type.
+Symmetric ciphers, however, typically support multiple key sizes (e.g.=
 AES-128
+vs. AES-192 vs. AES-256). These key sizes are determined with the leng=
th of the
+provided key. Thus, the kernel crypto API does not provide a separate =
way to
+select the particular symmetric cipher key size.
+
+
+Cipher allocation type and masks
+--------------------------------
+
+The different cipher handle allocation functions allow the specificati=
on of a
+type and mask flag. Both parameters have the following meaning (and ar=
e
+therefore not covered in the subsequent sections).
+
+The type flag specifies the type of the cipher algorithm. The caller u=
sually
+provides a 0 when the caller wants the default handling. Otherwise, th=
e caller
+may provide the following selections which match the the aforementione=
d cipher
+types:
+
+ * CRYPTO_ALG_TYPE_CIPHER	Raw block cipher
+ * CRYPTO_ALG_TYPE_COMPRESS	Compression
+ * CRYPTO_ALG_TYPE_AEAD		Authenticated Encryption with Associated Data=
 (MAC)
+ * CRYPTO_ALG_TYPE_BLKCIPHER	Synchronous multi-block cipher
+ * CRYPTO_ALG_TYPE_ABLKCIPHER	Asynchronous multi-block cipher
+ * CRYPTO_ALG_TYPE_GIVCIPHER
+ * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
+ * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
+ * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
+ * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
+ * CRYPTO_ALG_TYPE_RNG		Random Number Generation
+ * CRYPTO_ALG_TYPE_PCOMPRESS
+
+The mask flag restricts the type of cipher. The only allowed flag is
+CRYPTO_ALG_ASYNC to restrict the cipher lookup function to asynchronou=
s ciphers.
+Usually, a caller provides a 0 for the mask flag.
+
+When the caller provides a mask and type specification, the caller lim=
its the
+kernel crypto API=B4s search for a suitable cipher implementation for =
the given
+cipher name. That means, even when a caller uses a cipher name that ex=
ists
+during its initialization call, the kernel crypto API may not select i=
t due
+to the used type and mask field.
+
+
+Developing Cipher Algorithms
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+Registering and unregistering transformation
+---------------------------------------------
+
+There are three distinct types of registration functions in the Crypto=
 API.
+One is used to register a generic cryptographic transformation, while =
the
+other two are specific to HASH transformations and COMPRESSion. We wil=
l
+discuss the latter two in a separate chapter, here we will only look a=
t
+the generic ones.
+
+The generic registration functions can be found in include/linux/crypt=
o.h
+and their definition can be seen below. The former function registers =
a
+single transformation, while the latter works on an array of transform=
ation
+descriptions. The latter is useful when registering transformations in=
 bulk.
+
+   int crypto_register_alg(struct crypto_alg *alg);
+   int crypto_register_algs(struct crypto_alg *algs, int count);
+
+The counterparts to those functions are listed below.
+
+   int crypto_unregister_alg(struct crypto_alg *alg);
+   int crypto_unregister_algs(struct crypto_alg *algs, int count);
+
+Notice that both registration and unregistration functions do return a=
 value,
+so make sure to handle errors.
+
+The bulk registration / unregistration functions require that struct c=
rypto_alg
+is an array of count size. These functions simply loop over that array=
 and
+register / unregister each individual algorithm. If an error occurs, t=
he
+loop is terminated at the offending algorithm definition. That means, =
the
+algorithms prior to the offending algorithm are successfully registere=
d.
+
+Single-block ciphers [CIPHER]
+-----------------------------
+Example of transformations: aes, arc4, ...
+
+This section describes the simplest of all transformation implementati=
ons,
+that being the CIPHER type. The CIPHER type is used for transformation=
s
+which operate on exactly one block at a time and there are no dependen=
cies
+between blocks at all.
+
+Registration specifics
+......................
+
+The registration of [CIPHER] algorithm is specific in that struct cryp=
to_alg
+field .cra_type is empty. The .cra_u.cipher has to be filled in with p=
roper
+callbacks to implement this transformation.
+
+Fields in struct cipher_alg explained
+.....................................
+
+This section explains the .cra_u.cipher fields and how they are called=
=2E
+All of the fields are mandatory and must be filled:
+
+   .cia_min_keysize ... Minimum key size supported by the transformati=
on.
+                        - This is the smallest key length supported by=
 this
+                          transformation algorithm. This must be set t=
o one
+                          of the pre-defined values as this is not har=
dware
+                          specific.
+                        - Possible values for this field can be found =
via:
+                          $ git grep "_MIN_KEY_SIZE" include/crypto/
+   .cia_max_keysize ... Maximum key size supported by the transformati=
on.
+                        - This is the largest key length supported by =
this
+                          transformation algorithm. This must be set t=
o one
+                          of the pre-defined values as this is not har=
dware
+                          specific.
+                        - Possible values for this field can be found =
via:
+                          $ git grep "_MAX_KEY_SIZE" include/crypto/
+   .cia_setkey() ...... Set key for the transformation.
+                        - This function is used to either program a su=
pplied
+                          key into the hardware or store the key in th=
e
+                          transformation context for programming it la=
ter. Note
+                          that this function does modify the transform=
ation
+                          context.
+                        - This function can be called multiple times d=
uring
+                          the existence of the transformation object, =
so one
+                          must make sure the key is properly reprogram=
med
+                          into the hardware.
+                        - This function is also responsible for checki=
ng the
+                          key length for validity.
+                        - In case a software fallback was put in place=
 in
+                          the .cra_init() call, this function might ne=
ed to
+                          use the fallback if the algorithm doesn't su=
pport
+                          all of the key sizes.
+   .cia_encrypt() ..... Encrypt a single block.
+                        - This function is used to encrypt a single bl=
ock of
+                          data, which must be .cra_blocksize big. This=
 always
+                          operates on a full .cra_blocksize and it is =
not
+                          possible to encrypt a block of smaller size.=
 The
+                          supplied buffers must therefore also be at l=
east
+                          of .cra_blocksize size.
+                        - Both the input and output buffers are always=
 aligned
+                          to .cra_alignmask . In case either of the in=
put or
+                          output buffer supplied by user of the crypto=
 API is
+                          not aligned to .cra_alignmask, the crypto AP=
I will
+                          re-align the buffers. The re-alignment means=
 that a
+                          new buffer will be allocated, the data will =
be copied
+                          into the new buffer, then the processing wil=
l happen
+                          on the new buffer, then the data will be cop=
ied back
+                          into the original buffer and finally the new=
 buffer
+                          will be freed.
+                        - In case a software fallback was put in place=
 in
+                          the .cra_init() call, this function might ne=
ed to
+                          use the fallback if the algorithm doesn't su=
pport
+                          all of the key sizes.
+                        - In case the key was stored in transformation=
 context,
+                          the key might need to be re-programmed into =
the
+                          hardware in this function.
+                        - This function shall not modify the transform=
ation
+                          context, as this function may be called in p=
arallel
+                          with the same transformation object.
+   .cia_decrypt() ..... Decrypt a single block.
+                        - This is a reverse counterpart to .cia_encryp=
t(), and
+                          the conditions are exactly the same.
+
+Here are schematics of how these functions are called when operated fr=
om
+other part of the kernel. Note that the .cia_setkey() call might happe=
n
+before or after any of these schematics happen, but must not happen du=
ring
+any of these are in-flight.
+
+         KEY ---.    PLAINTEXT ---.
+                v                 v
+          .cia_setkey() -> .cia_encrypt()
+                                  |
+                                  '-----> CIPHERTEXT
+
+Please note that a pattern where .cia_setkey() is called multiple time=
s
+is also valid:
+
+  KEY1 --.    PLAINTEXT1 --.         KEY2 --.    PLAINTEXT2 --.
+         v                 v                v                 v
+   .cia_setkey() -> .cia_encrypt() -> .cia_setkey() -> .cia_encrypt()
+                           |                                  |
+                           '---> CIPHERTEXT1                  '---> CI=
PHERTEXT2
+
+
+Multi-block ciphers [BLKCIPHER] [ABLKCIPHER]
+--------------------------------------------
+
+Example of transformations: cbc(aes), ecb(arc4), ...
+
+This section describes the multi-block cipher transformation implement=
ations
+for both synchronous [BLKCIPHER] and asynchronous [ABLKCIPHER] case. T=
he
+multi-block ciphers are used for transformations which operate on scat=
terlists
+of data supplied to the transformation functions. They output the resu=
lt into
+a scatterlist of data as well.
+
+Registration specifics
+......................
+
+The registration of [BLKCIPHER] or [ABLKCIPHER] algorithms is one of t=
he most
+standard procedures throughout the crypto API. There are no specifics =
for
+this case other that re-aligning of input and output buffers does not =
happen
+automatically within the crypto API, but is the responsibility of the =
crypto
+API consumer. The crypto API consumer shall use crypto_blkcipher_align=
mask()
+or crypto_ablkcipher_alignmask() respectively to determine the needs o=
f the
+transformation object and prepare the scatterlist with data accordingl=
y.
+
+Fields in struct blkcipher_alg and struct ablkcipher_alg explained
+..................................................................
+
+This section explains the .cra_u.blkcipher and .cra_u.cra_ablkcipher f=
ields
+and how they are called. Please note that this is very similar to the =
basic
+CIPHER case for all but minor details. All of the fields but .geniv ar=
e
+mandatory and must be filled:
+
+   .min_keysize ... Minimum key size supported by the transformation.
+                    - This is the smallest key length supported by thi=
s
+                      transformation algorithm. This must be set to on=
e
+                      of the pre-defined values as this is not hardwar=
e
+                      specific.
+                    - Possible values for this field can be found via:
+                      $ git grep "_MIN_KEY_SIZE" include/crypto/
+   .max_keysize ... Maximum key size supported by the transformation.
+                    - This is the largest key length supported by this
+                      transformation algorithm. This must be set to on=
e
+                      of the pre-defined values as this is not hardwar=
e
+                      specific.
+                    - Possible values for this field can be found via:
+                      $ git grep "_MAX_KEY_SIZE" include/crypto/
+   .setkey() ...... Set key for the transformation.
+                    - This function is used to either program a suppli=
ed
+                      key into the hardware or store the key in the
+                      transformation context for programming it later.=
 Note
+                      that this function does modify the transformatio=
n
+                      context.
+                    - This function can be called multiple times durin=
g
+                      the existence of the transformation object, so o=
ne
+                      must make sure the key is properly reprogrammed
+                      into the hardware.
+                    - This function is also responsible for checking t=
he
+                      key length for validity.
+                    - In case a software fallback was put in place in
+                      the .cra_init() call, this function might need t=
o
+                      use the fallback if the algorithm doesn't suppor=
t
+                      all of the key sizes.
+   .encrypt() ..... Encrypt a scatterlist of blocks.
+                    - This function is used to encrypt the supplied
+                      scatterlist containing the blocks of data. The c=
rypto
+                      API consumer is responsible for aligning the ent=
ries
+                      of the scatterlist properly and making sure the
+                      chunks are correctly sized.
+                    - In case a software fallback was put in place in
+                      the .cra_init() call, this function might need t=
o
+                      use the fallback if the algorithm doesn't suppor=
t
+                      all of the key sizes.
+                    - In case the key was stored in transformation con=
text,
+                      the key might need to be re-programmed into the
+                      hardware in this function.
+                    - This function shall not modify the transformatio=
n
+                      context, as this function may be called in paral=
lel
+                      with the same transformation object.
+   .decrypt() ..... Decrypt a single block.
+                    - This is a reverse counterpart to .encrypt(), and=
 the
+                      conditions are exactly the same.
+
+Please refer to the single block cipher description for schematics of =
the block
+cipher usage. The usage patterns are exactly the same for [ABLKCIPHER]=
 and
+[BLKCIPHER] as they are for plain [CIPHER].
+
+Specifics of asynchronous multi-block cipher
+............................................
+
+There are a couple of specifics to the [ABLKCIPHER] interface.
+
+First of all, some of the drivers will want to use the Generic Scatter=
Walk
+in case the hardware needs to be fed separate chunks of the scatterlis=
t
+which contains the plaintext and will contain the ciphertext. Please r=
efer
+below for a description and usage of the Generic ScatterWalk interface=
=2E
+
+It is recommended to enqueue cryptographic transformation requests int=
o
+generic crypto queues. This allows for these requests to be processed =
in
+sequence as the cryptographic hardware becomes free.
+
+
+Hashing [HASH]
+--------------
+
+Example of transformations: crc32, md5, sha1, sha256,...
+
+Registering and unregistering the transformation
+................................................
+
+There are multiple ways to register a HASH transformation, depending o=
n
+whether the transformation is synchronous [SHASH] or asynchronous [AHA=
SH]
+and the amount of HASH transformations we are registering. You can fin=
d
+the prototypes defined in include/crypto/internal/hash.h :
+
+   int crypto_register_ahash(struct ahash_alg *alg);
+
+   int crypto_register_shash(struct shash_alg *alg);
+   int crypto_register_shashes(struct shash_alg *algs, int count);
+
+The respective counterparts for unregistering the HASH transformation =
are
+as follows:
+
+   int crypto_unregister_ahash(struct ahash_alg *alg);
+
+   int crypto_unregister_shash(struct shash_alg *alg);
+   int crypto_unregister_shashes(struct shash_alg *algs, int count);
+
+Common fields of struct shash_alg and ahash_alg explained
+.........................................................
+
+For definition of these structures, please refer to include/crypto/has=
h.h .
+We will now explain the meaning of each field:
+
+   .init() ......... Initialize the transformation context.
+                     - Intended only to initialize the state of the HA=
SH
+                       transformation at the begining. This shall fill=
 in
+                       the internal structures used during the entire =
duration
+                       of the whole transformation.
+                     - No data processing happens at this point.
+   .update() ....... Push chunk of data into the driver for transforma=
tion.
+                     - This function actually pushes blocks of data fr=
om upper
+                       layers into the driver, which then passes those=
 to the
+                       hardware as seen fit.
+                     - This function must not finalize the HASH transf=
ormation,
+                       this only adds more data into the transformatio=
n.
+                     - This function shall not modify the transformati=
on
+                       context, as this function may be called in para=
llel
+                       with the same transformation object.
+                     - Data processing can happen synchronously [SHASH=
] or
+                       asynchronously [AHASH] at this point.
+   .final() ....... Retrieve result from the driver.
+                     - This function finalizes the transformation and =
retrieves
+                       the resulting hash from the driver and pushes i=
t back to
+                       upper layers.
+                     - No data processing happens at this point.
+   .finup() ........ Combination of update()+final() .
+                     - This function is effectively a combination of u=
pdate()
+                       and final() calls issued in sequence.
+                     - As some hardware cannot do update() and final()
+                       separately, this callback was added to allow su=
ch
+                       hardware to be used at least by IPsec.
+                     - Data processing can happen synchronously [SHASH=
] or
+                       asynchronously [AHASH] at this point.
+   .digest() ....... Combination of init()+update()+final() .
+                     - This function effectively behaves as the entire=
 chain
+                       of operations, init(), update() and final() iss=
ued in
+                       sequence.
+                     - Just like .finup(), this was added for hardware=
 which
+                       cannot do even the .finup(), but can only do th=
e whole
+                       transformation in one run.
+                     - Data processing can happen synchronously [SHASH=
] or
+                       asynchronously [AHASH] at this point.
+
+   .setkey() ....... Set optional key used by the hashing algorithm .
+                     - Intended to push optional key used by the hashi=
ng
+                       algorithm from upper layers into the driver.
+                     - This function can store the key in the transfor=
mation
+                       context or can outright program it into the har=
dware.
+                       In the former case, one must be careful to prog=
ram
+                       the key into the hardware at appropriate time a=
nd one
+                       must be careful that .setkey() can be called mu=
ltiple
+                       times during the existence of the transformatio=
n
+                       object.
+                     - Not all hashing algorithms do implement this fu=
nction.
+                       -> SHAx/MDx/CRCx do NOT implement this function=
=2E
+                       -> HMAC(MDx)/HMAC(SHAx) do implement this funct=
ion.
+                     - This function must be called before any other o=
f the
+                       init()/update()/final()/finup()/digest() is cal=
led.
+                     - No data processing happens at this point.
+
+   .export() ....... Export partial state of the transformation .
+                     - This function dumps the entire state of the ong=
oing
+                       transformation into a provided block of data so=
 it
+                       can be .import()ed back later on.
+                     - This is useful in case you want to save partial=
 result
+                       of the transformation after processing certain =
amount
+                       of data and reload this partial result multiple=
 times
+                       later on for multiple re-use.
+                     - No data processing happens at this point.
+   .import() ....... Import partial state of the transformation .
+                     - This function loads the entire state of the ong=
oing
+                       transformation from a provided block of data so=
 the
+                       transformation can continue from this point onw=
ard.
+                     - No data processing happens at this point.
+
+Here are schematics of how these functions are called when operated fr=
om
+other part of the kernel. Note that the .setkey() call might happen be=
fore
+or after any of these schematics happen, but must not happen during an=
y of
+these are in-flight. Please note that calling .init() followed immedia=
telly
+by .finish() is also a perfectly valid transformation.
+
+   I)   DATA -----------.
+                        v
+         .init() -> .update() -> .final()      ! .update() might not b=
e called
+                     ^    |         |            at all in this scenar=
io.
+                     '----'         '---> HASH
+
+   II)  DATA -----------.-----------.
+                        v           v
+         .init() -> .update() -> .finup()      ! .update() may not be =
called
+                     ^    |         |            at all in this scenar=
io.
+                     '----'         '---> HASH
+
+   III) DATA -----------.
+                        v
+                    .digest()                  ! The entire process is=
 handled
+                        |                        by the .digest() call=
=2E
+                        '---------------> HASH
+
+Here is a schematic of how the .export()/.import() functions are calle=
d when
+used from another part of the kernel.
+
+   KEY--.                 DATA--.
+        v                       v                  ! .update() may not=
 be called
+    .setkey() -> .init() -> .update() -> .export()   at all in this sc=
enario.
+                             ^     |         |
+                             '-----'         '--> PARTIAL_HASH
+
+   ----------- other transformations happen here -----------
+
+   PARTIAL_HASH--.   DATA1--.
+                 v          v
+             .import -> .update() -> .final()     ! .update() may not =
be called
+                         ^    |         |           at all in this sce=
nario.
+                         '----'         '--> HASH1
+
+   PARTIAL_HASH--.   DATA2-.
+                 v         v
+             .import -> .finup()
+                           |
+                           '---------------> HASH2
+
+The struct hash_alg_common fields and it's mirror in struct shash_alg
+.....................................................................
+
+This structure defines various size constraints and generic properties=
 of
+the hashing algorithm that is being implemented. Let us first inspect =
the
+size properties:
+
+   digestsize .... Size of the result of the transformation.
+                   - A buffer of this size must be available to the .f=
inal()
+                     and .finup() calls, so they can store the resulti=
ng hash
+                     into it.
+                   - For various predefined sizes, search include/cryp=
to/
+                     using 'git grep _DIGEST_SIZE include/crypto' .
+   statesize ..... Size of the block for partial state of the transfor=
mation.
+                   - A buffer of this size must be passed to the .expo=
rt()
+                     function as it will save the partial state of the
+                     transformation into it. On the other side, the .i=
mport()
+                     function will load the state from a buffer of thi=
s size
+                     as well.
+
+
+Specifics of asynchronous HASH transformation
+.............................................
+
+There are a couple of specifics to the [AHASH] interface.
+
+First of all, some of the drivers will want to use the Generic Scatter=
Walk
+in case the hardware needs to be fed separate chunks of the scatterlis=
t
+which contains the input data. The buffer containing the resulting has=
h will
+always be properly aligned to .cra_alignmask so there is no need to wo=
rry
+about this. Please refer to the section 9.1) of this document of the
+description and usage of the Generic ScatterWalk interface.
+
+It is recommended to enqueue cryptographic transformation requests int=
o
+generic crypto queues. This allows for these requests to be processed =
in
+sequence as the cryptographic hardware becomes free.
+
+
+Single block cipher API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+See source code comments for the *_cipher* calls in include/linux/cryp=
to.h.
+
+
+Synchronous block cipher API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+See source code comments for the *_blkcipher* calls in include/linux/c=
rypto.h.
+
+
+Asynchronous block cipher API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+See source code comments for the *_ablkcipher* calls and "ablkcipher_r=
equest_*
+calls in include/linux/crypto.h.
+
+
+Synchronous message digest API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+See source code comments for the *_hash* calls in include/linux/crypto=
=2Eh.
+
+
+Synchronous message digest API with caller-accessible state space
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+See source code comments for the *_shash* calls in include/crypto/hash=
=2Eh.
+
+
+Asynchronous message digest API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
+
+See source code comments for the *_ahash* calls and "ahash_request_*
+calls in include/crypto/hash.h.
+
+
+Random number generation API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+See source code comments for the *_rng* calls in include/crypto/hash.h=
=2E
+
+
+AEAD asynchronous cipher API
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+
+See source code comments for the *_aead* calls and "aead_request_*
+calls in include/linux/crypto.h.
+
+
+Authors
+=3D=3D=3D=3D=3D=3D=3D
+
+Stephan Mueller <smueller@chronox.de>
+Marek Vasut <marex@denx.de>
--=20
2.1.0
