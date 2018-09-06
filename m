From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/4] crypto: skcipher - Remove VLA usage
Date: Thu,  6 Sep 2018 15:58:50 -0700
Message-ID: <20180906225854.40989-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This removes VLAs[1] from SKCIPHER_REQUEST_ON_STACK by making sure that
on-stack requests are being used only on non-ASYNC algorithms and that
enough space has been reserved.

v2:
- Instead of globally failing large reqsizes, limit to only non-ASYNC users
  of the on-stack request.
- Remove unused tfm argument after VLA removal.

-Kees

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Kees Cook (4):
  crypto: skcipher - Consolidate encrypt/decrypt sanity check
  crypto: skcipher - Enforce non-ASYNC for on-stack requests
  crypto: skcipher - Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
  crypto: skcipher - Remove unused argument to SKCIPHER_REQUEST_ON_STACK()

 arch/s390/crypto/aes_s390.c                   |  8 +-
 arch/x86/crypto/fpu.c                         |  4 +-
 crypto/algif_aead.c                           |  2 +-
 crypto/authenc.c                              |  2 +-
 crypto/authencesn.c                           |  2 +-
 crypto/cryptd.c                               |  4 +-
 crypto/echainiv.c                             |  2 +-
 crypto/gcm.c                                  |  2 +-
 crypto/seqiv.c                                |  2 +-
 drivers/block/cryptoloop.c                    |  2 +-
 drivers/crypto/axis/artpec6_crypto.c          |  2 +-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       |  2 +-
 drivers/crypto/chelsio/chcr_algo.c            |  2 +-
 drivers/crypto/mxs-dcp.c                      |  2 +-
 drivers/crypto/omap-aes.c                     |  2 +-
 drivers/crypto/picoxcell_crypto.c             |  2 +-
 drivers/crypto/qce/ablkcipher.c               |  2 +-
 drivers/crypto/sahara.c                       |  8 +-
 drivers/crypto/vmx/aes_cbc.c                  |  4 +-
 drivers/crypto/vmx/aes_ctr.c                  |  2 +-
 drivers/crypto/vmx/aes_xts.c                  |  2 +-
 drivers/net/ppp/ppp_mppe.c                    |  6 +-
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  |  4 +-
 drivers/staging/rtl8192e/rtllib_crypt_wep.c   |  4 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c |  4 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c  |  4 +-
 drivers/usb/wusbcore/crypto.c                 |  2 +-
 include/crypto/skcipher.h                     | 74 ++++++++++++++-----
 net/ceph/crypto.c                             |  2 +-
 net/mac802154/llsec.c                         |  4 +-
 net/rxrpc/rxkad.c                             | 10 +--
 net/sunrpc/auth_gss/gss_krb5_crypto.c         | 14 ++--
 net/wireless/lib80211_crypt_tkip.c            |  4 +-
 net/wireless/lib80211_crypt_wep.c             |  4 +-
 34 files changed, 116 insertions(+), 80 deletions(-)

-- 
2.17.1
