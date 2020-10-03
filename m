Return-Path: <SRS0=yz7Y=DK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2965C4727F
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B606A20709
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Oct 2020 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgJCTSz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Oct 2020 15:18:55 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:39864 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgJCTSz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Oct 2020 15:18:55 -0400
X-IronPort-AV: E=Sophos;i="5.77,332,1596492000"; 
   d="scan'208";a="470811687"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 21:18:51 +0200
Date:   Sat, 3 Oct 2020 21:18:51 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
cc:     Joe Perches <joe@perches.com>, Mark Brown <broonie@kernel.org>,
        tools@linux.kernel.org, linux-iio@vger.kernel.org,
        Julia Lawall <Julia.Lawall@inria.fr>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-acpi@vger.kernel.org, David Lechner <david@lechnology.com>,
        =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        kernel-janitors@vger.kernel.org, drbd-dev@lists.linbit.com,
        openipmi-developer@lists.sourceforge.net,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-ide@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-wireless@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH 00/18] use semicolons rather than commas to separate
 statements
In-Reply-To: <20201003191501.o56tqq63d2buq5ox@chatter.i7.local>
Message-ID: <alpine.DEB.2.22.394.2010032118420.2741@hadrien>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr> <160132172369.55460.9237357219623604216.b4-ty@kernel.org> <b1174f9be2ce65f6b5ebefcba0b48e792926abbc.camel@perches.com> <20200929113745.GB4799@sirena.org.uk>
 <db26d49401dc0bd6b9013a603a155f9827f404a4.camel@perches.com> <20201001110150.GA6715@sirena.org.uk> <f44d19ad596f261c0287c9ab18c45161003efb43.camel@perches.com> <20201003191501.o56tqq63d2buq5ox@chatter.i7.local>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Sat, 3 Oct 2020, Konstantin Ryabitsev wrote:

> On Sat, Oct 03, 2020 at 11:40:48AM -0700, Joe Perches wrote:
> > (Adding tools and Konstantin Ryabitsev)
> >
> > There seems to be some mismatch between b4's use of the
> > cover letter to a patch series and what maintainers that
> > apply a subset of the patches in the patch series.
> >
> > The merge description shows the entire patch series as
> > applied, but the actual merge is only a subset of the
> > series.
> >
> > Can this be improved in b4?
>
> So, the following logic should be applied:
>
> - if the entire series was applied, reply to 0/n
> - if a subset only is applied, reply to each n/n of the patch that was
>   cherry-picked out of the series
>
> Is that an accurate summary?

That sounds good.

julia
