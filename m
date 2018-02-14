From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 4/6] crypto: virtio: convert to new crypto engine API
Date: Wed, 14 Feb 2018 17:51:59 +0200
Message-ID: <20180214175137-mutt-send-email-mst@kernel.org>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
	<20180126191534.17569-5-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, corbet@lwn.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, fabien.dessenne@st.com,
	virtualization@lists.linux-foundation.org,
	linux-sunxi@googlegroups.com, linux-crypto@vger.kernel.org,
	mcoquelin.stm32@gmail.com, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org, alexandre.torgue@st.com
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20180126191534.17569-5-clabbe.montjoie@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jan 26, 2018 at 08:15:32PM +0100, Corentin Labbe wrote:
> This patch convert the driver to the new crypto engine API.
> 
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Pls queue when/if rest of changes go in.

> ---
>  drivers/crypto/virtio/virtio_crypto_algs.c   | 16 ++++++++++------
>  drivers/crypto/virtio/virtio_crypto_common.h |  3 +--
>  drivers/crypto/virtio/virtio_crypto_core.c   |  3 ---
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c b/drivers/crypto/virtio/virtio_crypto_algs.c
> index abe8c15450df..ba190cfa7aa1 100644
> --- a/drivers/crypto/virtio/virtio_crypto_algs.c
> +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
> @@ -29,6 +29,7 @@
>  
>  
>  struct virtio_crypto_ablkcipher_ctx {
> +	struct crypto_engine_ctx enginectx;
>  	struct virtio_crypto *vcrypto;
>  	struct crypto_tfm *tfm;
>  
> @@ -491,7 +492,7 @@ static int virtio_crypto_ablkcipher_encrypt(struct ablkcipher_request *req)
>  	vc_sym_req->ablkcipher_req = req;
>  	vc_sym_req->encrypt = true;
>  
> -	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
> +	return crypto_transfer_ablkcipher_request_to_engine(data_vq->engine, req);
>  }
>  
>  static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
> @@ -511,7 +512,7 @@ static int virtio_crypto_ablkcipher_decrypt(struct ablkcipher_request *req)
>  	vc_sym_req->ablkcipher_req = req;
>  	vc_sym_req->encrypt = false;
>  
> -	return crypto_transfer_cipher_request_to_engine(data_vq->engine, req);
> +	return crypto_transfer_ablkcipher_request_to_engine(data_vq->engine, req);
>  }
>  
>  static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
> @@ -521,6 +522,9 @@ static int virtio_crypto_ablkcipher_init(struct crypto_tfm *tfm)
>  	tfm->crt_ablkcipher.reqsize = sizeof(struct virtio_crypto_sym_request);
>  	ctx->tfm = tfm;
>  
> +	ctx->enginectx.op.do_one_request = virtio_crypto_ablkcipher_crypt_req;
> +	ctx->enginectx.op.prepare_request = NULL;
> +	ctx->enginectx.op.unprepare_request = NULL;
>  	return 0;
>  }
>  
> @@ -538,9 +542,9 @@ static void virtio_crypto_ablkcipher_exit(struct crypto_tfm *tfm)
>  }
>  
>  int virtio_crypto_ablkcipher_crypt_req(
> -	struct crypto_engine *engine,
> -	struct ablkcipher_request *req)
> +	struct crypto_engine *engine, void *vreq)
>  {
> +	struct ablkcipher_request *req = container_of(vreq, struct ablkcipher_request, base);
>  	struct virtio_crypto_sym_request *vc_sym_req =
>  				ablkcipher_request_ctx(req);
>  	struct virtio_crypto_request *vc_req = &vc_sym_req->base;
> @@ -561,8 +565,8 @@ static void virtio_crypto_ablkcipher_finalize_req(
>  	struct ablkcipher_request *req,
>  	int err)
>  {
> -	crypto_finalize_cipher_request(vc_sym_req->base.dataq->engine,
> -					req, err);
> +	crypto_finalize_ablkcipher_request(vc_sym_req->base.dataq->engine,
> +					   req, err);
>  	kzfree(vc_sym_req->iv);
>  	virtcrypto_clear_request(&vc_sym_req->base);
>  }
> diff --git a/drivers/crypto/virtio/virtio_crypto_common.h b/drivers/crypto/virtio/virtio_crypto_common.h
> index e976539a05d9..72621bd67211 100644
> --- a/drivers/crypto/virtio/virtio_crypto_common.h
> +++ b/drivers/crypto/virtio/virtio_crypto_common.h
> @@ -107,8 +107,7 @@ struct virtio_crypto *virtcrypto_get_dev_node(int node);
>  int virtcrypto_dev_start(struct virtio_crypto *vcrypto);
>  void virtcrypto_dev_stop(struct virtio_crypto *vcrypto);
>  int virtio_crypto_ablkcipher_crypt_req(
> -	struct crypto_engine *engine,
> -	struct ablkcipher_request *req);
> +	struct crypto_engine *engine, void *vreq);
>  
>  void
>  virtcrypto_clear_request(struct virtio_crypto_request *vc_req);
> diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
> index ff1410a32c2b..83326986c113 100644
> --- a/drivers/crypto/virtio/virtio_crypto_core.c
> +++ b/drivers/crypto/virtio/virtio_crypto_core.c
> @@ -111,9 +111,6 @@ static int virtcrypto_find_vqs(struct virtio_crypto *vi)
>  			ret = -ENOMEM;
>  			goto err_engine;
>  		}
> -
> -		vi->data_vq[i].engine->cipher_one_request =
> -			virtio_crypto_ablkcipher_crypt_req;
>  	}
>  
>  	kfree(names);
> -- 
> 2.13.6
