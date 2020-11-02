Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EAAC00A89
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 06:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9298D222B9
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 06:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604299462;
	bh=Gj9e/6PYyh8olvUNC1nVxy17IId+wFYzrjoSTMIcQjw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ndSYiPMYOvsp/n94tlPnlNVInlZh+tC0Wkc56JV16qigcsLmxFuHK7UtYeq8GMAOH
	 T6GBQFWV7Jo5vB4yJr4WY8Nv3uJGrxfJn3doly3iGh2TOL9lbd1WYl6B9+Y5tYaQb5
	 +x1Q6z+fDcpfgOT+o05XhMyDW8l97oTfs0tyM3fU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgKBGoV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Nov 2020 01:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727806AbgKBGoV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Nov 2020 01:44:21 -0500
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 905A2222B9
        for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2020 06:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604299460;
        bh=Gj9e/6PYyh8olvUNC1nVxy17IId+wFYzrjoSTMIcQjw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b2qruSiWIClda2SKPsqBwB0yYg9rJuvWdw/OcLWcRh3lWqk4J8HC8A6FhCOLVW1lj
         BWOH8Wy/W460xOZDmxMlKGZs15UxVLB2TOakdQGoM3BqnAWqOG8pA+fa/J4Q25+qOO
         pQCWdd2yltEQBKMx3s39XvNrE7rlVAILAyLBK7Do=
Received: by mail-oo1-f43.google.com with SMTP id f1so3120294oov.1
        for <linux-crypto@vger.kernel.org>; Sun, 01 Nov 2020 22:44:20 -0800 (PST)
X-Gm-Message-State: AOAM532pHtGkqFaDwED2JdnxsyDseRNOZo/3x8+fZsQmAj6TMRSE4gxS
        Mi2YKny6Wt1DkvJUMML5JgEU1lusu97mxkH6rNc=
X-Google-Smtp-Source: ABdhPJwUoGzj1/5l+sgfB90ILAbVuKS6akPg8lyBb3wvWImdMIOOH+rvZ4R419s5te3W3Zpb9pBXHwoNlEhnih0bpDs=
X-Received: by 2002:a4a:9806:: with SMTP id y6mr11018345ooi.45.1604299459917;
 Sun, 01 Nov 2020 22:44:19 -0800 (PST)
MIME-Version: 1.0
References: <20201101163352.6395-1-ardb@kernel.org> <CAHmME9qKgB3_ZGF4eGVGy2qU2obiwRgiXTxCZ8PuW7EaRsef_Q@mail.gmail.com>
In-Reply-To: <CAHmME9qKgB3_ZGF4eGVGy2qU2obiwRgiXTxCZ8PuW7EaRsef_Q@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 2 Nov 2020 07:44:09 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFKD91gh2uumiMX-nrDoMOxbz+HKCbn8v685wnxGbZ_5w@mail.gmail.com>
Message-ID: <CAMj1kXFKD91gh2uumiMX-nrDoMOxbz+HKCbn8v685wnxGbZ_5w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/chacha-neon - optimize for non-block size multiples
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2 Nov 2020 at 01:30, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Cool patch! I look forward to getting out the old arm32 rig and
> benching this. One question:
>
> On Sun, Nov 1, 2020 at 5:33 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > On out-of-order microarchitectures such as Cortex-A57, this results in
> > a speedup for 1420 byte blocks of about 21%, without any signficant
> > performance impact of the power-of-2 block sizes. On lower end cores
> > such as Cortex-A53, the speedup for 1420 byte blocks is only about 2%,
> > but also without impacting other input sizes.
>
> A57 and A53 are 64-bit, but this is code for 32-bit arm, right? So the
> comparison is more like A15 vs A5? Or are you running 32-bit kernels
> on armv8 hardware?

The latter. The only 32-bit hardware I have in my drawer is Cortex-A8,
which I expect to benefit from this change, but the way its
micro-architecture integrates the NEON stages into the pipeline is a
bit odd, and therefore, you cannot really extrapolate from those
results for other cores.

Cortex-A57 and Cortex-A15 should be fairly similar, so that is really
the target for this optimization. Cortex-A5 and A7 already omit the
NEON code path entirely, so they are not affected in the first place.
Cortex-A53 is significant because this is what the Raspberry Pi3 uses
(and it ships with a 32-bit kernel)
