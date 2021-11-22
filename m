Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CEEC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 06:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhKVGqe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 01:46:34 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:10479 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhKVGqd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 01:46:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637563326;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=16MMtPuos/hf7WCLpbhZlSOUlQcAe+4TJmECh7cIO+0=;
    b=qeQ7SGjqvY/pTu6GNNWh96lTESaBwd6hTe2cDc0lo+VrbEBJ6c/IBselZFMLy7/zcT
    4W9aahJFLt7MJU3weS9UtDUZwMTDUU1x/skvVX6EFJntLZQeR8HVe2OoRxA/aNQtS2w2
    dLj6BJcJp1OlhbZ5diFryQt2j21ZLQ7b8R+BdbG55o/kLpP33OHyBoF3iX8bI5o8zhdt
    hm6fiz98LeH4/dYDgfSpU+1SDs73xoYumc19+fR02islCRIqiQfXenFXOGVd6TZZWmQ7
    tsROmXSUDFY4JTUjsb8z+9X32z1xW5K+sifGtWG4GeBuzOygW7DX4OdE8tLNkqaqEA8a
    OuJw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSfAhhe"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxAM6g34hM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 22 Nov 2021 07:42:03 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Date:   Mon, 22 Nov 2021 07:42:02 +0100
Message-ID: <11035663.0FQYWtqqoJ@tauon.chronox.de>
In-Reply-To: <YZsyZua9T8DD6JF5@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de> <2560758.ogP2UNPRoF@tauon.chronox.de> <YZsyZua9T8DD6JF5@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. November 2021, 07:02:14 CET schrieb Greg Kroah-Hartman:

Hi Greg,

> On Mon, Nov 22, 2021 at 06:34:43AM +0100, Stephan Mueller wrote:
> > Am Sonntag, 21. November 2021, 23:42:33 CET schrieb Jason A. Donenfeld:
> > 
> > Hi Jason,
> > 
> > > Hi Stephan,
> > > 
> > > You've posted it again, and yet I still believe this is not the
> > > correct design or direction. I do not think the explicit goal of
> > > extended configurability ("flexibility") or the explicit goal of being
> > > FIPS compatible represent good directions, and I think this introduces
> > > new problems rather than solving any existing ones.
> > 
> > The members from the Linux distributions that are on copy on this may tell
> > you a different story. They all developed their own downstream patches to
> > somehow add the flexibility that is needed for them. So, we have a great
> > deal of fragmentation at the resting-foundation of Linux cryptography.
> 
> What distros specifically have patches in their kernels that do
> different things to the random code path?  Do you have pointers to those
> patches anywhere?  Why have the distros not submitted their changes
> upstream?

I will leave the representatives from the distros to chime in and point to 
these patches.

Yet, these changes are commonly a band-aid only that have some additional 
drawbacks. Bottom line, there is no appropriate way with the current code to 
allow vendors what they want to achieve. One hint to what changes vendors are 
attempting can be found in [1] slide 20.

[1] https://www.chronox.de/lrng/doc/lrng_presentation_v43.pdf
> 
> thanks,
> 
> greg k-h


Ciao
Stephan


