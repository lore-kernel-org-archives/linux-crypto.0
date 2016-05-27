From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [RFC 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 27 May 2016 08:31:43 +0200
Message-ID: <5747E9CF.7010706@gmail.com>
References: <cover.1464144790.git.baolin.wang@linaro.org>
 <7f0fef5fe473a451e352b2d42e1eed483fd28667.1464144791.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ebiggers3@gmail.com, js1304@gmail.com, tadeusz.struk@intel.com,
	smueller@chronox.de, standby24x7@gmail.com, shli@kernel.org,
	dan.j.williams@intel.com, martin.petersen@oracle.com,
	sagig@mellanox.com, kent.overstreet@gmail.com,
	keith.busch@intel.com, tj@kernel.org, ming.lei@canonical.com,
	broonie@kernel.org, arnd@arndb.de, linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>, axboe@kernel.dk,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7f0fef5fe473a451e352b2d42e1eed483fd28667.1464144791.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/25/2016 08:12 AM, Baolin Wang wrote:
> Now some cipher hardware engines prefer to handle bulk block rather than one
> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
> the intermediate values (IV) by themselves in one bulk block. This means we
> can increase the size of the request by merging request rather than always 512
> bytes and thus increase the hardware engine processing speed.

Hi,

could you please elaborate how exactly you are processing independently
encrypted sectors? For example with XTS mode. Do you play internally with
tweak calculation? Does this keep 512 bytes sector encryption blocks independent?

(If not, it is breaking compatibility everywhere and you are reinventing
disk encryption logic here - just for performance reason for some hw
not designed for this task... But that was said several times already.)

> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
> mode.

What exactly skcipher will do if this flag is set?

Which drivers it should use? I do not see any posted patch that uses this flag yet.
How we can test it?

Milan

> 
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
> ---
>  include/crypto/skcipher.h |    7 +++++++
>  include/linux/crypto.h    |    6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 0f987f5..d89d29a 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -519,5 +519,12 @@ static inline void skcipher_request_set_crypt(
>  	req->iv = iv;
>  }
>  
> +static inline unsigned int skcipher_is_bulk_mode(struct crypto_skcipher *sk_tfm)
> +{
> +	struct crypto_tfm *tfm = crypto_skcipher_tfm(sk_tfm);
> +
> +	return crypto_tfm_alg_bulk(tfm);
> +}
> +
>  #endif	/* _CRYPTO_SKCIPHER_H */
>  
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 6e28c89..a315487 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -63,6 +63,7 @@
>  #define CRYPTO_ALG_DEAD			0x00000020
>  #define CRYPTO_ALG_DYING		0x00000040
>  #define CRYPTO_ALG_ASYNC		0x00000080
> +#define CRYPTO_ALG_BULK			0x00000100
>  
>  /*
>   * Set this bit if and only if the algorithm requires another algorithm of
> @@ -623,6 +624,11 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
>  	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
>  }
>  
> +static inline unsigned int crypto_tfm_alg_bulk(struct crypto_tfm *tfm)
> +{
> +	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_BULK;
> +}
> +
>  static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
>  {
>  	return tfm->__crt_alg->cra_blocksize;
> 
