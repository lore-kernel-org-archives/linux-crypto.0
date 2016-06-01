From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [PATCH v2 1/2] crypto: engine: permit to enqueue ashash_request
Date: Wed, 1 Jun 2016 10:27:16 +0800
Message-ID: <CAMz4kuLsZs4gSZoOFfC7vkrjPkmWRJThW-1fzky5ZLAEzF4nDw@mail.gmail.com>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
	<1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464615122-16685-2-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 30 May 2016 at 21:32, LABBE Corentin <clabbe.montjoie@gmail.com> wrote:
> The current crypto engine allow only ablkcipher_request to be enqueued.
> Thus denying any use of it for hardware that also handle hash algo.
>
> This patch convert all ablkcipher_request references to the
> more general crypto_async_request.
>
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  crypto/crypto_engine.c  | 17 +++++++----------
>  include/crypto/algapi.h | 14 +++++++-------
>  2 files changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index a55c82d..b658cb8 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -19,7 +19,7 @@
>  #define CRYPTO_ENGINE_MAX_QLEN 10
>
>  void crypto_finalize_request(struct crypto_engine *engine,
> -                            struct ablkcipher_request *req, int err);
> +                            struct crypto_async_request *req, int err);
>
>  /**
>   * crypto_pump_requests - dequeue one request from engine queue to process
> @@ -34,7 +34,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>                                  bool in_kthread)
>  {
>         struct crypto_async_request *async_req, *backlog;
> -       struct ablkcipher_request *req;
>         unsigned long flags;
>         bool was_busy = false;
>         int ret;
> @@ -82,9 +81,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>         if (!async_req)
>                 goto out;
>
> -       req = ablkcipher_request_cast(async_req);
> -
> -       engine->cur_req = req;
> +       engine->cur_req = async_req;
>         if (backlog)
>                 backlog->complete(backlog, -EINPROGRESS);
>
> @@ -142,7 +139,7 @@ static void crypto_pump_work(struct kthread_work *work)
>   * @req: the request need to be listed into the engine queue
>   */
>  int crypto_transfer_request(struct crypto_engine *engine,
> -                           struct ablkcipher_request *req, bool need_pump)
> +                           struct crypto_async_request *req, bool need_pump)
>  {
>         unsigned long flags;
>         int ret;
> @@ -154,7 +151,7 @@ int crypto_transfer_request(struct crypto_engine *engine,
>                 return -ESHUTDOWN;
>         }
>
> -       ret = ablkcipher_enqueue_request(&engine->queue, req);
> +       ret = crypto_enqueue_request(&engine->queue, req);
>
>         if (!engine->busy && need_pump)
>                 queue_kthread_work(&engine->kworker, &engine->pump_requests);
> @@ -171,7 +168,7 @@ EXPORT_SYMBOL_GPL(crypto_transfer_request);
>   * @req: the request need to be listed into the engine queue
>   */
>  int crypto_transfer_request_to_engine(struct crypto_engine *engine,
> -                                     struct ablkcipher_request *req)
> +                                     struct crypto_async_request *req)
>  {
>         return crypto_transfer_request(engine, req, true);
>  }
> @@ -184,7 +181,7 @@ EXPORT_SYMBOL_GPL(crypto_transfer_request_to_engine);
>   * @err: error number
>   */
>  void crypto_finalize_request(struct crypto_engine *engine,
> -                            struct ablkcipher_request *req, int err)
> +                            struct crypto_async_request *req, int err)
>  {
>         unsigned long flags;
>         bool finalize_cur_req = false;
> @@ -208,7 +205,7 @@ void crypto_finalize_request(struct crypto_engine *engine,
>                 spin_unlock_irqrestore(&engine->queue_lock, flags);
>         }
>
> -       req->base.complete(&req->base, err);
> +       req->complete(req, err);
>
>         queue_kthread_work(&engine->kworker, &engine->pump_requests);
>  }
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index eeafd21..d720a2a 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -173,26 +173,26 @@ struct crypto_engine {
>         int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
>
>         int (*prepare_request)(struct crypto_engine *engine,
> -                              struct ablkcipher_request *req);
> +                              struct crypto_async_request *req);
>         int (*unprepare_request)(struct crypto_engine *engine,
> -                                struct ablkcipher_request *req);
> +                                struct crypto_async_request *req);
>         int (*crypt_one_request)(struct crypto_engine *engine,
> -                                struct ablkcipher_request *req);
> +                                struct crypto_async_request *req);
>
>         struct kthread_worker           kworker;
>         struct task_struct              *kworker_task;
>         struct kthread_work             pump_requests;
>
>         void                            *priv_data;
> -       struct ablkcipher_request       *cur_req;
> +       struct crypto_async_request     *cur_req;
>  };
>
>  int crypto_transfer_request(struct crypto_engine *engine,
> -                           struct ablkcipher_request *req, bool need_pump);
> +                           struct crypto_async_request *req, bool need_pump);
>  int crypto_transfer_request_to_engine(struct crypto_engine *engine,
> -                                     struct ablkcipher_request *req);
> +                                     struct crypto_async_request *req);
>  void crypto_finalize_request(struct crypto_engine *engine,
> -                            struct ablkcipher_request *req, int err);
> +                            struct crypto_async_request *req, int err);
>  int crypto_engine_start(struct crypto_engine *engine);
>  int crypto_engine_stop(struct crypto_engine *engine);
>  struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
> --
> 2.7.3
>

Reviewed-by: Baolin Wang <baolin.wang@linaro.org>


-- 
Baolin.wang
Best Regards
