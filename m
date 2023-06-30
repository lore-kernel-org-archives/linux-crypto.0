Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75126EB64D7
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 15:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjF3PvM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 11:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjF3PvL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 11:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9458F35A5
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 08:51:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B81B61775
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 15:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D8EC433D9;
        Fri, 30 Jun 2023 15:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688140269;
        bh=o+HQ6sKOLOmf9NJpSPsWFmx92fmjlFfWr9D3EoklLi8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jHffzW9mVEhnx1vyn2AqZf5LL+zIBS/Fs/Cilynv8kMBaoJPC/L0mO8gkSH4wa9C7
         TzFQ6M8ouxTdZyX2eL8agbFrKVKOHxkraVuVKUg8wZMUVKEzQ6TJvZzRfTLad3abQZ
         /EkJu5MoHfqasGxByyrNqF/w249qqWuCvlokWkPAZ64NAxx70LWWY3qyj2MnkvRSSS
         n7cm1F2X+mKVMIhYwXA11c0RjkrAdVhShvzs4hbpz4ijrugYfSkSIArFTV8Riv2GC/
         of8L/DUGLlrJlfnbWetYpiCIvF/9yS7p0s+6SyAptGHRbz3euuE6hc23utAsaA0s/i
         IoDByBRQ7H5vg==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so3302924e87.3;
        Fri, 30 Jun 2023 08:51:09 -0700 (PDT)
X-Gm-Message-State: ABy/qLYlpwkV1iabXoTBm7GPqhGbZWRgRXNt1O3ruzhsCm2vrTjJCC1c
        o42AZ2lvp/Gu3At9whENjnhDX4xRxZSVjQLsRl0=
X-Google-Smtp-Source: APBJJlHeM6BWV3muIjxnacs7zjjB0XKOeozxgRkAM5i8VKs9paqzZF7WBIi4waH6K6drUKfYMfm79y4EELrsxUS4wqA=
X-Received: by 2002:a05:6512:3da5:b0:4f8:6e6e:3f42 with SMTP id
 k37-20020a0565123da500b004f86e6e3f42mr4240856lfv.14.1688140267474; Fri, 30
 Jun 2023 08:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008a7ae505aef61db1@google.com> <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
 <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
 <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
 <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
 <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
 <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
 <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
 <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
 <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com> <20230630082733.4250175b@kernel.org>
In-Reply-To: <20230630082733.4250175b@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 30 Jun 2023 17:50:55 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE9a399_CiXNHMqpNk+Fz=4YPd0s-5B0gU66wYbEhiiZQ@mail.gmail.com>
Message-ID: <CAMj1kXE9a399_CiXNHMqpNk+Fz=4YPd0s-5B0gU66wYbEhiiZQ@mail.gmail.com>
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Potapenko <glider@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 30 Jun 2023 at 17:27, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 30 Jun 2023 17:16:06 +0200 Ard Biesheuvel wrote:
> > Note that this is the *input* scatterlist containing the AAD
> > (additional authenticated data) and the crypto input, and so there is
> > definitely a bug here that shouldn't be papered over by zero'ing the
> > allocation.
>
> Noob question, it's not the tag / AAD, right? We definitely don't init
> that..

assoclen + cryptlen does not cover the tag on encryption, so it would
be omitted here regardless of whether it was covered in the input
scatterlist or not.
