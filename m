Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22D4C17441
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 22:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA5421872
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 22:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="PhH8e4EB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKLWpI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:45:08 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:12229 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLWpI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 17:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573598704;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=DImeky0BTUCha4r7Uhw0UC1AKgaF3x/DYPNkEbHElSo=;
        b=PhH8e4EBsOgwYqrm0QN6vPaXiYgGDtYXNWWIuKOGWldojLsfmAFpEDtMTZpWag7RQO
        62d0kxK0xXzPTS49QO6U9gZQX9AzdAGIekX80XXXTrD2w5YPBgJfoXa+sVT5xUwGhvzh
        +hJKxQqnT1le8vLAVKtH0gVLUed9Ah5uxMJkCQ9RiLXkNeWa4mSozpsLRbJi47zpWS/S
        mNrGQkDtpYzz6p8TSl3K4IZNShOP2VQOI6N9IqnVez3Cp5sNpgbqkBR8OpELOPL0bvkP
        bFb4gsccXhZ5XDiSp/7Y86Vep03P8nAtNluMc4ESGE3IhHZvh9fD0oXYSrOV+LFNkSK+
        nNZw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmwdNLqV/Nz7PsNPEA=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.29.0 SBL|AUTH)
        with ESMTPSA id N09a57vACMhj9yq
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 12 Nov 2019 23:43:45 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Florian Weimer <fw@deneb.enyo.de>
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
Subject: Re: [PATCH v24 00/12] /dev/random - a new approach with full SP800-90B compliance
Date:   Tue, 12 Nov 2019 23:43:42 +0100
Message-ID: <5603724.uI2RiKDNrm@positron.chronox.de>
In-Reply-To: <875zjpfcu9.fsf@mid.deneb.enyo.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <875zjpfcu9.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 12. November 2019, 14:23:10 CET schrieb Florian Weimer:

Hi Florian,

> * Stephan M=FCller:
> > * support deactivation of TRNG (i.e. blocking behavior of /dev/random)
> >=20
> >   at compile time. If deactivated, /dev/random behaves like
> >   getrandom(2).
>=20
> I don't quite understand this comment.  Doesn't getrandom with the
> GRND_RANDOM always behave like /dev/random?  Presumably, without the
> TRNG tap, the GRND_RANDOM flag for getrandom is ignored, and reading
> from /dev/random behaves like reading from /dev/urandom.

Absolutely. Apologies for the imprecision here. I will correct that.

The idea is that the constant blocking behavior of /dev/random and GRND_RAN=
DOM=20
is replaced with the blocking behavior of getrandom(2) without the GRND_RAN=
DOM=20
flag (i.e. the interface waits until the LRNG thinks it is completely seede=
d=20
before it provides ulimited data).
>=20
> Anyway, reading the accompanying PDF, this looks rather impressive:
> the userspace bootstrapping problem is gone (the issue where waiting
> for more entropy prevents the collection of more entropy), *and* we
> can still make the standards people happy.
>=20
> (Replying from my other account due to mail issues, sorry.)


Ciao
Stephan


