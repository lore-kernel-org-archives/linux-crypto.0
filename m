From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH v2] IV Generation algorithms for dm-crypt
Date: Tue, 13 Dec 2016 14:19:08 +0530
Message-ID: <1481618949-20086-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35508 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932714AbcLMItr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 03:49:47 -0500
Received: by mail-pg0-f41.google.com with SMTP id p66so45585864pga.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2016 00:49:46 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

===============================================================================
GENIV Template cipher
===============================================================================

Currently, the iv generation algorithms are implemented in dm-crypt.c. The goal
is to move these algorithms from the dm layer to the kernel crypto layer by
implementing them as template ciphers so they can be used in relation with
algorithms like aes, and with multiple modes like cbc, ecb etc. As part of this
patchset, the iv-generation code is moved from the dm layer to the crypto layer
and adapt the dm-layer to send a whole 'bio' (as defined in the block layer)
at a time. Each bio contains the in memory representation of physically
contiguous disk blocks. Since the bio itself may not be contiguous in main
memory, the dm layer sets up a chained scatterlist of these blocks split into
physically contiguous segments in memory so that DMA can be performed.


v1 --> v2
----------

1. dm-crypt changes to process larger block sizes (one segment in a bio)
2. Incorporated changes w.r.t. comments from Herbert.

v1: https://patchwork.kernel.org/patch/9439175

One challenge in doing so is that the IVs are generated based on a 512-byte
sector number. This infact limits the block sizes to 512 bytes. But this should
not be a problem if a hardware with iv generation support is used. The geniv
itself splits the segments into sectors so it could choose the IV based on
sector number. But it could be modelled in hardware effectively by not
splitting up the segments in the bio.

Another challenge faced is that dm-crypt has an option to use multiple keys.
The key selection is done based on the sector number. If the whole bio is
encrypted / decrypted with the same key, the encrypted volumes will not be
compatible with the original dm-crypt [without the changes].

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
To be discussed
-------------------------------------------------------------------------------

1. Changes to testmgr.c
2. How to use multiple keys.
   When using multiple keys with the original dm-crypt, the key selection is
   made based on the sector number as:

   key_index = sector & (key_count - 1)

   This restricts the usage of the same key for encrypting/decrypting a single
   bio. One way to solve this is to move the key management code from dm-crypt
   to cryto layer. But this seems tricky when using template ciphers because,
   when multiple ciphers are instantiated from dm layer, each cipher instance
   set with a unique subkey (part of the bigger master key) and these instances
   themselves do not have access to each other's instances or contexts. This
   way, a single instance cannot encryt/decrypt a whole bio. I have not been
   able to get around this problem.

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

# With a keycount >= 2
# These were tested ok but not compatible with the older dm-crypt
# because the keys were selected based on the IV number when multiple
# keys are involved. This needs to be fixed.

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

 crypto/Kconfig         |   10 +
 crypto/Makefile        |    1 +
 crypto/geniv.c         | 1294 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c  |  894 +++++----------------------------
 include/crypto/geniv.h |   60 +++
 5 files changed, 1499 insertions(+), 760 deletions(-)
 create mode 100644 crypto/geniv.c
 create mode 100644 include/crypto/geniv.h

-- 
Binoy Jayan
