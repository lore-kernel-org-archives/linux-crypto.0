Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19418C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF45C233F7
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 11:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbhAMLyW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:54:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbhAMLyV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 06:54:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6504C233ED;
        Wed, 13 Jan 2021 11:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610538820;
        bh=k/Q9fyU/p08Du+XK3Dob2ymM0e6uhINM1gkBv7GmQMI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=q0NSrMoHTaimB1TRTbi03ro7eD95Zz46m2QutA859JMviLX8aGD633yo1eyN2FP6H
         VFx6LkX4lgqo0ttWZZ6ODCfF6e4UW5KjNfP2TxOVM3p/4+zmSvhzmJQyj1RCorPFua
         TW/gGLZryipqRny/GDfZDFt+07l5SHOeanQ4HlYpN6Wf8FHaBSPbALfbP5z3bKN86N
         PnlNrqrKiWU6Hpr6ja4i7jCBHdqjVqDHtEZlZc4uoeMrlBO+pm50/SQkwyZ3ykqqRK
         z2cqwtDN57zP/p4yuaajuzhof/QaHuC6PFWlsl9tuXyXAmHkYy9JOS7qXaW3XwLZg2
         L3aLi/FIubbJg==
Received: by mail-oi1-f178.google.com with SMTP id d203so1812139oia.0;
        Wed, 13 Jan 2021 03:53:40 -0800 (PST)
X-Gm-Message-State: AOAM531slifLVSswKSzhgJBeLUhlfueb4Bc5i3L//pPs4T/owBPWT89e
        JF9f9dvcZRVBwQPo1LGBTvluKsevO99+LwN80mk=
X-Google-Smtp-Source: ABdhPJytRAdbmlAMBN+T5b6CKTYgIMpssjn2b4bI7j9eci/LQ3YUjhyG4mOiSClMPoJc9vePJ42a1aXIUNj0m2Msh2c=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr927716oig.33.1610538819630;
 Wed, 13 Jan 2021 03:53:39 -0800 (PST)
MIME-Version: 1.0
References: <20210112192938.70666-1-ebiggers@kernel.org>
In-Reply-To: <20210112192938.70666-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 13 Jan 2021 12:53:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF1Gpq-3gX=yqgw-mtEd8OzTD6aPvF+MWmD1FuTrQzW9Q@mail.gmail.com>
Message-ID: <CAMj1kXF1Gpq-3gX=yqgw-mtEd8OzTD6aPvF+MWmD1FuTrQzW9Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] random: remove dead code left over from blocking pool
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 12 Jan 2021 at 20:30, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Remove some dead code that was left over following commit 90ea1c6436d2
> ("random: remove the blocking pool").
>
> Cc: linux-crypto@vger.kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Reviewed-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>
> Andrew, please consider taking this patch since the maintainer has been
> ignoring it for 4 months
> (https://lkml.kernel.org/lkml/20200916043652.96640-1-ebiggers@kernel.org/T/#u).
>
>
>  drivers/char/random.c         | 17 ++-----
>  include/trace/events/random.h | 83 -----------------------------------
>  2 files changed, 3 insertions(+), 97 deletions(-)
>
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index a894c0559a8cf..bbc5098b1a81f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -500,7 +500,6 @@ struct entropy_store {
>         unsigned short add_ptr;
>         unsigned short input_rotate;
>         int entropy_count;
> -       unsigned int initialized:1;
>         unsigned int last_data_init:1;
>         __u8 last_data[EXTRACT_SIZE];
>  };
> @@ -660,7 +659,7 @@ static void process_random_ready_list(void)
>   */
>  static void credit_entropy_bits(struct entropy_store *r, int nbits)
>  {
> -       int entropy_count, orig, has_initialized = 0;
> +       int entropy_count, orig;
>         const int pool_size = r->poolinfo->poolfracbits;
>         int nfrac = nbits << ENTROPY_SHIFT;
>
> @@ -717,23 +716,14 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
>         if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
>                 goto retry;
>
> -       if (has_initialized) {
> -               r->initialized = 1;
> -               kill_fasync(&fasync, SIGIO, POLL_IN);
> -       }
> -
>         trace_credit_entropy_bits(r->name, nbits,
>                                   entropy_count >> ENTROPY_SHIFT, _RET_IP_);
>
>         if (r == &input_pool) {
>                 int entropy_bits = entropy_count >> ENTROPY_SHIFT;
>
> -               if (crng_init < 2) {
> -                       if (entropy_bits < 128)
> -                               return;
> +               if (crng_init < 2 && entropy_bits >= 128)
>                         crng_reseed(&primary_crng, r);
> -                       entropy_bits = ENTROPY_BITS(r);
> -               }
>         }
>  }
>
> @@ -1385,8 +1375,7 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
>  }
>
>  /*
> - * This function does the actual extraction for extract_entropy and
> - * extract_entropy_user.
> + * This function does the actual extraction for extract_entropy.
>   *
>   * Note: we assume that .poolwords is a multiple of 16 words.
>   */
> diff --git a/include/trace/events/random.h b/include/trace/events/random.h
> index 9570a10cb949b..3d7b432ca5f31 100644
> --- a/include/trace/events/random.h
> +++ b/include/trace/events/random.h
> @@ -85,28 +85,6 @@ TRACE_EVENT(credit_entropy_bits,
>                   __entry->entropy_count, (void *)__entry->IP)
>  );
>
> -TRACE_EVENT(push_to_pool,
> -       TP_PROTO(const char *pool_name, int pool_bits, int input_bits),
> -
> -       TP_ARGS(pool_name, pool_bits, input_bits),
> -
> -       TP_STRUCT__entry(
> -               __field( const char *,  pool_name               )
> -               __field(          int,  pool_bits               )
> -               __field(          int,  input_bits              )
> -       ),
> -
> -       TP_fast_assign(
> -               __entry->pool_name      = pool_name;
> -               __entry->pool_bits      = pool_bits;
> -               __entry->input_bits     = input_bits;
> -       ),
> -
> -       TP_printk("%s: pool_bits %d input_pool_bits %d",
> -                 __entry->pool_name, __entry->pool_bits,
> -                 __entry->input_bits)
> -);
> -
>  TRACE_EVENT(debit_entropy,
>         TP_PROTO(const char *pool_name, int debit_bits),
>
> @@ -161,35 +139,6 @@ TRACE_EVENT(add_disk_randomness,
>                   MINOR(__entry->dev), __entry->input_bits)
>  );
>
> -TRACE_EVENT(xfer_secondary_pool,
> -       TP_PROTO(const char *pool_name, int xfer_bits, int request_bits,
> -                int pool_entropy, int input_entropy),
> -
> -       TP_ARGS(pool_name, xfer_bits, request_bits, pool_entropy,
> -               input_entropy),
> -
> -       TP_STRUCT__entry(
> -               __field( const char *,  pool_name               )
> -               __field(          int,  xfer_bits               )
> -               __field(          int,  request_bits            )
> -               __field(          int,  pool_entropy            )
> -               __field(          int,  input_entropy           )
> -       ),
> -
> -       TP_fast_assign(
> -               __entry->pool_name      = pool_name;
> -               __entry->xfer_bits      = xfer_bits;
> -               __entry->request_bits   = request_bits;
> -               __entry->pool_entropy   = pool_entropy;
> -               __entry->input_entropy  = input_entropy;
> -       ),
> -
> -       TP_printk("pool %s xfer_bits %d request_bits %d pool_entropy %d "
> -                 "input_entropy %d", __entry->pool_name, __entry->xfer_bits,
> -                 __entry->request_bits, __entry->pool_entropy,
> -                 __entry->input_entropy)
> -);
> -
>  DECLARE_EVENT_CLASS(random__get_random_bytes,
>         TP_PROTO(int nbytes, unsigned long IP),
>
> @@ -253,38 +202,6 @@ DEFINE_EVENT(random__extract_entropy, extract_entropy,
>         TP_ARGS(pool_name, nbytes, entropy_count, IP)
>  );
>
> -DEFINE_EVENT(random__extract_entropy, extract_entropy_user,
> -       TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
> -                unsigned long IP),
> -
> -       TP_ARGS(pool_name, nbytes, entropy_count, IP)
> -);
> -
> -TRACE_EVENT(random_read,
> -       TP_PROTO(int got_bits, int need_bits, int pool_left, int input_left),
> -
> -       TP_ARGS(got_bits, need_bits, pool_left, input_left),
> -
> -       TP_STRUCT__entry(
> -               __field(          int,  got_bits                )
> -               __field(          int,  need_bits               )
> -               __field(          int,  pool_left               )
> -               __field(          int,  input_left              )
> -       ),
> -
> -       TP_fast_assign(
> -               __entry->got_bits       = got_bits;
> -               __entry->need_bits      = need_bits;
> -               __entry->pool_left      = pool_left;
> -               __entry->input_left     = input_left;
> -       ),
> -
> -       TP_printk("got_bits %d still_needed_bits %d "
> -                 "blocking_pool_entropy_left %d input_entropy_left %d",
> -                 __entry->got_bits, __entry->got_bits, __entry->pool_left,
> -                 __entry->input_left)
> -);
> -
>  TRACE_EVENT(urandom_read,
>         TP_PROTO(int got_bits, int pool_left, int input_left),
>
> --
> 2.30.0
>
