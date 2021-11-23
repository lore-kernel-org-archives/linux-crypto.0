Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF45DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Nov 2021 05:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhKWFm5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Nov 2021 00:42:57 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:9334 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhKWFm4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Nov 2021 00:42:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637645911;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=5XQcVk/mWF9utsBmrG26dD7whuFkkMxCgJx6KnvZ8gw=;
    b=NTgp4RNBJTVvzSXCQbYuwVcA/UGK3k91bt6GRF59BdzNYolUxBgfekfXYAcNnpXo7G
    zheyy5p4IGLBCDCqAOUWK0H3n/qIsK0uT/CC/X9t45ob8uZDNufFM2ELiuK3QJhecH2O
    POJ5BSJtfF78+n7y+QhqNh/yirRdWt4JDotZsxcgRbsMAEkyLEsbZXDUXHrc57V/sY5H
    FZ3FHa1UTrTT2/4REpHLB0VMGcobX23ZMAKIpDdGmfhUtDz170HSwS5cWt5r5VsumIOQ
    kqWy1LzULqQoFa4T8LWQopeMHUBp1x4Yrmspzt4xhDSfDr5LH2CpT8BQHeRtka0AIMo2
    xj2Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbIvScLTm3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.34.6 DYNA|AUTH)
    with ESMTPSA id y09e43xAN5cT4VK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 23 Nov 2021 06:38:29 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Simo Sorce <simo@redhat.com>, noloader@gmail.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Date:   Tue, 23 Nov 2021 06:38:29 +0100
Message-ID: <5873227.WSGUhziGkc@tauon.chronox.de>
In-Reply-To: <CAH8yC8niN=q-pD4B3OU9zj84GN-vfi=T_aLq9V3sLTZ-mRP_GQ@mail.gmail.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de> <afdf9c4a4005f6aeaded9e976c48160933f3c447.camel@redhat.com> <CAH8yC8niN=q-pD4B3OU9zj84GN-vfi=T_aLq9V3sLTZ-mRP_GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. November 2021, 22:06:55 CET schrieb Jeffrey Walton:

Hi Jeffrey,

> On Mon, Nov 22, 2021 at 10:10 AM Simo Sorce <simo@redhat.com> wrote:
> > On Mon, 2021-11-22 at 07:55 +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Nov 22, 2021 at 07:42:02AM +0100, Stephan Mueller wrote:
> > > > ...
> > > > I will leave the representatives from the distros to chime in and
> > > > point to
> > > > these patches.
> > > 
> > > Then why not work with the distros to get these changes merged into the
> > > kernel tree?  They know that keeping things out-of-the-tree costs them
> > > time and money, so why are they keeping them there?
> > 
> > I can speak for my distro.
> > We have not proposed them because they are hacks, we know they are
> > hacks, and we know they are not the long term solution.
> > Yet we have no better way (in our products, today) so far to deal with
> > these issues because what is needed is an effort like LRNG (does not
> > have to be this specific implementation), because hacks will not cut it
> > in the long term.
> 
> Kernel support for FIPS validated crypto would be very useful, IMHO.
> 
> Currently most folks I know and consult with use CentOS because CentOS
> is free and includes the FIPS canister for OpenSSL. Several folks I
> know and consult with don't have a solution because they use Debian
> derivatives, like Ubuntu. They use Ubuntu because Ubuntu offers the
> image processing packages they need out of the box.
> 
> Moving the validated crypto into the kernel would be useful since all
> distros can provide it without the need for one-off patches.
> 
> What I am less clear about.... NIST is only one standard body, and not
> everyone trusts the US. There are other bodies that should probably be
> represented, like KISA. So the big question becomes, how does the
> kernel offer "approved" crypto for different consumers? (where
> "approved" means blessed by some agency like NIST or KISA).

IMHO that is where the flexibility of the LRNG comes in. I am currently in 
discussion with the German BSI on their requirements and these requirements 
can be covered by a few extra lines since it only affects a different initial 
seeding of the DRNG.

In any case, the LRNG supports other approaches by:

- select one or more entropy sources (or provide one from external) that are 
considered appropriate

- if needed, adjust the initial seeding operation

- if needed, adjust the crypto primitives that are in use.

Ciao
Stephan
> 
> Jeff


Ciao
Stephan


