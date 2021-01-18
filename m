Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFB5C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 12:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44BE2065E
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jan 2021 12:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389298AbhARMLf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jan 2021 07:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403807AbhARMKu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jan 2021 07:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C07FF208D5;
        Mon, 18 Jan 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610971808;
        bh=VO8Q71JIzVWPPB+FCHBwwoRa4mTNvS2Wg4JbjxOYW5w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Dl+gdId9lqcX05hWACysMpicyspFHBrUuv57P257a8ncaN/YZsCgbaGsNW+2grlNE
         xx7Kbdt5TD6eUV9E3VHUtGfz0i5vpa8+zYW1oxybnunb4J8A2kz9x1gEmUZrWyumpM
         t3kBO/kHEdRQ4PTvhP/g2J4VJYi+hCMRYMSEJotlR7tHsRifHAKwdXkYSpG+zj4M2q
         W1EjnjExc3AlI3I3y83WA2fK46hy5M64uMcSgiNS3eFW3wMGnMtrXY3Kf61B0rjTnR
         2a9DFhKt3HF/UNFXNbG1lIqo3szvwliNZs9AOInGTWp6tWkunKdrl6Shchj4rr7VuC
         MGm6+t1e/A/2w==
Received: by mail-oi1-f169.google.com with SMTP id s75so17478248oih.1;
        Mon, 18 Jan 2021 04:10:08 -0800 (PST)
X-Gm-Message-State: AOAM531ya5gDCIrodzHd7oHmt4pvt6BJ6NwdXRQyFPsvetmzFXi3TCPE
        bDFH3ra9sHh6wIi9R1DD3tGDwoGNMrZLzid4eOo=
X-Google-Smtp-Source: ABdhPJyJfiFiRlcYa+bgXA1A7m+wUOg/ssP9BRzLZYX69gw0lgPu2QrIHF5DtAmhC1pP3vzLJu7aitHkLvvsvT/u/5s=
X-Received: by 2002:aca:210f:: with SMTP id 15mr12665970oiz.174.1610971807918;
 Mon, 18 Jan 2021 04:10:07 -0800 (PST)
MIME-Version: 1.0
References: <20201217172101.381772-1-daniele.alessandrelli@linux.intel.com>
 <CY4PR1101MB2326ED0E6C23D1D868D53365E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <20210104113148.GA20575@gondor.apana.org.au> <CY4PR1101MB23260DF5A317CA05BBA3C2F9E7D20@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CY4PR1101MB232696B49BA1A3441E8B335EE7A80@CY4PR1101MB2326.namprd11.prod.outlook.com>
 <CAMj1kXH9sHm_=dXS7646MbPQoQST9AepfHORSJgj0AxzWB4SvQ@mail.gmail.com> <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB232656080E3F457EC345E7B2E7A40@CY4PR1101MB2326.namprd11.prod.outlook.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 18 Jan 2021 13:09:56 +0100
X-Gmail-Original-Message-ID: <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
Message-ID: <CAMj1kXF9yUVEdPeF6EUCSOdb44HdFuVPk6G2cKOAUAn-mVjCzw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Keem Bay OCS ECC crypto driver
To:     "Reshetova, Elena" <elena.reshetova@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Alessandrelli, Daniele" <daniele.alessandrelli@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 18 Jan 2021 at 12:55, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>
> > On Thu, 14 Jan 2021 at 11:25, Reshetova, Elena
> > <elena.reshetova@intel.com> wrote:
> > >
> > > > > On Mon, Jan 04, 2021 at 08:04:15AM +0000, Reshetova, Elena wrote:
> > > > > > > 2. The OCS ECC HW does not support the NIST P-192 curve. We were
> > planning
> > > > to
> > > > > > >    add SW fallback for P-192 in the driver, but the Intel Crypto team
> > > > > > >    (which, internally, has to approve any code involving cryptography)
> > > > > > >    advised against it, because they consider P-192 weak. As a result, the
> > > > > > >    driver is not passing crypto self-tests. Is there any possible solution
> > > > > > >    to this? Is it reasonable to change the self-tests to only test the
> > > > > > >    curves actually supported by the tested driver? (not fully sure how to do
> > > > > > >    that).
> > > > > >
> > > > > > An additional reason against the P-192 SW fallback is the fact that it can
> > > > > > potentially trigger unsafe behavior which is not even "visible" to the end user
> > > > > > of the ECC functionality. If I request (by my developer mistake) a P-192
> > > > > > weaker curve from ECC Keem Bay HW driver, it is much safer to return a
> > > > > > "not supported" error that proceed behind my back with a SW code
> > > > > > implementation making me believe that I am actually getting a HW-backed up
> > > > > > functionality (since I don't think there is a way for me to check that I am using
> > > > > > SW fallback).
> > > > >
> > > > > Sorry, but if you break the Crypto API requirement then your driver
> > > > > isn't getting merged.
> > > >
> > > > But should not we think what behavior would make sense for good crypto drivers
> > in
> > > > future?
> > > > As cryptography moves forward (especially for the post quantum era), we will
> > have
> > > > lengths for all existing algorithms increased (in addition to having a bunch of new
> > > > ones),
> > > > and we surely should not expect the new generation of HW drivers to implement
> > > > the old/weaker lengths, so why there the requirement to support them? It is not
> > a
> > > > part of crypto API definition on what bit lengths should be supported, because it
> > > > cannot be part of API to begin with since it is always changing parameter
> > (algorithms
> > > > and attacks
> > > > develop all the time).
> > >
> > > I would really appreciate, if someone helps us to understand here. Maybe there is a
> > > correct way to address this, but we just don't see it. The question is not even about
> > > this particular crypto driver and the fact whenever it gests merged or not, but the
> > > logic of the crypto API subsystem.
> > >
> > > As far as I understand the implementations that are provided by the specialized
> > drivers
> > > (like our Keem Bay OCS ECC driver example here) have a higher priority vs. generic
> > > Implementations that exists in kernel, which makes sense because we expect these
> > drivers
> > > (and the security HW they talk to) to provide both more efficient and more secure
> > > implementations than a pure SW implementation in kernel can do (even if it utilizes
> > special
> > > instructions, like SIMD, AESNI, etc.). However, naturally these drivers are bound by
> > > what security HW can do, and if it does not support a certain size/param of the
> > algorithm
> > > (P-192 curve in our case), it is pointless and wrong for them to reimplement what
> > SW is
> > > already doing in kernel, so they should not do so and currently they re-direct to
> > core kernel
> > > implementation. So far good.
> > >
> > > But now comes my biggest worry is that this redirection as far
> > > as I can see is *internal to driver itself*, i.e. it does a callback to these core
> > functions from the driver
> > > code, which again, unless I misunderstand smth, leads to the fact that the end user
> > gets
> > > P-192 curve ECC implementation from the core kernel that has been "promoted"
> > to a highest
> > > priority (given that ECC KeemBay driver for example got priority 300 to begin with).
> > So, if
> > > we say we have another HW Driver 'Foo', which happens to implement P-192
> > curves more securely,
> > > but happens to have a lower priority than ECC KeemBay driver, its implementation
> > would never
> > > be chosen, but core kernel implementation will be used (via SW fallback internal to
> > ECC Keem
> > > Bay driver).
> > >
> >
> > No, this is incorrect. If you allocate a fallback algorithm in the
> > correct way, the crypto API will resolve the allocation in the usual
> > manner, and select whichever of the remaining implementations has the
> > highest priority (provided that it does not require a fallback
> > itself).
>
> Thank you very much Ard for the important correction here!
> See below if I got it now correctly to the end for the use case in question.
>
> >
> > > Another problem is that for a user of crypto API I don't see a way (and perhaps I
> > am wrong here)
> > > to guarantee that all my calls to perform crypto operations will end up being
> > performed on a
> > > security HW I want (maybe because this is the only thing I trust). It seems to be
> > possible in theory,
> > > but in practice would require careful evaluation of a kernel setup and a sync
> > between what
> > > end user requests and what driver can provide. Let me try to explain a potential
> > scenario.
> > > Lets say we had an end user that used to ask for both P-192 and P-384 curve-based
> > ECC operations
> > > and let's say we had a driver and security HW that implemented it. The end user
> > made sure that
> > > this driver implementation is always preferred vs. other existing implementations.
> > Now, time moves, a new
> > > security HW comes instead that only supports P-384, and the driver now has been
> > updated to
> > > support P-192 via the SW fallback (like we are asked now).
> > > Now, how does an end user notice that when it asks for a P-192 based operations,
> > his operations
> > > are not done in security HW anymore? The only way seems to be
> > > is to know that driver and security HW has been updated, algorithms and sizes
> > changed, etc.
> > > It might take a while before the end user realizes this and for example stops using
> > P-192 altogether,
> > > but what if this silent redirect by the driver actually breaks some security
> > assumptions (side-channel
> > > resistance being one potential example) made by this end user? The consequences
> > can be very bad.
> > > You might say: "this is the end user problem to verify this", but shouldn't we do
> > smth to prevent or
> > > at least indicate such potential issues to them?
> > >
> >
> > I don't think it is possible at the API level to define rules that
> > will always produce the most secure combination of drivers. The
> > priority fields are only used to convey relative performance (which is
> > already semantically murky, given the lack of distinction between
> > hardware with a single queue vs software algorithms that can be
> > executed by all CPUs in parallel).
> >
> > When it comes to comparative security, trustworthiness or robustness
> > of implementations, it is simply left up to the user to blacklist
> > modules that they prefer not to use. When fallback allocations are
> > made in the correct way, the remaining available implementations will
> > be used in priority order.
>
> So, let me see if I understand the full picture correctly now and how to utilize
> the blacklisting of modules as a user. Suppose I want to blacklist everything but
> my OSC driver module. So, if I am as a user refer to a specific driver implementation
> using a unique driver name (ecdh-keembay-ocs in our case), then regardless of the
> fact that a driver implements this SW fallback for P-192 curve, if I am as a user to
> ask for P-192 curve (or any other param that results in SW fallback), I will be notified
> that this requested implementation does not provide it?
>

This is rather unusual compared with how the crypto API is typically
used, but if this is really what you want to implement, you can do so
by:
- having a "ecdh" implementation that implements the entire range, and
uses a fallback for curves that it does not implement
- export the same implementation again as "ecdh" and with a known
driver name "ecdh-keembay-ocs", but with a slightly lower priority,
and in this case, return an error when the unimplemented curve is
requested.

That way, you fully adhere to the API, by providing implementations of
all curves by default. And if a user requests "ecdh-keembay-ocs"
explicitly, it will not be able to use the P192 curve inadvertently.

But policing which curves are secure and which are not is really not
the job of the API. We have implementations of MD5 and RC4 in the
kernel that we would *love* to remove but we simply cannot do so as
long as they are still being used. The same applies to P192: we simply
cannot fail requests for that curve for use cases that were previously
deemed valid. It is perfectly reasonable to omit the implementation
from your hardware, but banning its use outright on the grounds that
is no longer secure conflicts with our requirement not to break
existing use cases.
