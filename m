From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v4 05/13] crypto/rng: ensure that the RNG is ready before using
Date: Tue,  6 Jun 2017 19:47:56 +0200
Message-ID: <20170606174804.31124-6-Jason@zx2c4.com>
References: <20170606174804.31124-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Theodore Ts'o <tytso@mit.edu>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Miller <davem@davemloft.net>,
	Eric Biggers <ebiggers3@gmail.com>
Return-path: <kernel-hardening-return-8369-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170606174804.31124-1-Jason@zx2c4.com>
List-Id: linux-crypto.vger.kernel.org

Otherwise, we might be seeding the RNG using bad randomness, which is
dangerous. The one use of this function from within the kernel -- not
from userspace -- is being removed (keys/big_key), so that call site
isn't relevant in assessing this.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/rng.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index f46dac5288b9..e042437e64b4 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -48,12 +48,14 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 		if (!buf)
 			return -ENOMEM;
 
-		get_random_bytes(buf, slen);
+		err = get_random_bytes_wait(buf, slen);
+		if (err)
+			goto out;
 		seed = buf;
 	}
 
 	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
-
+out:
 	kzfree(buf);
 	return err;
 }
-- 
2.13.0
