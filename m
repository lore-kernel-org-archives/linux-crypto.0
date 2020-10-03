Return-Path: <SRS0=yz7Y=DK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE052C47095
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6744206DD
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgJCTnU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Oct 2020 15:43:20 -0400
Received: from smtprelay0115.hostedemail.com ([216.40.44.115]:57876 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725831AbgJCTnU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Oct 2020 15:43:20 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 91E911DED;
        Sat,  3 Oct 2020 19:43:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: loss06_3d0c09b271af
X-Filterd-Recvd-Size: 4162
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Oct 2020 19:43:15 +0000 (UTC)
Message-ID: <9ab43333596f08abbbbbf1fa8cdf1ded4b65af2a.camel@perches.com>
Subject: Re: [PATCH 00/18] use semicolons rather than commas to separate
 statements
From:   Joe Perches <joe@perches.com>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Julia Lawall <julia.lawall@inria.fr>
Cc:     Mark Brown <broonie@kernel.org>, tools@linux.kernel.org,
        linux-iio@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-acpi@vger.kernel.org, David Lechner <david@lechnology.com>,
        Valdis =?UTF-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        kernel-janitors@vger.kernel.org, drbd-dev@lists.linbit.com,
        openipmi-developer@lists.sourceforge.net,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-ide@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-wireless@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Date:   Sat, 03 Oct 2020 12:43:13 -0700
In-Reply-To: <20201003193137.z2bpwzlz5a66kkex@chatter.i7.local>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
         <160132172369.55460.9237357219623604216.b4-ty@kernel.org>
         <b1174f9be2ce65f6b5ebefcba0b48e792926abbc.camel@perches.com>
         <20200929113745.GB4799@sirena.org.uk>
         <db26d49401dc0bd6b9013a603a155f9827f404a4.camel@perches.com>
         <20201001110150.GA6715@sirena.org.uk>
         <f44d19ad596f261c0287c9ab18c45161003efb43.camel@perches.com>
         <20201003191501.o56tqq63d2buq5ox@chatter.i7.local>
         <alpine.DEB.2.22.394.2010032118420.2741@hadrien>
         <20201003193137.z2bpwzlz5a66kkex@chatter.i7.local>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 2020-10-03 at 15:31 -0400, Konstantin Ryabitsev wrote:
> On Sat, Oct 03, 2020 at 09:18:51PM +0200, Julia Lawall wrote:
> > > > There seems to be some mismatch between b4's use of the
> > > > cover letter to a patch series and what maintainers that
> > > > apply a subset of the patches in the patch series.
> > > > 
> > > > The merge description shows the entire patch series as
> > > > applied, but the actual merge is only a subset of the
> > > > series.
> > > > 
> > > > Can this be improved in b4?
> > > 
> > > So, the following logic should be applied:
> > > 
> > > - if the entire series was applied, reply to 0/n
> > > - if a subset only is applied, reply to each n/n of the patch that was
> > >   cherry-picked out of the series
> > > 
> > > Is that an accurate summary?
> > 
> > That sounds good.
> 
> I'm worried that this can get unwieldy for series of 50 patches where 49 
> got applied. Would the following be better:
> 
> -----
> From: ...
> To: ...
> Subject: Re: [PATCH 00/18] use semicolons...
> 
> On Sun...
> > These patches...
> > 
> > [...]
> 
> A subset of these patches was applied to
> 
>   https://...
> 
> Thanks!
> 
> [5/18] regmap: debugfs:
>        commit:
> 
> (etc)
> -----
> 
> In other words, we:
> 
> - specifically say that it's a subset
> - instead of just enumerating the number of patches that were applied, 
>   as is currently the case ([1/1]) we list the exact numbers out of the 
>   posted series (e.g. [5/18])
> 
> I think this is a better solution than potentially flooding everyone 
> with 49 emails.

I think it would be better to reply individually as
the likelihood that the maintainer skips just a few
patches of a large series is relatively low.

It's more likely for a treewide or multi-subsystem
patch set for a maintainer to apply just a single one
or a selected few of the patches and individual
replies make it much easier to determine which ones
were applied.

thanks, Joe

