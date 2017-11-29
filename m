From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 0/4] crypto: engine - Permit to enqueue all async requests
Date: Wed, 29 Nov 2017 09:41:17 +0100
Message-ID: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, alexandre.torgue@st.com,
        arei.gonglei@huawei.com, davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello

The current crypto_engine support only ahash and ablkcipher.
My first patch which try to add skcipher was Nacked, it will add too many functions
and adding other algs(aead, asymetric_key) will make the situation worst.

This patchset remove all algs specific stuff and now only process generic crypto_async_request.

The requests handler function pointer are now moved out of struct engine and
are now stored directly in a crypto_engine_reqctx.

The original proposal of Herbert [1] cannot be done completly since the crypto_engine
could only dequeue crypto_async_request and it is impossible to access any request_ctx
without knowing the underlying request type.

So I do something near that was requested: adding crypto_engine_reqctx in TFM context.
Note that the current implementation expect that crypto_engine_reqctx
is the first member of the context.

The first patch convert the crypto engine with the new way,
while the following patchs convert the 3 existing users of crypto_engine.
Note that this split break bisection, so probably the final commit will be all merged.

The 3 latest patch were compile tested only, but the first is tested successfully
with my new sun8i-ce driver.

Regards

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1474434.html

Corentin Labbe (4):
  crypto: engine - Permit to enqueue all async requests
  crypto: omap: convert to new crypto engine API
  crypto: virtio: convert to new crypto engine API
  crypto: stm32: convert to the new crypto engine API

 crypto/crypto_engine.c                       | 188 ++++++---------------------
 drivers/crypto/omap-aes.c                    |  21 ++-
 drivers/crypto/omap-aes.h                    |   3 +
 drivers/crypto/omap-des.c                    |  24 +++-
 drivers/crypto/stm32/stm32-hash.c            |  22 +++-
 drivers/crypto/virtio/virtio_crypto_algs.c   |  15 ++-
 drivers/crypto/virtio/virtio_crypto_common.h |   2 +-
 drivers/crypto/virtio/virtio_crypto_core.c   |   3 -
 include/crypto/engine.h                      |  46 +++----
 9 files changed, 122 insertions(+), 202 deletions(-)

-- 
2.13.6
