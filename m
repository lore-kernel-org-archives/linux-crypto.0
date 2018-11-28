Return-Path: <SRS0=p+N9=OH=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbeK2KVN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 05:21:13 -0500
Date: Wed, 28 Nov 2018 15:17:54 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/11] crypto: crypto_user_stat: fix use_after_free of
 struct xxx_request
Message-ID: <20181128231753.GA131170@gmail.com>
References: <1542974541-23024-1-git-send-email-clabbe@baylibre.com>
 <1542974541-23024-7-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542974541-23024-7-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

On Fri, Nov 23, 2018 at 12:02:16PM +0000, Corentin Labbe wrote:
> All crypto_stats functions use the struct xxx_request for feeding stats,
> but in some case this structure could already be freed.
> 
> For fixing this, the needed parameters (len and alg) will be stored
> before the request being executed.
> Fixes: cac5818c25d0 ("crypto: user - Implement a generic crypto statistics")
> Reported-by: syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/ahash.c             |  17 ++-
>  crypto/algapi.c            | 285 +++++++++++++++++++++++++++++++++++++
>  crypto/rng.c               |   4 +-
>  include/crypto/acompress.h |  38 ++---
>  include/crypto/aead.h      |  38 ++---
>  include/crypto/akcipher.h  |  74 ++--------
>  include/crypto/hash.h      |  32 +----
>  include/crypto/kpp.h       |  48 ++-----
>  include/crypto/rng.h       |  27 +---
>  include/crypto/skcipher.h  |  36 ++---
>  include/linux/crypto.h     |  63 ++++----
>  11 files changed, 386 insertions(+), 276 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 3a348fbcf8f9..5d320a811f75 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -364,20 +364,28 @@ static int crypto_ahash_op(struct ahash_request *req,
>  
>  int crypto_ahash_final(struct ahash_request *req)
>  {
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct crypto_alg *alg = tfm->base.__crt_alg;
> +	unsigned int nbytes = req->nbytes;
>  	int ret;
>  
> +	crypto_stats_get(alg);
>  	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
> -	crypto_stat_ahash_final(req, ret);
> +	crypto_stats_ahash_final(nbytes, ret, alg);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_final);
>  
>  int crypto_ahash_finup(struct ahash_request *req)
>  {
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct crypto_alg *alg = tfm->base.__crt_alg;
> +	unsigned int nbytes = req->nbytes;
>  	int ret;
>  
> +	crypto_stats_get(alg);
>  	ret = crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
> -	crypto_stat_ahash_final(req, ret);
> +	crypto_stats_ahash_final(nbytes, ret, alg);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_finup);
> @@ -385,13 +393,16 @@ EXPORT_SYMBOL_GPL(crypto_ahash_finup);
>  int crypto_ahash_digest(struct ahash_request *req)
>  {
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct crypto_alg *alg = tfm->base.__crt_alg;
> +	unsigned int nbytes = req->nbytes;
>  	int ret;
>  
> +	crypto_stats_get(alg);
>  	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>  		ret = -ENOKEY;
>  	else
>  		ret = crypto_ahash_op(req, tfm->digest);
> -	crypto_stat_ahash_final(req, ret);
> +	crypto_stats_ahash_final(nbytes, ret, alg);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_digest);
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 42fe316f80ee..aae302d92c2a 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -1078,6 +1078,291 @@ int crypto_type_has_alg(const char *name, const struct crypto_type *frontend,
>  }
>  EXPORT_SYMBOL_GPL(crypto_type_has_alg);
>  
> +#ifdef CONFIG_CRYPTO_STATS
> +void crypto_stats_get(struct crypto_alg *alg)
> +{
> +	crypto_alg_get(alg);
> +}
> +
> +void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret,
> +				     struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->cipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->encrypt_cnt);
> +		atomic64_add(nbytes, &alg->encrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret,
> +				     struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->cipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->decrypt_cnt);
> +		atomic64_add(nbytes, &alg->decrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg,
> +			       int ret)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->aead_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->encrypt_cnt);
> +		atomic64_add(cryptlen, &alg->encrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg,
> +			       int ret)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->aead_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->decrypt_cnt);
> +		atomic64_add(cryptlen, &alg->decrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
> +				   struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->akcipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->encrypt_cnt);
> +		atomic64_add(src_len, &alg->encrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
> +				   struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->akcipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->decrypt_cnt);
> +		atomic64_add(src_len, &alg->decrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
> +		atomic64_inc(&alg->akcipher_err_cnt);
> +	else
> +		atomic64_inc(&alg->sign_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
> +		atomic64_inc(&alg->akcipher_err_cnt);
> +	else
> +		atomic64_inc(&alg->verify_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->compress_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->compress_cnt);
> +		atomic64_add(slen, &alg->compress_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->compress_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->decompress_cnt);
> +		atomic64_add(slen, &alg->decompress_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_ahash_update(unsigned int nbytes, int ret,
> +			       struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
> +		atomic64_inc(&alg->hash_err_cnt);
> +	else
> +		atomic64_add(nbytes, &alg->hash_tlen);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_ahash_final(unsigned int nbytes, int ret,
> +			      struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->hash_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->hash_cnt);
> +		atomic64_add(nbytes, &alg->hash_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
> +{
> +	if (ret)
> +		atomic64_inc(&alg->kpp_err_cnt);
> +	else
> +		atomic64_inc(&alg->setsecret_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
> +{
> +	if (ret)
> +		atomic64_inc(&alg->kpp_err_cnt);
> +	else
> +		atomic64_inc(&alg->generate_public_key_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
> +{
> +	if (ret)
> +		atomic64_inc(&alg->kpp_err_cnt);
> +	else
> +		atomic64_inc(&alg->compute_shared_secret_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
> +		atomic64_inc(&alg->rng_err_cnt);
> +	else
> +		atomic64_inc(&alg->seed_cnt);
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen,
> +			       int ret)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->rng_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->generate_cnt);
> +		atomic64_add(dlen, &alg->generate_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret,
> +				   struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->cipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->encrypt_cnt);
> +		atomic64_add(cryptlen, &alg->encrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +
> +void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
> +				   struct crypto_alg *alg)
> +{
> +	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> +		atomic64_inc(&alg->cipher_err_cnt);
> +	} else {
> +		atomic64_inc(&alg->decrypt_cnt);
> +		atomic64_add(cryptlen, &alg->decrypt_tlen);
> +	}
> +	crypto_alg_put(alg);
> +}
> +#else
> +void crypto_stats_get(struct crypto_alg *alg)
> +{}
> +void crypto_stats_ablkcipher_encrypt(unsigned int nbytes, int ret,
> +				     struct crypto_alg *alg)
> +{}
> +void crypto_stats_ablkcipher_decrypt(unsigned int nbytes, int ret,
> +				     struct crypto_alg *alg)
> +{}
> +void crypto_stats_aead_encrypt(unsigned int cryptlen, struct crypto_alg *alg,
> +			       int ret)
> +{}
> +void crypto_stats_aead_decrypt(unsigned int cryptlen, struct crypto_alg *alg,
> +			       int ret)
> +{}
> +void crypto_stats_ahash_update(unsigned int nbytes, int ret,
> +			       struct crypto_alg *alg)
> +{}
> +void crypto_stats_ahash_final(unsigned int nbytes, int ret,
> +			      struct crypto_alg *alg)
> +{}
> +void crypto_stats_akcipher_encrypt(unsigned int src_len, int ret,
> +				   struct crypto_alg *alg)
> +{}
> +void crypto_stats_akcipher_decrypt(unsigned int src_len, int ret,
> +				   struct crypto_alg *alg)
> +{}
> +void crypto_stats_akcipher_sign(int ret, struct crypto_alg *alg)
> +{}
> +void crypto_stats_akcipher_verify(int ret, struct crypto_alg *alg)
> +{}
> +void crypto_stats_compress(unsigned int slen, int ret, struct crypto_alg *alg)
> +{}
> +void crypto_stats_decompress(unsigned int slen, int ret, struct crypto_alg *alg)
> +{}
> +void crypto_stats_kpp_set_secret(struct crypto_alg *alg, int ret)
> +{}
> +void crypto_stats_kpp_generate_public_key(struct crypto_alg *alg, int ret)
> +{}
> +void crypto_stats_kpp_compute_shared_secret(struct crypto_alg *alg, int ret)
> +{}
> +void crypto_stats_rng_seed(struct crypto_alg *alg, int ret)
> +{}
> +void crypto_stats_rng_generate(struct crypto_alg *alg, unsigned int dlen,
> +			       int ret)
> +{}
> +void crypto_stats_skcipher_encrypt(unsigned int cryptlen, int ret,
> +				   struct crypto_alg *alg)
> +{}
> +void crypto_stats_skcipher_decrypt(unsigned int cryptlen, int ret,
> +				   struct crypto_alg *alg)
> +{}
> +#endif

The stubs need to be static inline in the .h file so that they are optimized out
when !CONFIG_CRYPTO_STATS.  Otherwise there is a massive bloat.  See the
dissassembly of a call to crypto_skcipher_encrypt() in each case:

With inline stubs (same as original, before the crypto stats feature):

	ffffffff812f6e80 <encrypt>:
	ffffffff812f6e80:       48 8b 47 40             mov    0x40(%rdi),%rax
	ffffffff812f6e84:       f6 00 01                testb  $0x1,(%rax)
	ffffffff812f6e87:       75 03                   jne    ffffffff812f6e8c <encrypt+0xc>
	ffffffff812f6e89:       ff 60 e0                jmpq   *-0x20(%rax)
	ffffffff812f6e8c:       b8 82 ff ff ff          mov    $0xffffff82,%eax
	ffffffff812f6e91:       c3                      retq   

With non-inline stubs (even when !CONFIG_CRYPTO_STATS):

	ffffffff812f75e0 <encrypt>:
	ffffffff812f75e0:       41 55                   push   %r13
	ffffffff812f75e2:       41 54                   push   %r12
	ffffffff812f75e4:       55                      push   %rbp
	ffffffff812f75e5:       48 89 fd                mov    %rdi,%rbp
	ffffffff812f75e8:       53                      push   %rbx
	ffffffff812f75e9:       48 8b 5f 40             mov    0x40(%rdi),%rbx
	ffffffff812f75ed:       44 8b 2f                mov    (%rdi),%r13d
	ffffffff812f75f0:       4c 8b 63 38             mov    0x38(%rbx),%r12
	ffffffff812f75f4:       4c 89 e7                mov    %r12,%rdi
	ffffffff812f75f7:       e8 14 df fd ff          callq  ffffffff812d5510 <crypto_stats_get>
	ffffffff812f75fc:       f6 03 01                testb  $0x1,(%rbx)
	ffffffff812f75ff:       75 1e                   jne    ffffffff812f761f <encrypt+0x3f>
	ffffffff812f7601:       48 89 ef                mov    %rbp,%rdi
	ffffffff812f7604:       ff 53 e0                callq  *-0x20(%rbx)
	ffffffff812f7607:       89 c3                   mov    %eax,%ebx
	ffffffff812f7609:       4c 89 e2                mov    %r12,%rdx
	ffffffff812f760c:       89 de                   mov    %ebx,%esi
	ffffffff812f760e:       44 89 ef                mov    %r13d,%edi
	ffffffff812f7611:       e8 3a de fd ff          callq  ffffffff812d5450 <crypto_stats_skcipher_encrypt>
	ffffffff812f7616:       89 d8                   mov    %ebx,%eax
	ffffffff812f7618:       5b                      pop    %rbx
	ffffffff812f7619:       5d                      pop    %rbp
	ffffffff812f761a:       41 5c                   pop    %r12
	ffffffff812f761c:       41 5d                   pop    %r13
	ffffffff812f761e:       c3                      retq   
	ffffffff812f761f:       bb 82 ff ff ff          mov    $0xffffff82,%ebx
	ffffffff812f7624:       eb e3                   jmp    ffffffff812f7609 <encrypt+0x29>

- Eric
