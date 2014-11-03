From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Mon, 3 Nov 2014 08:34:39 -0500
Message-ID: <20141103083439.635f5cb6@lwn.net>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
	<4163724.RCMDlx8dmE@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	Jason Cooper <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:37581 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaKCNen (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2014 08:34:43 -0500
In-Reply-To: <4163724.RCMDlx8dmE@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 02 Nov 2014 21:35:11 +0100
Stephan Mueller <smueller@chronox.de> wrote:

> The design of the kernel crypto API as well as hints to program with
> the kernel crypto API are given.

Cool to see this, thanks.  Please forgive me if I go into full grumpy
editor mode here.  There's a lot of good information here, but I think =
it
could be made better with a bit of effort...

> diff --git a/Documentation/crypto/crypto-API-spec.txt b/Documentation=
/crypto/crypto-API-spec.txt
> new file mode 100644
> index 0000000..8a24c98
> --- /dev/null
> +++ b/Documentation/crypto/crypto-API-spec.txt
> @@ -0,0 +1,721 @@
> +Kernel Crypto API Interface Specification
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The kernel crypto API offers a rich set of cryptographic ciphers as =
well as
> +other data transformation mechanisms and methods to invoke these. Th=
is document
> +contains a description of the API and provides example code.
> +
> +To understand and properly use the kernel crypto API a brief explana=
tion of its
> +structure is given. Based on the architecture, the API can be separa=
ted into
> +different components. Following the architecture specification, hint=
s to
> +developers of ciphers are provided. Pointers to the API function cal=
l
> +documentation are given at the end.
> +
> +The kernel crypto API refers to all algorithms as "transformation". =
Therefore, a

transformation*s*

> +cipher handle variable usually has the name "tfm". Besides cryptogra=
phic
> +operations, the kernel crypto API also knows compression transforms =
and handles
> +them the same way as ciphers.

Should that be s/transforms/transformations/ to keep the terminology
consistent?=20

> +The kernel crypto API serves the following entity types:
> +
> +	* consumers requesting cryptographic services
> +
> +	* data transformation implementations (typically ciphers) that
> +	  can be called by consumers using the kernel crypto API
> +
> +This specification is intended for consumers of the kernel crypto AP=
I as well
> +as for developers implementing ciphers. This API specification, howe=
ver, does
> +not discusses all API calls available to data transformation impleme=
ntations
> +((i.e. implementations of ciphers and other transformations (such as=
 CRC or
> +even compression algorithms) that can register with the kernel crypt=
o API).
> +
> +Note: The terms "transformation" and cipher algorithm are used inter=
changably.
> +
> +
> +Terminology
> +-----------
> +
> +The transformation implementation is an actual code or interface to =
hardware
> +which implements a certain transformation with precisely defined beh=
avior.
> +
> +The transformation object (TFM) is an instance of a transformation
> +implementation. There can be multiple transformation objects associa=
ted with
> +a single transformation implementation. Each of those transformation=
 objects
> +is held by a crypto API consumer or another transformation. Transfor=
mation
> +object is allocated when a crypto API consumer requests a transforma=
tion
> +implementation. The consumer is then provided with a structure, whic=
h contains
> +a transformation object (TFM).

It seems like it would be good to show what this object is and how to
allocate it here, rather than just teasing the reader saying it's possi=
ble?=20

> +The transformation context is private data associated with the trans=
formation
> +object.
> +
> +
> +Kernel Crypto API Architecture
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +
> +Cipher algorithm types
> +----------------------
> +
> +The kernel crypto API provides different API calls for the following=
 cipher
> +types:
> +
> +	* Symmetric ciphers
> +
> +	* AEAD ciphers
> +
> +	* Message digest, including keyed message digest
> +
> +	* Random number generation
> +
> +	* User space interface
> +
> +
> +Ciphers and Templates
> +---------------------
> +
> +The kernel crypto API provides implementations of single block ciphe=
rs and
> +message digests. In addition, the kernel crypto API provides numerou=
s
> +"templates" that can be used in conjunction with the single block ci=
phers and
> +message digests. Templates include all types of block chaining mode,=
 the HMAC
> +mechanism, etc.
> +
> +Single block ciphers and message digests can either be directly used=
 by a
> +caller or invoked together with a template to form multi-block ciphe=
rs or keyed
> +message digests.
> +
> +A single block cipher may even be called with multiple templates. Ho=
wever,
> +templates cannot be used without a single cipher.
> +
> +
> +Synchronous and asynchronous operation
> +--------------------------------------
> +
> +The kernel crypto API provides synchronous and asynchronous API oper=
ations.
> +
> +When using the synchronous API operation, the caller invokes a ciphe=
r operation
> +which is performed synchronously by the kernel crypto API. That mean=
s, the
> +caller waits until the cipher operation completes. Therefore, the ke=
rnel crypto
> +API calls work like regular function calls. For synchronous operatio=
n, the set
> +of API calls is small and conceptually similar to any other crypto l=
ibrary.
> +
> +Asynchronous operation is provided by the kernel crypto API which im=
plies that
> +the invocation of a cipher operation will complete almost instantly.=
 That
> +invocation triggers the cipher operation but it does not signal its =
completion.
> +Before invoking a cipher operation, the caller must provide a callba=
ck function
> +the kernel crypto API can invoke to signal the completion of the cip=
her
> +operation. Furthermore, the caller must ensure it can handle such as=
ynchronous
> +events by applying appropriate locking around its data. The kernel c=
rypto API
> +does not perform any special serialization operation to protect the =
caller's
> +data integrity.
> +
> +
> +Kernel crypto API cipher references and priority
> +------------------------------------------------
> +
> +A cipher is referenced by the caller with a string. That string has =
the
> +following semantics:
> +
> +	template(single block cipher)
> +
> +where "template" and "single block cipher" is the aforementioned tem=
plate and
> +single block cipher, respectively. If applicable, additional templat=
es may
> +enclose other templates, such as
> +
> +	template1(template2(single block cipher)))

I suspect a lot of readers may reach the glaze-over point around here. =
 The
discussion is useful but all very abstract and hard to tie to the actua=
l
crypto code.  A real-world example here would help.

> +The kernel crypto API may provide multiple implementations of a temp=
late or a
> +single block cipher. For example, AES on newer Intel hardware has th=
e following
> +implementations: AES-NI, assembler implementation, or straight C. No=
w, when
> +using the string "aes" with the kernel crypto API, which cipher impl=
ementation
> +is used? The answer to that question is the priority number assigned=
 to each
> +cipher implementation by the kernel crypto API. When a caller uses t=
he string to
> +refer to a cipher during initialization of a cipher handle, the kern=
el crypto
> +API looks up all implementations providing an implementation with th=
at name and
> +selects the implementation with the highest priority.

This seems like detail stuff that should go with the actual API descrip=
tion?

> +Now, a caller may have the need to refer to a specific cipher implem=
entation and
> +thus does not want to rely on the priority-based selection. To accom=
modate this
> +scenario, the kernel crypto API allows the cipher implementation to =
register a
> +unique name in addition to common names. When using that unique name=
, a caller
> +is therefore always sure to refer to the intended cipher implementat=
ion.
> +
> +The list of available ciphers is given in /proc/crypto. When reading=
 that file,
> +all available ciphers are listed. However, that list does not specif=
y all

Those two sentences repeat each other.  Anyway, that's available cipher=
s in
a running kernel, presumably, and not everything that could be build in=
to a
kernel.  A useful distinction to make.

> +possible permutations of templates and ciphers. Each block listed in
> +/proc/crypto contains the following information:
> +
> +	* name: the generic name of the cipher that is subject to the
> +	  priority-based selection -- this name can be used by the cipher
> +	  allocation API calls

So, it's not just a name, it's a qualified name - "ctr(aes)" rather tha=
n
just "aes".  How is the reader to interpret that extra information?

> +	* driver: the unique name of the cipher -- this name can be used by=
 the
> +	  cipher allocation API calls
> +
> +	* module: the kernel module providing the cipher implementation (or
> +	  "kernel" for statically linked ciphers)
> +
> +	* priority: the priority value of the cipher implementation
> +
> +	* refcnt: the reference count of the respective cipher (i.e. the nu=
mber
> +	  of current consumers of this cipher)
> +
> +	* selftest: specification whether the self test for the cipher pass=
ed
> +
> +	* type:
> +		- blkcipher for symmetric block ciphers
> +		- ablkcipher for asymmetric block ciphers
> +		- cipher for single block ciphers that may be used with an
> +		  additional template
> +		- shash for symmetric message digest
> +		- ahash for asymmetric message digest
> +		- aead for AEAD cipher type
> +		- compression for compression type transforms
> +		- rng for random number generator
> +		- givcipher for cipher with associated IV generator
> +
> +	* blocksize: blocksize of cipher in bytes
> +
> +	* keysize: key size in bytes
> +
> +	* ivsize: IV size in bytes
> +
> +	* seedsize: required size of seed data for random number generator
> +
> +	* digestsize: output size of the message digest

Worth saying that some of these fields won't be present if they are not
relevant?=20

> +	* geniv: IV generation type:
> +		- eseqiv for encrypted sequence number based IV generation
> +		- seqiv for sequence number based IV generation
> +		- chainiv for chain iv generation
> +		- <builtin> is a marker that the cipher implements IV generation
> +		  and handling as it is specific to the given cipher
> +
> +
> +Key sizes
> +---------
> +
> +When allocating a cipher handle, the caller only specifies the ciphe=
r type.
> +Symmetric ciphers, however, typically support multiple key sizes (e.=
g. AES-128
> +vs. AES-192 vs. AES-256). These key sizes are determined with the le=
ngth of the
> +provided key. Thus, the kernel crypto API does not provide a separat=
e way to
> +select the particular symmetric cipher key size.
> +
> +
> +Cipher allocation type and masks
> +--------------------------------
> +
> +The different cipher handle allocation functions allow the specifica=
tion of a
> +type and mask flag. Both parameters have the following meaning (and =
are
> +therefore not covered in the subsequent sections).
> +
> +The type flag specifies the type of the cipher algorithm. The caller=
 usually
> +provides a 0 when the caller wants the default handling. Otherwise, =
the caller
> +may provide the following selections which match the the aforementio=
ned cipher
> +types:
> +
> + * CRYPTO_ALG_TYPE_CIPHER	Raw block cipher
> + * CRYPTO_ALG_TYPE_COMPRESS	Compression
> + * CRYPTO_ALG_TYPE_AEAD		Authenticated Encryption with Associated Da=
ta (MAC)
> + * CRYPTO_ALG_TYPE_BLKCIPHER	Synchronous multi-block cipher
> + * CRYPTO_ALG_TYPE_ABLKCIPHER	Asynchronous multi-block cipher
> + * CRYPTO_ALG_TYPE_GIVCIPHER

What's this one?

> + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
> + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
> + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
> + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
> + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
> + * CRYPTO_ALG_TYPE_PCOMPRESS

What's that last one?

> +The mask flag restricts the type of cipher. The only allowed flag is
> +CRYPTO_ALG_ASYNC to restrict the cipher lookup function to asynchron=
ous ciphers.
> +Usually, a caller provides a 0 for the mask flag.
> +
> +When the caller provides a mask and type specification, the caller l=
imits the
> +kernel crypto API=C2=B4s search for a suitable cipher implementation=
 for the given
> +cipher name. That means, even when a caller uses a cipher name that =
exists
> +during its initialization call, the kernel crypto API may not select=
 it due
> +to the used type and mask field.
> +
> +
> +Developing Cipher Algorithms
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +Registering and unregistering transformation
> +---------------------------------------------
> +
> +There are three distinct types of registration functions in the Cryp=
to API.
> +One is used to register a generic cryptographic transformation, whil=
e the
> +other two are specific to HASH transformations and COMPRESSion. We w=
ill
> +discuss the latter two in a separate chapter, here we will only look=
 at
> +the generic ones.
> +
> +The generic registration functions can be found in include/linux/cry=
pto.h
> +and their definition can be seen below. The former function register=
s a
> +single transformation, while the latter works on an array of transfo=
rmation
> +descriptions. The latter is useful when registering transformations =
in bulk.
> +
> +   int crypto_register_alg(struct crypto_alg *alg);
> +   int crypto_register_algs(struct crypto_alg *algs, int count);
> +
> +The counterparts to those functions are listed below.
> +
> +   int crypto_unregister_alg(struct crypto_alg *alg);
> +   int crypto_unregister_algs(struct crypto_alg *algs, int count);
> +

This would be a good place to talk about struct crypto_alg?

> +Notice that both registration and unregistration functions do return=
 a value,
> +so make sure to handle errors.

What is the form of the error return?

> +The bulk registration / unregistration functions require that struct=
 crypto_alg
> +is an array of count size. These functions simply loop over that arr=
ay and
> +register / unregister each individual algorithm. If an error occurs,=
 the
> +loop is terminated at the offending algorithm definition. That means=
, the
> +algorithms prior to the offending algorithm are successfully registe=
red.

What is the return value in the error case?  How does the caller determ=
ine
which one failed?

> +Single-block ciphers [CIPHER]
> +-----------------------------
> +Example of transformations: aes, arc4, ...
> +
> +This section describes the simplest of all transformation implementa=
tions,
> +that being the CIPHER type. The CIPHER type is used for transformati=
ons
> +which operate on exactly one block at a time and there are no depend=
encies
> +between blocks at all.
> +
> +Registration specifics
> +......................
> +
> +The registration of [CIPHER] algorithm is specific in that struct cr=
ypto_alg
> +field .cra_type is empty. The .cra_u.cipher has to be filled in with=
 proper
> +callbacks to implement this transformation.

You haven't really introduced this structure, though, so the reader doe=
sn't
really know what fields exist and which should be worried about.

> +Fields in struct cipher_alg explained
> +.....................................

And struct cipher_alg is totally new and could use some introduction.
Where is it used?

> +This section explains the .cra_u.cipher fields and how they are call=
ed.
> +All of the fields are mandatory and must be filled:
> +
> +   .cia_min_keysize ... Minimum key size supported by the transforma=
tion.
> +                        - This is the smallest key length supported =
by this
> +                          transformation algorithm. This must be set=
 to one
> +                          of the pre-defined values as this is not h=
ardware
> +                          specific.
> +                        - Possible values for this field can be foun=
d via:
> +                          $ git grep "_MIN_KEY_SIZE" include/crypto/
> +   .cia_max_keysize ... Maximum key size supported by the transforma=
tion.
> +                        - This is the largest key length supported b=
y this
> +                          transformation algorithm. This must be set=
 to one
> +                          of the pre-defined values as this is not h=
ardware
> +                          specific.
> +                        - Possible values for this field can be foun=
d via:
> +                          $ git grep "_MAX_KEY_SIZE" include/crypto/
> +   .cia_setkey() ...... Set key for the transformation.
> +                        - This function is used to either program a =
supplied
> +                          key into the hardware or store the key in =
the
> +                          transformation context for programming it =
later. Note
> +                          that this function does modify the transfo=
rmation
> +                          context.
> +                        - This function can be called multiple times=
 during
> +                          the existence of the transformation object=
, so one
> +                          must make sure the key is properly reprogr=
ammed
> +                          into the hardware.
> +                        - This function is also responsible for chec=
king the
> +                          key length for validity.
> +                        - In case a software fallback was put in pla=
ce in
> +                          the .cra_init() call, this function might =
need to
> +                          use the fallback if the algorithm doesn't =
support
> +                          all of the key sizes.

What's this software fallback and cra_init() of which you speak?  Most
readers will have no clue of what you're talking about here.

> +   .cia_encrypt() ..... Encrypt a single block.
> +                        - This function is used to encrypt a single =
block of
> +                          data, which must be .cra_blocksize big. Th=
is always
> +                          operates on a full .cra_blocksize and it i=
s not
> +                          possible to encrypt a block of smaller siz=
e. The
> +                          supplied buffers must therefore also be at=
 least
> +                          of .cra_blocksize size.

This is about where I realize life might be better if you gave full
function prototypes.  Where is cra_blocksize specified?

> +                        - Both the input and output buffers are alwa=
ys aligned
> +                          to .cra_alignmask . In case either of the =
input or
> +                          output buffer supplied by user of the cryp=
to API is
> +                          not aligned to .cra_alignmask, the crypto =
API will
> +                          re-align the buffers. The re-alignment mea=
ns that a
> +                          new buffer will be allocated, the data wil=
l be copied
> +                          into the new buffer, then the processing w=
ill happen
> +                          on the new buffer, then the data will be c=
opied back
> +                          into the original buffer and finally the n=
ew buffer
> +                          will be freed.
> +                        - In case a software fallback was put in pla=
ce in
> +                          the .cra_init() call, this function might =
need to
> +                          use the fallback if the algorithm doesn't =
support
> +                          all of the key sizes.
> +                        - In case the key was stored in transformati=
on context,
> +                          the key might need to be re-programmed int=
o the
> +                          hardware in this function.
> +                        - This function shall not modify the transfo=
rmation
> +                          context, as this function may be called in=
 parallel
> +                          with the same transformation object.
> +   .cia_decrypt() ..... Decrypt a single block.
> +                        - This is a reverse counterpart to .cia_encr=
ypt(), and
> +                          the conditions are exactly the same.
> +
> +Here are schematics of how these functions are called when operated =
from
> +other part of the kernel. Note that the .cia_setkey() call might hap=
pen
> +before or after any of these schematics happen, but must not happen =
during
> +any of these are in-flight.
> +
> +         KEY ---.    PLAINTEXT ---.
> +                v                 v
> +          .cia_setkey() -> .cia_encrypt()
> +                                  |
> +                                  '-----> CIPHERTEXT
> +
> +Please note that a pattern where .cia_setkey() is called multiple ti=
mes
> +is also valid:
> +
> +  KEY1 --.    PLAINTEXT1 --.         KEY2 --.    PLAINTEXT2 --.
> +         v                 v                v                 v
> +   .cia_setkey() -> .cia_encrypt() -> .cia_setkey() -> .cia_encrypt(=
)
> +                           |                                  |
> +                           '---> CIPHERTEXT1                  '---> =
CIPHERTEXT2
> +
> +
> +Multi-block ciphers [BLKCIPHER] [ABLKCIPHER]
> +--------------------------------------------
> +
> +Example of transformations: cbc(aes), ecb(arc4), ...
> +
> +This section describes the multi-block cipher transformation impleme=
ntations
> +for both synchronous [BLKCIPHER] and asynchronous [ABLKCIPHER] case.=
 The
> +multi-block ciphers are used for transformations which operate on sc=
atterlists
> +of data supplied to the transformation functions. They output the re=
sult into
> +a scatterlist of data as well.
> +
> +Registration specifics
> +......................
> +
> +The registration of [BLKCIPHER] or [ABLKCIPHER] algorithms is one of=
 the most
> +standard procedures throughout the crypto API. There are no specific=
s for
> +this case other that re-aligning of input and output buffers does no=
t happen
> +automatically within the crypto API, but is the responsibility of th=
e crypto
> +API consumer. The crypto API consumer shall use crypto_blkcipher_ali=
gnmask()

But just above you said that the crypto subsystem would copy data to al=
ign
it if need be?

> +or crypto_ablkcipher_alignmask() respectively to determine the needs=
 of the
> +transformation object and prepare the scatterlist with data accordin=
gly.
> +
> +Fields in struct blkcipher_alg and struct ablkcipher_alg explained
> +..................................................................

Where are these structs used?

> +This section explains the .cra_u.blkcipher and .cra_u.cra_ablkcipher=
 fields
> +and how they are called. Please note that this is very similar to th=
e basic
> +CIPHER case for all but minor details. All of the fields but .geniv =
are
> +mandatory and must be filled:
> +
> +   .min_keysize ... Minimum key size supported by the transformation=
=2E
> +                    - This is the smallest key length supported by t=
his
> +                      transformation algorithm. This must be set to =
one
> +                      of the pre-defined values as this is not hardw=
are
> +                      specific.
> +                    - Possible values for this field can be found vi=
a:
> +                      $ git grep "_MIN_KEY_SIZE" include/crypto/
> +   .max_keysize ... Maximum key size supported by the transformation=
=2E
> +                    - This is the largest key length supported by th=
is
> +                      transformation algorithm. This must be set to =
one
> +                      of the pre-defined values as this is not hardw=
are
> +                      specific.
> +                    - Possible values for this field can be found vi=
a:
> +                      $ git grep "_MAX_KEY_SIZE" include/crypto/
> +   .setkey() ...... Set key for the transformation.
> +                    - This function is used to either program a supp=
lied
> +                      key into the hardware or store the key in the
> +                      transformation context for programming it late=
r. Note
> +                      that this function does modify the transformat=
ion
> +                      context.
> +                    - This function can be called multiple times dur=
ing
> +                      the existence of the transformation object, so=
 one
> +                      must make sure the key is properly reprogramme=
d
> +                      into the hardware.
> +                    - This function is also responsible for checking=
 the
> +                      key length for validity.
> +                    - In case a software fallback was put in place i=
n
> +                      the .cra_init() call, this function might need=
 to
> +                      use the fallback if the algorithm doesn't supp=
ort
> +                      all of the key sizes.
> +   .encrypt() ..... Encrypt a scatterlist of blocks.
> +                    - This function is used to encrypt the supplied
> +                      scatterlist containing the blocks of data. The=
 crypto
> +                      API consumer is responsible for aligning the e=
ntries
> +                      of the scatterlist properly and making sure th=
e
> +                      chunks are correctly sized.
> +                    - In case a software fallback was put in place i=
n
> +                      the .cra_init() call, this function might need=
 to
> +                      use the fallback if the algorithm doesn't supp=
ort
> +                      all of the key sizes.
> +                    - In case the key was stored in transformation c=
ontext,
> +                      the key might need to be re-programmed into th=
e
> +                      hardware in this function.
> +                    - This function shall not modify the transformat=
ion
> +                      context, as this function may be called in par=
allel
> +                      with the same transformation object.
> +   .decrypt() ..... Decrypt a single block.
> +                    - This is a reverse counterpart to .encrypt(), a=
nd the
> +                      conditions are exactly the same.
> +
> +Please refer to the single block cipher description for schematics o=
f the block
> +cipher usage. The usage patterns are exactly the same for [ABLKCIPHE=
R] and
> +[BLKCIPHER] as they are for plain [CIPHER].
> +
> +Specifics of asynchronous multi-block cipher
> +............................................
> +
> +There are a couple of specifics to the [ABLKCIPHER] interface.
> +
> +First of all, some of the drivers will want to use the Generic Scatt=
erWalk
> +in case the hardware needs to be fed separate chunks of the scatterl=
ist
> +which contains the plaintext and will contain the ciphertext. Please=
 refer
> +below for a description and usage of the Generic ScatterWalk interfa=
ce.
> +
> +It is recommended to enqueue cryptographic transformation requests i=
nto
> +generic crypto queues. This allows for these requests to be processe=
d in
> +sequence as the cryptographic hardware becomes free.

What's a generic crypto queue?  That's a new concept.

> +Hashing [HASH]
> +--------------
> +
> +Example of transformations: crc32, md5, sha1, sha256,...
> +
> +Registering and unregistering the transformation
> +................................................
> +
> +There are multiple ways to register a HASH transformation, depending=
 on
> +whether the transformation is synchronous [SHASH] or asynchronous [A=
HASH]
> +and the amount of HASH transformations we are registering. You can f=
ind

s/amount/number/

> +the prototypes defined in include/crypto/internal/hash.h :
> +
> +   int crypto_register_ahash(struct ahash_alg *alg);
> +
> +   int crypto_register_shash(struct shash_alg *alg);
> +   int crypto_register_shashes(struct shash_alg *algs, int count);

Yay, full prototypes.  But can we introduce that structure too?  I gues=
s
you sort-of do that below.

> +The respective counterparts for unregistering the HASH transformatio=
n are
> +as follows:
> +
> +   int crypto_unregister_ahash(struct ahash_alg *alg);
> +
> +   int crypto_unregister_shash(struct shash_alg *alg);
> +   int crypto_unregister_shashes(struct shash_alg *algs, int count);
> +
> +Common fields of struct shash_alg and ahash_alg explained
> +.........................................................
> +
> +For definition of these structures, please refer to include/crypto/h=
ash.h .
> +We will now explain the meaning of each field:
> +
> +   .init() ......... Initialize the transformation context.
> +                     - Intended only to initialize the state of the =
HASH
> +                       transformation at the begining. This shall fi=
ll in
> +                       the internal structures used during the entir=
e duration
> +                       of the whole transformation.
> +                     - No data processing happens at this point.
> +   .update() ....... Push chunk of data into the driver for transfor=
mation.

Push *a* chunk...

> +                     - This function actually pushes blocks of data =
from upper
> +                       layers into the driver, which then passes tho=
se to the
> +                       hardware as seen fit.
> +                     - This function must not finalize the HASH tran=
sformation,

What does "finalize" mean in this context?

> +                       this only adds more data into the transformat=
ion.
> +                     - This function shall not modify the transforma=
tion
> +                       context, as this function may be called in pa=
rallel
> +                       with the same transformation object.
> +                     - Data processing can happen synchronously [SHA=
SH] or
> +                       asynchronously [AHASH] at this point.
> +   .final() ....... Retrieve result from the driver.
> +                     - This function finalizes the transformation an=
d retrieves
> +                       the resulting hash from the driver and pushes=
 it back to
> +                       upper layers.
> +                     - No data processing happens at this point.
> +   .finup() ........ Combination of update()+final() .
> +                     - This function is effectively a combination of=
 update()
> +                       and final() calls issued in sequence.
> +                     - As some hardware cannot do update() and final=
()
> +                       separately, this callback was added to allow =
such
> +                       hardware to be used at least by IPsec.
> +                     - Data processing can happen synchronously [SHA=
SH] or
> +                       asynchronously [AHASH] at this point.
> +   .digest() ....... Combination of init()+update()+final() .
> +                     - This function effectively behaves as the enti=
re chain
> +                       of operations, init(), update() and final() i=
ssued in
> +                       sequence.
> +                     - Just like .finup(), this was added for hardwa=
re which
> +                       cannot do even the .finup(), but can only do =
the whole
> +                       transformation in one run.
> +                     - Data processing can happen synchronously [SHA=
SH] or
> +                       asynchronously [AHASH] at this point.

Are functions like these mandatory, or will the crypto core call the
sequence separately if need be?

> +   .setkey() ....... Set optional key used by the hashing algorithm =
=2E
> +                     - Intended to push optional key used by the has=
hing
> +                       algorithm from upper layers into the driver.
> +                     - This function can store the key in the transf=
ormation
> +                       context or can outright program it into the h=
ardware.
> +                       In the former case, one must be careful to pr=
ogram
> +                       the key into the hardware at appropriate time=
 and one
> +                       must be careful that .setkey() can be called =
multiple
> +                       times during the existence of the transformat=
ion
> +                       object.
> +                     - Not all hashing algorithms do implement this =
function.
> +                       -> SHAx/MDx/CRCx do NOT implement this functi=
on.
> +                       -> HMAC(MDx)/HMAC(SHAx) do implement this fun=
ction.
> +                     - This function must be called before any other=
 of the
> +                       init()/update()/final()/finup()/digest() is c=
alled.
> +                     - No data processing happens at this point.
> +
> +   .export() ....... Export partial state of the transformation .
> +                     - This function dumps the entire state of the o=
ngoing
> +                       transformation into a provided block of data =
so it
> +                       can be .import()ed back later on.
> +                     - This is useful in case you want to save parti=
al result
> +                       of the transformation after processing certai=
n amount
> +                       of data and reload this partial result multip=
le times
> +                       later on for multiple re-use.
> +                     - No data processing happens at this point.
> +   .import() ....... Import partial state of the transformation .
> +                     - This function loads the entire state of the o=
ngoing
> +                       transformation from a provided block of data =
so the
> +                       transformation can continue from this point o=
nward.
> +                     - No data processing happens at this point.
> +
> +Here are schematics of how these functions are called when operated =
from
> +other part of the kernel. Note that the .setkey() call might happen =
before
> +or after any of these schematics happen, but must not happen during =
any of
> +these are in-flight. Please note that calling .init() followed immed=
iatelly
> +by .finish() is also a perfectly valid transformation.
> +
> +   I)   DATA -----------.
> +                        v
> +         .init() -> .update() -> .final()      ! .update() might not=
 be called
> +                     ^    |         |            at all in this scen=
ario.
> +                     '----'         '---> HASH
> +
> +   II)  DATA -----------.-----------.
> +                        v           v
> +         .init() -> .update() -> .finup()      ! .update() may not b=
e called
> +                     ^    |         |            at all in this scen=
ario.
> +                     '----'         '---> HASH
> +
> +   III) DATA -----------.
> +                        v
> +                    .digest()                  ! The entire process =
is handled
> +                        |                        by the .digest() ca=
ll.
> +                        '---------------> HASH
> +
> +Here is a schematic of how the .export()/.import() functions are cal=
led when
> +used from another part of the kernel.
> +
> +   KEY--.                 DATA--.
> +        v                       v                  ! .update() may n=
ot be called
> +    .setkey() -> .init() -> .update() -> .export()   at all in this =
scenario.
> +                             ^     |         |
> +                             '-----'         '--> PARTIAL_HASH
> +
> +   ----------- other transformations happen here -----------
> +
> +   PARTIAL_HASH--.   DATA1--.
> +                 v          v
> +             .import -> .update() -> .final()     ! .update() may no=
t be called
> +                         ^    |         |           at all in this s=
cenario.
> +                         '----'         '--> HASH1
> +
> +   PARTIAL_HASH--.   DATA2-.
> +                 v         v
> +             .import -> .finup()
> +                           |
> +                           '---------------> HASH2
> +
> +The struct hash_alg_common fields and it's mirror in struct shash_al=
g
> +....................................................................=
=2E
> +
> +This structure defines various size constraints and generic properti=
es of
> +the hashing algorithm that is being implemented. Let us first inspec=
t the
> +size properties:

Where is this structure used?

> +   digestsize .... Size of the result of the transformation.
> +                   - A buffer of this size must be available to the =
=2Efinal()
> +                     and .finup() calls, so they can store the resul=
ting hash
> +                     into it.
> +                   - For various predefined sizes, search include/cr=
ypto/
> +                     using 'git grep _DIGEST_SIZE include/crypto' .
> +   statesize ..... Size of the block for partial state of the transf=
ormation.
> +                   - A buffer of this size must be passed to the .ex=
port()
> +                     function as it will save the partial state of t=
he
> +                     transformation into it. On the other side, the =
=2Eimport()
> +                     function will load the state from a buffer of t=
his size
> +                     as well.
> +
> +
> +Specifics of asynchronous HASH transformation
> +.............................................
> +
> +There are a couple of specifics to the [AHASH] interface.
> +
> +First of all, some of the drivers will want to use the Generic Scatt=
erWalk
> +in case the hardware needs to be fed separate chunks of the scatterl=
ist
> +which contains the input data. The buffer containing the resulting h=
ash will
> +always be properly aligned to .cra_alignmask so there is no need to =
worry
> +about this. Please refer to the section 9.1) of this document of the
> +description and usage of the Generic ScatterWalk interface.
> +
> +It is recommended to enqueue cryptographic transformation requests i=
nto
> +generic crypto queues. This allows for these requests to be processe=
d in
> +sequence as the cryptographic hardware becomes free.
> +
> +
> +Single block cipher API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_cipher* calls in include/linux/cr=
ypto.h.
> +
> +
> +Synchronous block cipher API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_blkcipher* calls in include/linux=
/crypto.h.
> +
> +
> +Asynchronous block cipher API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_ablkcipher* calls and "ablkcipher=
_request_*
> +calls in include/linux/crypto.h.
> +
> +
> +Synchronous message digest API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_hash* calls in include/linux/cryp=
to.h.
> +
> +
> +Synchronous message digest API with caller-accessible state space
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_shash* calls in include/crypto/ha=
sh.h.
> +
> +
> +Asynchronous message digest API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_ahash* calls and "ahash_request_*
> +calls in include/crypto/hash.h.
> +
> +
> +Random number generation API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_rng* calls in include/crypto/hash=
=2Eh.
> +
> +
> +AEAD asynchronous cipher API
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +See source code comments for the *_aead* calls and "aead_request_*
> +calls in include/linux/crypto.h.

These are all useful.  But I wonder if it would be worth the effort to =
turn
this inti a proper docbook document that automatically has everything
together in one place?

> +
> +Authors
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +Stephan Mueller <smueller@chronox.de>
> +Marek Vasut <marex@denx.de>

jon
