Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B15C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Nov 2021 17:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244654AbhK3RMQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:12:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243233AbhK3RMQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Nov 2021 12:12:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638292136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7K30WnjkuEnR0TFOmhGj++nMZbWrnMpgZrgfYl/y8Q0=;
        b=ORx9/m6aU0/j5BToHHtaoav0R21UmfrBXLxMj8bc9YVW48qWsdYggnVVccFOCsOW6oFdTp
        HLmNI70J3xcrFP0SXtvPLcxRQD3ndtOI8J7Wysldo35p6ATutdH0wdVt1uTrJSFizfv6Li
        U2wOdBzaWWWXNLzHCPBwAHhUKgwJlPI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-7cSIku7XNaKi7zJOsZMsLQ-1; Tue, 30 Nov 2021 12:08:55 -0500
X-MC-Unique: 7cSIku7XNaKi7zJOsZMsLQ-1
Received: by mail-qk1-f200.google.com with SMTP id s8-20020a05620a254800b0046d6993d174so14034439qko.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Nov 2021 09:08:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=7K30WnjkuEnR0TFOmhGj++nMZbWrnMpgZrgfYl/y8Q0=;
        b=R2eRTPvY5H2lHrp3t4OnjLcAcTQZRDEI1EURoX4hy57rL7EMrJ/hN1ihGn0ujRViWm
         I9HzkOfq80Dop0tmi0G82AAXQdArfwdypr+d7j0RgjVeZylzLwkFXNFYgbVhQDSamSC8
         QfxAJv2P1IUQ7/eqpJFlBPz8eSFtB/xOQ3s+u5MWLZbuV7VHwiYxS5Qm+SBqrJDBfoGE
         tsD511mHoDGgsmsuGDXf/54jK2+RkY+eSxu3C9VPAJSQ9ZyLo0WFzmnJ2p3/LjvqtFUS
         fO6j7gQ0/+de9uHgDKWLfDdIIdX+W/osyc5UE5VjfQDYhi2LqpOTllpevidkrl8v/rSi
         8Nxg==
X-Gm-Message-State: AOAM531IbVNau5dW2TLAJDnTKvVu7R23SZ91Pd05eviF9I0G0SalZ4kd
        3734R+EQsFFGsbM43kVwda/37vSjDN21bBc3Ue3wCEdXjvTy9wycBL9UtZDR5t/VkW987N9zn5f
        /OytSChABvVBOLVTvXn+RIOk1
X-Received: by 2002:a05:620a:17a2:: with SMTP id ay34mr516389qkb.543.1638292134475;
        Tue, 30 Nov 2021 09:08:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfOvEddTXllJYDns2FXJd+Ixkks0Jpy+tw+aPyiZlvUhKtZP+GM/0LBApC5tq++47DqSPywA==
X-Received: by 2002:a05:620a:17a2:: with SMTP id ay34mr516351qkb.543.1638292134211;
        Tue, 30 Nov 2021 09:08:54 -0800 (PST)
Received: from m8.users.ipa.redhat.com (cpe-158-222-141-151.nyc.res.rr.com. [158.222.141.151])
        by smtp.gmail.com with ESMTPSA id u21sm11136841qtw.29.2021.11.30.09.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 09:08:53 -0800 (PST)
Message-ID: <67cea601fd6b3e1deb6fe0c3401ca8410219ecf1.camel@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
From:   Simo Sorce <simo@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jeffrey Walton <noloader@gmail.com>,
        Stephan Mueller <smueller@chronox.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Date:   Tue, 30 Nov 2021 12:08:51 -0500
In-Reply-To: <YaZHKHjomEivul6U@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
         <22137816.pfsBpAd9cS@tauon.chronox.de> <YaEJtv4A6SoDFYjc@kroah.com>
         <9311513.S0ZZtNTvxh@tauon.chronox.de> <YaT+9MueQIa5p8xr@kroah.com>
         <CAH8yC8nokDTGs8H6nGDkvDxRHN_qoFROAfWnTv-q6UqzYvoSWA@mail.gmail.com>
         <YaYvYdnSaAvS8MAk@kroah.com>
         <ac123d96b31f4a51b167b4e85a205f31a6c97876.camel@redhat.com>
         <YaZHKHjomEivul6U@kroah.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2021-11-30 at 16:45 +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 30, 2021 at 09:31:09AM -0500, Simo Sorce wrote:
> > On Tue, 2021-11-30 at 15:04 +0100, Greg Kroah-Hartman wrote:
> > > On Tue, Nov 30, 2021 at 07:24:15AM -0500, Jeffrey Walton wrote:
> > > > On Mon, Nov 29, 2021 at 6:07 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > > ...
> > > > > Sometimes, yes, it is valid to have different implementations for things
> > > > > that do different things in the same area (like filesystems), but for a
> > > > > core function of the kernel, so far the existing random maintainer has
> > > > > not wanted to have multiple implementations.  Same goes for other parts
> > > > > of the kernel, it's not specific only to this one very tiny driver.
> > > > > 
> > > > > As a counterpoint, we do not allow duplicate drivers that control the
> > > > > same hardware types in the tree.  We have tried that in the past and it
> > > > > was a nightmare to support and maintain and just caused massive user
> > > > > confusion as well.  One can argue that the random driver is in this same
> > > > > category.
> > > > 
> > > > I think an argument could be made that they are different drivers
> > > > since they have different requirements and security goals. I don't
> > > > think it matters where the requirements came from, whether it was ad
> > > > hoc from the developer, NIST, KISA, CRYPTREC, NESSIE, or another
> > > > organization.
> > > > 
> > > > Maybe the problem is with the name of the driver? Perhaps the current
> > > > driver should be named random-linux, Stephan's driver should be named
> > > > random-nist, and the driver should be wired up based on a user's
> > > > selection. That should sidestep the problems associated with the
> > > > "duplicate drivers" policy.
> > > 
> > > The "problem" here is that the drivers/char/random.c file has three users,
> > > the userspace /dev/random and syscall api, the in-kernel "here's some
> > > entropy for the random core to use" api, and the in-kernel "give me some
> > > random data" api.
> > > 
> > > Odds are, you REALLY do not want the in-kernel calls to be pulling from
> > > the "random-government-crippled-specification" implementation, right?
> > 
> > You really *do* want that.
> > When our customers are mandated to use FIPS certified cryptography,
> > they want to use it for kernel cryptography as well, and in general
> > they want to use a certified randomness source as well.
> 
> There are huge numbers of internal kernel calls that use random data for
> non-crypto things.

Sure, but it makes little sense to use different random implementations
unless there are specific issues in terms of performance. It is also
not always easy to establish if a certain use of random numbers is
actually security relevant, may be context dependent, so it is
generally safer to just use the certified implementation for everything
if possible.

> > I do not get why you call the implementation crippled? The
> > specification is quite thorough and provides well reasoned requirements
> > as well as self-test that insure coding mistakes won't end up returning
> > non-random values.
> 
> Which specification are you talking about exactly?  There are loads of
> different ones it seems that people wish to follow, so it's hard to
> claim that they all are sane :)

Well, given I am interested primarily in FIPS certifications I was
referring specifically to SP800-90A/B/C:
https://csrc.nist.gov/publications/detail/sp/800-90a/rev-1/final
https://csrc.nist.gov/publications/detail/sp/800-90b/final
https://csrc.nist.gov/publications/detail/sp/800-90c/draft

> > I understand the mistrust vs gov agencies due to past mishaps like the
> > Dual-DRBG thing, but we are not talking about something like that in
> > this case. NIST is not mandating any specific algorithmic
> > implementation, the requirement set forth allow to use a variety of
> > different algorithms so that everyone can choose what they think is
> > sane.
> > 
> > > Again, just try evolving the existing code to meet the needs that you
> > > all have, stop trying to do wholesale reimplementations.  Those never
> > > succeed, and it's pretty obvious that no one wants a "plugin a random
> > > random driver" interface, right?
> > 
> > I think one of the issues is that the number of changes required
> > against the current random driver amount essentially to a re-
> > implementation. Sure, you can do it as a series of patches that
> > transform the current code in something completely different.
> 
> That is how kernel development works, it is nothing new.
> 
> > And the main question here is, how can we get there, in any case, if
> > the maintainer of the random device doesn't even participate in
> > discussions, does not pick obvious bug fixes and is simply not engaging
> > at all?
> 
> What obvious bug fixes have been dropped?

Stephan posted you the link a few days ago for one of the examples.
If you look at the last year you also will see that multiple patches
have gone in w/o the maintainer interacting, which is fine for obvious
stuff, but does not work for stuff that requires more feedback.

> > Your plan requires an active maintainer that guides these changes and
> > interact with the people proposing them to negotiate the best outcome.
> > But that is not happening so that road seem blocked at the moment.
> 
> We need working patches that fit with the kernel development model first
> before people can start blaming maintainers :)

This is a Catch-22, the maintainer is mum in what would be acceptable,
and whenever there are patches sent, there is no feedback on whether
they are acceptable or not. It's not like I like blaming anyone, but it
would be nice to have at least one word that gives a direction to
follow that the maintainer is willing to then engage with and review or
at least accept with proper third party review.

> I see almost 300 changes accepted for this tiny random.c file over the
> years we have had git (17 years).  I think that's a very large number of
> changes for a 2300 line file that is relied upon by everyone.

Seem like a lot more are desired too :-)

Simo.

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




