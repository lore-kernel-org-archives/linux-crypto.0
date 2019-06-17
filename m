Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC8BC31E5B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 20:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5DE52084B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 20:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFQUFj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 16:05:39 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:32995 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFQUFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 16:05:39 -0400
Received: by mail-qt1-f194.google.com with SMTP id x2so12414042qtr.0;
        Mon, 17 Jun 2019 13:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DtmxA5fwa/VmB57HrryIpb43t0KtmZN+0lhbT8ho4I4=;
        b=WVZwfywjNwsgkSPYUIHgPF9QBrrIaCVOmP7k44Hczbf8uWQcqBEiP9etWh3cRbT3UN
         DcqPuIgDdPCo9KvyJ5rgZte/Jf9Ozh+JPddH8xOhXmDyaaXbmyr1z2yVq3ABpI/dT6N9
         Z4oaB0shlYRo7rmaTWOilib7e4x/cY9KcMLBYg8p/T1PhjnIL6QedAow2ZFf0icT5tIT
         t52Fd4QqpgB1C50/JGG7UbbPRvlLGaQqa8JRFoGqvoEmcUr2BTNtgYvC1W0PP6EpNGQv
         nk3CbUflknITdntPIqTQXGreI3g9ItP4JM1uj4Y13DCkFRpgY3r4S01cMlabx/3hBQ1B
         ZISw==
X-Gm-Message-State: APjAAAV0/S8HrpL2K6/ALVFkIwK9mD9WRxpm6CgK61+px4K9CTqakWUi
        bU+fydRm5Wd/VDjuJIF1gbIGO/RFZT7295IpQ28=
X-Google-Smtp-Source: APXvYqzXSoVstbwGyLhRq3yTdl4ePWoJjOaHp0wzZVForu/3vfdDnNuPFfq50Z2P9t0Mjw29CRSJct3FXOH20DUDJ2M=
X-Received: by 2002:a0c:87ab:: with SMTP id 40mr22590324qvj.93.1560801938069;
 Mon, 17 Jun 2019 13:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190617132343.2678836-1-arnd@arndb.de> <20190617172008.GA92263@gmail.com>
In-Reply-To: <20190617172008.GA92263@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 17 Jun 2019 22:05:19 +0200
Message-ID: <CAK8P3a04d+xLWjmyDAn80EabkWOEnFXw-R=DGEfns37oPNXtRA@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 17, 2019 at 7:20 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Mon, Jun 17, 2019 at 03:23:02PM +0200, Arnd Bergmann wrote:
> > On arm32, we get warnings about high stack usage in some of the functions:
> >

> > @@ -1541,6 +1543,10 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
> >  done:
> >       snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
> >                vec->psize, vec->ksize);
> > +
> > +     kfree(desc);
> > +
> > +     return 0;
> >  }
>
> Instead of allocating the   here, can you allocate it in
> test_hash_vs_generic_impl() and call it 'generic_desc'?  Then it would match
> test_skcipher_vs_generic_impl() and test_aead_vs_generic_impl() which already
> dynamically allocate their skcipher_request and aead_request, respectively.

Ok, good idea. I could not find an equivalent of skcipher_request_alloc()
and skcipher_request_free(), so I ended up open-coding those.

> > @@ -1565,7 +1571,7 @@ static int test_hash_vs_generic_impl(const char *driver,
> >       unsigned int i;
> >       struct hash_testvec vec = { 0 };
> >       char vec_name[64];
> > -     struct testvec_config cfg;
> > +     struct testvec_config *cfg;
> >       char cfgname[TESTVEC_CONFIG_NAMELEN];
> >       int err;
> >
>
> Otherwise I guess this patch is fine for now, though there's still a lot of
> stuff with nontrivial size on the stack (cfgname, vec_name, _generic_driver,
> hash_testvec, plus the stuff in test_hash_vec_cfg).  There's also still a
> testvec_config on the stack in test_{hash,skcipher,aead}_vec(); I assume you
> didn't see a warning there only because it wasn't in combination with as much
> other stuff on the stack.

Right, the stack usage for the other function is still several the hundreds of
bytes, but it falls under the radar of the 1024 byte warning limit.

> I should probably have a go at refactoring this code to pack up most of this
> stuff in *_params structures, which would then be dynamically allocated much
> more easily.

Makes sense. I'll leave that up to you, and will repost a set of two patches
based on your suggestion for testvec_config (unchanged) and
test_hash_vs_generic_impl, after build testing my current patches over night.

       Arnd
