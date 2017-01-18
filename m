From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [RFC PATCH v3] IV Generation algorithms for dm-crypt
Date: Wed, 18 Jan 2017 15:10:24 +0530
Message-ID: <1484732425-10319-1-git-send-email-binoy.jayan@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Milan Broz <gmazyland@gmail.com>, Gilad <gilad@benyossef.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35598 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdARJlX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Jan 2017 04:41:23 -0500
Received: by mail-pg0-f41.google.com with SMTP id 194so3369722pgd.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Jan 2017 01:40:35 -0800 (PST)
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

Revisions:

v1: https://patchwork.kernel.org/patch/9439175
v2: https://patchwork.kernel.org/patch/9471923

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

Binoy Jayan (1):
  crypto: Add IV generation algorithms

 drivers/md/dm-crypt.c  | 1891 ++++++++++++++++++++++++++++++++++--------------
 include/crypto/geniv.h |   47 ++
 2 files changed, 1399 insertions(+), 539 deletions(-)
 create mode 100644 include/crypto/geniv.h

-- 
Binoy Jayan
