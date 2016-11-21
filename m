From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH] IV Generation algorithms for dm-crypt
Date: Mon, 21 Nov 2016 15:40:08 +0530
Message-ID: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


===============================================================================
GENIV Template cipher
===============================================================================

Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
is to move these algorithms from the dm layer to the kernel crypto layer by
implementing them as template ciphers so they can be used in relation with
algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
patchset, the iv-generation code is moved from the dm layer to the crypto layer.
The dm-layer can later be optimized to encrypt larger block sizes in a single
call to the crypto engine.

One challenge in doing so is with the 'essiv' which creates the IV by hashing
the 512-byte sector number. This infact limits the block sizes to 512 bytes.
A way to get around this problem has to be explored. Another thing to note is
that the algorithms shares its context data structures (cipher context and
request context) with the callee, i.e. dm-crypt here. Not sure if this coupling
is accepted. If not, this has to be decoupled. A new crypto api
'crypto_skcipher_set_ctx' defined in 'include/crypto/skcipher.h' which was
initially written for addressing this is not used now. But even if it is used,
the data structure definition would still be shared.

The following ASCII art decomposes the kernel crypto API layers when using the
skcipher with the automated IV generation. The shown example is used by the
DM layer. For other use cases of cbc(aes), the ASCII art applies as well, but
the caller may not use the same with a separate IV generator. In this case, the
caller must generate the IV. The depicted example decomposes <ivgen>(cbc(aes))
based on the generic C implementations (geniv.c, cbc.c and aes-generic.c).
The generic implementation depicts the dependency between the templates ciphers
used in implementing geniv using the kernel crypto API.
Here, <geniv> indicates one of the following algorithms:

1. plain
2. plain64
3. essiv
4. benbi
5. null
6. lmk
7. tcw

It is possible that some streamlined cipher implementations (like AES-NI)
provide implementations merging aspects which in the view of the kernel crypto
API cannot be decomposed into layers any more. Each block in the following
ASCII art is an independent cipher instance obtained from the kernel crypto
API. Each block is accessed by the caller or by other blocks using the API
functions defined by the kernel crypto API for the cipher implementation type.
The blocks below indicate the cipher type as well as the specific logic
implemented in the cipher.

The ASCII art picture also indicates the call structure, i.e. who calls which
component. The arrows point to the invoked block where the caller uses the API
applicable to the cipher type specified for the block. For the purpose of
illustration, here we take the example of the aes mode 'cbc'. However, the IV
generation algorithm could be used with other aes modes like ecb as well.

-------------------------------------------------------------------------------
Geniv implementation
-------------------------------------------------------------------------------

NB: The ASCII art below is best viewed in a fixed-width font.

                             crypt_convert_block()              (DM Layer)
                                      |
                                      | (1)
                                      |
                                      v
+------------+   +-----------+   +-----------+       +-----------+
|            |   |           |   |           |  (2)  |           |
|  skcipher  |   | skcipher  |   | skcipher  |----+  | skcipher  |   Blocks for
| (plain/64) |   | (benbi)   |   | (essiv)   |    |  |  (null)   |   lmk, tcw
+------------+   +-----------+   +-----------+    |  +-----------+ 
     |                |               |           v         |
     | (3)            | (3)      (3)  |    +-----------+    |
     |                |               |    |           |    |
     |                |               |    |   ahash   |    | (3)
     |                |               |    |           |    |
     |                |               |    +-----------+    |
     |                |               v                     |     (Crypto API
     |                |         +-----------+               |        Layer)
     |                v         |           |               |
     +------------------------> |  skcipher | <-------------+
                                |   (cbc)   |
                                +-----------+  (AES Mode Template cipher)
                                      | (4)
                                      v
                               +-----------+
                               |           |
                               |   cipher  |   (Base generic-AES cipher)
                               |   (aes)   |
                               +-----------+

     
The following call sequence is applicable when the DM layer triggers an
encryption operation with the crypt_convert_block() function. During
configuration, the administrator sets up the use of <geniv>(cbc(aes)) as the
template cipher. 'geniv' can be one among plain, plain64, essiv, benbi, null,
lmk, or tcw which are all implemented as seperate templates. 
The following are the template ciphers implemented as part of 'geniv.c'

1. plain(cbc(aes))
2. plain64(cbc(aes))
3. essiv(cbc(aes))
4. benbi(cbc(aes))
5. null(cbc(aes))
6. lmk(cbc(aes))
7. tcw(cbc(aes))

The following call sequence is now depicted in the ASCII art above:

1. crypt_convert_block invokes crypto_skcipher_encrypt() to trigger encryption
   operation of a single block (i.e. sector) with the IV same as the sector no.
   For example, with essiv, the IV generation implementation is registered with
   a call to 'crypto_register_template(&crypto_essiv_tmpl)'

2. During instantiation of the 'geniv' handle, the IV generation algorithm is
   instantiated. For the purpose of illustration, we take the example of essiv.
   In this case, the ahash cipher is instantiated to calculate the hash of the
   sector to generate the IV.

3. Now, geniv uses the skcipher api calls to invoke the associated cipher. In
   our case, during the instantiation of geniv, the cipher handle for cbc is
   provided to geniv. The geniv skcipher type implementation now invokes the
   skcipher api with the instantiated cbc(aes) cipher handle. During the
   instantiation of the cbc(aes) cipher, the cipher type generic-aes is also
   instantiated. That means that the SKCIPHER implementation of cbc(aes) only
   implements the Cipher-block chaining mode. After performing block chaining
   operation, the cipher implementation of aes is invoked. The skcipher of
   cbc(aes) now invokes the cipher api with the aes cipher handle to encrypt
   one block.

-------------------------------------------------------------------------------
Clarifications
-------------------------------------------------------------------------------

1. Changes to testmgr.c
2. How to encrypt blocks bigger than 512 bytes while using essiv?
   As sectors are tied to IV in case of 'essiv'.
   Will changing block size make it backward incompatible
   and with other platforms (like windows) which support LUKS volumes.
3. Did not move the key management code from dm-crypt to cryto layer
   when keycount > 1 as multiple ciphers are instantiated from dm layer
   with each cipher instance is allotted a part of the key provided.

-------------------------------------------------------------------------------
Test procedure
-------------------------------------------------------------------------------

The algorithms are tested using 'cryptsetup' utility to create LUKS
compatible volumes on Qemu.

NB: '/dev/sdb' is a second disk volume (configured in qemu)

# One time setup - Format the device compatible with LUKS.
# Choose one of the following IV generation alorithms at a time
cryptsetup -y -c aes-cbc-plain -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-plain64 -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-essiv:sha256 -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-benbi -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-null -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-lmk -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes-cbc-tcw -s 256 --hash sha256 luksFormat /dev/sdb

# With a keycount
cryptsetup -y -c aes:2-cbc-plain -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes:2-cbc-plain64 -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes:2-cbc-essiv:sha256 -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes:2-cbc-null -s 256 --hash sha256 luksFormat /dev/sdb
cryptsetup -y -c aes:2-cbc-lmk -s 256 --hash sha256 luksFormat /dev/sdb

# Add additional key - optional
cryptsetup luksAddKey /dev/sdb

# The above lists only a limited number of tests with the aes cipher.
# The IV generation algorithms may also be tested with other ciphers as well.

cryptsetup luksDump --dump-master-key /dev/sdb

# create a luks volume and open the device
cryptsetup luksOpen /dev/sdb crypt_fun
dmsetup table --showkeys

# Write some data to the device
cat data.txt > /dev/mapper/crypt_fun

# Read 100 bytes back
dd if=/dev/mapper/crypt_fun of=out.txt bs=100 count=1
cat out.txt

mkfs.ext4 -j /dev/mapper/crypt_fun

# Mount if fs creation succeeds
mount -t ext4 /dev/mapper/crypt_fun /mnt

<-- Use the encrypted file system -->

umount /mnt
cryptsetup luksClose crypt_fun
cryptsetup luksRemoveKey /dev/sdb

This seems to work well. The file system mounts successfully and the files
written to in the file system remain persistent across reboots.

Binoy Jayan (1):
  crypto: Add IV generation algorithms

 crypto/Kconfig            |    8 +
 crypto/Makefile           |    1 +
 crypto/geniv.c            | 1113 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c     |  725 +++--------------------------
 include/crypto/geniv.h    |  109 +++++
 include/crypto/skcipher.h |   17 +
 6 files changed, 1309 insertions(+), 664 deletions(-)
 create mode 100644 crypto/geniv.c
 create mode 100644 include/crypto/geniv.h

-- 
Binoy Jayan

