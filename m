Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35457C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 03:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1618560F37
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 03:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhG0CZU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbhG0CZT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 22:25:19 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38012C061764
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jul 2021 20:05:46 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id h27so8583712qtu.9
        for <linux-crypto@vger.kernel.org>; Mon, 26 Jul 2021 20:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dO+/VjmDNm/jvNfgL8TZqjssguu0SYylw+ZFTbhKfUs=;
        b=hnkvf5PtgJ9iT3a75HtWTd32Ux85xeReIjr1eqyhAUwnpNaIFXm1jBHhcDvmynqtTi
         sYQeIoLfecuTZLCwmwYxdVm4a5MsEjOupgr6gULzNbHmrV0l/jRkb9VhKVuFu3Y23K48
         9EFDJ390fmOpkGTHhx32407CxLrCiDw+FALzHCokwXvcM0f6uRI3THTP8Ti885wqkRc4
         NhJOruzjSNOJk4Wjse+i2eE+qZ9+BrmwfHCdjfNwC12EC8cYafJLWEKwzFrWnNMrT08f
         aI1UCA7r5iRMCpjlBB9Aq3Rao8A5vaxCmYDllXBbAbCCZvIM8ik4WiepRr4Ldi26LPYi
         HqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dO+/VjmDNm/jvNfgL8TZqjssguu0SYylw+ZFTbhKfUs=;
        b=ty1sscLngro3V7A31g6FxFDFDHlIF/lrDLWL8sr/buB0Vzx2DhZddRvcgc7/nCa2sA
         HYfSVhkZ57nixLi0GL/Coo+jYpWY73JhY0oFcNFNWHoQ9yPEeQhkkG1RbgNxcjSu3tNC
         AKLWVTVY2umkyNYcvgC7VSjEwKrnVHHRetIKxI5hZJ2KwSZav+f/ZHACGjRvFmZun2JO
         luvyPBwYkAbLM4Kf8h4XyDxPDsoKKtXU6G8p3VetW7hD6uQmdX9EcEEo4/tVuEBPfYkM
         fmSSS35R2F0E3sPsYcP9pPwl/L/Q53TSx31eWn2Op4ExxjQk4JxCATtRoHTOELbeoX6o
         v3fw==
X-Gm-Message-State: AOAM531845V+veftH9o/QwOaFS08UPhwQ43up2kPV8nUUzXYK3IPK8Q/
        89sm4QFApmZVNd2LRYusx7A3wkW1nI7d1apB4skpUw==
X-Google-Smtp-Source: ABdhPJyqE+hRQ9fnFW4vz9Q25MAPeJV8jIhJFgt89SzOiIJR5zM75fLPLlgNJ/T6xtaAyhnD2RdftD0e4cX11xcrtA8=
X-Received: by 2002:ac8:7773:: with SMTP id h19mr17385217qtu.184.1627355145337;
 Mon, 26 Jul 2021 20:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
 <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
In-Reply-To: <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Mon, 26 Jul 2021 20:05:34 -0700
Message-ID: <CA+HUmGhtPHbT=aBLS_Ny_t802s3RWaE+tupd4T8U9x50eW3JXg@mail.gmail.com>
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     David Ahern <dsahern@gmail.com>
Cc:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Salam Noureddine <noureddine@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <dima@arista.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Leonard,

thanks for taking on this task!

> I'm especially interested in feedback regarding ABI and testing.

I noticed that the TCP connection identifier is not part of the
representation of the MKT (tcp_authopt_key_info).
This could cause some issues if, for example 2 MKTs with different
<remote IP, remote TCP port> in the TCP connection identifier but same
KeyID (recv_id) are installed on a socket. In that case
tcp_authopt_inbound_key_lookup() may not pick the correct MKT for the
connection. Matching incoming segments only based on recv_id may not
comply with the RFC.
I think there may be other cases where TCP connection identifiers may
be needed to resolve conflicts, but I have to look at your patch in
more detail.

It would be helpful if you could split your patch into smaller
incremental chunks.

Francesco

On Mon, Jul 26, 2021 at 6:07 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/19/21 5:24 AM, Leonard Crestez wrote:
> > I'm especially interested in feedback regarding ABI and testing.
>
> Please add tests -- both positive and negative -- to
> tools/testing/selftests/net/fcnal-test.sh. That script already covers
> the MD5 permutations. You can add the uapi support needed to nettest.c
