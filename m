From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Fri, 12 Jan 2018 07:49:43 +0100
Message-ID: <3297958.ndliyBY1jk@tauon.chronox.de>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com> <1515700617-3513-2-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58210 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752915AbeALGtr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 01:49:47 -0500
In-Reply-To: <1515700617-3513-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. Januar 2018, 20:56:56 CET schrieb Corentin Labbe:

Hi Corentin,

> This patch implement a generic way to get statistics about all crypto
> usages.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/Kconfig                  | 11 ++++++++
>  crypto/ablkcipher.c             |  9 +++++++
>  crypto/acompress.c              |  9 +++++++
>  crypto/aead.c                   | 10 ++++++++
>  crypto/ahash.c                  |  8 ++++++
>  crypto/akcipher.c               | 13 ++++++++++
>  crypto/algapi.c                 |  6 +++++
>  crypto/blkcipher.c              |  9 +++++++
>  crypto/crypto_user.c            | 28 +++++++++++++++++++++
>  crypto/kpp.c                    |  7 ++++++
>  crypto/rng.c                    |  8 ++++++
>  crypto/scompress.c              |  9 +++++++
>  crypto/shash.c                  |  5 ++++
>  crypto/skcipher.c               |  9 +++++++
>  include/crypto/acompress.h      | 22 ++++++++++++++++
>  include/crypto/aead.h           | 22 ++++++++++++++++
>  include/crypto/akcipher.h       | 42 +++++++++++++++++++++++++++++++
>  include/crypto/hash.h           | 21 ++++++++++++++++
>  include/crypto/kpp.h            | 28 +++++++++++++++++++++
>  include/crypto/rng.h            | 17 +++++++++++++
>  include/crypto/skcipher.h       | 22 ++++++++++++++++
>  include/linux/crypto.h          | 56
> +++++++++++++++++++++++++++++++++++++++++ include/uapi/linux/cryptouser.h |
> 34 +++++++++++++++++++++++++
>  23 files changed, 405 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 971d558494c3..3b88fba14b59 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1780,6 +1780,17 @@ config CRYPTO_USER_API_AEAD
>  	  This option enables the user-spaces interface for AEAD
>  	  cipher algorithms.
> 
> +config CRYPTO_STATS
> +	bool "Crypto usage statistics for User-space"
> +	help
> +	  This option enables the gathering of crypto stats.
> +	  This will collect:
> +	  - encrypt/decrypt size and numbers of symmeric operations
> +	  - compress/decompress size and numbers of compress operations
> +	  - size and numbers of hash operations
> +	  - encrypt/decrypt/sign/verify numbers for asymmetric operations
> +	  - generate/seed numbers for rng operations
> +
>  config CRYPTO_HASH_INFO
>  	bool
> 
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index d880a4897159..f6d20e4ca977 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -369,6 +369,7 @@ static int crypto_init_ablkcipher_ops(struct crypto_tfm
> *tfm, u32 type, static int crypto_ablkcipher_report(struct sk_buff *skb,
> struct crypto_alg *alg) {
>  	struct crypto_report_blkcipher rblkcipher;
> +	u64 v;
> 
>  	strncpy(rblkcipher.type, "ablkcipher", sizeof(rblkcipher.type));
>  	strncpy(rblkcipher.geniv, alg->cra_ablkcipher.geniv ?: "<default>",
> @@ -378,6 +379,14 @@ static int crypto_ablkcipher_report(struct sk_buff
> *skb, struct crypto_alg *alg) rblkcipher.min_keysize =
> alg->cra_ablkcipher.min_keysize;
>  	rblkcipher.max_keysize = alg->cra_ablkcipher.max_keysize;
>  	rblkcipher.ivsize = alg->cra_ablkcipher.ivsize;
> +	v = atomic_read(&alg->encrypt_cnt);
> +	rblkcipher.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	rblkcipher.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	rblkcipher.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	rblkcipher.stat_decrypt_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
>  		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 1544b7c057fb..524c8a3e3f80 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -32,8 +32,17 @@ static const struct crypto_type crypto_acomp_type;
>  static int crypto_acomp_report(struct sk_buff *skb, struct crypto_alg *alg)
> {
>  	struct crypto_report_acomp racomp;
> +	u64 v;
> 
>  	strncpy(racomp.type, "acomp", sizeof(racomp.type));
> +	v = atomic_read(&alg->compress_cnt);
> +	racomp.stat_compress_cnt = v;
> +	v = atomic_read(&alg->compress_tlen);
> +	racomp.stat_compress_tlen = v;
> +	v = atomic_read(&alg->decompress_cnt);
> +	racomp.stat_decompress_cnt = v;
> +	v = atomic_read(&alg->decompress_tlen);
> +	racomp.stat_decompress_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMP,
>  		    sizeof(struct crypto_report_acomp), &racomp))
> diff --git a/crypto/aead.c b/crypto/aead.c
> index fe00cbd7243d..de13bd345d8b 100644
> --- a/crypto/aead.c
> +++ b/crypto/aead.c
> @@ -109,6 +109,7 @@ static int crypto_aead_report(struct sk_buff *skb,
> struct crypto_alg *alg) {
>  	struct crypto_report_aead raead;
>  	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
> +	u64 v;
> 
>  	strncpy(raead.type, "aead", sizeof(raead.type));
>  	strncpy(raead.geniv, "<none>", sizeof(raead.geniv));
> @@ -116,6 +117,15 @@ static int crypto_aead_report(struct sk_buff *skb,
> struct crypto_alg *alg) raead.blocksize = alg->cra_blocksize;
>  	raead.maxauthsize = aead->maxauthsize;
>  	raead.ivsize = aead->ivsize;
> +	v = atomic_read(&alg->encrypt_cnt);
> +	raead.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	raead.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	raead.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	raead.stat_decrypt_tlen = v;
> +
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_AEAD,
>  		    sizeof(struct crypto_report_aead), &raead))
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index 3a35d67de7d9..e718f387039c 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -356,18 +356,21 @@ static int crypto_ahash_op(struct ahash_request *req,
> 
>  int crypto_ahash_final(struct ahash_request *req)
>  {
> +	crypto_stat_ahash_final(req);
>  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->final);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_final);
> 
>  int crypto_ahash_finup(struct ahash_request *req)
>  {
> +	crypto_stat_ahash_final(req);
>  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->finup);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_finup);
> 
>  int crypto_ahash_digest(struct ahash_request *req)
>  {
> +	crypto_stat_ahash_final(req);
>  	return crypto_ahash_op(req, crypto_ahash_reqtfm(req)->digest);
>  }
>  EXPORT_SYMBOL_GPL(crypto_ahash_digest);
> @@ -487,11 +490,16 @@ static unsigned int crypto_ahash_extsize(struct
> crypto_alg *alg) static int crypto_ahash_report(struct sk_buff *skb, struct
> crypto_alg *alg) {
>  	struct crypto_report_hash rhash;
> +	u64 v;
> 
>  	strncpy(rhash.type, "ahash", sizeof(rhash.type));
> 
>  	rhash.blocksize = alg->cra_blocksize;
>  	rhash.digestsize = __crypto_hash_alg_common(alg)->digestsize;
> +	v = atomic_read(&alg->hash_cnt);
> +	rhash.stat_hash = v;
> +	v = atomic_read(&alg->hash_tlen);
> +	rhash.stat_hash_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_HASH,
>  		    sizeof(struct crypto_report_hash), &rhash))
> diff --git a/crypto/akcipher.c b/crypto/akcipher.c
> index cfbdb06d8ca8..02cb06824637 100644
> --- a/crypto/akcipher.c
> +++ b/crypto/akcipher.c
> @@ -29,8 +29,21 @@
>  static int crypto_akcipher_report(struct sk_buff *skb, struct crypto_alg
> *alg) {
>  	struct crypto_report_akcipher rakcipher;
> +	u64 v;
> 
>  	strncpy(rakcipher.type, "akcipher", sizeof(rakcipher.type));
> +	v = atomic_read(&alg->encrypt_cnt);
> +	rakcipher.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	rakcipher.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	rakcipher.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	rakcipher.stat_decrypt_tlen = v;
> +	v = atomic_read(&alg->sign_cnt);
> +	rakcipher.stat_sign_cnt = v;
> +	v = atomic_read(&alg->verify_cnt);
> +	rakcipher.stat_verify_cnt = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_AKCIPHER,
>  		    sizeof(struct crypto_report_akcipher), &rakcipher))
> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 395b082d03a9..cf563f9f4be9 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -243,6 +243,12 @@ static struct crypto_larval
> *__crypto_register_alg(struct crypto_alg *alg) list_add(&alg->cra_list,
> &crypto_alg_list);
>  	list_add(&larval->alg.cra_list, &crypto_alg_list);
> 
> +	atomic_set(&alg->encrypt_cnt, 0);
> +	atomic_set(&alg->decrypt_cnt, 0);
> +	atomic_set(&alg->encrypt_tlen, 0);
> +	atomic_set(&alg->decrypt_tlen, 0);
> +	atomic_set(&alg->verify_cnt, 0);
> +
>  out:
>  	return larval;
> 
> diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
> index 01c0d4aa2563..bae369c1a1d1 100644
> --- a/crypto/blkcipher.c
> +++ b/crypto/blkcipher.c
> @@ -508,6 +508,7 @@ static int crypto_init_blkcipher_ops(struct crypto_tfm
> *tfm, u32 type, u32 mask) static int crypto_blkcipher_report(struct sk_buff
> *skb, struct crypto_alg *alg) {
>  	struct crypto_report_blkcipher rblkcipher;
> +	u64 v;
> 
>  	strncpy(rblkcipher.type, "blkcipher", sizeof(rblkcipher.type));
>  	strncpy(rblkcipher.geniv, alg->cra_blkcipher.geniv ?: "<default>",
> @@ -517,6 +518,14 @@ static int crypto_blkcipher_report(struct sk_buff *skb,
> struct crypto_alg *alg) rblkcipher.min_keysize =
> alg->cra_blkcipher.min_keysize;
>  	rblkcipher.max_keysize = alg->cra_blkcipher.max_keysize;
>  	rblkcipher.ivsize = alg->cra_blkcipher.ivsize;
> +	v = atomic_read(&alg->encrypt_cnt);
> +	rblkcipher.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	rblkcipher.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	rblkcipher.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	rblkcipher.stat_decrypt_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
>  		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
> diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
> index 5c291eedaa70..bd62f71a1ed1 100644
> --- a/crypto/crypto_user.c
> +++ b/crypto/crypto_user.c
> @@ -82,12 +82,21 @@ static struct crypto_alg *crypto_alg_match(struct
> crypto_user_alg *p, int exact) static int crypto_report_cipher(struct
> sk_buff *skb, struct crypto_alg *alg) {
>  	struct crypto_report_cipher rcipher;
> +	u64 v;
> 
>  	strlcpy(rcipher.type, "cipher", sizeof(rcipher.type));
> 
>  	rcipher.blocksize = alg->cra_blocksize;
>  	rcipher.min_keysize = alg->cra_cipher.cia_min_keysize;
>  	rcipher.max_keysize = alg->cra_cipher.cia_max_keysize;
> +	v = atomic_read(&alg->encrypt_cnt);
> +	rcipher.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	rcipher.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	rcipher.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	rcipher.stat_decrypt_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_CIPHER,
>  		    sizeof(struct crypto_report_cipher), &rcipher))
> @@ -101,8 +110,18 @@ static int crypto_report_cipher(struct sk_buff *skb,
> struct crypto_alg *alg) static int crypto_report_comp(struct sk_buff *skb,
> struct crypto_alg *alg) {
>  	struct crypto_report_comp rcomp;
> +	u64 v;
> 
>  	strlcpy(rcomp.type, "compression", sizeof(rcomp.type));
> +	v = atomic_read(&alg->compress_cnt);
> +	rcomp.stat_compress_cnt = v;
> +	v = atomic_read(&alg->compress_tlen);
> +	rcomp.stat_compress_tlen = v;
> +	v = atomic_read(&alg->decompress_cnt);
> +	rcomp.stat_decompress_cnt = v;
> +	v = atomic_read(&alg->decompress_tlen);
> +	rcomp.stat_decompress_tlen = v;
> +
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
>  		    sizeof(struct crypto_report_comp), &rcomp))
>  		goto nla_put_failure;
> @@ -115,8 +134,17 @@ static int crypto_report_comp(struct sk_buff *skb,
> struct crypto_alg *alg) static int crypto_report_acomp(struct sk_buff *skb,
> struct crypto_alg *alg) {
>  	struct crypto_report_acomp racomp;
> +	u64 v;
> 
>  	strlcpy(racomp.type, "acomp", sizeof(racomp.type));
> +	v = atomic_read(&alg->compress_cnt);
> +	racomp.stat_compress_cnt = v;
> +	v = atomic_read(&alg->compress_tlen);
> +	racomp.stat_compress_tlen = v;
> +	v = atomic_read(&alg->decompress_cnt);
> +	racomp.stat_decompress_cnt = v;
> +	v = atomic_read(&alg->decompress_tlen);
> +	racomp.stat_decompress_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_ACOMP,
>  		    sizeof(struct crypto_report_acomp), &racomp))
> diff --git a/crypto/kpp.c b/crypto/kpp.c
> index a90edc27af77..3db941345818 100644
> --- a/crypto/kpp.c
> +++ b/crypto/kpp.c
> @@ -29,8 +29,15 @@
>  static int crypto_kpp_report(struct sk_buff *skb, struct crypto_alg *alg)
>  {
>  	struct crypto_report_kpp rkpp;
> +	u64 v;
> 
>  	strncpy(rkpp.type, "kpp", sizeof(rkpp.type));
> +	v = atomic_read(&alg->setsecret_cnt);
> +	rkpp.stat_setsecret_cnt = v;
> +	v = atomic_read(&alg->generate_public_key_cnt);
> +	rkpp.stat_generate_public_key_cnt = v;
> +	v = atomic_read(&alg->compute_shared_secret_cnt);
> +	rkpp.stat_compute_shared_secret_cnt = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_KPP,
>  		    sizeof(struct crypto_report_kpp), &rkpp))
> diff --git a/crypto/rng.c b/crypto/rng.c
> index b4a618668161..4cf1de1722ee 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -49,6 +49,7 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8
> *seed, unsigned int slen) seed = buf;
>  	}
> 
> +	crypto_stat_rng_seed(tfm);
>  	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
>  out:
>  	kzfree(buf);
> @@ -72,10 +73,17 @@ static unsigned int seedsize(struct crypto_alg *alg)
>  static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
>  {
>  	struct crypto_report_rng rrng;
> +	u64 v;
> 
>  	strncpy(rrng.type, "rng", sizeof(rrng.type));
> 
>  	rrng.seedsize = seedsize(alg);
> +	v = atomic_read(&alg->generate_cnt);
> +	rrng.stat_generate_cnt = v;
> +	v = atomic_read(&alg->generate_tlen);
> +	rrng.stat_generate_tlen = v;
> +	v = atomic_read(&alg->seed_cnt);
> +	rrng.stat_seed_cnt = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_RNG,
>  		    sizeof(struct crypto_report_rng), &rrng))
> diff --git a/crypto/scompress.c b/crypto/scompress.c
> index 968bbcf65c94..3c3115f5378e 100644
> --- a/crypto/scompress.c
> +++ b/crypto/scompress.c
> @@ -39,8 +39,17 @@ static DEFINE_MUTEX(scomp_lock);
>  static int crypto_scomp_report(struct sk_buff *skb, struct crypto_alg *alg)
> {
>  	struct crypto_report_comp rscomp;
> +	u64 v;
> 
>  	strncpy(rscomp.type, "scomp", sizeof(rscomp.type));
> +	v = atomic_read(&alg->compress_cnt);
> +	rscomp.stat_compress_cnt = v;
> +	v = atomic_read(&alg->compress_tlen);
> +	rscomp.stat_compress_tlen = v;
> +	v = atomic_read(&alg->decompress_cnt);
> +	rscomp.stat_decompress_cnt = v;
> +	v = atomic_read(&alg->decompress_tlen);
> +	rscomp.stat_decompress_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
>  		    sizeof(struct crypto_report_comp), &rscomp))
> diff --git a/crypto/shash.c b/crypto/shash.c
> index e849d3ee2e27..c1d086fa03e7 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -385,11 +385,16 @@ static int crypto_shash_report(struct sk_buff *skb,
> struct crypto_alg *alg) {
>  	struct crypto_report_hash rhash;
>  	struct shash_alg *salg = __crypto_shash_alg(alg);
> +	u64 v;
> 
>  	strncpy(rhash.type, "shash", sizeof(rhash.type));
> 
>  	rhash.blocksize = alg->cra_blocksize;
>  	rhash.digestsize = salg->digestsize;
> +	v = atomic_read(&alg->hash_cnt);
> +	rhash.stat_hash = v;
> +	v = atomic_read(&alg->hash_tlen);
> +	rhash.stat_hash_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_HASH,
>  		    sizeof(struct crypto_report_hash), &rhash))
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 11af5fd6a443..102194ecaa7d 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -875,6 +875,7 @@ static int crypto_skcipher_report(struct sk_buff *skb,
> struct crypto_alg *alg) struct crypto_report_blkcipher rblkcipher;
>  	struct skcipher_alg *skcipher = container_of(alg, struct skcipher_alg,
>  						     base);
> +	u64 v;
> 
>  	strncpy(rblkcipher.type, "skcipher", sizeof(rblkcipher.type));
>  	strncpy(rblkcipher.geniv, "<none>", sizeof(rblkcipher.geniv));
> @@ -883,6 +884,14 @@ static int crypto_skcipher_report(struct sk_buff *skb,
> struct crypto_alg *alg) rblkcipher.min_keysize = skcipher->min_keysize;
>  	rblkcipher.max_keysize = skcipher->max_keysize;
>  	rblkcipher.ivsize = skcipher->ivsize;
> +	v = atomic_read(&alg->encrypt_cnt);
> +	rblkcipher.stat_encrypt_cnt = v;
> +	v = atomic_read(&alg->encrypt_tlen);
> +	rblkcipher.stat_encrypt_tlen = v;
> +	v = atomic_read(&alg->decrypt_cnt);
> +	rblkcipher.stat_decrypt_cnt = v;
> +	v = atomic_read(&alg->decrypt_tlen);
> +	rblkcipher.stat_decrypt_tlen = v;
> 
>  	if (nla_put(skb, CRYPTOCFGA_REPORT_BLKCIPHER,
>  		    sizeof(struct crypto_report_blkcipher), &rblkcipher))
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index e328b52425a8..aed36031c6c1 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -234,6 +234,26 @@ static inline void acomp_request_set_params(struct
> acomp_req *req, req->flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
>  }
> 
> +static inline void crypto_stat_compress(struct acomp_req *req)
> +{
> +#ifdef CONFIG_CRYPTO_STATS
> +	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> +
> +	atomic_inc(&tfm->base.__crt_alg->compress_cnt);
> +	atomic_add(req->slen, &tfm->base.__crt_alg->compress_tlen);
> +#endif
> +}
> +
> +static inline void crypto_stat_decompress(struct acomp_req *req)
> +{
> +#ifdef CONFIG_CRYPTO_STATS
> +	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> +
> +	atomic_inc(&tfm->base.__crt_alg->decompress_cnt);
> +	atomic_add(req->slen, &tfm->base.__crt_alg->decompress_tlen);
> +#endif
> +}
> +
>  /**
>   * crypto_acomp_compress() -- Invoke asynchronous compress operation
>   *
> @@ -247,6 +267,7 @@ static inline int crypto_acomp_compress(struct acomp_req
> *req) {
>  	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> 
> +	crypto_stat_compress(req);
>  	return tfm->compress(req);

In general: should'nt the statistics increment only happen if the associated 
operation was successful?

>  /**
>   * crypto_ahash_finup() - update and finalize message digest
>   * @req: reference to the ahash_request handle that holds all information
> @@ -519,6 +538,8 @@ static inline int crypto_ahash_init(struct ahash_request
> *req) */
>  static inline int crypto_ahash_update(struct ahash_request *req)
>  {
> +
> +	crypto_stat_ahash_update(req);
>  	return crypto_ahash_reqtfm(req)->update(req);

In case you roll another update: please remove the blank line.

> diff --git a/include/uapi/linux/cryptouser.h
> b/include/uapi/linux/cryptouser.h index 19bf0ca6d635..15e51ccb3679 100644
> --- a/include/uapi/linux/cryptouser.h
> +++ b/include/uapi/linux/cryptouser.h
> @@ -73,6 +73,8 @@ struct crypto_report_hash {
>  	char type[CRYPTO_MAX_NAME];
>  	unsigned int blocksize;
>  	unsigned int digestsize;
> +	__u64 stat_hash;

Why do you use __u64? The atomic_t variable is an int, i.e. 32 bit. Thus I 
would think that __u32 would suffice?


> +	__u64 stat_hash_tlen;
>  };

What I am slightly unsure here is: how should user space detect whether these 
additional parameters are part of the NETLINK_USER API or not? I use that 
interface in my libkcapi whose binary may be used on multiple different kernel 
versions. How should that library operate if one kernel has these parameters 
and another does not?

Ciao
Stephan
