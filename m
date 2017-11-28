From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Write in sha3_update
Date: Tue, 28 Nov 2017 12:58:45 -0800
Message-ID: <20171128205845.GF45321@gmail.com>
References: <001a113a788209b77e055f0aebaf@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+6f724d52da8e3ff8872545bd8444f50f0d174c5f@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a113a788209b77e055f0aebaf@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 05:23:01AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> ==================================================================
> BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:341
> [inline]
> BUG: KASAN: stack-out-of-bounds in sha3_update+0xdf/0x2e0
> crypto/sha3_generic.c:161
> Write of size 4096 at addr ffff8801cca07c40 by task syzkaller076574/3044
> 

Here's a fix for this bug, though it's a bit messy due to having to export
shash_no_setkey().  Herbert, can you review this, and if you are okay with it
send it to Linus soon?  This bug is exploitable on some systems.

By the way, I notice there are also users of the shash or ahash API that don't
check whether the transform requires a key or not, for example
KEYCTL_DH_COMPUTE.  Perhaps it would also be a good idea to keep track of the
unkeyed/needs_key/keyed state in the 'struct crypto_tfm' so that
crypto_shash_init() and crypto_ahash_init() can validate the correct state.

---8<---

>From 98016167745de832ae4a1367595efe660660404d Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 28 Nov 2017 11:22:21 -0800
Subject: [PATCH] crypto: hmac - require that the underlying hash algorithm is
 unkeyed

The HMAC template doesn't check that its underlying hash algorithm is
unkeyed.  Problematically, trying to use "hmac(hmac(sha3-512-generic))"
through AF_ALG results in the inner HMAC being used without having been
keyed, resulting in sha3_update() being called without sha3_init(),
causing a stack buffer overflow.

This is a very old bug, but it seems to have only started causing real
problems when SHA-3 support was added (requires CONFIG_CRYPTO_SHA3)
because the innermost hash's state is ->import()ed from a zeroed buffer,
and it just so happens that other hash algorithms are fine with that,
but SHA-3 is not.  However, there could be arch or hardware-dependent
hash algorithms also affected; I couldn't test everything.

Fix the bug by introducing a function crypto_shash_alg_has_setkey()
which tests whether a shash algorithm is keyed.  Then update the HMAC
template to require that its underlying hash algorithm is unkeyed.

Here is a reproducer:

    #include <linux/if_alg.h>
    #include <sys/socket.h>

    int main()
    {
        int algfd;
        struct sockaddr_alg addr = {
            .salg_type = "hash",
            .salg_name = "hmac(hmac(sha3-512-generic))",
        };
        char key[4096] = { 0 };

        algfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
        bind(algfd, (const struct sockaddr *)&addr, sizeof(addr));
        setsockopt(algfd, SOL_ALG, ALG_SET_KEY, key, sizeof(key));
    }

Here was the KASAN report from syzbot:

    BUG: KASAN: stack-out-of-bounds in memcpy include/linux/string.h:341  [inline]
    BUG: KASAN: stack-out-of-bounds in sha3_update+0xdf/0x2e0  crypto/sha3_generic.c:161
    Write of size 4096 at addr ffff8801cca07c40 by task syzkaller076574/3044

    CPU: 1 PID: 3044 Comm: syzkaller076574 Not tainted 4.14.0-mm1+ #25
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  Google 01/01/2011
    Call Trace:
      __dump_stack lib/dump_stack.c:17 [inline]
      dump_stack+0x194/0x257 lib/dump_stack.c:53
      print_address_description+0x73/0x250 mm/kasan/report.c:252
      kasan_report_error mm/kasan/report.c:351 [inline]
      kasan_report+0x25b/0x340 mm/kasan/report.c:409
      check_memory_region_inline mm/kasan/kasan.c:260 [inline]
      check_memory_region+0x137/0x190 mm/kasan/kasan.c:267
      memcpy+0x37/0x50 mm/kasan/kasan.c:303
      memcpy include/linux/string.h:341 [inline]
      sha3_update+0xdf/0x2e0 crypto/sha3_generic.c:161
      crypto_shash_update+0xcb/0x220 crypto/shash.c:109
      shash_finup_unaligned+0x2a/0x60 crypto/shash.c:151
      crypto_shash_finup+0xc4/0x120 crypto/shash.c:165
      hmac_finup+0x182/0x330 crypto/hmac.c:152
      crypto_shash_finup+0xc4/0x120 crypto/shash.c:165
      shash_digest_unaligned+0x9e/0xd0 crypto/shash.c:172
      crypto_shash_digest+0xc4/0x120 crypto/shash.c:186
      hmac_setkey+0x36a/0x690 crypto/hmac.c:66
      crypto_shash_setkey+0xad/0x190 crypto/shash.c:64
      shash_async_setkey+0x47/0x60 crypto/shash.c:207
      crypto_ahash_setkey+0xaf/0x180 crypto/ahash.c:200
      hash_setkey+0x40/0x90 crypto/algif_hash.c:446
      alg_setkey crypto/af_alg.c:221 [inline]
      alg_setsockopt+0x2a1/0x350 crypto/af_alg.c:254
      SYSC_setsockopt net/socket.c:1851 [inline]
      SyS_setsockopt+0x189/0x360 net/socket.c:1830
      entry_SYSCALL_64_fastpath+0x1f/0x96

Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hmac.c                  | 5 +++++
 crypto/shash.c                 | 5 +++--
 include/crypto/internal/hash.h | 8 ++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 92871dc2a63e..82436db6b6a6 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -196,6 +196,11 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (IS_ERR(salg))
 		return PTR_ERR(salg);
 
+	/* The underlying hash algorithm must be unkeyed */
+	err = -EINVAL;
+	if (crypto_shash_alg_has_setkey(salg))
+		goto out_put_alg;
+
 	err = -EINVAL;
 	ds = salg->digestsize;
 	ss = salg->statesize;
diff --git a/crypto/shash.c b/crypto/shash.c
index 325a14da5827..e849d3ee2e27 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -25,11 +25,12 @@
 
 static const struct crypto_type crypto_shash_type;
 
-static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-			   unsigned int keylen)
+int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+		    unsigned int keylen)
 {
 	return -ENOSYS;
 }
+EXPORT_SYMBOL_GPL(shash_no_setkey);
 
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index f0b44c16e88f..c2bae8da642c 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -82,6 +82,14 @@ int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_instance(struct crypto_instance *inst);
 
+int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+		    unsigned int keylen);
+
+static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
+
 int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
 			    struct hash_alg_common *alg,
 			    struct crypto_instance *inst);
-- 
2.15.0.417.g466bffb3ac-goog
