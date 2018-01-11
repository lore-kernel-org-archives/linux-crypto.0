From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 0/2] crypto: Implement generic crypto statistics
Date: Thu, 11 Jan 2018 19:56:55 +0000
Message-ID: <1515700617-3513-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:44096 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932431AbeAKUBA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 15:01:00 -0500
Received: by mail-wm0-f68.google.com with SMTP id t8so7808518wmc.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jan 2018 12:00:59 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patch is a try to implement a generic crypto driver statistics.
The goal is to have an "ifconfig" for crypto device.

Some driver tried to implement this via a debugfs interface.
This serie do it directly in the crypto API and give access to stats
via the crypto_user(netlink) API.
Then an userspace tool will collect information via netlink.
Note that this userspace tool is heavily copied from libkcapi and if
Stephan Mueller agree, I will made a PR for adding getstat to it.

Example of output:
gcc getstat.c -o getstat && ./getstat 
authenc(hmac(sha512-generic),cbc-des3_ede-asm)	AEAD
	Encrypt: 6 bytes: 768
	Decrypt: 0 bytes: 0
authenc(hmac(sha512-generic),cbc(des-generic))	AEAD
	Encrypt: 8 bytes: 1024
	Decrypt: 0 bytes: 0
authenc(hmac(sha384-generic),cbc-des3_ede-asm)	AEAD
	Encrypt: 6 bytes: 768
	Decrypt: 0 bytes: 0
authenc(hmac(sha384-generic),cbc(des-generic))	AEAD
	Encrypt: 8 bytes: 1024
	Decrypt: 0 bytes: 0
authenc(hmac(sha256-generic),cbc-des3_ede-asm)	AEAD
	Encrypt: 6 bytes: 768
	Decrypt: 0 bytes: 0
authenc(hmac(sha256-generic),cbc(des-generic))	AEAD
	Encrypt: 8 bytes: 1024
	Decrypt: 0 bytes: 0
authenc(hmac(sha224-generic),cbc-des3_ede-asm)	AEAD
	Encrypt: 6 bytes: 768
	Decrypt: 0 bytes: 0
authenc(hmac(sha224-generic),cbc(des-generic))	AEAD
	Encrypt: 8 bytes: 1024
	Decrypt: 0 bytes: 0
authenc(hmac(sha1-generic),cbc-des3_ede-asm)	AEAD
	Encrypt: 6 bytes: 768
	Decrypt: 0 bytes: 0
authenc(hmac(sha1-generic),cbc(des-generic))	AEAD
	Encrypt: 8 bytes: 1024
	Decrypt: 0 bytes: 0
authenc(hmac(sha1-generic),ecb-cipher_null)	AEAD
	Encrypt: 12 bytes: 366
	Decrypt: 12 bytes: 606
authenc(hmac(md5-generic),ecb-cipher_null)	AEAD
	Encrypt: 12 bytes: 366
	Decrypt: 12 bytes: 558
authenc(hmac(sha1-generic),virtio_crypto_aes_cbc)	AEAD
	Encrypt: 42 bytes: 2208
	Decrypt: 0 bytes: 0
cmac(des3_ede-asm)
	Hash: 32 bytes: 480
cmac(aes-asm)
	Hash: 48 bytes: 1472
rfc4543(gcm_base(ctr(aes-asm),ghash-generic))	AEAD
	Encrypt: 6 bytes: 312
	Decrypt: 12 bytes: 816
rfc4106(gcm_base(ctr(aes-asm),ghash-generic))	AEAD
	Encrypt: 138 bytes: 6864
	Decrypt: 138 bytes: 9072
crc32-generic
	Hash: 56 bytes: 10850
vmac(aes-asm)
	Hash: 88 bytes: 8328
xcbc(aes-asm)
	Hash: 64 bytes: 936
hmac(sha224-generic)
	Hash: 46 bytes: 3868
hmac(sha512-generic)
	Hash: 46 bytes: 3868
hmac(sha384-generic)
	Hash: 46 bytes: 3868
hmac(sha1-generic)
	Hash: 136 bytes: 7884
hmac(md5-generic)
	Hash: 80 bytes: 2940
crct10dif-generic
	Hash: 40 bytes: 4492
rfc4309(ccm_base(ctr(aes-asm),cbcmac(aes-asm)))	AEAD
	Encrypt: 138 bytes: 6864
	Decrypt: 138 bytes: 9072
ccm_base(ctr(aes-asm),cbcmac(aes-asm))	AEAD
	Encrypt: 222 bytes: 8946
	Decrypt: 240 bytes: 12246
cbcmac(aes-asm)
	Hash: 478 bytes: 21034
gcm_base(ctr(aes-asm),ghash-generic)	AEAD
	Encrypt: 196 bytes: 8424
	Decrypt: 196 bytes: 12304
rfc3686(ctr(aes-asm))	Cipher
	Encrypt: 40 bytes: 17264
	Decrypt: 36 bytes: 864
ctr(aes-asm)	Cipher
	Encrypt: 924 bytes: 59560
	Decrypt: 474 bytes: 36192
xts(ecb(aes-asm))	Cipher
	Encrypt: 44 bytes: 11008
	Decrypt: 44 bytes: 11008
lrw(ecb(aes-asm))	Cipher
	Encrypt: 68 bytes: 7040
	Decrypt: 68 bytes: 7040
ecb(aes-asm)	Cipher
	Encrypt: 140 bytes: 23296
	Decrypt: 140 bytes: 23296
ctr(des-generic)	Cipher
	Encrypt: 24 bytes: 5940
	Decrypt: 24 bytes: 5940
cbc(des-generic)	Cipher
	Encrypt: 88 bytes: 8576
	Decrypt: 40 bytes: 3200
ecb(des-generic)	Cipher
	Encrypt: 64 bytes: 3744
	Decrypt: 36 bytes: 3232
pkcs1pad(rsa-generic,sha1)	Akcipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
	Sign: 0
	Verify: 13
virtio_crypto_aes_cbc	Cipher
	Encrypt: 82 bytes: 8320
	Decrypt: 38 bytes: 6080
ecdh-generic	KPP
	Setsecret: 4
	Generate public key: 3
	Compute_shared_secret: 4
ghash-generic
	Hash: 440 bytes: 10728
jitterentropy_rng	RNG
	Seed: 0
	Generate: 0 bytes: 0
drbg_nopr_hmac_sha256	RNG
	Seed: 5
	Generate: 9 bytes: 1056
drbg_nopr_hmac_sha512	RNG
	Seed: 0
	Generate: 0 bytes: 0
drbg_nopr_hmac_sha384	RNG
	Seed: 0
	Generate: 0 bytes: 0
drbg_nopr_hmac_sha1	RNG
	Seed: 0
	Generate: 0 bytes: 0
hmac(sha256-generic)
	Hash: 94 bytes: 5592
drbg_pr_hmac_sha256	RNG
	Seed: 4
	Generate: 8 bytes: 1024
drbg_pr_hmac_sha512	RNG
	Seed: 0
	Generate: 0 bytes: 0
drbg_pr_hmac_sha384	RNG
	Seed: 0
	Generate: 0 bytes: 0
drbg_pr_hmac_sha1	RNG
	Seed: 0
	Generate: 0 bytes: 0
lzo-scomp	Compress
	Compress: 2 bytes: 229
	Decompress: 4 bytes: 367
lzo-generic	Compress
	Compress: 0 bytes: 0
	Decompress: 0 bytes: 0
crc32c-generic
	Hash: 176 bytes: 31652
zlib-deflate-scomp	Compress
	Compress: 2 bytes: 261
	Decompress: 4 bytes: 345
deflate-scomp	Compress
	Compress: 2 bytes: 261
	Decompress: 4 bytes: 320
deflate-generic	Compress
	Compress: 0 bytes: 0
	Decompress: 0 bytes: 0
poly1305-generic
	Hash: 66 bytes: 9294
chacha20-generic	Cipher
	Encrypt: 16 bytes: 8853
	Decrypt: 16 bytes: 8853
ecb(arc4)-generic	Cipher
	Encrypt: 42 bytes: 540
	Decrypt: 42 bytes: 540
arc4-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
aes-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
des3_ede-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
des-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
sha384-generic
	Hash: 48 bytes: 10072
sha512-generic
	Hash: 48 bytes: 10072
sha224-generic
	Hash: 40 bytes: 9056
sha256-generic
	Hash: 40 bytes: 9056
sha1-generic
	Hash: 48 bytes: 9728
md5-generic
	Hash: 56 bytes: 1436
md4-generic
	Hash: 56 bytes: 1436
digest_null-generic
	Hash: 0 bytes: 0
compress_null-generic	Compress
	Compress: 0 bytes: 0
	Decompress: 0 bytes: 0
ecb-cipher_null	Cipher
	Encrypt: 130 bytes: 2828
	Decrypt: 24 bytes: 732
cipher_null-generic	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
rsa-generic	Akcipher
	Encrypt: 7 bytes: 232
	Decrypt: 6 bytes: 1152
	Sign: 0
	Verify: 13
dh-generic	KPP
	Setsecret: 2
	Generate public key: 2
	Compute_shared_secret: 2
ctr-des3_ede-asm	Cipher
	Encrypt: 20 bytes: 9950
	Decrypt: 20 bytes: 9950
cbc-des3_ede-asm	Cipher
	Encrypt: 46 bytes: 9568
	Decrypt: 16 bytes: 5728
ecb-des3_ede-asm	Cipher
	Encrypt: 28 bytes: 5104
	Decrypt: 28 bytes: 5104
des3_ede-asm	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0
aes-asm	cipher
	Encrypt: 0 bytes: 0
	Decrypt: 0 bytes: 0

Futur possible additions:
- Add a "number of needed fallback" statistics.
- maximum request size

Regards

Changes since RFC:
- Use cryptouser(netlink) instead of /sys
- Use atomic_t instead of unsigned long
- moved stat code into dedicated inline function
- spelling fixes

Corentin Labbe (2):
  crypto: Implement a generic crypto statistics
  crypto: tools: Add cryptostat userspace

 crypto/Kconfig                  |  11 ++
 crypto/ablkcipher.c             |   9 ++
 crypto/acompress.c              |   9 ++
 crypto/aead.c                   |  10 ++
 crypto/ahash.c                  |   8 ++
 crypto/akcipher.c               |  13 ++
 crypto/algapi.c                 |   6 +
 crypto/blkcipher.c              |   9 ++
 crypto/crypto_user.c            |  28 ++++
 crypto/kpp.c                    |   7 +
 crypto/rng.c                    |   8 ++
 crypto/scompress.c              |   9 ++
 crypto/shash.c                  |   5 +
 crypto/skcipher.c               |   9 ++
 include/crypto/acompress.h      |  22 ++++
 include/crypto/aead.h           |  10 ++
 include/crypto/akcipher.h       |  42 ++++++
 include/crypto/hash.h           |  10 ++
 include/crypto/kpp.h            |  28 ++++
 include/crypto/rng.h            |  17 +++
 include/crypto/skcipher.h       |  22 ++++
 include/linux/crypto.h          |  56 ++++++++
 include/uapi/linux/cryptouser.h |  34 +++++
 tools/crypto/getstat.c          | 279 ++++++++++++++++++++++++++++++++++++++++
 24 files changed, 661 insertions(+)
 create mode 100644 tools/crypto/getstat.c

-- 
2.13.6
