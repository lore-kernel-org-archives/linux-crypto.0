From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 0/2] crypto: Implement a generic crypto statistics
Date: Mon,  3 Sep 2018 19:22:46 +0000
Message-ID: <1536002568-18949-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch is a try to implement a generic crypto driver statistics.
The goal is to have an "ifconfig" for crypto device.

Some driver tried to implement this via a debugfs interface.

This serie do it directly in the crypto API and give access to stats
via the crypto_user(netlink) API.
Then an userspace tool will collect information via netlink.
Note that this userspace tool is heavily copied from libkcapi and if
Stephan Mueller agree, I will made a PR for adding getstat to it unless
tools/crypto is the good place for it.

Example of output:
pkcs1pad(rsa-sun8i-ce,sha1)	Akcipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Sign: 0
	Verify: 5
	Errors: 0
cryptd(__xts-aes-ce)	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
xts-aes-ce	cipher
	Encrypt: 17 bytes: 4384
	Decrypt: 17 bytes: 4384
	Errors: 0
cryptd(__ctr-aes-ce)	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
ctr-aes-ce	cipher
	Encrypt: 19 bytes: 5551
	Decrypt: 19 bytes: 5551
	Errors: 0
cryptd(__cbc-aes-ce)	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
cbc-aes-ce	cipher
	Encrypt: 19 bytes: 3040
	Decrypt: 19 bytes: 3040
	Errors: 0
cryptd(__ecb-aes-ce)	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
ecb-aes-ce	cipher
	Encrypt: 14 bytes: 2624
	Decrypt: 14 bytes: 2624
	Errors: 0
cbcmac-aes-ce	Hash
	Hash: 20 bytes: 1244
	Errors: 0
xcbc-aes-ce	Hash
	Hash: 28 bytes: 543
	Errors: 0
cmac-aes-ce	Hash
	Hash: 36 bytes: 1472
	Errors: 0
__xts-aes-ce	cipher
	Encrypt: 17 bytes: 4384
	Decrypt: 17 bytes: 4384
	Errors: 0
ctr-aes-ce	cipher
	Encrypt: 19 bytes: 5551
	Decrypt: 19 bytes: 5551
	Errors: 0
__ctr-aes-ce	cipher
	Encrypt: 19 bytes: 5551
	Decrypt: 19 bytes: 5551
	Errors: 0
__cbc-aes-ce	cipher
	Encrypt: 19 bytes: 3040
	Decrypt: 19 bytes: 3040
	Errors: 0
__ecb-aes-ce	cipher
	Encrypt: 14 bytes: 2624
	Decrypt: 14 bytes: 2624
	Errors: 0
rsa-sun8i-ce	Akcipher
	Encrypt: 7 bytes: 232
	Decrypt: 6 bytes: 1152
	Sign: 0
	Verify: 5
	Errors: 0
sun8i_ce_rng	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
ecb(des3_ede-generic)	cipher
	Encrypt: 24 bytes: 4584
	Decrypt: 24 bytes: 4584
	Errors: 0
ecb-des3-sun8i-ce	cipher
	Encrypt: 18 bytes: 3072
	Decrypt: 18 bytes: 3072
	Errors: 0
cbc(des3_ede-generic)	cipher
	Encrypt: 14 bytes: 5104
	Decrypt: 14 bytes: 5104
	Errors: 0
aes-ce	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
des3_ede-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
des-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
aes-arm64	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
crc32c-arm64-ce	Hash
	Hash: 92 bytes: 20649
	Errors: 0
cbc-des3-sun8i-ce	cipher
	Encrypt: 10 bytes: 3488
	Decrypt: 10 bytes: 3488
	Errors: 0
crc32-arm64-ce	Hash
	Hash: 92 bytes: 20649
	Errors: 0
ecb-aes-sun8i-ce	cipher
	Encrypt: 18 bytes: 3168
	Decrypt: 18 bytes: 3168
	Errors: 0
cbc-aes-sun8i-ce	cipher
	Encrypt: 24 bytes: 3712
	Decrypt: 24 bytes: 3712
	Errors: 0
sha256-ce	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha224-ce	Hash
	Hash: 26 bytes: 8860
	Errors: 0
cts(cbc-aes-sun8i-ce)	cipher
	Encrypt: 24 bytes: 956
	Decrypt: 24 bytes: 956
	Errors: 0
sha224-arm64-neon	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha256-arm64-neon	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha224-arm64	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha256-arm64	Hash
	Hash: 26 bytes: 8860
	Errors: 0
ctr-aes-sun8i-ce	cipher
	Encrypt: 24 bytes: 6738
	Decrypt: 24 bytes: 6738
	Errors: 0
sha1-ce	Hash
	Hash: 28 bytes: 9191
	Errors: 0
ecdh-generic	KPP
	Setsecret: 4
	Generate public key: 3
	Compute_shared_secret: 4
	Errors: 0
ghash-generic	Hash
	Hash: 32 bytes: 4358
	Errors: 0
jitterentropy_rng	RNG
	Seed: 0
	Generate: 1 bytes: 48
	Errors: 0
drbg_nopr_hmac_sha256	RNG
	Seed: 5
	Generate: 9 bytes: 1056
	Errors: 0
drbg_nopr_hmac_sha512	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
drbg_nopr_hmac_sha384	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
drbg_nopr_hmac_sha1	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
drbg_pr_hmac_sha256	RNG
	Seed: 4
	Generate: 8 bytes: 1024
	Errors: 0
drbg_pr_hmac_sha512	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
drbg_pr_hmac_sha384	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
drbg_pr_hmac_sha1	RNG
	Seed: 0
	Generate: 0 bytes: 0
	Errors: 0
crct10dif-generic	Hash
	Hash: 24 bytes: 19893
	Errors: 0
crc32c-generic	Hash
	Hash: 92 bytes: 20649
	Errors: 0
aes-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
sha224-generic	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha256-generic	Hash
	Hash: 26 bytes: 8860
	Errors: 0
sha1-generic	Hash
	Hash: 28 bytes: 9191
	Errors: 0
digest_null-generic	Hash
	Hash: 0 bytes: 0
	Errors: 0
compress_null-generic	Compress
	Compress: 0 bytes: 0
	Decompress: 0 bytes: 0
	Errors: 0
ecb-cipher_null	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
cipher_null-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Errors: 0
rsa-generic	Akcipher
	Encrypt: 17 bytes: 2832
	Decrypt: 9 bytes: 1920
	Sign: 0
	Verify: 36
	Errors: 0

Futur possible additions:
- Add a "number of needed fallback" statistics.
- maximum request size

Please let me know your opinions about it

Regards

Changes since RFC:
- Do not use anymore CRYPTO_MSG_GETALG and added a dedicated CRYPTO_MSG_GETSTAT

Changes since RFC:
- Use cryptouser(netlink) instead of /sys
- Use atomic_t instead of unsigned long
- moved stat code into dedicated inline function
- spelling fixes

Corentin Labbe (2):
  crypto: Implement a generic crypto statistics
  crypto: tools: Add cryptostat userspace

 crypto/Kconfig                               |  11 +
 crypto/Makefile                              |   1 +
 crypto/ahash.c                               |  21 +-
 crypto/algapi.c                              |   8 +
 crypto/{crypto_user.c => crypto_user_base.c} |   9 +-
 crypto/crypto_user_stat.c                    | 463 +++++++++++++++++++++++++++
 crypto/rng.c                                 |   1 +
 include/crypto/acompress.h                   |  38 ++-
 include/crypto/aead.h                        |  51 ++-
 include/crypto/akcipher.h                    |  76 ++++-
 include/crypto/hash.h                        |  32 +-
 include/crypto/internal/cryptouser.h         |   8 +
 include/crypto/kpp.h                         |  51 ++-
 include/crypto/rng.h                         |  29 +-
 include/crypto/skcipher.h                    |  44 ++-
 include/linux/crypto.h                       |  83 ++++-
 include/uapi/linux/cryptouser.h              |  52 +++
 tools/crypto/getstat.c                       | 294 +++++++++++++++++
 18 files changed, 1237 insertions(+), 35 deletions(-)
 rename crypto/{crypto_user.c => crypto_user_base.c} (97%)
 create mode 100644 crypto/crypto_user_stat.c
 create mode 100644 include/crypto/internal/cryptouser.h
 create mode 100644 tools/crypto/getstat.c

-- 
2.16.4
