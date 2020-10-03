Return-Path: <SRS0=yz7Y=DK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A967EC4741F
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE4B206C1
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgJCTgS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Oct 2020 15:36:18 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:37162 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725831AbgJCTgR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Oct 2020 15:36:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DC1A2180A7FF0;
        Sat,  3 Oct 2020 19:36:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: ship26_570a7fe271af
X-Filterd-Recvd-Size: 3575
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Oct 2020 19:36:11 +0000 (UTC)
Message-ID: <306974234222092651f7497504f8c03e1304926b.camel@perches.com>
Subject: Re: [PATCH 00/18] use semicolons rather than commas to separate
 statements
From:   Joe Perches <joe@perches.com>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Mark Brown <broonie@kernel.org>, tools@linux.kernel.org,
        linux-iio@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
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
Date:   Sat, 03 Oct 2020 12:36:10 -0700
In-Reply-To: <c7fd58ebd81f8731fc03434b2bdd8aa4bf99335a.camel@perches.com>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
         <160132172369.55460.9237357219623604216.b4-ty@kernel.org>
         <b1174f9be2ce65f6b5ebefcba0b48e792926abbc.camel@perches.com>
         <20200929113745.GB4799@sirena.org.uk>
         <db26d49401dc0bd6b9013a603a155f9827f404a4.camel@perches.com>
         <20201001110150.GA6715@sirena.org.uk>
         <f44d19ad596f261c0287c9ab18c45161003efb43.camel@perches.com>
         <20201003191501.o56tqq63d2buq5ox@chatter.i7.local>
         <c7fd58ebd81f8731fc03434b2bdd8aa4bf99335a.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 2020-10-03 at 12:27 -0700, Joe Perches wrote:
> On Sat, 2020-10-03 at 15:15 -0400, Konstantin Ryabitsev wrote:
> > On Sat, Oct 03, 2020 at 11:40:48AM -0700, Joe Perches wrote:
> > > (Adding tools and Konstantin Ryabitsev)
> > > 
> > > There seems to be some mismatch between b4's use of the
> > > cover letter to a patch series and what maintainers that
> > > apply a subset of the patches in the patch series.
> > > 
> > > The merge description shows the entire patch series as
> > > applied, but the actual merge is only a subset of the
> > > series.
> > > 
> > > Can this be improved in b4?
> > 
> > So, the following logic should be applied:
> > 
> > - if the entire series was applied, reply to 0/n
> > - if a subset only is applied, reply to each n/n of the patch that was 
> >   cherry-picked out of the series
> > 
> > Is that an accurate summary?
> 
> Exactly so, thanks.

And there's no need to commit the [0/n] cover letter as a
part of the merge unless the entire series was committed.

Or perhaps trim the cover letter to exclude the files
modified by the patch series and show only the actual files
committed.

And I believe b4 inserts this line ahead of the 0/n series
cover letter description for the merge:

    Merge series "<series>" from <author>:

Perhaps that like could be "partial merge of" when a partial
merge occurs or left as is if the entire series is applied.

cheers, Joe

