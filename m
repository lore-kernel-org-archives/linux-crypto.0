Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CA2C4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 05:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CBA0214DB
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 05:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Cahzp4hq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgJGFyy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 01:54:54 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:16549 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGFyy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 01:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1602050090;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=C8o//TEedE15rHNz3cZ8YSVaRQEVoqX8N3cKiUWpx3A=;
        b=Cahzp4hql1BlWFD8i7MdGROyeIHe7HYTSIcVV/gTE0bv2cpj2rrFlzxj3vYZGt/+ka
        XKS3c6c6glT64dABcdQIfJRJLTsjsk6Bnn99gLifMyrwQH7TLslcE3ntYdpgL2jYa71r
        UA+yIqVLjVzZJGxTk+UPa8a4Xn7zItml92n+OSdclICKjshV4axuVcS8P+s3Enh4Mk1l
        cq03Pgy+Smp/A1RJw2KOzv1WOm0i89KRAmh4lWrAh1Gpclyp5c8qNZyguMSNgYFbOW+c
        PnNR9NXPMU2Vljz9WRm0Wq2MT4e7fYNDC/nwOdG2FryCRWcifvgrdtZSMbSDhAL3JGP2
        tmlw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIvSfY6w+"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id C0b627w975qwOcC
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 7 Oct 2020 07:52:58 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Torsten Duwe <duwe@lst.de>, Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
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
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
Date:   Wed, 07 Oct 2020 07:52:58 +0200
Message-ID: <5285278.e8GPZlJvtg@tauon.chronox.de>
In-Reply-To: <20201007042409.GE912@sol.localdomain>
References: <20200921075857.4424-1-nstange@suse.de> <20201002123836.GA14807@lst.de> <20201007042409.GE912@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 7. Oktober 2020, 06:24:09 CEST schrieb Eric Biggers:

Hi Eric,
> 
> Note that having multiple RNG implementations would cause fragmentation,
> more maintenance burden, etc.  So IMO, that should be a last resort. 
> Instead we should try to find an implementation that works for everyone. 
> I.e., at least to me, Nicolai's patchset seems more on the right track than
> Stephan's patchset...

Thank you for sharing your considerations.

If you say that only one implementation should be there, I am wondering why 
not considering an implementation that as significant advantages over the 
existing implementation as outlined in my cover letter to patch v35. In the 
default configuration, it compiles no code at all that has any bearing on 
government standards. Yet it has a more cryptographic sound approach to handle 
entropy. In addition is meant to be extensible allowing each user to pick and 
chose what he wants. Yet, users who do not want these extensions should not 
suffer from it (neither performance-wise, nor should they suffer from an 
unnecessary complex code that builds all options into one C file).

And speaking of fragmentation, if it is not *possible* to allow users to pick 
what they want and need (and yes, in some parts of the world or for some users 
these government standards are simply a necessity), we surely invite 
fragmentation. In the LRNG, I tried to have all operations critical to entropy 
compression and random number generation modularized so that the a can be 
replaced or extended if needed without fragmentation.

PS: The reason why I started the LRNG was not government standards, but the 
result of performing two studies. The one study was about entropy in 
virtualized environment which showed that we have significant entropy in 
virtual environments and yet the existing /dev/random implementation thinks 
there is much less available. Another study I maintain for years also shows 
that the entire entropy collection and heuristic on bare metal systems is also 
in need of advancements. Initially I provided patches to the existing /dev/
random implementation, but basically all were silently ignored.

Ciao
Stephan


