Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730A2C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 09:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A3172243F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 09:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Qv8aB7Kx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfKTJCc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 04:02:32 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:30699 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbfKTJCc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 04:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574240550;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=p2Aiheugetx72zdukF/ebBtE1heRlYZy4yZjuCZjUrI=;
        b=Qv8aB7KxNWe1yOgSQ3eU1KNv9apQwQktkrEQ7Xkgsnjcjw1aX1rQnGAc/YzHGaqX6A
        2HOMGdeabV6YqjaWw9rx6ELYNoWQuanh+nfhrjbPiFjUeIyB7nWpSojYDOjLY4neSiMf
        SCOJNSrRB7Z2ELMmuXpPuIJFkARb6OG5trePR0v1C23mNzgeaubUZeFPApSOlR54NBDb
        +4zH77QbbyOXR8/U6ekAhe8IhDOMpPc9AtgqYrx0fYDpM9vCHiwpZaxmX5c0q9twclzN
        wOXZVnRhCU23/nzUPspGh7AjGlPvIlPoXoO1I00bwbHZcpynFqzJGWkZIMHq6aVlXpXo
        KVKw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDbL/ScbtM="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id N09a57vAK91NjSF
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 20 Nov 2019 10:01:23 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Nicolai Stange <nstange@suse.de>,
        "Peter, Matthias" <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH v25 12/12] LRNG - add interface for gathering of raw entropy
Date:   Wed, 20 Nov 2019 10:01:23 +0100
Message-ID: <1606105.I1uVafPBki@positron.chronox.de>
In-Reply-To: <ea5e2cf5-d622-03c1-eb96-7f7e4893ae04@infradead.org>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <3610406.x8mDjznOIz@positron.chronox.de> <ea5e2cf5-d622-03c1-eb96-7f7e4893ae04@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 19. November 2019, 18:17:55 CET schrieb Randy Dunlap:

Hi Randy,

> Hi,
>=20
> On 11/16/19 1:38 AM, Stephan M=FCller wrote:
> > diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
> > index e6ca3acc1e48..4ccc710832ef 100644
> > --- a/drivers/char/lrng/Kconfig
> > +++ b/drivers/char/lrng/Kconfig
> > @@ -169,4 +169,20 @@ config LRNG_APT_CUTOFF
> >=20
> >  	default 325 if !LRNG_APT_BROKEN
> >  	default 32 if LRNG_APT_BROKEN
> >=20
> > +config LRNG_TESTING
> > +	bool "Enable entropy test interface to LRNG noise source"
> > +	select CONFIG_DEBUG_FS
>=20
> 	That should be spelled as DEBUG_FS and preferably would be "depends on"
> 	instead of 'select'.

=46ixed.

Thank you very much.

Ciao
Stephan


