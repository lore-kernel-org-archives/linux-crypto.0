Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B99FEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jul 2023 20:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjGFUxX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jul 2023 16:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGFUxX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2023 16:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34831999
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 13:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58002612E4
        for <linux-crypto@vger.kernel.org>; Thu,  6 Jul 2023 20:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CCFC433C8;
        Thu,  6 Jul 2023 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688676800;
        bh=qcAxweDPq39L5npJuVAnsu8iW7yg61iPw5U4c+tnzj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RxhYD7pxdvhLtmloT+u6LMKjgIUU7dIx+enmhalOc81qCOo5Hz+4RFuthAvsWT1E/
         kUAaMR1lMiSRs55uVmSEfHeFa1pyjfPj1VX9JW75rfa5S/zqB0IR8lSzNLOfLvuqtD
         69BwaJGpiUsYnvYvR2gr927E8ecpHIzkYAtXM2uHPN1UfX/LfdCWGQSvbfEGlDW35Y
         3arIn7vx0GBRTFMZLsRCJD8zt2E/K9djoL8PxeHasRyE3w1jtWajQHE58oeRqGHwNY
         Z79b6DhSbc4+1a7S+tnd21wWND84yk1TfOkaODFn4k4vqqVg4mFApB2XmxMx1sqCrP
         WHbxLFg/M1Urg==
Date:   Thu, 6 Jul 2023 13:53:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Message-ID: <20230706135319.66d3cb78@kernel.org>
In-Reply-To: <35970e3b-8142-8e00-c12a-da8c6925c12c@I-love.SAKURA.ne.jp>
References: <0000000000008a7ae505aef61db1@google.com>
        <20200911170150.GA889@sol.localdomain>
        <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
        <CAMj1kXFqYozjJ+qPeSApESb0Cb6CUaGXBrs5LP81ERRvb3+TAw@mail.gmail.com>
        <59e1d5c0-aedb-7b5b-f37f-0c20185d7e9b@I-love.SAKURA.ne.jp>
        <CAMj1kXGHRUUFYL09Lm-mO6MfGc19rC=-7mSJ1eDTcbw7QuEkaw@mail.gmail.com>
        <CAG_fn=X+eU=-WLXASidBCHWS3L7RvtN=mx3Bj8GD9GcA=Htf2w@mail.gmail.com>
        <CAMj1kXFrsc7bsjo2i0=9AqVNSCvXEnYAukzoXeaYEH9EpNviBA@mail.gmail.com>
        <CAG_fn=VFa2yeiZmdyuVRmZYtWn6Tkox8UVrOrCv4tEec3BFYbQ@mail.gmail.com>
        <CAMj1kXEdwjN7Q8tKVxHz98zQ4EsWVSdLZ5tQaV-nXxc9hwRYjQ@mail.gmail.com>
        <CAG_fn=UWZWc+FZ_shCr+T9Y3gV9Bue-ZFHKJj78YXBq3JfnUKA@mail.gmail.com>
        <CAMj1kXE_PjQT6+A9a0Y=ZfbOr_H+umYSqHuRrM6AT_gFJxxP1w@mail.gmail.com>
        <8c989395-0f20-a957-6611-8a356badcf3c@I-love.SAKURA.ne.jp>
        <35970e3b-8142-8e00-c12a-da8c6925c12c@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 4 Jul 2023 22:32:00 +0900 Tetsuo Handa wrote:
> I found a simplified reproducer.
> This problem happens when splice() and sendmsg() run in parallel.

Could you retry with the upstream (tip of Linus's tree) and see if it
still repros? I tried to get a KMSAN kernel to boot on QEMU but it
the kernel doesn't want to start, no idea what's going on :(
