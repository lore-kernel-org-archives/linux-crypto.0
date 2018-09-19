From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 00/23] crypto: skcipher - Remove VLA usage
Date: Tue, 18 Sep 2018 19:10:37 -0700
Message-ID: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is the full follow-up to earlier discussions[1] that suggested
adding a new struct crypto_sync_skcipher to handle the VLA removal from
SKCIPHER_REQUEST_ON_STACK.

This series is effectively a no-op change: everything is a wrapper
around struct crypto_skcipher, but provides compile-time enforcement
for not putting an ASYNC skcipher on the stack, which allows us to
declare the on-stack requests with a fixed stack size.

[1] https://lkml.kernel.org/r/CAGXu5j+bpLK=EQ9LHkO8V=sdaQwt==6fbGhgn2Vi1E9_WxSGRQ@mail.gmail.com

-Kees

Kees Cook (23):
  crypto: skcipher - Introduce crypto_sync_skcipher
  gss_krb5: Remove VLA usage of skcipher
  lib80211: Remove VLA usage of skcipher
  mac802154: Remove VLA usage of skcipher
  s390/crypto: Remove VLA usage of skcipher
  x86/fpu: Remove VLA usage of skcipher
  block: cryptoloop: Remove VLA usage of skcipher
  libceph: Remove VLA usage of skcipher
  ppp: mppe: Remove VLA usage of skcipher
  rxrpc: Remove VLA usage of skcipher
  wusb: Remove VLA usage of skcipher
  crypto: ccp - Remove VLA usage of skcipher
  crypto: vmx - Remove VLA usage of skcipher
  crypto: null - Remove VLA usage of skcipher
  crypto: cryptd - Remove VLA usage of skcipher
  crypto: sahara - Remove VLA usage of skcipher
  crypto: qce - Remove VLA usage of skcipher
  crypto: artpec6 - Remove VLA usage of skcipher
  crypto: chelsio - Remove VLA usage of skcipher
  crypto: mxs-dcp - Remove VLA usage of skcipher
  crypto: omap-aes - Remove VLA usage of skcipher
  crypto: picoxcell - Remove VLA usage of skcipher
  crypto: skcipher - Remove SKCIPHER_REQUEST_ON_STACK()

 arch/s390/crypto/aes_s390.c                   | 48 +++++-----
 arch/x86/crypto/fpu.c                         | 30 ++++---
 crypto/algif_aead.c                           | 12 +--
 crypto/authenc.c                              |  8 +-
 crypto/authencesn.c                           |  8 +-
 crypto/cryptd.c                               | 32 +++----
 crypto/crypto_null.c                          | 11 ++-
 crypto/echainiv.c                             |  4 +-
 crypto/gcm.c                                  |  8 +-
 crypto/seqiv.c                                |  4 +-
 crypto/skcipher.c                             | 24 +++++
 drivers/block/cryptoloop.c                    | 22 ++---
 drivers/crypto/axis/artpec6_crypto.c          | 19 ++--
 drivers/crypto/ccp/ccp-crypto-aes-xts.c       | 13 +--
 drivers/crypto/ccp/ccp-crypto.h               |  2 +-
 drivers/crypto/chelsio/chcr_algo.c            | 27 +++---
 drivers/crypto/chelsio/chcr_crypto.h          |  2 +-
 drivers/crypto/mxs-dcp.c                      | 21 +++--
 drivers/crypto/omap-aes.c                     | 17 ++--
 drivers/crypto/omap-aes.h                     |  2 +-
 drivers/crypto/picoxcell_crypto.c             | 21 +++--
 drivers/crypto/qce/ablkcipher.c               | 13 ++-
 drivers/crypto/qce/cipher.h                   |  2 +-
 drivers/crypto/sahara.c                       | 31 ++++---
 drivers/crypto/vmx/aes_cbc.c                  | 22 ++---
 drivers/crypto/vmx/aes_ctr.c                  | 18 ++--
 drivers/crypto/vmx/aes_xts.c                  | 18 ++--
 drivers/net/ppp/ppp_mppe.c                    | 27 +++---
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  | 34 ++++----
 drivers/staging/rtl8192e/rtllib_crypt_wep.c   | 28 +++---
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 34 ++++----
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c  | 26 +++---
 drivers/usb/wusbcore/crypto.c                 | 16 ++--
 include/crypto/internal/geniv.h               |  2 +-
 include/crypto/null.h                         |  2 +-
 include/crypto/skcipher.h                     | 74 +++++++++++++++-
 include/linux/sunrpc/gss_krb5.h               | 30 +++----
 net/ceph/crypto.c                             | 12 +--
 net/ceph/crypto.h                             |  2 +-
 net/mac802154/llsec.c                         | 16 ++--
 net/mac802154/llsec.h                         |  2 +-
 net/rxrpc/ar-internal.h                       |  2 +-
 net/rxrpc/rxkad.c                             | 44 +++++-----
 net/sunrpc/auth_gss/gss_krb5_crypto.c         | 87 ++++++++++---------
 net/sunrpc/auth_gss/gss_krb5_keys.c           |  9 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c           | 53 ++++++-----
 net/sunrpc/auth_gss/gss_krb5_seqnum.c         | 18 ++--
 net/sunrpc/auth_gss/gss_krb5_wrap.c           | 20 ++---
 net/wireless/lib80211_crypt_tkip.c            | 34 ++++----
 net/wireless/lib80211_crypt_wep.c             | 28 +++---
 50 files changed, 563 insertions(+), 476 deletions(-)

-- 
2.17.1
