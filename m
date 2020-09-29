Return-Path: <SRS0=8ohu=DG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8D6C47425
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 00:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663F420738
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Sep 2020 00:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgI2Apa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:45:30 -0400
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:56402 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726698AbgI2Apa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Sep 2020 20:45:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 780A9100E7B40;
        Tue, 29 Sep 2020 00:45:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: self77_011759527186
X-Filterd-Recvd-Size: 2723
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Tue, 29 Sep 2020 00:45:25 +0000 (UTC)
Message-ID: <b1174f9be2ce65f6b5ebefcba0b48e792926abbc.camel@perches.com>
Subject: Re: [PATCH 00/18] use semicolons rather than commas to separate
 statements
From:   Joe Perches <joe@perches.com>
To:     Mark Brown <broonie@kernel.org>, linux-iio@vger.kernel.org,
        Julia Lawall <Julia.Lawall@inria.fr>
Cc:     linux-stm32@st-md-mailman.stormreply.com,
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
Date:   Mon, 28 Sep 2020 17:45:24 -0700
In-Reply-To: <160132172369.55460.9237357219623604216.b4-ty@kernel.org>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
         <160132172369.55460.9237357219623604216.b4-ty@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2020-09-28 at 20:35 +0100, Mark Brown wrote:
> On Sun, 27 Sep 2020 21:12:10 +0200, Julia Lawall wrote:
> > These patches replace commas by semicolons.  This was done using the
> > Coccinelle semantic patch (http://coccinelle.lip6.fr/) shown below.
> > 
> > This semantic patch ensures that commas inside for loop headers will not be
> > transformed.  It also doesn't touch macro definitions.
> > 
> > Coccinelle ensures that braces are added as needed when a single-statement
> > branch turns into a multi-statement one.
> > 
> > [...]
> 
> Applied to
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git for-next
> 
> Thanks!
> 
> [1/1] regmap: debugfs: use semicolons rather than commas to separate statements
>       commit: 7f4a122d0b50b40c64d24a5cf7aafe26dd9487ee

Hi Mark.

Rather than replying to the 0/n cover letter to a patch
series, can you reply to each of the specific patches in
the patch series you are applying?

Otherwise, it's a bit difficult to figure out which patches
you are applying.

thanks

