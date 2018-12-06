Return-Path: <SRS0=k6po=OP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:56028 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbeLFH2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Dec 2018 02:28:02 -0500
Received: by mail-it1-f196.google.com with SMTP id o19so25730342itg.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 Dec 2018 23:28:01 -0800 (PST)
MIME-Version: 1.0
References: <20181206045413.32531-1-ebiggers@kernel.org>
In-Reply-To: <20181206045413.32531-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 6 Dec 2018 08:27:49 +0100
Message-ID: <CAKv+Gu9cZFG1=Wq0nwXL7LH-w65tGp9mBJb-7_NCgusEiwtSkw@mail.gmail.com>
Subject: Re: [PATCH] dm verity: log the hash algorithm implementation
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
> Log the hash algorithm's driver name when a dm-verity target is created.
> This will help people determine whether the expected implementation is
> being used.  It can make an enormous difference; e.g., SHA-256 on ARM
> can be 8x faster with the crypto extensions than without.  It can also
> be useful to know if an implementation using an external crypto
> accelerator is being used instead of a software implementation.
>
> Example message:
>
> [   35.281945] device-mapper: verity: sha256 using implementation "sha256-ce"
>
> We've already found the similar message in fs/crypto/keyinfo.c to be
> very useful.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/md/dm-verity-target.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index fc65f0dedf7f..f4c31ffaa88e 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1040,6 +1040,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>                 v->tfm = NULL;
>                 goto bad;
>         }
> +
> +       /*
> +        * dm-verity performance can vary greatly depending on which hash
> +        * algorithm implementation is used.  Help people debug performance
> +        * problems by logging the ->cra_driver_name.
> +        */
> +       DMINFO("%s using implementation \"%s\"", v->alg_name,
> +              crypto_hash_alg_common(v->tfm)->base.cra_driver_name);
> +
>         v->digest_size = crypto_ahash_digestsize(v->tfm);
>         if ((1 << v->hash_dev_block_bits) < v->digest_size * 2) {
>                 ti->error = "Digest size too big";
> --
> 2.19.2
>
