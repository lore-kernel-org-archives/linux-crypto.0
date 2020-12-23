Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51750C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 15:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFA82332A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 15:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgLWP0Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 10:26:16 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:35265 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgLWP0P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 10:26:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1608737001;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=GPaKSqAjiz95DFz0fxi4lWiKU6bB5zmTEZkR6+nVG1c=;
        b=es7vzc8y7gbNc+Ea3R0xEEqWexvGwzwSCfeM5STGcWcDWjeckYuXqfnP9gv8kqTT6o
        CNvVhtbKfUUulQeJUkf0R3r5OhuIXxJulQafmqtdvKDD+MVSfTnjePKSA1SN6YDf5HMd
        tyky5+/WHAL0JqugZQ+lvrIRxuQbWuTBcC7HPdXTfprDnAqaZyp9SScVaSLfQZXrhR2a
        yV496X8xe9h+VZLk3xkOClSh9ltrScsLX19jh+8vOZopY9abau7ykt2OogvdgEzXNQIP
        lEXgIxhtLpq9X8QHAKnF4QmUMsPeWB3UznFAikXOPfd/jNZ0XAp9oaXdfku5zHbxg3Q3
        vEIQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlFkMRfNUE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.10.7 SBL|AUTH)
        with ESMTPSA id h02bd9wBNFMN0oq
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 23 Dec 2020 16:22:23 +0100 (CET)
Message-ID: <e61c46f2ded9d8676c77beb40c78200df0ada928.camel@chronox.de>
Subject: Re: drivers/char/random.c needs a (new) maintainer
From:   Stephan Mueller <smueller@chronox.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>
Cc:     Torsten Duwe <duwe@lst.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        And y Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, simo@redhat.com
Date:   Wed, 23 Dec 2020 16:22:22 +0100
In-Reply-To: <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
References: <20201130151231.GA24862@lst.de>
         <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
         <20201130165339.GE5364@mit.edu>
         <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
         <20201218132519.kj3nz7swsx7vvlr5@valinor.lan>
         <20201223132851.55d19271@blackhole.lan>
         <20201223151014.57caf98b@ezekiel.suse.cz>
         <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, dem 23.12.2020 um 15:32 +0100 schrieb Jason A. Donenfeld:
> 
> I would, however, be interested in a keccak-based construction. But
> just using the keccak permutation does not automatically make it
> "SHA-3", so we're back at the same issue again. FIPS is simply not
> interesting for our requirements.

Your requirements? Interesting approach.

Using non-assessed cryptography? Sounds dangerous to me even though it may be
based on some well-known construction.

I thought Linux in general and crypto in particular is about allowing user (or
the vendor) to decide about the used algorithm. So, let us have a mechanism
that gives them this freedom.

Thus the proposed idea sounds to me like a dangerous proposition upon which
almost all cryptography shall rest. This will surely invite even more
fragmentation.

Ciao
Stephan

PS: This entire discussion is NOT about the crypto side of the random numbers,
but about how get the entropy for the random numbers.



