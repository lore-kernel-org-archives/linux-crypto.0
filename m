Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDE8C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 15:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351983AbhKZP6r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 10:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378140AbhKZP4r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 10:56:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648BFC0619F1;
        Fri, 26 Nov 2021 07:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0856227D;
        Fri, 26 Nov 2021 15:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D557AC93056;
        Fri, 26 Nov 2021 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637941460;
        bh=NxlDA0cHHqiW0SMHHhqlrl0ssnqzbE6tYWoESXaKZTg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQetu7gsir66DYGD0q+9OWJdAUy33RSMRRaGccWQ8TTVljDMswxTGG+5gpWv/7dpb
         o32AeeqexTPlmHuwF2fEIQ330A0aZgWgZJqCn24dfr1WGUHrZQuxWgUcSgEpdGcYm3
         x/H7zJru9kbI374LzirrPbdWIvsnDGvP/8A87oE4=
Date:   Fri, 26 Nov 2021 16:44:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Simo Sorce <simo@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org,
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
Message-ID: <YaEA0fyowmFlDfmK@kroah.com>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
 <4641592.OV4Wx5bFTl@positron.chronox.de>
 <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
 <56d2da397bb53f71c0354b102c3b40940e9b4eda.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56d2da397bb53f71c0354b102c3b40940e9b4eda.camel@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 09:59:01AM -0500, Simo Sorce wrote:
> Jason,
> have you previously produced a list of reasoned concerns with this
> patchset and direction?
> 
> This specific email is not really useful to me to understand the
> concerns as it does not contain actionable suggestion or critique.
> 
> I personally find the direction fine, and with my distribution hat on I
> can say that FIPS is essential for us and any design must include an
> option to be FIPS certifiable.
> 
> As NIST keeps improving their testing capabilities and rigorous
> cryptographic design of the CSPRNGs as well as entropy sources the
> kernel must also adapt.
> 
> Stephan is providing a path forward, and I haven't seen any other
> proposal, let alone code, that provide improvements in this area.
> I am pretty sure the design can be improved if there is detailed and
> actionable feedback on what to change.
> 
> I hope the path forward can be one of collaboration rather then mere
> opposition.

Replacement of the existing code to cut over to the new one is not
collaboration, it's the exact opposite.

Submitting patches to the existing codebase to implement the
"requirements" is the proper way forward, why has that never been done.

Remember, evolution is the correct way of kernel development, not
intelligent design :)

thanks,

greg k-h
