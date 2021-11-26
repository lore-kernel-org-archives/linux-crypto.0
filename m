Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F787C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 16:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354425AbhKZQWu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 11:22:50 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:30048 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235743AbhKZQUt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 11:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637943362;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=vOlwVp8xFow1jZY5Q+b8GlcSPjy9Js3pFWCymHaTE2A=;
    b=EHwSNeXberIlexXc+km6egqG3AQnRxo4M2DzwVHT9h8aOlGqNGA1x28rYWWyLwLF4D
    KZ3CCb4e/bUOKsreUbCm2sDxucaxhmtNGHimIS2ftGETMuML1DdWFxq3+B+o9JLozBMp
    hiBgqbayasa6cfi0BZnOy1BTLr0rG8kWPpHa+Z9in38thMbw1fCJtRl2hCbR3kksoLpX
    u9fZ2/g0VRoWspS3KgxRD45jQ6lG/WwsnZvD89oHeT/8x3XhTaV4NrcUdbXhdYRENRRy
    Xl1KYwlBsWpWYMlv+Hp/Fwgk5Zi6csYmDAyI8HvXQBt4kXTuJX9aqmtXUCxjF2bAMjvm
    n/+Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIPScDPs="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.10 DYNA|AUTH)
    with ESMTPSA id 006230xAQGFxFM2
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 26 Nov 2021 17:15:59 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Simo Sorce <simo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
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
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
Date:   Fri, 26 Nov 2021 17:15:59 +0100
Message-ID: <22137816.pfsBpAd9cS@tauon.chronox.de>
In-Reply-To: <YaEA0fyowmFlDfmK@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de> <56d2da397bb53f71c0354b102c3b40940e9b4eda.camel@redhat.com> <YaEA0fyowmFlDfmK@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 26. November 2021, 16:44:17 CET schrieb Greg Kroah-Hartman:

Hi Greg,

> On Mon, Nov 22, 2021 at 09:59:01AM -0500, Simo Sorce wrote:
> > Jason,
> > have you previously produced a list of reasoned concerns with this
> > patchset and direction?
> > 
> > This specific email is not really useful to me to understand the
> > concerns as it does not contain actionable suggestion or critique.
> > 
> > I personally find the direction fine, and with my distribution hat on I
> > can say that FIPS is essential for us and any design must include an
> > option to be FIPS certifiable.
> > 
> > As NIST keeps improving their testing capabilities and rigorous
> > cryptographic design of the CSPRNGs as well as entropy sources the
> > kernel must also adapt.
> > 
> > Stephan is providing a path forward, and I haven't seen any other
> > proposal, let alone code, that provide improvements in this area.
> > I am pretty sure the design can be improved if there is detailed and
> > actionable feedback on what to change.
> > 
> > I hope the path forward can be one of collaboration rather then mere
> > opposition.
> 
> Replacement of the existing code to cut over to the new one is not
> collaboration, it's the exact opposite.
> 
> Submitting patches to the existing codebase to implement the
> "requirements" is the proper way forward, why has that never been done.

It has been attempted by Nikolai Stange without avail - no comments were 
received, let alone it was integrated.
> 
> Remember, evolution is the correct way of kernel development, not
> intelligent design :)
> 
> thanks,
> 
> greg k-h


Ciao
Stephan


