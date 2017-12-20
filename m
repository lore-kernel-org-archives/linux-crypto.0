From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH RFC 0/3] crypto: Implement a generic crypto statistics
Date: Wed, 20 Dec 2017 20:09:24 +0000
Message-ID: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40732 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754388AbdLTUJq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 15:09:46 -0500
Received: by mail-wr0-f193.google.com with SMTP id q9so23330605wre.7
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 12:09:45 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

This patch is a try to implement a generic crypto driver statistics.
The goal is to have an "ifconfig" for crypto device.

Some driver tried to implement this via a debugfs interface.

My proposed way is to embed this in the crypto framework by registering
a /sys/kernel/crypto tree and create a directory for each cra_driver_name.
Note that I assume than cra_driver_name will only exists once, which seems false for arm64 ctr-aes-ce.
But for me, it's a bug.
Each crypto algorithm "cra_name" can have multiple implementation called
"cra_driver_name".
If two different implementation have the same cra_driver_name, nothing
can easily differentiate them.
Furthermore the mechanism for getting a crypto algorithm with its
implementation name (crypto_alg_match() in crypto/crypto_user.c) will
get only the first one found.

Then an userspace tool will collect information in this tree.

Example of output:
./cryptostat
aes-arm (cipher) aes
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
aes-generic (cipher) aes
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
arc4-generic (cipher) arc4
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
cbc(aes-arm) (cipher) cbc(aes)
	Encrypt: 94	bytes 6096
	Decrypt: 94	bytes 6096
cbc-aes-sun8i-ce (cipher) cbc(aes)
	Encrypt: 24	bytes 3712
	Decrypt: 24	bytes 3712
cbc(des3_ede-generic) (cipher) cbc(des3_ede)
	Encrypt: 14	bytes 5104
	Decrypt: 14	bytes 5104
cbc-des3-sun8i-ce (cipher) cbc(des3_ede)
	Encrypt: 10	bytes 3488
	Decrypt: 10	bytes 3488
cipher_null-generic (cipher) cipher_null
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
compress_null-generic (compress) compress_null
	Compress: 0	bytes 0
	Decompress: 0	bytes 0
crc32c-generic (hash) crc32c
	Hash: 88	bytes 15826
crct10dif-generic (hash) crct10dif
	Hash: 20	bytes 2246
ctr(aes-arm) (cipher) ctr(aes)
	Encrypt: 31	bytes 10225
	Decrypt: 31	bytes 10225
ctr-aes-sun8i-ce (cipher) ctr(aes)
	Encrypt: 24	bytes 6738
	Decrypt: 24	bytes 6738
cts(cbc(aes-arm)) (cipher) cts(cbc(aes))
	Encrypt: 33	bytes 1241
	Decrypt: 33	bytes 1241
cts(cbc-aes-sun8i-ce) (cipher) cts(cbc(aes))
	Encrypt: 24	bytes 956
	Decrypt: 24	bytes 956
deflate-generic (compress) deflate
	Compress: 0	bytes 0
	Decompress: 0	bytes 0
deflate-scomp (compress) deflate
	Compress: 2	bytes 261
	Decompress: 4	bytes 320
des3_ede-generic (cipher) des3_ede
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
des-generic (cipher) des
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
dh-generic (kpp) dh
	Set_secret: 2
	Generate_public_key: 2
	Compute_shared_secret: 2
digest_null-generic (hash) digest_null
	Hash: 0	bytes 0
drbg_nopr_hmac_sha1 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
drbg_nopr_hmac_sha256 (rng) stdrng
	Generate: 8	bytes 1024
	Seed: 4
drbg_nopr_hmac_sha384 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
drbg_nopr_hmac_sha512 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
drbg_pr_hmac_sha1 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
drbg_pr_hmac_sha256 (rng) stdrng
	Generate: 8	bytes 1024
	Seed: 4
drbg_pr_hmac_sha384 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
drbg_pr_hmac_sha512 (rng) stdrng
	Generate: 0	bytes 0
	Seed: 0
ecb(aes-arm) (cipher) ecb(aes)
	Encrypt: 20	bytes 4160
	Decrypt: 20	bytes 4160
ecb-aes-sun8i-ce (cipher) ecb(aes)
	Encrypt: 18	bytes 3168
	Decrypt: 18	bytes 3168
ecb(arc4)-generic (cipher) ecb(arc4)
	Encrypt: 21	bytes 270
	Decrypt: 21	bytes 270
ecb-cipher_null (cipher) ecb(cipher_null)
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
ecb(des3_ede-generic) (cipher) ecb(des3_ede)
	Encrypt: 24	bytes 4584
	Decrypt: 24	bytes 4584
ecb-des3-sun8i-ce (cipher) ecb(des3_ede)
	Encrypt: 18	bytes 3072
	Decrypt: 18	bytes 3072
hmac(sha256-neon) (hash) hmac(sha256)
	Hash: 40	bytes 1788
jitterentropy_rng (rng) jitterentropy_rng
	Generate: 0	bytes 0
	Seed: 0
lzo-generic (compress) lzo
	Compress: 0	bytes 0
	Decompress: 0	bytes 0
lzo-scomp (compress) lzo
	Compress: 2	bytes 229
	Decompress: 4	bytes 367
md5-generic (hash) md5
	Hash: 28	bytes 718
pkcs1pad(rsa-sun8i-ce,sha1) (asymetric) pkcs1pad(rsa,sha1)
	Encrypt: 0	bytes 0
	Decrypt: 0	bytes 0
	Verify: 2
	Sign: 0
rsa-generic (asymetric) rsa
	Encrypt: 14	bytes 0
	Decrypt: 9	bytes 0
	Verify: 5
	Sign: 0
rsa-sun8i-ce (asymetric) rsa
	Encrypt: 7	bytes 0
	Decrypt: 6	bytes 0
	Verify: 2
	Sign: 0
sha1-asm (hash) sha1
	Hash: 24	bytes 4864
sha1-generic (hash) sha1
	Hash: 24	bytes 4864
sha1-neon (hash) sha1
	Hash: 24	bytes 4864
sha224-asm (hash) sha224
	Hash: 20	bytes 4528
sha224-generic (hash) sha224
	Hash: 20	bytes 4528
sha224-neon (hash) sha224
	Hash: 20	bytes 4528
sha256-asm (hash) sha256
	Hash: 20	bytes 4528
sha256-generic (hash) sha256
	Hash: 20	bytes 4528
sha256-neon (hash) sha256
	Hash: 20	bytes 4528
sha384-generic (hash) sha384
	Hash: 24	bytes 5036
sha512-generic (hash) sha512
	Hash: 24	bytes 5036
zlib-deflate-scomp (compress) zlib-deflate
	Compress: 2	bytes 261
	Decompress: 4	bytes 345

Note that this patch could be a starting base for a /proc/crypto replacement.

Please let me know your opinions about it

Regards

Corentin Labbe (3):
  crypto: Prevent to register duplicate cra_driver_name
  crypto: Implement a generic crypto statistics
  crypto: tools: Add cryptostat userspace

 crypto/Kconfig             |  11 +++
 crypto/ahash.c             |  18 +++++
 crypto/algapi.c            | 191 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/rng.c               |   3 +
 include/crypto/acompress.h |  10 +++
 include/crypto/akcipher.h  |  12 +++
 include/crypto/kpp.h       |   9 +++
 include/crypto/rng.h       |   5 ++
 include/crypto/skcipher.h  |   8 ++
 include/linux/crypto.h     |  22 ++++++
 tools/crypto/cryptostat    |  40 ++++++++++
 11 files changed, 329 insertions(+)
 create mode 100755 tools/crypto/cryptostat

-- 
2.13.6
