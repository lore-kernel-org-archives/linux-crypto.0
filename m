From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Sun, 6 Sep 2015 16:33:26 +0200
Message-ID: <CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
	<35165141.6IIWPIRvUD@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35893 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbIFOd2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 6 Sep 2015 10:33:28 -0400
Received: by wicgb1 with SMTP id gb1so20863450wic.1
        for <linux-crypto@vger.kernel.org>; Sun, 06 Sep 2015 07:33:26 -0700 (PDT)
In-Reply-To: <35165141.6IIWPIRvUD@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 6 September 2015 at 10:34, Stephan Mueller <smueller@chronox.de> wrote:
> Am Sonntag, 6. September 2015, 01:00:29 schrieb Andrew Zaborowski:
> Albeit I have nothing to say against the code, but shouldn't we first get the
> split of the setkey function implemented? The conversion work will increase
> more and more we merge code that uses that API that was decided to be
> revamped.

Probably yes, I also read about the decision to use iov buffers, this
will have a bigger effect on code.  I posted the patch nevertheless to
judge if this functionality is wanted, whether it should be a separate
template like I propose (because that's admittedly more code than I
expected for something that simple) and to get a reality check on how
the template is created/instantiated/registered/...

>
> Tadeusz, what do you think?
>> +{
>> +     struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>> +     struct akcipher_request *req;
>> +     int err;
>> +
>> +     err = crypto_akcipher_setkey(ctx->child, key, keylen);
>> +
>> +     if (!err) {
>> +             /* Find out new modulus size from rsa implementation */
>> +             req = akcipher_request_alloc(ctx->child, GFP_KERNEL);
>> +             if (IS_ERR(req))
>> +                     return PTR_ERR(req);
>> +
>> +             akcipher_request_set_crypt(req, NULL, NULL, 0, 0);
>> +             if (crypto_akcipher_encrypt(req) != -EOVERFLOW)
>> +                     err = -EINVAL;
>
> I had a chat with Tadesusz already on this code which I need for the
> algif_akcipher code too (and there I need this check more often as user space
> may simply change the key under my feet). I feel that it is a waste of CPU
> cycles to set up a fake encryption request just to get the data length which
> is based on the used key.
>
> The value we obtain here is simply a check of the key length. Thus, I would
> think that we should have a separate akcipher API call for this instead of
> requiring the caller to allocate a fake request context.

I agree this isn't the ideal way to query the modulus size.  It may be
acceptable as a temporary thing though, where the long term solution
would be to better integrate with the keys subsystem as argued by
Marcel Holtmann in another thread.

>
> Tadeusz, are you working on that code or shall I have a look?
>> +
>> +             ctx->key_size = req->dst_len;
>> +             akcipher_request_free(req);
>> +     }
>> +
>> +     return err;
>> +}
>> +
>> +static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int
>> err) +{
>> +     struct akcipher_request *child_req = akcipher_request_ctx(req);
>> +
>> +     kfree(child_req->src);
>
> kzfree?
>
>> +     req->dst_len = child_req->dst_len;
>> +     return err;
>> +}
>> +
>> +static void pkcs1pad_encrypt_sign_complete_cb(
>> +             struct crypto_async_request *child_async_req, int err)
>> +{
>> +     struct akcipher_request *req = child_async_req->data;
>> +     struct crypto_async_request async_req;
>> +
>> +     if (err == -EINPROGRESS)
>> +             return;
>> +
>> +     async_req.data = req->base.data;
>> +     async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
>> +     async_req.flags = child_async_req->flags;
>> +     req->base.complete(&async_req,
>> +                     pkcs1pad_encrypt_sign_complete(req, err));
>> +}
>> +
>> +static int pkcs1pad_encrypt(struct akcipher_request *req)
>> +{
>> +     struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>> +     struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
>> +     struct akcipher_request *child_req = akcipher_request_ctx(req);
>> +     int err, i, ps_len;
>
> i and ps_len should be unsigned int
>
>> +     uint8_t *src;
>> +
>> +     if (!ctx->key_size)
>> +             return -EINVAL;
>> +
>> +     if (req->src_len > ctx->key_size - 11)
>> +             return -EOVERFLOW;
>> +
>> +     src = kmalloc(ctx->key_size,
>> +                     (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>> +                     GFP_KERNEL : GFP_ATOMIC);
>> +     if (!src)
>> +             return -ENOMEM;
>> +
>> +     /* Reuse output buffer, add padding in the input */
>> +     child_req->src = src;
>> +     child_req->src_len = ctx->key_size;
>> +     child_req->dst = req->dst;
>> +     child_req->dst_len = req->dst_len;
>> +
>> +     ps_len = ctx->key_size - req->src_len - 3;
>> +     src[0] = 0x00;
>> +     src[1] = 0x02;
>> +     for (i = 0; i < ps_len; i++)
>> +             src[2 + i] = 1 + prandom_u32_max(255);
>
> To save some CPU cycles, why not run from i = 2 to ctx->key_size - req-
>>src_len - 1? This should eliminate the addition.
>
>> +     src[ps_len + 2] = 0x00;
>> +     memcpy(src + ps_len + 3, req->src, req->src_len);
>> +
>> +     akcipher_request_set_tfm(child_req, ctx->child);
>> +     akcipher_request_set_callback(child_req, req->base.flags,
>> +                     pkcs1pad_encrypt_sign_complete_cb, req);
>> +
>> +     err = crypto_akcipher_encrypt(child_req);
>> +     if (err != -EINPROGRESS && err != -EBUSY)
>> +             return pkcs1pad_encrypt_sign_complete(req, err);
>> +
>> +     return err;
>> +}
>> +
>> +static int pkcs1pad_decrypt_complete(struct akcipher_request *req, int err)
>> +{
>> +     struct akcipher_request *child_req = akcipher_request_ctx(req);
>> +     int pos;
>
> unsigned int, just to be save?
>
> Note, this code is intended to be exposed to user space.
>
>> +     uint8_t *dst = child_req->dst;
>> +
>> +     BUG_ON(err == -EOVERFLOW);
>
> Why is the BUG needed here? Again, I am worrying about user space.

it's not really "needed" but we should never receive an EOVERFLOW
because we are locally allocating the reg->dst buffer ot be exactly
the size of the rsa modulus so if this is too small we have a bug
somewhere.

>> +
>> +     if (err)
>> +             goto done;
>> +
>> +     if (dst[0] != 0x00) {
>> +             err = -EINVAL;
>> +             goto done;
>> +     }
>> +     if (dst[1] != 0x02) {
>> +             err = -EINVAL;
>> +             goto done;
>> +     }
>> +     for (pos = 2; pos < child_req->dst_len; pos++)
>> +             if (dst[pos] == 0x00)
>> +                     break;
>
> What happens if the padding has a 0x00 in its pseudo random data?

The pseudo random bytes must all be non-zero for the padding to be
unambiguous (RFC3447 iirc).  If there's a 0x00 in the first 8 bytes
that's invalid input, if it's after the 8th random byte it represents
a different plaintext.

Thanks for your review, I'll change the code according to your other comments.

Cheers
