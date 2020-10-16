Return-Path: <SRS0=63hd=DX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17DC7C43457
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE7CD20874
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Oct 2020 17:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391429AbgJPR00 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Oct 2020 13:26:26 -0400
Received: from verein.lst.de ([213.95.11.211]:36538 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391280AbgJPR00 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Oct 2020 13:26:26 -0400
Received: by verein.lst.de (Postfix, from userid 2005)
        id 68CC068BEB; Fri, 16 Oct 2020 19:26:19 +0200 (CEST)
Date:   Fri, 16 Oct 2020 19:26:19 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Stephan Mueller <smueller@chronox.de>
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
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20201016172619.GA18410@lst.de>
References: <20200921075857.4424-1-nstange@suse.de> <20201002123836.GA14807@lst.de> <20201002131555.GD3783@1wt.eu> <2961243.vtBmWVcJkq@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2961243.vtBmWVcJkq@tauon.chronox.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 02, 2020 at 03:56:28PM +0200, Stephan Mueller wrote:
> Am Freitag, 2. Oktober 2020, 15:15:55 CEST schrieb Willy Tarreau:
> 
> Hi Willy,
> 
> > > And this is all ???
> > 
> > Possibly a lot of people got used to seeing the numerous versions
> > and are less attentive to new series, it's possible that your message
> > will wake everyone up.
> 
> I think that points to my patch series. My patch series which provide a 
> complete separate, API and ABI compliant drop in replacement of /dev/random, 
> nobody from the gatekeepers cared to even answer. It would not touch the 
> existing code.
> 
> After waiting some time without changing the code (e.g. after Andi Lutomirski 
> commented), I got no answer at all from the gatekeepers, not even any 
> indication in what direction I should move if something was not desired in the 
> patch series.
> 
> Thus I continued adding the features that I think are necessary and for which 
> I received comments from mathematicians. What else should I do?
> 
> With the patch set v35 of my patch series, I see all my goals finally 
> achieved at I expect the code to be stable from here on. The last one was the 
> hardest: to get rid of all non-cryptographic conditioning operations and yet 
> retain performance en par or even superior to the existing /dev/random 
> implementation.

Would you mind to resend it here, for a comparison?

	Torsten

