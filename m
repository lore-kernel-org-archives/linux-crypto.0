Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59848C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 15:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB5121D79
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 15:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgLWPeB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 10:34:01 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:33279 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbgLWPeA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:00 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7255665a;
        Wed, 23 Dec 2020 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=cPxPg5L3FiTf53bj1fIQGjA/waI=; b=O4gSMF
        ECWRin2VHyK2Oc+z3RVR4wb2ad63B2hP2pJL0L3Mdac1hudTIFJ4M8qjPMLTzgSq
        tKQ0fYGXlpF3LXSK2R/Hq0p42BTWa44HhXmsG8KvhgYzcr0CwbBDbaansucqPRDO
        ynoODZiR7NoafRyOUA2h+LChZO421Y4HQyfHZk9h3YG0WMvmsfg02oQ79KBufdHR
        CbdjlRoeFLpPrWRp16Vxq7E/LBRluakRAKpOoo+YrumgHwAOwJUbngSeZX75UrHS
        mDbSQYX0uUywwTpMhsslQ5bPyC0hXsVCzjzeTmI857jVu5shH0TdI8QoZJpKXObW
        1oudc83ggS3cG3gA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 31d7647c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 23 Dec 2020 15:24:43 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id a16so14900332ybh.5;
        Wed, 23 Dec 2020 07:33:15 -0800 (PST)
X-Gm-Message-State: AOAM532mCfj8EYQrf0Ac73tgJxxmsdmWjk7HXfclrZbf7D/gBTFGp6DR
        4ZkZOdoU9e07b3bd9YiDaq2iTqjvwYIo8AwuscY=
X-Google-Smtp-Source: ABdhPJwTxW5gLWApSRxGBYFLPC5JovUF0Jg/9Qegw81NaR32opuLgSSi9L8TBzbwu1No9mtDAhoJkX2lCn60kS2Blv0=
X-Received: by 2002:a25:4744:: with SMTP id u65mr38977305yba.239.1608737594497;
 Wed, 23 Dec 2020 07:33:14 -0800 (PST)
MIME-Version: 1.0
References: <20201130151231.GA24862@lst.de> <CAHmME9p4vFGWh7+CKF4f3dw5r+ru5PVG0-vP77JowX8sPhin1g@mail.gmail.com>
 <20201130165339.GE5364@mit.edu> <CAHmME9pksS8ec17RAwCNJimt4B0xZgd3qYHUPnaT4Bj4CF7n0A@mail.gmail.com>
 <20201218132519.kj3nz7swsx7vvlr5@valinor.lan> <20201223132851.55d19271@blackhole.lan>
 <20201223151014.57caf98b@ezekiel.suse.cz> <CAHmME9ooV1HRGO4bLsNKqv1EjDsUYsM6TcMbmEL=4CejTB+1ZQ@mail.gmail.com>
 <e61c46f2ded9d8676c77beb40c78200df0ada928.camel@chronox.de>
In-Reply-To: <e61c46f2ded9d8676c77beb40c78200df0ada928.camel@chronox.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Dec 2020 16:33:03 +0100
X-Gmail-Original-Message-ID: <CAHmME9p266FpLENSH+HvZ_G_uEM8O_L-MDDTMRBxFms7zqM5tQ@mail.gmail.com>
Message-ID: <CAHmME9p266FpLENSH+HvZ_G_uEM8O_L-MDDTMRBxFms7zqM5tQ@mail.gmail.com>
Subject: Re: drivers/char/random.c needs a (new) maintainer
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Petr Tesarik <ptesarik@suse.cz>, Torsten Duwe <duwe@lst.de>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 23, 2020 at 4:26 PM Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Mittwoch, dem 23.12.2020 um 15:32 +0100 schrieb Jason A. Donenfeld:
> >
> > I would, however, be interested in a keccak-based construction. But
> > just using the keccak permutation does not automatically make it
> > "SHA-3", so we're back at the same issue again. FIPS is simply not
> > interesting for our requirements.
>
> Using non-assessed cryptography? Sounds dangerous to me even though it may be
> based on some well-known construction.

"assessed" is not necessarily the same as FIPS. Don't conflate the
two. I don't appreciate that kind of dishonest argumentation.

And new constructions that I'm interested in would be formally
verified (like the other crypto work I've done) with review and buy-in
from the cryptographic community, both engineering and academic. I
have no interest in submitting "non-assessed" things developed in a
vacuum, and I'm displeased with your attempting to make that
characterization.

Similarly, any other new design proposed I would expect a similar
amount of rigor. The current RNG is admittedly a bit of a mess, but at
least it's a design that's evolved. Something that's "revolutionary",
rather than evolutionary, needs considerably more argumentation.

So, please, don't strawman this into the "non-assessed" rhetoric.
