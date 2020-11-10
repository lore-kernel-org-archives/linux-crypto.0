Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AA5C388F7
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 10:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFCD20795
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Nov 2020 10:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="rL6VescS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgKJKX0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Nov 2020 05:23:26 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:25161 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgKJKX0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Nov 2020 05:23:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1605003804;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=zByrFVmJDlSOfKWmXEqO4kvjtQhPeNiZ8Q12Fayu59Q=;
        b=rL6VescSpmv+jc4hOnS8bLCIeDuEMCvIt3oKv460DhJ8plalDPzMC3QP50aKxu1orA
        /cO9wByXrCXHvK0i2wmheFVm2r91k5y1+wOX7JlIt/pwQ+yoll7WkmUK9WyHmNQigiSZ
        pnXtrkgV3k0SytTipSFa6oQoZ4hTJtGjUXVcfhHLS9U2w2svW75Zek1p1lNoXB9F12Sr
        +AhJXv7CaaOjA5Z4bIj13BX9zmp0P/Ut8DodZ0dPB2uzV/y8Pm3+3n0DMkflTxGhm4CV
        agkLddF48zg/l1MUlvZo1H7V3e/dANQ2q/CrXi3dFTYXyh2hO7DVKHCW3oIxtWaqAKd0
        FIow==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfEhGW"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.3.3 DYNA|AUTH)
        with ESMTPSA id Y03aecwAAAMFFdn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 10 Nov 2020 11:22:15 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Willy Tarreau <w@1wt.eu>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [PATCH v36 00/13] /dev/random - a new approach
Date:   Tue, 10 Nov 2020 11:22:14 +0100
Message-ID: <34318060.ATrlOLLGV9@tauon.chronox.de>
In-Reply-To: <3073852.aeNJFYEL58@positron.chronox.de>
References: <20200921075857.4424-1-nstange@suse.de> <20201016172619.GA18410@lst.de> <3073852.aeNJFYEL58@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 19. Oktober 2020, 21:28:50 CET schrieb Stephan M=FCller:

Hi,
>=20
> * Performance
>=20
>  - Faster by up to 75% in the critical code path of the interrupt handler
>    depending on data collection size configurable at kernel compile time -
>    the default is about equal in performance with existing /dev/random as
>    outlined in [2] section 4.2.

By streamlining the implementation a bit, the LRNG interrupt handler now=20
operates about 130% faster than the existing /dev/random (average of 97 cyc=
les=20
of the existing /dev/random code vs. an average of 42 cycles of the LRNG).=
=20
This fast operation is the default now due to patch [2]. The conceptual dat=
a=20
handling outlined in [3] section 2.2 remains unchanged.

Even the addition of health tests applied to the noise source data would st=
ill=20
result in a faster interrupt handling code (average of 97 cycles of the=20
existing /dev/random code vs on average 78 cycles of the LRNG).

[1] https://github.com/smuellerDD/lrng/commit/
10b74b242950371273e38df78060e258d9d3ea40

[2] https://github.com/smuellerDD/lrng/commit/
383b087653c21cf20984f5508befa57e96f685ba

[3] https://chronox.de/lrng/doc/lrng.pdf

Ciao
Stephan


