From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/9] crypto: add zbufsize() interface
Date: Thu,  2 Aug 2018 14:51:09 -0700
Message-ID: <20180802215118.17752-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When pstore was refactored to use the crypto compress API in:

  commit cb3bee0369bc ("pstore: Use crypto compress API")

nearly all the pstore-specific compression routines were replaced with
the existing crypto compression API. One case remained: calculating the
"worst case" compression sizes ahead of time so it could have a buffer
preallocated for doing compression (which was called "zbufsize").

To make pstore fully algorithm-agnostic, the compression API needs to
grow this functionality. This adds the interface to support querying the
"worst case" estimate, with a new "zbufsize" routine that each compressor
can implement.

This series adds the interface, updates each compressor, and refactors
pstore. (Though note, this is based on v4.18-rc2, and pstore will be
gaining zstd support during the v4.19 merge window, so the last patch
in this series will need to be coordinated, but I left it to show how
things would look right now.)

-Kees


Kees Cook (9):
  crypto: add zbufsize() interface
  crypto, 842: implement zbufsize()
  crypto, null: Implement zbufsize()
  crypto, lzo: Implement zbufsize()
  crypto, deflate: Implement zbufsize()
  crypto, zstd: Implement zbufsize()
  crypto, lz4: Implement zbufsize()
  crypto, lz4hc: Implement zbufsize()
  pstore: Use crypto_comp_zbufsize()

 crypto/842.c                        |  17 ++-
 crypto/compress.c                   |   9 ++
 crypto/crypto_null.c                |  10 +-
 crypto/deflate.c                    |  48 +++++++-
 crypto/lz4.c                        |  22 +++-
 crypto/lz4hc.c                      |  22 +++-
 crypto/lzo.c                        |  22 +++-
 crypto/zstd.c                       |  22 +++-
 fs/pstore/Kconfig                   |  91 +++++----------
 fs/pstore/inode.c                   |   2 -
 fs/pstore/internal.h                |   3 -
 fs/pstore/platform.c                | 171 ++++++----------------------
 include/crypto/internal/scompress.h |  11 ++
 include/linux/crypto.h              |  12 ++
 include/linux/sw842.h               |   9 ++
 15 files changed, 257 insertions(+), 214 deletions(-)

-- 
2.17.1
