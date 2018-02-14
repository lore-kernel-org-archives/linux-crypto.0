From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v2 2/6] crypto: engine - Permit to enqueue all async
 requests
Date: Wed, 14 Feb 2018 13:31:58 +0000
Message-ID: <fb4578e7-6321-0281-8ba7-2186786859a3@st.com>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
 <20180126191534.17569-3-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Corentin Labbe <clabbe.montjoie@gmail.com>, Alexandre TORGUE
 <alexandre.torgue@st.com>, "arei.gonglei@huawei.com"
 <arei.gonglei@huawei.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "davem@davemloft.net" <davem@davemloft.net>, "herbert@gondor.apana.org.au"
 <herbert@gondor.apana.org.au>, "jasowang@redhat.com" <jasowang@redhat.com>,
 "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>, "mst@redhat.com"
 <mst@redhat.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180126191534.17569-3-clabbe.montjoie@gmail.com>
Content-Language: en-US
Content-ID: <07F31AC11012B3469E8C532091FB3E67@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Adding my tested-by for the AEAD part which is new in v2


On 26/01/18 20:15, Corentin Labbe wrote:
> The crypto engine could actually only enqueue hash and ablkcipher request.
> This patch permit it to enqueue any type of crypto_async_request.
>
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Tested-by: Fabien Dessenne <fabien.dessenne@st.com>

Tested-by: Fabien Dessenne <fabien.dessenne@st.com>


> ---
>   crypto/crypto_engine.c  | 301 ++++++++++++++++++++++++++----------------------
>   include/crypto/engine.h |  68 ++++++-----
>   2 files changed, 203 insertions(+), 166 deletions(-)
>
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index 61e7c4e02fd2..992e8d8dcdd9 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -15,13 +15,50 @@
>   #include <linux/err.h>
>   #include <linux/delay.h>
>   #include <crypto/engine.h>
> -#include <crypto/internal/hash.h>
>   #include <uapi/linux/sched/types.h>
>   #include "internal.h"
>   
>   #define CRYPTO_ENGINE_MAX_QLEN 10
>   
>   /**
> + * crypto_finalize_request - finalize one request if the request is done
> + * @engine: the hardware engine
> + * @req: the request need to be finalized
> + * @err: error number
> + */
> +static void crypto_finalize_request(struct crypto_engine *engine,
> +			     struct crypto_async_request *req, int err)
> +{
> +	unsigned long flags;
> +	bool finalize_cur_req = false;
> +	int ret;
> +	struct crypto_engine_ctx *enginectx;
> +
> +	spin_lock_irqsave(&engine->queue_lock, flags);
> +	if (engine->cur_req == req)
> +		finalize_cur_req = true;
> +	spin_unlock_irqrestore(&engine->queue_lock, flags);
> +
> +	if (finalize_cur_req) {
> +		enginectx = crypto_tfm_ctx(req->tfm);
> +		if (engine->cur_req_prepared &&
> +		    enginectx->op.unprepare_request) {
> +			ret = enginectx->op.unprepare_request(engine, req);
> +			if (ret)
> +				dev_err(engine->dev, "failed to unprepare request\n");
> +		}
> +		spin_lock_irqsave(&engine->queue_lock, flags);
> +		engine->cur_req = NULL;
> +		engine->cur_req_prepared = false;
> +		spin_unlock_irqrestore(&engine->queue_lock, flags);
> +	}
> +
> +	req->complete(req, err);
> +
> +	kthread_queue_work(engine->kworker, &engine->pump_requests);
> +}
> +
> +/**
>    * crypto_pump_requests - dequeue one request from engine queue to process
>    * @engine: the hardware engine
>    * @in_kthread: true if we are in the context of the request pump thread
> @@ -34,11 +71,10 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>   				 bool in_kthread)
>   {
>   	struct crypto_async_request *async_req, *backlog;
> -	struct ahash_request *hreq;
> -	struct ablkcipher_request *breq;
>   	unsigned long flags;
>   	bool was_busy = false;
> -	int ret, rtype;
> +	int ret;
> +	struct crypto_engine_ctx *enginectx;
>   
>   	spin_lock_irqsave(&engine->queue_lock, flags);
>   
> @@ -94,7 +130,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>   
>   	spin_unlock_irqrestore(&engine->queue_lock, flags);
>   
> -	rtype = crypto_tfm_alg_type(engine->cur_req->tfm);
>   	/* Until here we get the request need to be encrypted successfully */
>   	if (!was_busy && engine->prepare_crypt_hardware) {
>   		ret = engine->prepare_crypt_hardware(engine);
> @@ -104,57 +139,31 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>   		}
>   	}
>   
> -	switch (rtype) {
> -	case CRYPTO_ALG_TYPE_AHASH:
> -		hreq = ahash_request_cast(engine->cur_req);
> -		if (engine->prepare_hash_request) {
> -			ret = engine->prepare_hash_request(engine, hreq);
> -			if (ret) {
> -				dev_err(engine->dev, "failed to prepare request: %d\n",
> -					ret);
> -				goto req_err;
> -			}
> -			engine->cur_req_prepared = true;
> -		}
> -		ret = engine->hash_one_request(engine, hreq);
> -		if (ret) {
> -			dev_err(engine->dev, "failed to hash one request from queue\n");
> -			goto req_err;
> -		}
> -		return;
> -	case CRYPTO_ALG_TYPE_ABLKCIPHER:
> -		breq = ablkcipher_request_cast(engine->cur_req);
> -		if (engine->prepare_cipher_request) {
> -			ret = engine->prepare_cipher_request(engine, breq);
> -			if (ret) {
> -				dev_err(engine->dev, "failed to prepare request: %d\n",
> -					ret);
> -				goto req_err;
> -			}
> -			engine->cur_req_prepared = true;
> -		}
> -		ret = engine->cipher_one_request(engine, breq);
> +	enginectx = crypto_tfm_ctx(async_req->tfm);
> +
> +	if (enginectx->op.prepare_request) {
> +		ret = enginectx->op.prepare_request(engine, async_req);
>   		if (ret) {
> -			dev_err(engine->dev, "failed to cipher one request from queue\n");
> +			dev_err(engine->dev, "failed to prepare request: %d\n",
> +				ret);
>   			goto req_err;
>   		}
> -		return;
> -	default:
> -		dev_err(engine->dev, "failed to prepare request of unknown type\n");
> -		return;
> +		engine->cur_req_prepared = true;
> +	}
> +	if (!enginectx->op.do_one_request) {
> +		dev_err(engine->dev, "failed to do request\n");
> +		ret = -EINVAL;
> +		goto req_err;
>   	}
> +	ret = enginectx->op.do_one_request(engine, async_req);
> +	if (ret) {
> +		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
> +		goto req_err;
> +	}
> +	return;
>   
>   req_err:
> -	switch (rtype) {
> -	case CRYPTO_ALG_TYPE_AHASH:
> -		hreq = ahash_request_cast(engine->cur_req);
> -		crypto_finalize_hash_request(engine, hreq, ret);
> -		break;
> -	case CRYPTO_ALG_TYPE_ABLKCIPHER:
> -		breq = ablkcipher_request_cast(engine->cur_req);
> -		crypto_finalize_cipher_request(engine, breq, ret);
> -		break;
> -	}
> +	crypto_finalize_request(engine, async_req, ret);
>   	return;
>   
>   out:
> @@ -170,13 +179,12 @@ static void crypto_pump_work(struct kthread_work *work)
>   }
>   
>   /**
> - * crypto_transfer_cipher_request - transfer the new request into the
> - * enginequeue
> + * crypto_transfer_request - transfer the new request into the engine queue
>    * @engine: the hardware engine
>    * @req: the request need to be listed into the engine queue
>    */
> -int crypto_transfer_cipher_request(struct crypto_engine *engine,
> -				   struct ablkcipher_request *req,
> +static int crypto_transfer_request(struct crypto_engine *engine,
> +				   struct crypto_async_request *req,
>   				   bool need_pump)
>   {
>   	unsigned long flags;
> @@ -189,7 +197,7 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
>   		return -ESHUTDOWN;
>   	}
>   
> -	ret = ablkcipher_enqueue_request(&engine->queue, req);
> +	ret = crypto_enqueue_request(&engine->queue, req);
>   
>   	if (!engine->busy && need_pump)
>   		kthread_queue_work(engine->kworker, &engine->pump_requests);
> @@ -197,102 +205,131 @@ int crypto_transfer_cipher_request(struct crypto_engine *engine,
>   	spin_unlock_irqrestore(&engine->queue_lock, flags);
>   	return ret;
>   }
> -EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request);
>   
>   /**
> - * crypto_transfer_cipher_request_to_engine - transfer one request to list
> + * crypto_transfer_request_to_engine - transfer one request to list
>    * into the engine queue
>    * @engine: the hardware engine
>    * @req: the request need to be listed into the engine queue
>    */
> -int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
> -					     struct ablkcipher_request *req)
> +static int crypto_transfer_request_to_engine(struct crypto_engine *engine,
> +					     struct crypto_async_request *req)
>   {
> -	return crypto_transfer_cipher_request(engine, req, true);
> +	return crypto_transfer_request(engine, req, true);
>   }
> -EXPORT_SYMBOL_GPL(crypto_transfer_cipher_request_to_engine);
>   
>   /**
> - * crypto_transfer_hash_request - transfer the new request into the
> - * enginequeue
> + * crypto_transfer_ablkcipher_request_to_engine - transfer one ablkcipher_request
> + * to list into the engine queue
>    * @engine: the hardware engine
>    * @req: the request need to be listed into the engine queue
> + * TODO: Remove this function when skcipher conversion is finished
>    */
> -int crypto_transfer_hash_request(struct crypto_engine *engine,
> -				 struct ahash_request *req, bool need_pump)
> +int crypto_transfer_ablkcipher_request_to_engine(struct crypto_engine *engine,
> +						 struct ablkcipher_request *req)
>   {
> -	unsigned long flags;
> -	int ret;
> -
> -	spin_lock_irqsave(&engine->queue_lock, flags);
> -
> -	if (!engine->running) {
> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> -		return -ESHUTDOWN;
> -	}
> -
> -	ret = ahash_enqueue_request(&engine->queue, req);
> +	return crypto_transfer_request_to_engine(engine, &req->base);
> +}
> +EXPORT_SYMBOL_GPL(crypto_transfer_ablkcipher_request_to_engine);
>   
> -	if (!engine->busy && need_pump)
> -		kthread_queue_work(engine->kworker, &engine->pump_requests);
> +/**
> + * crypto_transfer_aead_request_to_engine - transfer one aead_request
> + * to list into the engine queue
> + * @engine: the hardware engine
> + * @req: the request need to be listed into the engine queue
> + */
> +int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
> +					   struct aead_request *req)
> +{
> +	return crypto_transfer_request_to_engine(engine, &req->base);
> +}
> +EXPORT_SYMBOL_GPL(crypto_transfer_aead_request_to_engine);
>   
> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> -	return ret;
> +/**
> + * crypto_transfer_akcipher_request_to_engine - transfer one akcipher_request
> + * to list into the engine queue
> + * @engine: the hardware engine
> + * @req: the request need to be listed into the engine queue
> + */
> +int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
> +					       struct akcipher_request *req)
> +{
> +	return crypto_transfer_request_to_engine(engine, &req->base);
>   }
> -EXPORT_SYMBOL_GPL(crypto_transfer_hash_request);
> +EXPORT_SYMBOL_GPL(crypto_transfer_akcipher_request_to_engine);
>   
>   /**
> - * crypto_transfer_hash_request_to_engine - transfer one request to list
> - * into the engine queue
> + * crypto_transfer_hash_request_to_engine - transfer one ahash_request
> + * to list into the engine queue
>    * @engine: the hardware engine
>    * @req: the request need to be listed into the engine queue
>    */
>   int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
>   					   struct ahash_request *req)
>   {
> -	return crypto_transfer_hash_request(engine, req, true);
> +	return crypto_transfer_request_to_engine(engine, &req->base);
>   }
>   EXPORT_SYMBOL_GPL(crypto_transfer_hash_request_to_engine);
>   
>   /**
> - * crypto_finalize_cipher_request - finalize one request if the request is done
> + * crypto_transfer_skcipher_request_to_engine - transfer one skcipher_request
> + * to list into the engine queue
> + * @engine: the hardware engine
> + * @req: the request need to be listed into the engine queue
> + */
> +int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
> +					       struct skcipher_request *req)
> +{
> +	return crypto_transfer_request_to_engine(engine, &req->base);
> +}
> +EXPORT_SYMBOL_GPL(crypto_transfer_skcipher_request_to_engine);
> +
> +/**
> + * crypto_finalize_ablkcipher_request - finalize one ablkcipher_request if
> + * the request is done
>    * @engine: the hardware engine
>    * @req: the request need to be finalized
>    * @err: error number
> + * TODO: Remove this function when skcipher conversion is finished
>    */
> -void crypto_finalize_cipher_request(struct crypto_engine *engine,
> -				    struct ablkcipher_request *req, int err)
> +void crypto_finalize_ablkcipher_request(struct crypto_engine *engine,
> +					struct ablkcipher_request *req, int err)
>   {
> -	unsigned long flags;
> -	bool finalize_cur_req = false;
> -	int ret;
> -
> -	spin_lock_irqsave(&engine->queue_lock, flags);
> -	if (engine->cur_req == &req->base)
> -		finalize_cur_req = true;
> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> -
> -	if (finalize_cur_req) {
> -		if (engine->cur_req_prepared &&
> -		    engine->unprepare_cipher_request) {
> -			ret = engine->unprepare_cipher_request(engine, req);
> -			if (ret)
> -				dev_err(engine->dev, "failed to unprepare request\n");
> -		}
> -		spin_lock_irqsave(&engine->queue_lock, flags);
> -		engine->cur_req = NULL;
> -		engine->cur_req_prepared = false;
> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> -	}
> +	return crypto_finalize_request(engine, &req->base, err);
> +}
> +EXPORT_SYMBOL_GPL(crypto_finalize_ablkcipher_request);
>   
> -	req->base.complete(&req->base, err);
> +/**
> + * crypto_finalize_aead_request - finalize one aead_request if
> + * the request is done
> + * @engine: the hardware engine
> + * @req: the request need to be finalized
> + * @err: error number
> + */
> +void crypto_finalize_aead_request(struct crypto_engine *engine,
> +				  struct aead_request *req, int err)
> +{
> +	return crypto_finalize_request(engine, &req->base, err);
> +}
> +EXPORT_SYMBOL_GPL(crypto_finalize_aead_request);
>   
> -	kthread_queue_work(engine->kworker, &engine->pump_requests);
> +/**
> + * crypto_finalize_akcipher_request - finalize one akcipher_request if
> + * the request is done
> + * @engine: the hardware engine
> + * @req: the request need to be finalized
> + * @err: error number
> + */
> +void crypto_finalize_akcipher_request(struct crypto_engine *engine,
> +				      struct akcipher_request *req, int err)
> +{
> +	return crypto_finalize_request(engine, &req->base, err);
>   }
> -EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
> +EXPORT_SYMBOL_GPL(crypto_finalize_akcipher_request);
>   
>   /**
> - * crypto_finalize_hash_request - finalize one request if the request is done
> + * crypto_finalize_hash_request - finalize one ahash_request if
> + * the request is done
>    * @engine: the hardware engine
>    * @req: the request need to be finalized
>    * @err: error number
> @@ -300,35 +337,25 @@ EXPORT_SYMBOL_GPL(crypto_finalize_cipher_request);
>   void crypto_finalize_hash_request(struct crypto_engine *engine,
>   				  struct ahash_request *req, int err)
>   {
> -	unsigned long flags;
> -	bool finalize_cur_req = false;
> -	int ret;
> -
> -	spin_lock_irqsave(&engine->queue_lock, flags);
> -	if (engine->cur_req == &req->base)
> -		finalize_cur_req = true;
> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> -
> -	if (finalize_cur_req) {
> -		if (engine->cur_req_prepared &&
> -		    engine->unprepare_hash_request) {
> -			ret = engine->unprepare_hash_request(engine, req);
> -			if (ret)
> -				dev_err(engine->dev, "failed to unprepare request\n");
> -		}
> -		spin_lock_irqsave(&engine->queue_lock, flags);
> -		engine->cur_req = NULL;
> -		engine->cur_req_prepared = false;
> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> -	}
> -
> -	req->base.complete(&req->base, err);
> -
> -	kthread_queue_work(engine->kworker, &engine->pump_requests);
> +	return crypto_finalize_request(engine, &req->base, err);
>   }
>   EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
>   
>   /**
> + * crypto_finalize_skcipher_request - finalize one skcipher_request if
> + * the request is done
> + * @engine: the hardware engine
> + * @req: the request need to be finalized
> + * @err: error number
> + */
> +void crypto_finalize_skcipher_request(struct crypto_engine *engine,
> +				      struct skcipher_request *req, int err)
> +{
> +	return crypto_finalize_request(engine, &req->base, err);
> +}
> +EXPORT_SYMBOL_GPL(crypto_finalize_skcipher_request);
> +
> +/**
>    * crypto_engine_start - start the hardware engine
>    * @engine: the hardware engine need to be started
>    *
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> index dd04c1699b51..1cbec29af3d6 100644
> --- a/include/crypto/engine.h
> +++ b/include/crypto/engine.h
> @@ -17,7 +17,10 @@
>   #include <linux/kernel.h>
>   #include <linux/kthread.h>
>   #include <crypto/algapi.h>
> +#include <crypto/aead.h>
> +#include <crypto/akcipher.h>
>   #include <crypto/hash.h>
> +#include <crypto/skcipher.h>
>   
>   #define ENGINE_NAME_LEN	30
>   /*
> @@ -37,12 +40,6 @@
>    * @unprepare_crypt_hardware: there are currently no more requests on the
>    * queue so the subsystem notifies the driver that it may relax the
>    * hardware by issuing this call
> - * @prepare_cipher_request: do some prepare if need before handle the current request
> - * @unprepare_cipher_request: undo any work done by prepare_cipher_request()
> - * @cipher_one_request: do encryption for current request
> - * @prepare_hash_request: do some prepare if need before handle the current request
> - * @unprepare_hash_request: undo any work done by prepare_hash_request()
> - * @hash_one_request: do hash for current request
>    * @kworker: kthread worker struct for request pump
>    * @pump_requests: work struct for scheduling work to the request pump
>    * @priv_data: the engine private data
> @@ -65,19 +62,6 @@ struct crypto_engine {
>   	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
>   	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
>   
> -	int (*prepare_cipher_request)(struct crypto_engine *engine,
> -				      struct ablkcipher_request *req);
> -	int (*unprepare_cipher_request)(struct crypto_engine *engine,
> -					struct ablkcipher_request *req);
> -	int (*prepare_hash_request)(struct crypto_engine *engine,
> -				    struct ahash_request *req);
> -	int (*unprepare_hash_request)(struct crypto_engine *engine,
> -				      struct ahash_request *req);
> -	int (*cipher_one_request)(struct crypto_engine *engine,
> -				  struct ablkcipher_request *req);
> -	int (*hash_one_request)(struct crypto_engine *engine,
> -				struct ahash_request *req);
> -
>   	struct kthread_worker           *kworker;
>   	struct kthread_work             pump_requests;
>   
> @@ -85,19 +69,45 @@ struct crypto_engine {
>   	struct crypto_async_request	*cur_req;
>   };
>   
> -int crypto_transfer_cipher_request(struct crypto_engine *engine,
> -				   struct ablkcipher_request *req,
> -				   bool need_pump);
> -int crypto_transfer_cipher_request_to_engine(struct crypto_engine *engine,
> -					     struct ablkcipher_request *req);
> -int crypto_transfer_hash_request(struct crypto_engine *engine,
> -				 struct ahash_request *req, bool need_pump);
> +/*
> + * struct crypto_engine_op - crypto hardware engine operations
> + * @prepare__request: do some prepare if need before handle the current request
> + * @unprepare_request: undo any work done by prepare_request()
> + * @do_one_request: do encryption for current request
> + */
> +struct crypto_engine_op {
> +	int (*prepare_request)(struct crypto_engine *engine,
> +			       void *areq);
> +	int (*unprepare_request)(struct crypto_engine *engine,
> +				 void *areq);
> +	int (*do_one_request)(struct crypto_engine *engine,
> +			      void *areq);
> +};
> +
> +struct crypto_engine_ctx {
> +	struct crypto_engine_op op;
> +};
> +
> +int crypto_transfer_ablkcipher_request_to_engine(struct crypto_engine *engine,
> +						 struct ablkcipher_request *req);
> +int crypto_transfer_aead_request_to_engine(struct crypto_engine *engine,
> +					   struct aead_request *req);
> +int crypto_transfer_akcipher_request_to_engine(struct crypto_engine *engine,
> +					       struct akcipher_request *req);
>   int crypto_transfer_hash_request_to_engine(struct crypto_engine *engine,
> -					   struct ahash_request *req);
> -void crypto_finalize_cipher_request(struct crypto_engine *engine,
> -				    struct ablkcipher_request *req, int err);
> +					       struct ahash_request *req);
> +int crypto_transfer_skcipher_request_to_engine(struct crypto_engine *engine,
> +					       struct skcipher_request *req);
> +void crypto_finalize_ablkcipher_request(struct crypto_engine *engine,
> +					struct ablkcipher_request *req, int err);
> +void crypto_finalize_aead_request(struct crypto_engine *engine,
> +				  struct aead_request *req, int err);
> +void crypto_finalize_akcipher_request(struct crypto_engine *engine,
> +				      struct akcipher_request *req, int err);
>   void crypto_finalize_hash_request(struct crypto_engine *engine,
>   				  struct ahash_request *req, int err);
> +void crypto_finalize_skcipher_request(struct crypto_engine *engine,
> +				      struct skcipher_request *req, int err);
>   int crypto_engine_start(struct crypto_engine *engine);
>   int crypto_engine_stop(struct crypto_engine *engine);
>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
