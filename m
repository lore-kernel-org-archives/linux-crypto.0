Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC59DC4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 20:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C6E60C3E
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 20:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhG0UYC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhG0UYC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jul 2021 16:24:02 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185ACC061764
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jul 2021 13:24:01 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id 184so57037qkh.1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jul 2021 13:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfPPqr+n6W+oUQ7/MwzdsdcC0Gicejjjwi/Du2DCqTA=;
        b=XpHI84232rdkuSzMsqVAF5iRv/K72DtUpS3KizlTGfOTGPOR07J64LnHUfNMUT75RW
         DM4VtVHZDDeO1oxnzj2xw56fwkcNgfxt1zMlRtwrguhO2W2/Y8aALY97r3yWI1YDb6PS
         3J2GUeYNY3GGMz1xLOgX4UB8AFl2Y9WM2ChVE9FGwvGv4UFkDUu99xWkvHU+cHsLMUVt
         +uuxH67j6CAG/T5hXzjyqbIDpbegkFL8SgxES+xOMWrmyeBYih/xKWqHXi19zI3TEGfc
         /O94F5ISztNiyqQoh9O9PdHi+13ZsvZLick/uyq0fXsCn1ppP6cyo/6iqXOno/AdItjJ
         lc4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfPPqr+n6W+oUQ7/MwzdsdcC0Gicejjjwi/Du2DCqTA=;
        b=iZPKLPkc9hRjac7D1zJTtIGyRud0jntnGyS2rHwuviFddetRXpAG/beGOfcbL8n6Lt
         zB8agOV37e8nOjvE7y3rzhL/FahKCNdTB7yzMi8G0DBcsWX+8xsKIwb3eXsyMgnwlVYP
         VNlAPkZmyI3wVGv7fwaFvEQyypdsq9geiJYfmWlF53p1+DjWBkrHxieG6RmqawGvySBG
         gJ4yQUChZ9L0RErGIS8T5kdrgnKvhv56IsJrWL400NYuJOPFJ0rkD6E4SE/FNdvbseWS
         hs5x4/FpAML0cmiEGIBzTwFgxaVXBL0SSXgvG0A/6esM31PUVeR/gS9iE2UKGhFxqMwi
         MpxQ==
X-Gm-Message-State: AOAM533oixWV8lZiwgNEWOT/DqGgJzcKrmx+y8P27CHyrVbKfUiIpGTi
        6ElaVqZLhgFkz8yeKSZTZbNs3JD6pzH7fjnrouzu0w==
X-Google-Smtp-Source: ABdhPJziICUuoZA7coSdlp5SMWI078kDN24e/pjIHCqcPMNTNC+4Q2ifhW+pIQTgetZDn2GLvcqPzUrSPsbQ5BkpmxM=
X-Received: by 2002:a37:46d0:: with SMTP id t199mr14173981qka.416.1627417440209;
 Tue, 27 Jul 2021 13:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <01383a8751e97ef826ef2adf93bfde3a08195a43.1626693859.git.cdleonard@gmail.com>
 <e2215577-2dc5-9669-20b8-91c7700fa987@gmail.com> <CA+HUmGhtPHbT=aBLS_Ny_t802s3RWaE+tupd4T8U9x50eW3JXg@mail.gmail.com>
 <3afe618a-e848-83c3-2cc5-6ad66f3ef44b@gmail.com>
In-Reply-To: <3afe618a-e848-83c3-2cc5-6ad66f3ef44b@gmail.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 27 Jul 2021 13:23:49 -0700
Message-ID: <CA+HUmGgwvn7uPfoKqy1extwEksAXOcTf2trDX8dcYGtdeppebQ@mail.gmail.com>
Subject: Re: [RFC] tcp: Initial support for RFC5925 auth option
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
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
        Dmitry Safonov <dima@arista.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 27, 2021 at 11:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>
>
>
> On 7/27/21 6:05 AM, Francesco Ruggeri wrote:
> > Hi Leonard,
> >
> > thanks for taking on this task!
> >
> >> I'm especially interested in feedback regarding ABI and testing.
> >
> > I noticed that the TCP connection identifier is not part of the
> > representation of the MKT (tcp_authopt_key_info).
> > This could cause some issues if, for example 2 MKTs with different
> > <remote IP, remote TCP port> in the TCP connection identifier but same
> > KeyID (recv_id) are installed on a socket. In that case
> > tcp_authopt_inbound_key_lookup() may not pick the correct MKT for the
> > connection. Matching incoming segments only based on recv_id may not
> > comply with the RFC.
> > I think there may be other cases where TCP connection identifiers may
> > be needed to resolve conflicts, but I have to look at your patch in
> > more detail.
>
> The RFC doesn't specify what the "tcp connection identifier" needs to
> contains so for this first version nothing was implemented.
>
> Looking at MD5 support in linux the initial commit only supported
> binding keys to addresses and only relatively support was added for
> address prefixes and interfaces. Remote ports still have no effect.
>
> I think adding explicit address binding for TCP-AO would be sufficient,
> this can be enhanced later. The most typical usecase for TCP auth is to
> connect with a BGP peer with a fixed IP address.
>
> As far as I understand this only actually matters for SYN packets where
> you want a single listen socket to accept client using overlapping
> keyids. For an active connection userspace can only add keys for the
> upcoming destination.

The RFC does not seem to put any restrictions on the MKTs used with a
TCP connection, except that every segment must match at most one MKT,
where the matching is done on the socket pair and for incoming
segments on the KeyID, and for outgoing segments by designating a
desired MKT.
If I understand what you suggest for the initial commit, socket pair
matching would not be done, and user level (together with out-of-band
coordination between peers) would be responsible for making sure that
the segments' socket pairs are consistent with the implied socket
pairs of the MKTs on the socket. Failure to do that would be
considered a misconfiguration and would result in undefined behavior.
Is that correct?
Even if the MKT's socket pair is not used in the initial commit, would
it help having it in the API, to avoid future incompatibilities with
user level? Or would it be understood that user level code using the
initial commit may have to change with future commits?
