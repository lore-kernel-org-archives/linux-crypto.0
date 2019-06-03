Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88887C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D5526E66
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H13F6VBk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfFCGvw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:51:52 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52427 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfFCGvw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:51:52 -0400
Received: by mail-it1-f194.google.com with SMTP id l21so3660166ita.2
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=034ZzLV//9XYknEybHLyLMV5RJWMUoKCggci3oNzxbg=;
        b=H13F6VBkVsDk+F6M20ElIRUzKsV4nIe9wRqOaNugArG1kbh4O7mrQZeX4l+/rJ91bJ
         64Vh89yY49Auts6caRzKuToS35lWqzsYTnvRcD9YNjhrFzL5hWdYUZpDeu6Sko2meJS9
         UvR6POVRXGIw3iC/uX+Wt3koVuS1SWWJXeaUku8epdVoX+ErcWq5HR+dwNRRBO1W16Ly
         bzSq4nkNY8ThzafI9tT/gvgP2OqAJ2joIbcjFjMPddA8vuGDC62/TnYuchEGnI3R0GUG
         7nqF21Tw/9ypj20kaCPmSOTFhA8JoISnd2P9hToGxYULVQ64QcWkkLT7gD4IuGYo3qyr
         WbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=034ZzLV//9XYknEybHLyLMV5RJWMUoKCggci3oNzxbg=;
        b=G/jq43DxISA2Dkgmx7AZVvx+KsPLZ0/8K70i4IviYGZv4kOo1TJrPAyfZeo7i7VVV1
         wl47DAPXnd6GBYrBnR2YbFTrRkG6pibaWJmRUDDw7ouJyadOLQmdyhcMyLjAcKGqGl9s
         xEoSNo4YysoLamv89JTeZgab5+soZ0bWxQKF5G5v36EuDMVj6tpbTB3Xke7edlC5KiDj
         COAchiRbsL69d6godd6qpKKJmMospf8jj4Fhp0CQMYuYhLHfdQJCrmZjz0A0MoOWh5IB
         4LbQE8zcfO7oNyXhkPjORy+EH7AOnK2LwlO+snOchuet4lssZ458abyM4rsdpNWXEzZV
         Q/tQ==
X-Gm-Message-State: APjAAAWGkfi7LqVSwFShNxhgpvyr23GrNQWk+6PmB5ZkA/3xzJoS58bz
        Oq9T4kDM7fL0W26MFqMKmwkQ3IIiPR8jSJj1yGYAcg==
X-Google-Smtp-Source: APXvYqzxAsTWKu3b5PPNsxl6KQDxPepHOBWlBfISIVCB2ZNrf7kLqzKAHH1F7y6nmIWYQ8Y/vcIZx6JZRsElsPx31l0=
X-Received: by 2002:a02:b01c:: with SMTP id p28mr16246174jah.130.1559544711578;
 Sun, 02 Jun 2019 23:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054408.5903-1-ebiggers@kernel.org>
In-Reply-To: <20190603054408.5903-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:51:38 +0200
Message-ID: <CAKv+Gu-6B4bgwPXsbueZ-mu8LjKnm1EyLn5b9-ncMCxSLdA=ug@mail.gmail.com>
Subject: Re: [PATCH] crypto: doc - improve the skcipher API example code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:44, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Rewrite the skcipher API example, changing it to encrypt a buffer with
> AES-256-XTS.  This addresses various problems with the previous example:
>
> - It requests a specific driver "cbc-aes-aesni", which is unusual.
>   Normally users ask for "cbc(aes)", not a specific driver.
>
> - It encrypts only a single AES block.  For the reader, that doesn't
>   clearly distinguish the "skcipher" API from the "cipher" API.
>
> - Showing how to encrypt something with bare CBC is arguably a poor
>   choice of example, as it doesn't follow modern crypto trends.  Now,
>   usually authenticated encryption is recommended, in which case the
>   user would use the AEAD API, not skcipher.  Disk encryption is still a
>   legitimate use for skcipher, but for that usually XTS is recommended.
>
> - Many other bugs and poor coding practices, such as not setting
>   CRYPTO_TFM_REQ_MAY_SLEEP, unnecessarily allocating a heap buffer for
>   the IV, unnecessary NULL checks, using a pointless wrapper struct, and
>   forgetting to set an error code in one case.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  Documentation/crypto/api-samples.rst | 176 ++++++++++++---------------
>  1 file changed, 77 insertions(+), 99 deletions(-)
>
> diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
> index f14afaaf2f324..e923f17bc2bd5 100644
> --- a/Documentation/crypto/api-samples.rst
> +++ b/Documentation/crypto/api-samples.rst
> @@ -4,111 +4,89 @@ Code Examples
>  Code Example For Symmetric Key Cipher Operation
>  -----------------------------------------------
>
> -::
> -
> -
> -    /* tie all data structures together */
> -    struct skcipher_def {
> -        struct scatterlist sg;
> -        struct crypto_skcipher *tfm;
> -        struct skcipher_request *req;
> -        struct crypto_wait wait;
> -    };
> -
> -    /* Perform cipher operation */
> -    static unsigned int test_skcipher_encdec(struct skcipher_def *sk,
> -                         int enc)
> -    {
> -        int rc;
> -
> -        if (enc)
> -            rc = crypto_wait_req(crypto_skcipher_encrypt(sk->req), &sk->wait);
> -        else
> -            rc = crypto_wait_req(crypto_skcipher_decrypt(sk->req), &sk->wait);
> -
> -       if (rc)
> -               pr_info("skcipher encrypt returned with result %d\n", rc);
> +This code encrypts some data with AES-256-XTS.  For sake of example,
> +all inputs are random bytes, the encryption is done in-place, and it's
> +assumed the code is running in a context where it can sleep.
>
> -        return rc;
> -    }
> +::
>
> -    /* Initialize and trigger cipher operation */
>      static int test_skcipher(void)
>      {
> -        struct skcipher_def sk;
> -        struct crypto_skcipher *skcipher = NULL;
> -        struct skcipher_request *req = NULL;
> -        char *scratchpad = NULL;
> -        char *ivdata = NULL;
> -        unsigned char key[32];
> -        int ret = -EFAULT;
> -
> -        skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
> -        if (IS_ERR(skcipher)) {
> -            pr_info("could not allocate skcipher handle\n");
> -            return PTR_ERR(skcipher);
> -        }
> -
> -        req = skcipher_request_alloc(skcipher, GFP_KERNEL);
> -        if (!req) {
> -            pr_info("could not allocate skcipher request\n");
> -            ret = -ENOMEM;
> -            goto out;
> -        }
> -
> -        skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -                          crypto_req_done,
> -                          &sk.wait);
> -
> -        /* AES 256 with random key */
> -        get_random_bytes(&key, 32);
> -        if (crypto_skcipher_setkey(skcipher, key, 32)) {
> -            pr_info("key could not be set\n");
> -            ret = -EAGAIN;
> -            goto out;
> -        }
> -
> -        /* IV will be random */
> -        ivdata = kmalloc(16, GFP_KERNEL);
> -        if (!ivdata) {
> -            pr_info("could not allocate ivdata\n");
> -            goto out;
> -        }
> -        get_random_bytes(ivdata, 16);
> -
> -        /* Input data will be random */
> -        scratchpad = kmalloc(16, GFP_KERNEL);
> -        if (!scratchpad) {
> -            pr_info("could not allocate scratchpad\n");
> -            goto out;
> -        }
> -        get_random_bytes(scratchpad, 16);
> -
> -        sk.tfm = skcipher;
> -        sk.req = req;
> -
> -        /* We encrypt one block */
> -        sg_init_one(&sk.sg, scratchpad, 16);
> -        skcipher_request_set_crypt(req, &sk.sg, &sk.sg, 16, ivdata);
> -        crypto_init_wait(&sk.wait);
> -
> -        /* encrypt data */
> -        ret = test_skcipher_encdec(&sk, 1);
> -        if (ret)
> -            goto out;
> -
> -        pr_info("Encryption triggered successfully\n");
> -
> +            struct crypto_skcipher *tfm = NULL;
> +            struct skcipher_request *req = NULL;
> +            u8 *data = NULL;
> +            const size_t datasize = 512; /* data size in bytes */
> +            struct scatterlist sg;
> +            DECLARE_CRYPTO_WAIT(wait);
> +            u8 iv[16];  /* AES-256-XTS takes a 16-byte IV */
> +            u8 key[64]; /* AES-256-XTS takes a 64-byte key */
> +            int err;
> +
> +            /*
> +             * Allocate a tfm (a transformation object) and set the key.
> +             *
> +             * In real-world use, a tfm and key are typically used for many
> +             * encryption/decryption operations.  But in this example, we'll just do a
> +             * single encryption operation with it (which is not very efficient).
> +             */
> +
> +            tfm = crypto_alloc_skcipher("xts(aes)", 0, 0);
> +            if (IS_ERR(tfm)) {
> +                    pr_err("Error allocating xts(aes) handle: %ld\n", PTR_ERR(tfm));
> +                    return PTR_ERR(tfm);
> +            }
> +
> +            get_random_bytes(key, sizeof(key));
> +            err = crypto_skcipher_setkey(tfm, key, sizeof(key));
> +            if (err) {
> +                    pr_err("Error setting key: %d\n", err);
> +                    goto out;
> +            }
> +
> +            /* Allocate a request object */
> +            req = skcipher_request_alloc(tfm, GFP_KERNEL);
> +            if (!req) {
> +                    err = -ENOMEM;
> +                    goto out;
> +            }
> +
> +            /* Prepare the input data */
> +            data = kmalloc(datasize, GFP_KERNEL);
> +            if (!data) {
> +                    err = -ENOMEM;
> +                    goto out;
> +            }
> +            get_random_bytes(data, datasize);
> +
> +            /* Initialize the IV */
> +            get_random_bytes(iv, sizeof(iv));
> +
> +            /*
> +             * Encrypt the data in-place.
> +             *
> +             * For simplicity, in this example we wait for the request to complete
> +             * before proceeding, even if the underlying implementation is asynchronous.
> +             *
> +             * To decrypt instead of encrypt, just change crypto_skcipher_encrypt() to
> +             * crypto_skcipher_decrypt().
> +             */
> +            sg_init_one(&sg, data, datasize);
> +            skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> +                                               CRYPTO_TFM_REQ_MAY_SLEEP,
> +                                          crypto_req_done, &wait);
> +            skcipher_request_set_crypt(req, &sg, &sg, datasize, iv);
> +            err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> +            if (err) {
> +                    pr_err("Error encrypting data: %d\n", err);
> +                    goto out;
> +            }
> +
> +            pr_debug("Encryption was successful\n");
>      out:
> -        if (skcipher)
> -            crypto_free_skcipher(skcipher);
> -        if (req)
> +            crypto_free_skcipher(tfm);
>              skcipher_request_free(req);
> -        if (ivdata)
> -            kfree(ivdata);
> -        if (scratchpad)
> -            kfree(scratchpad);
> -        return ret;
> +            kfree(data);
> +            return err;
>      }
>
>
> --
> 2.21.0
>
