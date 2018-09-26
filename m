From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v8 7/9] crypto: qat: Remove VLA usage
Date: Wed, 26 Sep 2018 10:44:41 +0200
Message-ID: <CAKv+Gu-dGbWsQu0NgOWVFy7Sca3yBD0pLzEMwmkG3mg9LFPpkA@mail.gmail.com>
References: <20180807211843.47586-1-keescook@chromium.org> <20180807211843.47586-8-keescook@chromium.org>
 <CAK8P3a3kiH-a+JG8FqUw7nc_hk+9z-FdsGFT57SxR83W32zKzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        device-mapper deve
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3kiH-a+JG8FqUw7nc_hk+9z-FdsGFT57SxR83W32zKzQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 25 Sep 2018 at 18:12, Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Aug 7, 2018 at 11:18 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > In the quest to remove all stack VLA usage from the kernel[1], this uses
> > the new upper bound for the stack buffer. Also adds a sanity check.
> >
> > [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>
> After rebasing to linux-next, I now get a warning about this file:
>
> drivers/crypto/qat/qat_common/qat_algs.c: In function 'qat_alg_do_precomputes':
> drivers/crypto/qat/qat_common/qat_algs.c:257:1: error: the frame size
> of 1112 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> I assume it was already possible to get into that state with the VLA,
> but it seems bad enough that I think we need to do something
> about it.
>
> The large stack variables add up to 1084 bytes, which fully explains
> how we got here:
>
>         SHASH_DESC_ON_STACK(shash, ctx->hash_tfm); /* 360 */
>         struct sha1_state sha1;  /* 92 */
>         struct sha256_state sha256; /* 104 */
>         struct sha512_state sha512; /* 208 */
>         char ipad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */
>         char opad[MAX_ALGAPI_BLOCKSIZE]; /* 160 */
>
> The question is what we can do about it. One simple step I've tried
> is to move the sha1/sha256/sha512 into a union, which saves around
> 200 bytes and should bring us (slightly) below the warning
> limit, but I suspect we can do better than that. Any ideas?
>

All the processing takes place in the context of a setkey() operation,
which means only one such operation should be in flight per tfm at any
given time. So we could move all these pieces into the tfm context
struct instead. Something like the below [untested] (whitespace
mangling courtesy of Gmail)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c
b/drivers/crypto/qat/qat_common/qat_algs.c
index 1138e41d6805..c14f1906bdf4 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -113,6 +113,13 @@ struct qat_alg_aead_ctx {
  struct crypto_shash *hash_tfm;
  enum icp_qat_hw_auth_algo qat_hash_alg;
  struct qat_crypto_instance *inst;
+ union {
+ struct sha1_state sha1;
+ struct sha256_state sha256;
+ struct sha512_state sha512;
+ };
+ char ipad[MAX_ALGAPI_BLOCKSIZE];
+ char opad[MAX_ALGAPI_BLOCKSIZE];
 };

 struct qat_alg_ablkcipher_ctx {
@@ -148,37 +155,32 @@ static int qat_alg_do_precomputes(struct
icp_qat_hw_auth_algo_blk *hash,
    unsigned int auth_keylen)
 {
  SHASH_DESC_ON_STACK(shash, ctx->hash_tfm);
- struct sha1_state sha1;
- struct sha256_state sha256;
- struct sha512_state sha512;
  int block_size = crypto_shash_blocksize(ctx->hash_tfm);
  int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
- char ipad[block_size];
- char opad[block_size];
  __be32 *hash_state_out;
  __be64 *hash512_state_out;
  int i, offset;

- memset(ipad, 0, block_size);
- memset(opad, 0, block_size);
+ memset(ctx->ipad, 0, block_size);
+ memset(ctx->opad, 0, block_size);
  shash->tfm = ctx->hash_tfm;
  shash->flags = 0x0;

  if (auth_keylen > block_size) {
  int ret = crypto_shash_digest(shash, auth_key,
-       auth_keylen, ipad);
+       auth_keylen, ctx->ipad);
  if (ret)
  return ret;

- memcpy(opad, ipad, digest_size);
+ memcpy(ctx->opad, ctx->ipad, digest_size);
  } else {
- memcpy(ipad, auth_key, auth_keylen);
- memcpy(opad, auth_key, auth_keylen);
+ memcpy(ctx->ipad, auth_key, auth_keylen);
+ memcpy(ctx->opad, auth_key, auth_keylen);
  }

  for (i = 0; i < block_size; i++) {
- char *ipad_ptr = ipad + i;
- char *opad_ptr = opad + i;
+ char *ipad_ptr = ctx->ipad + i;
+ char *opad_ptr = ctx->opad + i;
  *ipad_ptr ^= HMAC_IPAD_VALUE;
  *opad_ptr ^= HMAC_OPAD_VALUE;
  }
@@ -186,7 +188,7 @@ static int qat_alg_do_precomputes(struct
icp_qat_hw_auth_algo_blk *hash,
  if (crypto_shash_init(shash))
  return -EFAULT;

- if (crypto_shash_update(shash, ipad, block_size))
+ if (crypto_shash_update(shash, ctx->ipad, block_size))
  return -EFAULT;

  hash_state_out = (__be32 *)hash->sha.state1;
@@ -194,22 +196,22 @@ static int qat_alg_do_precomputes(struct
icp_qat_hw_auth_algo_blk *hash,

  switch (ctx->qat_hash_alg) {
  case ICP_QAT_HW_AUTH_ALGO_SHA1:
- if (crypto_shash_export(shash, &sha1))
+ if (crypto_shash_export(shash, &ctx->sha1))
  return -EFAULT;
  for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
- *hash_state_out = cpu_to_be32(*(sha1.state + i));
+ *hash_state_out = cpu_to_be32(*(ctx->sha1.state + i));
  break;
  case ICP_QAT_HW_AUTH_ALGO_SHA256:
- if (crypto_shash_export(shash, &sha256))
+ if (crypto_shash_export(shash, &ctx->sha256))
  return -EFAULT;
  for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
- *hash_state_out = cpu_to_be32(*(sha256.state + i));
+ *hash_state_out = cpu_to_be32(*(ctx->sha256.state + i));
  break;
  case ICP_QAT_HW_AUTH_ALGO_SHA512:
- if (crypto_shash_export(shash, &sha512))
+ if (crypto_shash_export(shash, &ctx->sha512))
  return -EFAULT;
  for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
- *hash512_state_out = cpu_to_be64(*(sha512.state + i));
+ *hash512_state_out = cpu_to_be64(*(ctx->sha512.state + i));
  break;
  default:
  return -EFAULT;
@@ -218,7 +220,7 @@ static int qat_alg_do_precomputes(struct
icp_qat_hw_auth_algo_blk *hash,
  if (crypto_shash_init(shash))
  return -EFAULT;

- if (crypto_shash_update(shash, opad, block_size))
+ if (crypto_shash_update(shash, ctx->opad, block_size))
  return -EFAULT;

  offset = round_up(qat_get_inter_state_size(ctx->qat_hash_alg), 8);
@@ -227,28 +229,28 @@ static int qat_alg_do_precomputes(struct
icp_qat_hw_auth_algo_blk *hash,

  switch (ctx->qat_hash_alg) {
  case ICP_QAT_HW_AUTH_ALGO_SHA1:
- if (crypto_shash_export(shash, &sha1))
+ if (crypto_shash_export(shash, &ctx->sha1))
  return -EFAULT;
  for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
- *hash_state_out = cpu_to_be32(*(sha1.state + i));
+ *hash_state_out = cpu_to_be32(*(ctx->sha1.state + i));
  break;
  case ICP_QAT_HW_AUTH_ALGO_SHA256:
- if (crypto_shash_export(shash, &sha256))
+ if (crypto_shash_export(shash, &ctx->sha256))
  return -EFAULT;
  for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
- *hash_state_out = cpu_to_be32(*(sha256.state + i));
+ *hash_state_out = cpu_to_be32(*(ctx->sha256.state + i));
  break;
  case ICP_QAT_HW_AUTH_ALGO_SHA512:
- if (crypto_shash_export(shash, &sha512))
+ if (crypto_shash_export(shash, &ctx->sha512))
  return -EFAULT;
  for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
- *hash512_state_out = cpu_to_be64(*(sha512.state + i));
+ *hash512_state_out = cpu_to_be64(*(ctx->sha512.state + i));
  break;
  default:
  return -EFAULT;
  }
- memzero_explicit(ipad, block_size);
- memzero_explicit(opad, block_size);
+ memzero_explicit(ctx->ipad, block_size);
+ memzero_explicit(ctx->opad, block_size);
  return 0;
 }
