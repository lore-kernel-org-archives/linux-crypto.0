Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BC7C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 11:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DC3A20873
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 11:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOZNcbLX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgE0L2f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 07:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgE0L2f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 07:28:35 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F9C061A0F;
        Wed, 27 May 2020 04:28:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k19so19981044edv.9;
        Wed, 27 May 2020 04:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cUS3+FHzxdOJYBvppLYv/k7Qnu4FBiAFM6a3qwD7zwE=;
        b=EOZNcbLX4WgtgegWPrbd31D1EDL1EwaAPdS/8W+FukopOQKazQsRHeVSMbBY0lh8Sp
         55WI9/eWKvjGONoI96NM4gz4SLe6yxjSXzBDMdI6TaaNquols/wODObgUqHchYP2ykNh
         Mt/50OjTxCzIUxPDhnaK19aG2LsNmXZt0jxj3p7Wcdi2E4AsjFkwtQ8+veswFbOkZgsP
         3SaH38NQKvl5Gzh/5TwsrOpd+sU6phvrZa8McqrqjC9vKkcg2lucAgjAQ3BXzs+8Fn0Q
         G/LH5EgJpE661+jvyfKfUKPd3i8M5b3ZgjJbFwucRPnQ0qxTaozdh6XRhry6D/Do/MWZ
         76kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cUS3+FHzxdOJYBvppLYv/k7Qnu4FBiAFM6a3qwD7zwE=;
        b=YpwFRom3o8uC3cd2t8KGy70SC6AOqnDEH7bZrtmdKlgcXI3uG0MKL+SiyD9D0sOzx/
         vVWEj/AD10kaUoQI9gm5yj5pmQz4nSxfyQmh+rY57x3PU81ezQOtmJzHzDDyIcRnmNO9
         eDIjSAif/UaBVj9LAw1/NhPe8hRKXK9Nlyo2rblbFVjFTAXMOZkHYp6wfrYHHpNXHWf1
         Z2B5p6nbQay+LXwyj6mPs2KCZ+zMyiK2uwdwDwcA3AfW/zIo0BegRX1bA4LSAizY9hWT
         wwjBR9nUiBqBzha8/9ENgzEhMqLh2MQExwJ/jLX12mHDgKcYyzGn7uJOToddLZfMVkQg
         PaAg==
X-Gm-Message-State: AOAM531BhXejA9ALuzAo4bcgzRYnFUQU36t5RSHpJXUdIUas13ytV2bo
        R2+z4DyeA0aUcX21cwD5kjJc8Yj2rG6r1UGGn0w=
X-Google-Smtp-Source: ABdhPJwApfQ8QYyu3sVC9yXDreluemdyvMzOiEEd71HoZVJi+WtLnVwAzYnI3LiLJWzGu11AWxzRM6Aa182jB7eHhGQ=
X-Received: by 2002:a50:f983:: with SMTP id q3mr908282edn.259.1590578913571;
 Wed, 27 May 2020 04:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <CANpvso4V67SBKn9+SXc+H=r-H-up+GWt77K4jH5HJx9k+sR+hA@mail.gmail.com>
 <CACXcFmkYtSeRMNTr=NXGK06MUyEnvaFqe_9Q11kWZq=f1ZdE_A@mail.gmail.com>
In-Reply-To: <CACXcFmkYtSeRMNTr=NXGK06MUyEnvaFqe_9Q11kWZq=f1ZdE_A@mail.gmail.com>
From:   Eric Curtin <ericcurtin17@gmail.com>
Date:   Wed, 27 May 2020 12:28:21 +0100
Message-ID: <CANpvso5xjawMVcRff-qbTeoPLkvyNNYCqdCuZYVEOYv-zsycQw@mail.gmail.com>
Subject: Re: Looking for an open-source thesis idea
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sandy,

I actually have worked quite a bit with IPsec, it's not a protocol I'm
a huge fan of, it's use of multiple ports make it difficult to work
with middleboxs (be it load-balancers, TLS interceptors, reverse
proxies, proxies, firewalls, routers, switches, etc.). I've even seen
issues where some middleboxes only recognize TCP/UDP packets and not
ESP packets. There's so many implementations of IPsec with various
routers OS's and the standard seems to be only sort of universally
accepted. It can be difficult to deploy.

Although Wireshark does solve at many of these problems, it's simpler
at least, as regards VPNs I really like it. I'm actually more a fan of
protocols that applications have a little more control over like QUIC
over UDP or TLS over TCP.

I actually use HTTPS Everywhere plugin, but at the end of the day,
that simply just turns on TLS encryption if it's available right?

I like some of the problems QUIC solves, the multiple handshake
problem decreasing overall round trips, and just that it's more
modern. openssl is brilliant, but there's a lot of deadwood, older
encryption techniques in that codebase.

A monolithic secure TCP protocol seems like a nice idea, but maybe it
is too difficult.

I think it's a nice idea to explore OOM killer and compare it to the
solutions on various other OS's (FreeBSD, AIX, z/OS, Solaris, HP-UX,
macOS, iOS, Windows, Zircon, etc. and the OS I work on Powermax).
Thanks for that.

Any other ideas, keep them coming :)

On Tue, 26 May 2020 at 08:18, Sandy Harris <sandyinchina@gmail.com> wrote:
>
> Eric Curtin <ericcurtin17@gmail.com> wrote:
>
> > Hope I'm not bothering you. I'm looking for a masters thesis idea, ...
>
> > I'm really liking this
> > new QUIC (UDP) protocol as an alternative to TCP over TLS. And with
> > the growth of new modern secure protocols like Wireguard. I was
> > wondering, would it be an idea to do a monolithic secure TCP protocol
> > (as an alternative to TCP over TLS) as a small thesis project or is it
> > as hard as the guys at Google make is sound?
> >
> > "Because TCP is implemented in operating system kernels, and middlebox
> > firmware, making significant changes to TCP is next to impossible."
>
> I'm inclined to agree with the Google folk on that. However, what about
> IPsec? That was designed to secure anything-over-IP so it should be
> a more general solution. The FreeS/WAN project added opportunistic
> encryption for wider availability
> https://freeswan.org/freeswan_trees/freeswan-2.06/doc/intro.html#goals
>
> Today some opportunistic encryption protocols -- SMTP-over-TLS and
> HTTPS Everywhere -- are quite widespread but my impression is
> that opportunistic IPsec is not. Would adding it to an open source
> router be a thesis-sized project? Or, since routers likely have IPsec
> already, just making it easier to deploy?
>
> > I'm open to any other suggestions also for my thesis :)
>
> Linux's OOM killer strikes me as a spectacularly ugly kluge,
> but people who are certainly more knowledgeable and likely
> more competent seem to think it is necessary. Is there a
> thesis in examining it, looking at how other Unix-like systems
> handle the problem & perhaps implementing an alternative
> for Linux?
