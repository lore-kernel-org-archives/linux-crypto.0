Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6E0C433F5
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 17:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhKUR1K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 12:27:10 -0500
Received: from smtprelay0216.hostedemail.com ([216.40.44.216]:48698 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238369AbhKUR1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 12:27:10 -0500
Received: from omf15.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id BB28A101EEBB2;
        Sun, 21 Nov 2021 17:24:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 5FB772000508;
        Sun, 21 Nov 2021 17:23:54 +0000 (UTC)
Message-ID: <3c22f7e433ad86424c3a7b171f7e0710afc644a2.camel@perches.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
From:   Joe Perches <joe@perches.com>
To:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
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
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Date:   Sun, 21 Nov 2021 09:23:53 -0800
In-Reply-To: <4641592.OV4Wx5bFTl@positron.chronox.de>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
         <4641592.OV4Wx5bFTl@positron.chronox.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 5FB772000508
X-Stat-Signature: p4ietruf66nm8oosn4wyx3daxy3isjdi
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+oVSRchNiOt+YglZxBuciD8t3B6J1pJUQ=
X-HE-Tag: 1637515434-982633
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 2021-11-21 at 17:40 +0100, Stephan Müller wrote:
> In an effort to provide a flexible implementation for a random number
> generator that also delivers entropy during early boot time, allows
> replacement of the deterministic random number generation mechanism,
> implement the various components in separate code for easier
> maintenance, and provide compliance to SP800-90[A|B|C], introduce
> the Linux Random Number Generator (LRNG) framework.
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -10817,6 +10817,13 @@ F:	Documentation/litmus-tests/
>  F:	Documentation/memory-barriers.txt
>  F:	tools/memory-model/
>  
> +LINUX RANDOM NUMBER GENERATOR (LRNG) DRIVER
> +M:	Stephan Mueller <smueller@chronox.de>
> +S:	Maintained
> +W:	https://www.chronox.de/lrng.html
> +F:	drivers/char/lrng/*

Are you specifically intending _not_ to maintain any files in
any possible subdirectories of this directory?

If not, this should be

F:	drivers/char/lrng/

> +F:	include/linux/lrng.h
> +

Trivia and additionally: 

Maybe run the patch series through scripts/checkpatch.pl --strict and
see if you want to change anything.


