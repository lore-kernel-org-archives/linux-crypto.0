Return-Path: <SRS0=esIh=TI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECE0C04A6B
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 21:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C81A20989
	for <linux-crypto@archiver.kernel.org>; Wed,  8 May 2019 21:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UwXq7RG5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfEHVIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 May 2019 17:08:43 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34637 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfEHVIn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 May 2019 17:08:43 -0400
Received: by mail-ua1-f67.google.com with SMTP id f9so7937707ual.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2019 14:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85jAqiZ3rdqGfRvDGF/DUutEfAhFjbADqQZ1rKThcjI=;
        b=UwXq7RG5GbFeEc83Dhtk4yt40YEVN6o9JoBGv+9ERexPqq8oo2r5vW6MQbaxvQJruM
         qVzsMwdsJFIKh1gnJ1TchbHrGKlvv65iFVA+AjaqqHluvK1ywrlFGVWuNt/JOMxqwlQU
         IDVJi+FZd3XpMZTQkuqI4l6ltLywx1nG4LFLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85jAqiZ3rdqGfRvDGF/DUutEfAhFjbADqQZ1rKThcjI=;
        b=btajeKV+uCmn8WPUkIh3IuMqSGlV9JBF1yAXtxRgGHqN2MNkS307/5GfBS/jCoGYRx
         hGh++1lq4AgI9ypkKs192SqvBH6ASFDDJb5pp4apBkznK8rYEemxHy/jFk1Oj8PfxlXY
         1XWK7qhkS20ve7dyy/wSB5dsCIBMxfp/PA4N9JgyXoXJI4+p/XgPxHKZc3IcOseU+N+x
         XTvn/z2Q8sldfQpngJ04TJTnowILb4Qg0geJdjQjfqLri3O1U6/aVG3DPusL8cUTySry
         bEJiihDoDP4cE3LR++p7RYibibDsxXH/IoLlbSfsHP07D1w1TuJQ/0JdBS1oX1t3RkQ7
         TxNA==
X-Gm-Message-State: APjAAAX6LqME9HB9fMGPigsbh53GFmBRisvGqMXANyiJreUUkaGuJyRA
        YqreVb2G5GVXi6/95gKCTVbBymYQjOE=
X-Google-Smtp-Source: APXvYqy9duICY0mMwmVOzpuT7DaPSlJGEUJhchDTqWbPEhmkk3UnCOG/poR7FWtWFiCaOUp8EgTZHw==
X-Received: by 2002:a9f:204a:: with SMTP id 68mr22105059uam.19.1557349721492;
        Wed, 08 May 2019 14:08:41 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id 69sm6019vkl.6.2019.05.08.14.08.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 14:08:40 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id g187so19372vsc.8
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2019 14:08:39 -0700 (PDT)
X-Received: by 2002:a67:7c8a:: with SMTP id x132mr251877vsc.172.1557349719455;
 Wed, 08 May 2019 14:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190507161321.34611-1-keescook@chromium.org> <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain> <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
In-Reply-To: <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
From:   Kees Cook <keescook@chromium.org>
Date:   Wed, 8 May 2019 14:08:25 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
Message-ID: <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Joao Moreira <jmoreira@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 8, 2019 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, May 07, 2019 at 02:50:46PM -0700, Eric Biggers wrote:
> >
> > I don't know yet.  It's difficult to read the code with 2 layers of macros.
> >
> > Hence why I asked why you didn't just change the prototypes to be compatible.
>
> I agree.  Kees, since you're changing this anyway please make it
> look better not worse.

Do you mean I should use the typedefs in the new macros? I'm not aware
of a way to use a typedef to declare a function body, so I had to
repeat them. I'm open to suggestions!

As far as "fixing the prototypes", the API is agnostic of the context
type, and uses void *. And also it provides a way to call the same
function with different pointer types on the other arguments:

For example, quoting the existing code:

asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
                                const u8 *src);

Which is used for ecb and cbc:

#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
...
static const struct common_glue_ctx twofish_dec = {
...
                .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }

static const struct common_glue_ctx twofish_dec_cbc = {
...
                .fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }

which have different prototypes:

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union {
                common_glue_func_t ecb;
                common_glue_cbc_func_t cbc;
                common_glue_ctr_func_t ctr;
                common_glue_xts_func_t xts;
        } fn_u;
};

What CFI dislikes is calling a func(void *ctx, ...) when the actual
function is, for example, func(struct twofish_ctx *ctx, ...).

This needs to be fixed at the call site, not the static initializers,
and since the call site is void, there needs to be a static inline
that will satisfy the types.

I'm open to suggestions! :)

Thanks,

-- 
Kees Cook
