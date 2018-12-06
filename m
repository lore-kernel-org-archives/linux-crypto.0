Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:56055 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbeLFH2N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 02:28:13 -0500
Received: by mail-it1-f193.google.com with SMTP id o19so25730989itg.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2018 23:28:12 -0800 (PST)
MIME-Version: 1.0
References: <20181206045300.32387-1-ebiggers@kernel.org>
In-Reply-To: <20181206045300.32387-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 6 Dec 2018 08:28:01 +0100
Message-ID: <CAKv+Gu_ZMUXaj45wQT_+m7VHNLhpdAaDnxEVduHJjGcCB05zMA@mail.gmail.com>
Subject: Re: [PATCH] dm crypt: log the encryption algorithm implementation
To: Eric Biggers <ebiggers@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 6 Dec 2018 at 05:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Log the encryption algorithm's driver name when a dm-crypt target is
> created.  This will help people determine whether the expected
> implementation is being used.  In some cases we've seen people do
> benchmarks and reject using encryption for performance reasons, when in
> fact they used a much slower implementation than was possible on the
> hardware.  It can make an enormous difference; e.g., AES-XTS on ARM can
> be over 10x faster with the crypto extensions than without.  It can also
> be useful to know if an implementation using an external crypto
> accelerator is being used instead of a software implementation.
>
> Example message:
>
> [   29.307629] device-mapper: crypt: xts(aes) using implementation "xts-aes-ce"
>
> We've already found the similar message in fs/crypto/keyinfo.c to be
> very useful.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/md/dm-crypt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index b8eec515a003..7646135487be 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1885,6 +1885,13 @@ static int crypt_alloc_tfms_skcipher(struct crypt_config *cc, char *ciphermode)
>                 }
>         }
>
> +       /*
> +        * dm-crypt performance can vary greatly depending on which crypto
> +        * algorithm implementation is used.  Help people debug performance
> +        * problems by logging the ->cra_driver_name.
> +        */
> +       DMINFO("%s using implementation \"%s\"", ciphermode,
> +              crypto_skcipher_alg(any_tfm(cc))->base.cra_driver_name);
>         return 0;
>  }
>
> @@ -1903,6 +1910,8 @@ static int crypt_alloc_tfms_aead(struct crypt_config *cc, char *ciphermode)
>                 return err;
>         }
>
> +       DMINFO("%s using implementation \"%s\"", ciphermode,
> +              crypto_aead_alg(any_tfm_aead(cc))->base.cra_driver_name);
>         return 0;
>  }
>
> --
> 2.19.2
>
