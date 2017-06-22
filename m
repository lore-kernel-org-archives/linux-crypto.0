From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v6 0/2] IV Generation algorithms for dm-crypt
Date: Thu, 22 Jun 2017 10:11:48 +0530
Message-ID: <1498106510-19793-1-git-send-email-binoy.jayan@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Rajendra <rnayak@codeaurora.org>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Mark Brown <broonie@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

===============================================================================
dm-crypt optimization for larger block sizes
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

One challenge in doing so is that the IVs are generated based on a 512-byte
sector number. This infact limits the block sizes to 512 bytes. But this should
not be a problem if a hardware with iv generation support is used. The geniv
itself splits the segments into sectors so it could choose the IV based on
sector number. But it could be modelled in hardware effectively by not
splitting up the segments in the bio.

Another challenge faced is that dm-crypt has an option to use multiple keys.
The key selection is done based on the sector number. If the whole bio is
encrypted / decrypted with the same key, the encrypted volumes will not be
compatible with the original dm-crypt [without the changes]. So, the key
selection code is moved to crypto layer so the neighboring sectors are
encrypted with a different key.

The dm layer allocates space for iv. The hardware drivers can choose to make
use of this space to generate their IVs sequentially or allocate it on their
own. This can be moved to crypto layer too. Postponing this decision until
the requirement to integrate milan's changes are clear.

Interface to the crypto layer - include/crypto/geniv.h

More information on test procedure can be found in v1.
Results of performance tests with software crypto in v5.

The patch 'crypto: Multikey template for essiv' depends on
the following patches by Gilad:
     MAINTAINERS: add Gilad BY as maintainer for ccree
     staging: ccree: add devicetree bindings
     staging: ccree: add TODO list
     staging: add ccree crypto driver

Revisions:
----------

v1: https://patchwork.kernel.org/patch/9439175
v2: https://patchwork.kernel.org/patch/9471923
v3: https://lkml.org/lkml/2017/1/18/170
v4: https://patchwork.kernel.org/patch/9559665
v5: https://patchwork.kernel.org/patch/9669237

v5 --> v6:
----------

1. Moved allocation of initialization vectors to the iv-generator
2. Few consmetic changes as the consequence of the above
3. Few logical to boolean expressions for faster calculation
4. Included multikey template for splitting keys.
   This needs testing with real hardware (juno with ccree)
   and also modification. It is only for testing and not
   for inclusion upstream.

v4 --> v5
----------

1. Fix for the multiple instance issue in /proc/crypto
2. Few cosmetic changes including struct alignment
3. Simplified 'struct geniv_req_info'

v3 --> v4
----------
Fix for the bug reported by Gilad Ben-Yossef.
The element '__ctx' in 'struct skcipher_request req' overflowed into the
element 'struct scatterlist src' which immediately follows 'req' in
'struct geniv_subreq' and corrupted src.

v2 --> v3
----------

1. Moved iv algorithms in dm-crypt.c for control
2. Key management code moved from dm layer to cryto layer
   so that cipher instance selection can be made depending on key_index
3. The revision v2 had scatterlist nodes created for every sector in the bio.
   It is modified to create only once scatterlist node to reduce memory
   foot print. Synchronous requests are processed sequentially. Asynchronous
   requests are processed in parallel and is freed in the async callback.
4. Changed allocation for sub-requests using mempool

v1 --> v2
----------

1. dm-crypt changes to process larger block sizes (one segment in a bio)
2. Incorporated changes w.r.t. comments from Herbert.


Binoy Jayan (2):
  crypto: Add IV generation algorithms
  crypto: Multikey template for essiv

 drivers/md/dm-crypt.c            | 1940 +++++++++++++++++++++++++++-----------
 drivers/staging/ccree/Makefile   |    2 +-
 drivers/staging/ccree/essiv.c    |  777 +++++++++++++++
 drivers/staging/ccree/essiv_sw.c | 1040 ++++++++++++++++++++
 include/crypto/geniv.h           |   46 +
 5 files changed, 3251 insertions(+), 554 deletions(-)
 create mode 100644 drivers/staging/ccree/essiv.c
 create mode 100644 drivers/staging/ccree/essiv_sw.c
 create mode 100644 include/crypto/geniv.h

-- 
Binoy Jayan
