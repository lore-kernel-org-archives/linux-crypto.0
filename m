From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] tls: Add support for encryption using async offload accelerator
Date: Wed, 31 Jan 2018 08:10:16 +0200
Message-ID: <CAOtvUMfXFhZXoYcc5QQTJudK5PvzTCSiXVMWV8D=A+Mq8QNgPw@mail.gmail.com>
References: <20180131103654.9759-1-vakul.garg@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        ilyal@mellanox.com, aviadye@mellanox.com, davejwatson@fb.com,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
To: Vakul Garg <vakul.garg@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35590 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeAaGKR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 01:10:17 -0500
Received: by mail-vk0-f66.google.com with SMTP id n132so8345155vke.2
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jan 2018 22:10:17 -0800 (PST)
In-Reply-To: <20180131103654.9759-1-vakul.garg@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Vakul,

On Wed, Jan 31, 2018 at 12:36 PM, Vakul Garg <vakul.garg@nxp.com> wrote:
> Async crypto accelerators (e.g. drivers/crypto/caam) support offloading
> GCM operation. If they are enabled, crypto_aead_encrypt() return error
> code -EINPROGRESS. In this case tls_do_encryption() needs to wait on a
> completion till the time the response for crypto offload request is
> received.
>

Thank you for this patch. I think it is actually a bug fix and should
probably go into stable
since I believe current code is broken on machines where any async GCM
transformation
is registered with a high enough priority as it will try to call a
NULL callback.

But, please use the new crypto_wait_req() and friends to implement the waiting.
Take a look at the code example in
Documentation/crypto/api-samples.rst to see how.

Also, maybe add an explanation why  CRYPTO_TFM_REQ_MAY_BACKLOG
flag should not be used here, if this was on purpose?

I mean I'm not sure using backlog here is a good idea but probably
should explain why
not.

Thanks!
Gilad


> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> ---
>  net/tls/tls_sw.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 73d19210dd49..390e6dc7b135 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -39,6 +39,11 @@
>
>  #include <net/tls.h>
>
> +struct crypto_completion {
> +       struct completion comp;
> +       int result;
> +};
> +
>  static void trim_sg(struct sock *sk, struct scatterlist *sg,
>                     int *sg_num_elem, unsigned int *sg_size, int target_size)
>  {
> @@ -194,6 +199,14 @@ static void tls_free_both_sg(struct sock *sk)
>                 &ctx->sg_plaintext_size);
>  }
>
> +static void crypto_complete(struct crypto_async_request *req, int err)
> +{
> +       struct crypto_completion *x = req->data;
> +
> +       x->result = err;
> +       complete(&x->comp);
> +}
> +
>  static int tls_do_encryption(struct tls_context *tls_ctx,
>                              struct tls_sw_context *ctx, size_t data_len,
>                              gfp_t flags)
> @@ -202,6 +215,7 @@ static int tls_do_encryption(struct tls_context *tls_ctx,
>                 crypto_aead_reqsize(ctx->aead_send);
>         struct aead_request *aead_req;
>         int rc;
> +       struct crypto_completion crypto_done;
>
>         aead_req = kzalloc(req_size, flags);
>         if (!aead_req)
> @@ -214,7 +228,15 @@ static int tls_do_encryption(struct tls_context *tls_ctx,
>         aead_request_set_ad(aead_req, TLS_AAD_SPACE_SIZE);
>         aead_request_set_crypt(aead_req, ctx->sg_aead_in, ctx->sg_aead_out,
>                                data_len, tls_ctx->iv);
> +       aead_request_set_callback(aead_req, 0, crypto_complete, &crypto_done);
> +
> +       init_completion(&crypto_done.comp);
> +
>         rc = crypto_aead_encrypt(aead_req);
> +       if (rc == -EINPROGRESS) {
> +               wait_for_completion(&crypto_done.comp);
> +               rc = crypto_done.result;
> +       }
>
>         ctx->sg_encrypted_data[0].offset -= tls_ctx->prepend_size;
>         ctx->sg_encrypted_data[0].length += tls_ctx->prepend_size;
> --
> 2.13.6
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
