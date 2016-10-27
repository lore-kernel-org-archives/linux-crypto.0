From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 00/18] Backport crypto fixes.
Date: Thu, 27 Oct 2016 17:29:33 +0300
Message-ID: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

While fuzzing our 3.10 based kernel we observed some crashes, e.g:
      http://lkml.kernel.org/r/<CACT4Y+aE-pNUnCLbDQkFQ9Y7QivN_g6hEuS7t1RpknPHFmHg+g@mail.gmail.com>

It appears that 3.10-stable lacks some crypto related fixes. Here is my attempt
to backport them.
Many patches didn't apply cleanly, so to make sure that my conflict resolution
is correct I compared it with other stable trees.

Ard Biesheuvel (1):
  crypto: cryptd - initialize child shash_desc on import

Herbert Xu (17):
  crypto: algif_skcipher - Require setkey before accept(2)
  crypto: af_alg - Disallow bind/setkey/... after accept(2)
  crypto: af_alg - Add nokey compatibility path
  crypto: algif_skcipher - Add nokey compatibility path
  crypto: hash - Add crypto_ahash_has_setkey
  crypto: algif_hash - Require setkey before accept(2)
  crypto: skcipher - Add crypto_skcipher_has_setkey
  crypto: algif_skcipher - Add key check exception for cipher_null
  crypto: af_alg - Allow af_af_alg_release_parent to be called on nokey
    path
  crypto: algif_hash - Remove custom release parent function
  crypto: algif_skcipher - Remove custom release parent function
  crypto: af_alg - Forbid bind(2) when nokey child sockets are present
  crypto: algif_hash - Fix race condition in hash_check_key
  crypto: algif_skcipher - Fix race condition in skcipher_check_key
  crypto: algif_skcipher - Load TX SG list after waiting
  crypto: shash - Fix has_key setting
  crypto: skcipher - Fix blkcipher walk OOM crash

 crypto/ablkcipher.c     |   2 +
 crypto/af_alg.c         |  51 +++++++++++++-
 crypto/ahash.c          |   5 +-
 crypto/algif_hash.c     | 165 ++++++++++++++++++++++++++++++++++++++++++++--
 crypto/algif_skcipher.c | 172 +++++++++++++++++++++++++++++++++++++++++++-----
 crypto/blkcipher.c      |   4 +-
 crypto/cryptd.c         |   9 ++-
 crypto/shash.c          |   5 +-
 include/crypto/hash.h   |   6 ++
 include/crypto/if_alg.h |  11 ++--
 include/linux/crypto.h  |   8 +++
 11 files changed, 400 insertions(+), 38 deletions(-)

-- 
2.7.3
